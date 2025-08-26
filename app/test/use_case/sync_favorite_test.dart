import 'package:drift/drift.dart' as sql;
import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/favorite.dart';
import 'package:nc_photos/use_case/sync_favorite.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:test/test.dart';

import '../mock_type.dart';
import '../test_util.dart' as util;

void main() {
  KiwiContainer().registerInstance<EventBus>(MockEventBus());

  group("SyncFavorite", () {
    test("new", _new);
    test("remove", _remove);
  });
}

Future<void> _new() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 100)
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg", isFavorite: true)
            ..addJpeg("admin/test2.jpg", isFavorite: true)
            ..addJpeg("admin/test3.jpg")
            ..addJpeg("admin/test4.jpg")
            ..addJpeg("admin/test5.jpg"))
          .build();
  final c = DiContainer(
    favoriteRepo: MockFavoriteMemoryRepo([
      const Favorite(fileId: 101),
      const Favorite(fileId: 102),
      const Favorite(fileId: 103),
      const Favorite(fileId: 104),
    ]),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  await SyncFavorite(c)(account);
  expect(await _listSqliteDbFavoriteFileIds(c.sqliteDb), {101, 102, 103, 104});
}

Future<void> _remove() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 100)
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg", isFavorite: true)
            ..addJpeg("admin/test2.jpg", isFavorite: true)
            ..addJpeg("admin/test3.jpg", isFavorite: true)
            ..addJpeg("admin/test4.jpg", isFavorite: true)
            ..addJpeg("admin/test5.jpg"))
          .build();
  final c = DiContainer(
    favoriteRepo: MockFavoriteMemoryRepo([
      const Favorite(fileId: 103),
      const Favorite(fileId: 104),
    ]),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  await SyncFavorite(c)(account);
  expect(await _listSqliteDbFavoriteFileIds(c.sqliteDb), {103, 104});
}

Future<Set<int>> _listSqliteDbFavoriteFileIds(compat.SqliteDb db) async {
  final query =
      db.selectOnly(db.files).join([
          sql.innerJoin(
            db.accountFiles,
            db.accountFiles.file.equalsExp(db.files.rowId),
          ),
        ])
        ..addColumns([db.files.fileId])
        ..where(db.accountFiles.isFavorite.equals(true));
  return (await query.map((r) => r.read(db.files.fileId)!).get()).toSet();
}
