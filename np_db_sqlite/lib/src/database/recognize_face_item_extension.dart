part of '../database_extension.dart';

extension SqliteDbRecognizeFaceItemExtension on SqliteDb {
  /// Return all items of a specific face provided by Recognize
  Future<List<RecognizeFaceItem>> queryRecognizeFaceItemsByFaceLabel({
    required ByAccount account,
    required String label,
    List<RecognizeFaceItemSort>? orderBy,
    int? limit,
    int? offset,
  }) {
    _log.info("[queryRecognizeFaceItemsByFaceLabel] label: $label");
    final query = select(recognizeFaceItems).join([
      innerJoin(
        recognizeFaces,
        recognizeFaces.rowId.equalsExp(recognizeFaceItems.parent),
        useColumns: false,
      ),
    ]);
    if (account.sqlAccount != null) {
      query
        ..where(recognizeFaces.account.equals(account.sqlAccount!.rowId))
        ..where(recognizeFaces.label.equals(label));
    } else {
      query
        ..join([
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
        )
        ..where(recognizeFaces.label.equals(label));
    }
    if (orderBy != null) {
      query.orderBy(orderBy.toOrderingItem(this).toList());
      if (limit != null) {
        query.limit(limit, offset: offset);
      }
    }
    return query.map((r) => r.readTable(recognizeFaceItems)).get();
  }
}
