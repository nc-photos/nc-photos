part of '../database_extension.dart';

extension SqliteDbFaceRecognitionPersonExtension on SqliteDb {
  /// Return all faces provided by FaceRecognition
  Future<List<FaceRecognitionPerson>> queryFaceRecognitionPersons({
    required ByAccount account,
  }) {
    _log.info("[queryFaceRecognitionPersons]");
    if (account.sqlAccount != null) {
      final query = select(faceRecognitionPersons)
        ..where((t) => t.account.equals(account.sqlAccount!.rowId));
      return query.get();
    } else {
      final query =
          select(faceRecognitionPersons).join([
              innerJoin(
                accounts,
                accounts.rowId.equalsExp(faceRecognitionPersons.account),
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
      return query.map((r) => r.readTable(faceRecognitionPersons)).get();
    }
  }

  Future<List<FaceRecognitionPerson>> searchFaceRecognitionPersonByName({
    required ByAccount account,
    required String name,
  }) async {
    _log.info("[searchFaceRecognitionPersonByName] name: $name");
    if (account.sqlAccount != null) {
      final query =
          select(faceRecognitionPersons)
            ..where((t) => t.account.equals(account.sqlAccount!.rowId))
            ..where(
              (t) =>
                  t.name.like(name) |
                  t.name.like("% $name") |
                  t.name.like("$name %"),
            );
      return query.get();
    } else {
      final query =
          select(faceRecognitionPersons).join([
              innerJoin(
                accounts,
                accounts.rowId.equalsExp(faceRecognitionPersons.account),
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
            ..where(
              faceRecognitionPersons.name.like(name) |
                  faceRecognitionPersons.name.like("% $name") |
                  faceRecognitionPersons.name.like("$name %"),
            );
      return query.map((r) => r.readTable(faceRecognitionPersons)).get();
    }
  }

  Future<void> replaceFaceRecognitionPersons({
    required ByAccount account,
    required List<DbFaceRecognitionPerson> inserts,
    required List<DbFaceRecognitionPerson> deletes,
    required List<DbFaceRecognitionPerson> updates,
  }) async {
    _log.info("[replaceFaceRecognitionPersons]");
    final sqlAccount = await accountOf(account);
    await batch((batch) {
      for (final d in deletes) {
        batch.deleteWhere(
          faceRecognitionPersons,
          ($FaceRecognitionPersonsTable t) =>
              t.account.equals(sqlAccount.rowId) & t.name.equals(d.name),
        );
      }
      for (final u in updates) {
        batch.update(
          faceRecognitionPersons,
          FaceRecognitionPersonConverter.toSql(
            sqlAccount,
            u,
          ).copyWith(account: const Value.absent(), name: const Value.absent()),
          where:
              ($FaceRecognitionPersonsTable t) =>
                  t.account.equals(sqlAccount.rowId) & t.name.equals(u.name),
        );
      }
      for (final i in inserts) {
        batch.insert(
          faceRecognitionPersons,
          FaceRecognitionPersonConverter.toSql(sqlAccount, i),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
