part of '../database_extension.dart';

extension SqliteDbNcAlbumExtension on SqliteDb {
  Future<NcAlbum?> queryNcAlbumByRelativePath({
    required ByAccount account,
    required String relativePath,
  }) {
    _log.info("[queryNcAlbumByRelativePath] relativePath: $relativePath");
    if (account.sqlAccount != null) {
      final query =
          select(ncAlbums)
            ..where((t) => t.account.equals(account.sqlAccount!.rowId))
            ..where((t) => t.relativePath.equals(relativePath));
      return query.getSingleOrNull();
    } else {
      final query =
          select(ncAlbums).join([
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
            )
            ..where(ncAlbums.relativePath.equals(relativePath));
      return query.map((r) => r.readTable(ncAlbums)).getSingleOrNull();
    }
  }

  Future<List<NcAlbum>> queryNcAlbums({required ByAccount account}) {
    _log.info("[queryNcAlbums]");
    if (account.sqlAccount != null) {
      final query = select(ncAlbums)
        ..where((t) => t.account.equals(account.sqlAccount!.rowId));
      return query.get();
    } else {
      final query =
          select(ncAlbums).join([
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
      return query.map((r) => r.readTable(ncAlbums)).get();
    }
  }

  Future<List<List<Object?>>> partialQueryNcAlbums({
    required ByAccount account,
    required List<Expression<Object>> columns,
  }) {
    _log.info("[partialQueryNcAlbums]");
    final query = selectOnly(ncAlbums)..addColumns(columns);
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
    return query.map((r) => columns.map((c) => r.read(c)).toList()).get();
  }

  Future<void> insertNcAlbum({
    required DbAccount account,
    required DbNcAlbum album,
  }) async {
    _log.info("[insertNcAlbum] $album");
    final sqlAccount = await accountOf(ByAccount.db(account));
    final obj = NcAlbumConverter.toSql(sqlAccount, album);
    await into(ncAlbums).insert(obj);
  }

  Future<void> deleteNcAlbum({
    required DbAccount account,
    required DbNcAlbum album,
  }) async {
    _log.info("[deleteNcAlbum] $album");
    final sqlAccount = await accountOf(ByAccount.db(account));
    await (delete(ncAlbums)
          ..where((t) => t.account.equals(sqlAccount.rowId))
          ..where((t) => t.relativePath.equals(album.relativePath)))
        .go();
  }

  Future<void> replaceNcAlbums({
    required ByAccount account,
    required List<DbNcAlbum> inserts,
    required List<DbNcAlbum> deletes,
    required List<DbNcAlbum> updates,
  }) async {
    _log.info("[replaceNcAlbums]");
    final sqlAccount = await accountOf(account);
    await batch((batch) {
      for (final d in deletes) {
        batch.deleteWhere(
          ncAlbums,
          ($NcAlbumsTable t) =>
              t.account.equals(sqlAccount.rowId) &
              t.relativePath.equals(d.relativePath),
        );
      }
      for (final u in updates) {
        batch.update(
          ncAlbums,
          NcAlbumConverter.toSql(sqlAccount, u).copyWith(
            account: const Value.absent(),
            relativePath: const Value.absent(),
          ),
          where:
              ($NcAlbumsTable t) =>
                  t.account.equals(sqlAccount.rowId) &
                  t.relativePath.equals(u.relativePath),
        );
      }
      for (final i in inserts) {
        batch.insert(
          ncAlbums,
          NcAlbumConverter.toSql(sqlAccount, i),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
