part of '../database_extension.dart';

extension SqliteDbNcAlbumItemExtension on SqliteDb {
  Future<List<NcAlbumItem>> queryNcAlbumItemsByParentRelativePath({
    required ByAccount account,
    required String parentRelativePath,
  }) {
    final query = select(ncAlbumItems).join([
      innerJoin(
        ncAlbums,
        ncAlbums.rowId.equalsExp(ncAlbumItems.parent),
        useColumns: false,
      ),
    ]);
    if (account.sqlAccount != null) {
      query.where(ncAlbums.account.equals(account.sqlAccount!.rowId));
    } else {
      query.join([
          innerJoin(
            accounts,
            accounts.rowId.equalsExp(ncAlbums.account),
            useColumns: false,
          ),
          innerJoin(
            servers,
            servers.rowId.equalsExp(accounts.server),
            useColumns: false,
          ),
        ])
        ..where(servers.address.equals(account.dbAccount!.serverAddress))
        ..where(
          accounts.userId.equals(
            account.dbAccount!.userId.toCaseInsensitiveString(),
          ),
        );
    }
    query.where(ncAlbums.relativePath.equals(parentRelativePath));
    return query.map((r) => r.readTable(ncAlbumItems)).get();
  }

  Future<void> replaceNcAlbumItems({
    required int parentRowId,
    required List<DbNcAlbumItem> inserts,
    required List<DbNcAlbumItem> deletes,
    required List<DbNcAlbumItem> updates,
  }) async {
    _log.info("[replaceNcAlbumItems]");
    await batch((batch) {
      for (final d in deletes) {
        batch.deleteWhere(
          ncAlbumItems,
          ($NcAlbumItemsTable t) =>
              t.parent.equals(parentRowId) & t.fileId.equals(d.fileId),
        );
      }
      for (final u in updates) {
        batch.update(
          ncAlbumItems,
          NcAlbumItemConverter.toSql(parentRowId, u).copyWith(
            parent: const Value.absent(),
            relativePath: const Value.absent(),
          ),
          where:
              ($NcAlbumItemsTable t) =>
                  t.parent.equals(parentRowId) & t.fileId.equals(u.fileId),
        );
      }
      for (final i in inserts) {
        batch.insert(
          ncAlbumItems,
          NcAlbumItemConverter.toSql(parentRowId, i),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
