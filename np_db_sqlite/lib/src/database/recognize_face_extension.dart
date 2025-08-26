part of '../database_extension.dart';

extension SqliteDbRecognizeFaceExtension on SqliteDb {
  /// Return all faces provided by Recognize
  Future<List<RecognizeFace>> queryRecognizeFaces({
    required ByAccount account,
    List<String>? labels,
  }) {
    _log.info("[queryRecognizeFaces]");
    if (account.sqlAccount != null) {
      final query = select(recognizeFaces)
        ..where((t) => t.account.equals(account.sqlAccount!.rowId));
      if (labels != null) {
        query.where((t) => t.label.isIn(labels));
      }
      return query.get();
    } else {
      final query =
          select(recognizeFaces).join([
              innerJoin(
                accounts,
                accounts.rowId.equalsExp(recognizeFaces.account),
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
      if (labels != null) {
        query.where(recognizeFaces.label.isIn(labels));
      }
      return query.map((r) => r.readTable(recognizeFaces)).get();
    }
  }

  Future<void> replaceRecognizeFaces({
    required ByAccount account,
    required List<DbRecognizeFace> inserts,
    required List<DbRecognizeFace> deletes,
    required List<DbRecognizeFace> updates,
  }) async {
    _log.info("[replaceRecognizeFaces]");
    final sqlAccount = await accountOf(account);
    await batch((batch) {
      for (final d in deletes) {
        batch.deleteWhere(
          recognizeFaces,
          ($RecognizeFacesTable t) =>
              t.account.equals(sqlAccount.rowId) & t.label.equals(d.label),
        );
      }
      for (final u in updates) {
        batch.update(
          recognizeFaces,
          RecognizeFacesCompanion(label: Value(u.label)),
          where:
              ($RecognizeFacesTable t) =>
                  t.account.equals(sqlAccount.rowId) & t.label.equals(u.label),
        );
      }
      for (final i in inserts) {
        batch.insert(
          recognizeFaces,
          RecognizeFaceConverter.toSql(sqlAccount, i),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Future<void> replaceRecognizeFaceItems({
    required RecognizeFace face,
    required List<DbRecognizeFaceItem> inserts,
    required List<DbRecognizeFaceItem> deletes,
    required List<DbRecognizeFaceItem> updates,
  }) async {
    _log.info("[replaceRecognizeFaceItems] face: $face");
    await batch((batch) {
      for (final d in deletes) {
        batch.deleteWhere(
          recognizeFaceItems,
          ($RecognizeFaceItemsTable t) =>
              t.parent.equals(face.rowId) & t.fileId.equals(d.fileId),
        );
      }
      for (final u in updates) {
        batch.update(
          recognizeFaceItems,
          RecognizeFaceItemConverter.toSql(face, u).copyWith(
            parent: const Value.absent(),
            fileId: const Value.absent(),
          ),
          where:
              ($RecognizeFaceItemsTable t) =>
                  t.parent.equals(face.rowId) & t.fileId.equals(u.fileId),
        );
      }
      for (final i in inserts) {
        batch.insert(
          recognizeFaceItems,
          RecognizeFaceItemConverter.toSql(face, i),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
