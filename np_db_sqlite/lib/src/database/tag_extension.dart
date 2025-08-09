part of '../database_extension.dart';

extension SqliteDbTagExtension on SqliteDb {
  Future<List<Tag>> queryTags({required ByAccount account}) async {
    _log.info("[queryTags]");
    if (account.sqlAccount != null) {
      final query = select(tags)
        ..where((t) => t.server.equals(account.sqlAccount!.server));
      return query.get();
    } else {
      final query = select(tags).join([
        innerJoin(
          servers,
          servers.rowId.equalsExp(tags.server),
          useColumns: false,
        ),
      ])..where(servers.address.equals(account.dbAccount!.serverAddress));
      return query.map((r) => r.readTable(tags)).get();
    }
  }

  Future<Tag?> queryTagByDisplayName({
    required ByAccount account,
    required String displayName,
  }) {
    _log.info("[queryTagByDisplayName] displayName: $displayName");
    if (account.sqlAccount != null) {
      final query =
          select(tags)
            ..where((t) => t.server.equals(account.sqlAccount!.server))
            ..where((t) => t.displayName.like(displayName))
            ..limit(1);
      return query.getSingleOrNull();
    } else {
      final query =
          select(tags).join([
              innerJoin(
                servers,
                servers.rowId.equalsExp(tags.server),
                useColumns: false,
              ),
            ])
            ..where(servers.address.equals(account.dbAccount!.serverAddress))
            ..where(tags.displayName.like(displayName))
            ..limit(1);
      return query.map((r) => r.readTable(tags)).getSingleOrNull();
    }
  }

  Future<void> replaceTags({
    required ByAccount account,
    required List<DbTag> inserts,
    required List<DbTag> deletes,
    required List<DbTag> updates,
  }) async {
    _log.info("[replaceTags]");
    final sqlAccount = await accountOf(account);
    await batch((batch) {
      for (final d in deletes) {
        batch.deleteWhere(
          tags,
          ($TagsTable t) =>
              t.server.equals(sqlAccount.server) & t.tagId.equals(d.id),
        );
      }
      for (final u in updates) {
        batch.update(
          tags,
          TagConverter.toSql(
            sqlAccount,
            u,
          ).copyWith(server: const Value.absent(), tagId: const Value.absent()),
          where:
              ($TagsTable t) =>
                  t.server.equals(sqlAccount.server) & t.tagId.equals(u.id),
        );
      }
      for (final i in inserts) {
        batch.insert(
          tags,
          TagConverter.toSql(sqlAccount, i),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
