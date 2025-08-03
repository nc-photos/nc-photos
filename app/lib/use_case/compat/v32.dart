import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'v32.g.dart';

/// Compatibility helper for v32
@npLog
class CompatV32 {
  static Future<bool> isPrefNeedMigration() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey("accounts");
  }

  static Future<void> migratePref() async {
    final pref = await SharedPreferences.getInstance();
    final jsons = pref.getStringList("accounts");
    if (jsons == null) {
      return;
    }
    _log.info("[migratePref] Migrate Pref.accounts");
    final newJsons = <JsonObj>[];
    for (final j in jsons) {
      newJsons.add(<String, dynamic>{
        "account": jsonDecode(j),
        "settings": <String, dynamic>{
          "isEnableFaceRecognitionApp": true,
        },
      });
    }
    if (await pref.setStringList(
        "accounts2", newJsons.map((e) => jsonEncode(e)).toList())) {
      _log.info("[migratePref] Migrated ${newJsons.length} accounts");
      await pref.remove("accounts");
    } else {
      _log.severe("[migratePref] Failed while writing pref");
    }
  }

  static bool isExifNeedMigration(Exif exif) =>
      exif.data.containsKey("UserComment") ||
      exif.data.containsKey("MakerNote");

  static Exif migrateExif(Exif exif, String logFilename) {
    _log.info("[migrateExif] Migrate EXIF for file: $logFilename");
    final newData = Map.of(exif.data);
    newData.removeWhere(
        (key, value) => key == "UserComment" || key == "MakerNote");
    return Exif(newData);
  }

  static final _log = _$CompatV32NpLog.log;
}
