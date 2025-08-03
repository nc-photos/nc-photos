import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:logging/logging.dart';
import 'package:np_db_sqlite/src/database.dart' as sql;
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart' as sql;

part 'util.g.dart';

Future<Map<String, dynamic>> getSqliteConnectionArgs() async {
  // put the database file, called db.sqlite here, into the documents folder
  // for your app.
  final dbFolder = await getApplicationDocumentsDirectory();
  return {
    "path": path_lib.join(dbFolder.path, "db.sqlite"),
  };
}

QueryExecutor openSqliteConnectionWithArgs(Map<String, dynamic> args) {
  final file = File(args["path"]);
  return NativeDatabase(
    file,
    // logStatements: true,
  );
}

QueryExecutor openSqliteConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final args = await getSqliteConnectionArgs();
    return openSqliteConnectionWithArgs(args);
  });
}

Future<void> applyWorkaroundToOpenSqlite3OnOldAndroidVersions() {
  return sql.applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
}

/// Export [db] to [dir] and return the exported database file
///
/// User must have write access to [dir]. On mobile platforms, this typically
/// means only internal directories are allowed
Future<File> exportSqliteDb(sql.SqliteDb db, Directory dir) async {
  final file = File(path_lib.join(dir.path, "export.sqlite"));
  _$__NpLog.log.fine("[exportSqliteDb] path: ${file.absolute}");
  if (await file.exists()) {
    await file.delete();
  }
  await db.customStatement("VACUUM INTO ?", [file.path]);
  return file;
}

@npLog
// ignore: camel_case_types
class __ {}
