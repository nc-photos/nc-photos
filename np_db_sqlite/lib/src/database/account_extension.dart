part of '../database_extension.dart';

extension SqliteDbAccountExtension on SqliteDb {
  Future<void> insertAccounts(List<DbAccount> accounts) async {
    final serverUrls = <String>{};
    for (final a in accounts) {
      serverUrls.add(a.serverAddress);
    }
    final dbServers = <String, Server>{};
    for (final url in serverUrls) {
      try {
        dbServers[url] = await into(servers).insertReturning(
          ServersCompanion.insert(address: url),
          mode: InsertMode.insertOrIgnore,
        );
      } on StateError catch (_) {
        // already exists
        final query = select(servers)..where((t) => t.address.equals(url));
        dbServers[url] = await query.getSingle();
      }
    }
    for (final a in accounts) {
      await into(this.accounts).insert(
        AccountsCompanion.insert(
          server: dbServers[a.serverAddress]!.rowId,
          userId: a.userId.toCaseInsensitiveString(),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Delete an account
  ///
  /// If the deleted Account is the last one associated with a Server, then the
  /// Server will also be deleted
  Future<void> deleteAccount(DbAccount account) async {
    final sqlAccount = await accountOf(ByAccount.db(account));
    _log.info("[deleteAccount] Remove account: ${sqlAccount.rowId}");
    await (delete(accounts)
      ..where((t) => t.rowId.equals(sqlAccount.rowId))).go();
    final accountCountExp = accounts.rowId.count(
      filter: accounts.server.equals(sqlAccount.server),
    );
    final accountCountQuery = selectOnly(accounts)
      ..addColumns([accountCountExp]);
    final accountCount =
        await accountCountQuery.map((r) => r.read(accountCountExp)).getSingle();
    _log.info("[deleteAccount] Remaining accounts in server: $accountCount");
    if (accountCount == 0) {
      _log.info("[deleteAccount] Remove server: ${sqlAccount.server}");
      await (delete(servers)
        ..where((t) => t.rowId.equals(sqlAccount.server))).go();
    }
    await cleanUpDanglingFiles();
  }
}
