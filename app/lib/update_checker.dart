import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:nc_photos/k.dart' as k;

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
