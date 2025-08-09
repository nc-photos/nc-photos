import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/database_extension.dart';
import 'package:test/test.dart';

import '../test_util.dart' as util;

void main() {
  group("database.SqliteDbFileExtension", () {
    test("cleanUpDanglingFiles", _cleanUpDanglingFiles);
    test("countFileGroupsByDate", _countFileGroupsByDate);
  });
}

/// Clean up Files without an associated entry in AccountFiles
///
/// Expect: Dangling files deleted
Future<void> _cleanUpDanglingFiles() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final db = util.buildTestDb();
  addTearDown(() => db.close());
  await db.transaction(() async {
    await db.insertAccounts([account]);
    await util.insertFiles(db, account, files);

    await db.alsoFuture((db) async {
      await db
          .into(db.files)
          .insert(FilesCompanion.insert(server: 1, fileId: files.length));
    });
  });

  expect(await db.select(db.files).map((f) => f.fileId).get(), [0, 1, 2]);
  await db.let((db) async {
    await db.cleanUpDanglingFiles();
  });
  expect(await db.select(db.files).map((f) => f.fileId).get(), [0, 1]);
}

Future<void> _countFileGroupsByDate() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg(
              "admin/test1.jpg",
              lastModified: DateTime(2024, 1, 2, 3, 4, 5),
            )
            ..addJpeg(
              "admin/test2.jpg",
              lastModified: DateTime(2024, 1, 2, 4, 5, 6),
            )
            ..addJpeg(
              "admin/test3.jpg",
              lastModified: DateTime(2024, 1, 3, 4, 5, 6),
            ))
          .build();
  final db = util.buildTestDb();
  addTearDown(() => db.close());
  await db.transaction(() async {
    await db.insertAccounts([account]);
    await util.insertFiles(db, account, files);
  });

  final result = await db.countFileGroupsByDate(account: ByAccount.db(account));
  expect(result.dateCount, {Date(2024, 1, 2): 2, Date(2024, 1, 3): 1});
}
