import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:np_db/np_db.dart';

class CompatV81 {
  static Future<void> clearDb(PrefController prefController, NpDb db) async {
    final accounts = prefController.accountsValue;
    return db.clearAndInitWithAccounts(accounts.toDb());
  }
}
