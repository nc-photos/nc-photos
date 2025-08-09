import 'package:logging/logging.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'v46.g.dart';

@npLog
class CompatV46 {
  static Future<void> insertDbAccounts(
    PrefController prefController,
    NpDb db,
  ) async {
    _log.info("[insertDbAccounts] Insert current accounts to Sqlite database");
    final accounts = prefController.accountsValue;
    await db.addAccounts(accounts.toDb());
  }

  static final _log = _$CompatV46NpLog.log;
}
