import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_universal_storage/np_universal_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'v34.g.dart';

/// Compatibility helper for v34
@npLog
class CompatV34 {
  static Future<bool> isPrefNeedMigration() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey("accounts2") || pref.containsKey("accounts");
  }

  static Future<void> migratePref(UniversalStorage storage) async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey("accounts2")) {
      return _migratePrefV2(pref, storage);
    } else {
      return _migratePrefV1(pref, storage);
    }
  }

  static Future<void> _migratePrefV2(
      SharedPreferences pref, UniversalStorage storage) async {
    final jsons = pref.getStringList("accounts2");
    if (jsons == null) {
      return;
    }
    _log.info("[migratePref] Migrate Pref.accounts2");
    final newJsons = <JsonObj>[];
    for (final j in jsons) {
      final JsonObj account2 = jsonDecode(j).cast<String, dynamic>();
      final id = Account.newId();
      account2["account"]["id"] = id;
      newJsons.add(account2["account"]);
      await storage.putString(
          "accounts/$id/pref", jsonEncode(account2["settings"]));
    }
    if (await pref.setStringList(
        "accounts3", newJsons.map((e) => jsonEncode(e)).toList())) {
      _log.info("[migratePref] Migrated ${newJsons.length} accounts2");
      await pref.remove("accounts2");
    } else {
      _log.severe("[migratePref] Failed while writing pref");
    }
  }

  static Future<void> _migratePrefV1(
      SharedPreferences pref, UniversalStorage storage) async {
    final jsons = pref.getStringList("accounts");
    if (jsons == null) {
      return;
    }
    _log.info("[migratePref] Migrate Pref.accounts");
    final newJsons = <JsonObj>[];
    for (final j in jsons) {
      final JsonObj account = jsonDecode(j).cast<String, dynamic>();
      final id = Account.newId();
      account["id"] = id;
      newJsons.add(account);
      await storage.putString("accounts/$id/pref",
          """{"isEnableFaceRecognitionApp":true,"shareFolder":""}""");
    }
    if (await pref.setStringList(
        "accounts3", newJsons.map((e) => jsonEncode(e)).toList())) {
      _log.info("[migratePref] Migrated ${newJsons.length} accounts");
      await pref.remove("accounts");
    } else {
      _log.severe("[migratePref] Failed while writing pref");
    }
  }

  static final _log = _$CompatV34NpLog.log;
}
