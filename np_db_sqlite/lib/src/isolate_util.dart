import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:flutter/foundation.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/util.dart';
import 'package:np_platform_util/np_platform_util.dart';

typedef ComputeWithDbCallback<T, U> =
    Future<U> Function(SqliteDb db, T message);

/// Create a drift db running in an isolate
///
/// This is only expected to be used in the main isolate
Future<SqliteDb> createDb() async {
  // see: https://drift.simonbinder.eu/docs/advanced-features/isolates/
  final driftIsolate = await _createDriftIsolate();
  final connection = await driftIsolate.connect();
  return SqliteDb(executor: connection);
}

Future<U> computeWithDb<T, U>(
  ComputeWithDbCallback<T, U> callback,
  T args,
  SqliteDb fallbackDb,
) async {
  if (getRawPlatform() == NpPlatform.web) {
    return await callback(fallbackDb, args);
  } else {
    return await compute(
      _computeWithDbImpl<T, U>,
      _ComputeWithDbMessage(await getSqliteConnectionArgs(), callback, args),
    );
  }
}

class _IsolateStartRequest {
  const _IsolateStartRequest(this.sendDriftIsolate, this.platformArgs);

  final SendPort sendDriftIsolate;
  final Map<String, dynamic> platformArgs;
}

class _ComputeWithDbMessage<T, U> {
  const _ComputeWithDbMessage(
    this.sqliteConnectionArgs,
    this.callback,
    this.args,
  );

  final Map<String, dynamic> sqliteConnectionArgs;
  final ComputeWithDbCallback<T, U> callback;
  final T args;
}

Future<DriftIsolate> _createDriftIsolate() async {
  final args = await getSqliteConnectionArgs();
  final receivePort = ReceivePort();
  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, args),
  );
  // _startBackground will send the DriftIsolate to this ReceivePort
  return await receivePort.first as DriftIsolate;
}

@pragma("vm:entry-point")
Future<void> _startBackground(_IsolateStartRequest request) async {
  initDrift();
  // this is the entry point from the background isolate! Let's create
  // the database from the path we received
  final executor = openSqliteConnectionWithArgs(request.platformArgs);
  // we're using DriftIsolate.inCurrent here as this method already runs on a
  // background isolate. If we used DriftIsolate.spawn, a third isolate would be
  // started which is not what we want!
  final driftIsolate = DriftIsolate.inCurrent(
    () => DatabaseConnection(executor),
    // this breaks background service!
    serialize: false,
  );
  // inform the starting isolate about this, so that it can call .connect()
  request.sendDriftIsolate.send(driftIsolate);
}

Future<U> _computeWithDbImpl<T, U>(_ComputeWithDbMessage<T, U> message) async {
  initDrift();
  // we don't use driftIsolate because opening a DB normally is found to perform
  // better
  final sqliteDb = SqliteDb(
    executor: openSqliteConnectionWithArgs(message.sqliteConnectionArgs),
  );
  try {
    return await message.callback(sqliteDb, message.args);
  } finally {
    await sqliteDb.close();
  }
}
