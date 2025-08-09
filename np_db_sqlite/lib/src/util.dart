import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/native/util.dart'
    if (dart.library.html) 'package:np_db_sqlite/src/web/util.dart'
    as impl;

void initDrift() {
  driftRuntimeOptions.debugPrint = (log) => debugPrint(log, wrapWidth: 1024);
}

Future<Map<String, dynamic>> getSqliteConnectionArgs() =>
    impl.getSqliteConnectionArgs();

QueryExecutor openSqliteConnectionWithArgs(Map<String, dynamic> args) =>
    impl.openSqliteConnectionWithArgs(args);

QueryExecutor openSqliteConnection() => impl.openSqliteConnection();

Future<void> applyWorkaroundToOpenSqlite3OnOldAndroidVersions() =>
    impl.applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

/// Export [db] to [dir] and return the exported database file
///
/// User must have write access to [dir]. On mobile platforms, this typically
/// means only internal directories are allowed
Future<io.File> exportSqliteDb(SqliteDb db, io.Directory dir) =>
    impl.exportSqliteDb(db, dir);

extension DateTimeColumnExtension on Column<DateTime> {
  Expression<bool>? isBetweenTimeRange(TimeRange range) {
    final epoch = unixepoch;
    // convert ranges to inclusive
    final from =
        range.fromBound == TimeRangeBound.inclusive
            ? range.from?.millisecondsSinceEpoch.let((e) => e ~/ 1000)
            : range.from?.millisecondsSinceEpoch.let((e) => e ~/ 1000 + 1);
    final to =
        range.toBound == TimeRangeBound.inclusive
            ? range.to?.millisecondsSinceEpoch.let((e) => e ~/ 1000)
            : range.to?.millisecondsSinceEpoch.let((e) => e ~/ 1000 - 1);
    if (from != null && to != null) {
      return epoch.isBetweenValues(from, to);
    } else if (from != null) {
      return epoch.isBiggerOrEqualValue(from);
    } else if (to != null) {
      return epoch.isSmallerOrEqualValue(to);
    } else {
      // both null
      return null;
    }
  }
}
