import 'package:drift/drift.dart' as sql;
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/tag/data_source.dart';
import 'package:nc_photos/use_case/sync_tag.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:test/test.dart';

import '../mock_type.dart';
import '../test_util.dart' as util;

void main() {
  group("SyncTag", () {
    test("new", _new);
    test("remove", _remove);
    test("update", _update);
  });
}

/// Sync with remote where there are new tags
///
/// Remote: [tag0, tag1, tag2]
/// Local: [tag0]
/// Expect: [tag0, tag1, tag2]
Future<void> _new() async {
  final account = util.buildAccount();
  final c = DiContainer.late();
  c.npDb = util.buildTestDb();
  addTearDown(() => c.sqliteDb.close());
  c.tagRepoRemote = MockTagMemoryRepo({
    account.url: [
      const Tag(id: 10, displayName: "tag0"),
      const Tag(id: 11, displayName: "tag1"),
      const Tag(id: 12, displayName: "tag2"),
    ],
  });
  c.tagRepoLocal = TagRepo(TagSqliteDbDataSource(c.npDb));
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.batch((batch) {
      batch.insert(
        c.sqliteDb.tags,
        compat.TagsCompanion.insert(server: 1, tagId: 10, displayName: "tag0"),
      );
    });
  });

  await SyncTag(c)(account);
  expect(await _listSqliteDbTags(c.sqliteDb), {
    account.url: {
      const DbTag(
        id: 10,
        displayName: "tag0",
        userVisible: null,
        userAssignable: null,
      ),
      const DbTag(
        id: 11,
        displayName: "tag1",
        userVisible: null,
        userAssignable: null,
      ),
      const DbTag(
        id: 12,
        displayName: "tag2",
        userVisible: null,
        userAssignable: null,
      ),
    },
  });
}

/// Sync with remote where there are removed tags
///
/// Remote: [tag0]
/// Local: [tag0, tag1, tag2]
/// Expect: [tag0]
Future<void> _remove() async {
  final account = util.buildAccount();
  final c = DiContainer.late();
  c.npDb = util.buildTestDb();
  addTearDown(() => c.sqliteDb.close());
  c.tagRepoRemote = MockTagMemoryRepo({
    account.url: [const Tag(id: 10, displayName: "tag0")],
  });
  c.tagRepoLocal = TagRepo(TagSqliteDbDataSource(c.npDb));
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.batch((batch) {
      batch.insertAll(c.sqliteDb.tags, [
        compat.TagsCompanion.insert(server: 1, tagId: 10, displayName: "tag0"),
        compat.TagsCompanion.insert(server: 1, tagId: 11, displayName: "tag1"),
        compat.TagsCompanion.insert(server: 1, tagId: 12, displayName: "tag2"),
      ]);
    });
  });

  await SyncTag(c)(account);
  expect(await _listSqliteDbTags(c.sqliteDb), {
    account.url: {
      const DbTag(
        id: 10,
        displayName: "tag0",
        userVisible: null,
        userAssignable: null,
      ),
    },
  });
}

/// Sync with remote where there are updated tags (i.e, same id, different
/// properties)
///
/// Remote: [tag0, new tag1]
/// Local: [tag0, tag1]
/// Expect: [tag0, new tag1]
Future<void> _update() async {
  final account = util.buildAccount();
  final c = DiContainer.late();
  c.npDb = util.buildTestDb();
  addTearDown(() => c.sqliteDb.close());
  c.tagRepoRemote = MockTagMemoryRepo({
    account.url: [
      const Tag(id: 10, displayName: "tag0"),
      const Tag(id: 11, displayName: "new tag1"),
    ],
  });
  c.tagRepoLocal = TagRepo(TagSqliteDbDataSource(c.npDb));
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.batch((batch) {
      batch.insertAll(c.sqliteDb.tags, [
        compat.TagsCompanion.insert(server: 1, tagId: 10, displayName: "tag0"),
        compat.TagsCompanion.insert(server: 1, tagId: 11, displayName: "tag1"),
      ]);
    });
  });

  await SyncTag(c)(account);
  expect(await _listSqliteDbTags(c.sqliteDb), {
    account.url: {
      const DbTag(
        id: 10,
        displayName: "tag0",
        userVisible: null,
        userAssignable: null,
      ),
      const DbTag(
        id: 11,
        displayName: "new tag1",
        userVisible: null,
        userAssignable: null,
      ),
    },
  });
}

Future<Map<String, Set<DbTag>>> _listSqliteDbTags(compat.SqliteDb db) async {
  final query = db.select(db.tags).join([
    sql.innerJoin(db.servers, db.servers.rowId.equalsExp(db.tags.server)),
  ]);
  final result =
      await query
          .map(
            (r) => (server: r.readTable(db.servers), tag: r.readTable(db.tags)),
          )
          .get();
  final product = <String, Set<DbTag>>{};
  for (final r in result) {
    (product[r.server.address] ??= {}).add(compat.TagConverter.fromSql(r.tag));
  }
  return product;
}
