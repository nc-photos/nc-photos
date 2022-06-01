import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/object_extension.dart';

enum UpdateCheckerResult { updateAvailable, alreadyLatest, error }

class UpdateChecker {
  Future<UpdateCheckerResult> call() async {
    try {
      final uri = Uri.https("bit.ly", "3pb2oG9");
      final req = http.Request("GET", uri);
      final response = await http.Response.fromStream(
        await http.Client().send(req),
      );
      if (response.statusCode != 200) {
        _log.severe("[call] Failed GETing URL: ${response.statusCode}");
        return UpdateCheckerResult.error;
      }
      final body = response.body;
      final json = jsonDecode(body) as Map;
      final data = json[_buildVariant] as Map;
      _log.info("[call] Update data: ${jsonEncode(data)}");
      final latest = data["v"];
      _versionStr = data["vStr"];
      _updateUrl = data["url"];
      if (latest > k.version) {
        return UpdateCheckerResult.updateAvailable;
      } else {
        return UpdateCheckerResult.alreadyLatest;
      }
    } catch (e, stackTrace) {
      _log.severe("[call] Exception", e, stackTrace);
      return UpdateCheckerResult.error;
    }
  }

  /// Return the binary url (if available) after [call] returned with
  /// [UpdateCheckerResult.updateAvailable]
  String? get updateUrl => _updateUrl;
  String? get versionStr => _versionStr;

  String? _updateUrl;
  String? _versionStr;

  static const _buildVariant = "";

  static final _log = Logger("update_checker.UpdateChecker");
}

class AutoUpdateChecker {
  const AutoUpdateChecker();

  Future<void> call() async {
    try {
      if (Pref().isAutoUpdateCheckAvailableOr()) {
        return;
      }

      final prev =
          Pref().getLastAutoUpdateCheckTime()?.run(
            (obj) => DateTime.fromMillisecondsSinceEpoch(obj).toUtc(),
          ) ??
          DateTime(0);
      final now = DateTime.now().toUtc();
      if (now.isAfter(prev) && now.difference(prev) > const Duration(days: 7)) {
        unawaited(
          Pref().setLastAutoUpdateCheckTime(now.millisecondsSinceEpoch),
        );
        await _check();
      }
    } catch (e, stackTrace) {
      _log.severe("[call] Exception", e, stackTrace);
    }
  }

  Future<void> _check() async {
    _log.info("[_check] Auto update check");
    final checker = UpdateChecker();
    final result = await checker();
    if (result == UpdateCheckerResult.updateAvailable) {
      _log.info("[_check] New update available");
      unawaited(Pref().setIsAutoUpdateCheckAvailable(true));
    }
  }

  static final _log = Logger("update_checker.AutoUpdateChecker");
}
