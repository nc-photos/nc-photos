import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/session_storage.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_log/np_log.dart';

part 'recognize_api_key_manager.g.dart';

class RecognizeNotInstalledError implements Exception {
  const RecognizeNotInstalledError();

  @override
  String toString() {
    return "Recognize not installed on server";
  }
}

class ServerAppNotInstalledError implements Exception {
  const ServerAppNotInstalledError();

  @override
  String toString() {
    return "nc-photos Integration app not installed on server";
  }
}

@npLog
class RecognizeApiKeyManager {
  const RecognizeApiKeyManager({required this.account});

  Future<String> getKey() async {
    // Recognize is expiring their api keys after 24 hours, we may as well not
    // persisting it then
    final apiKey = SessionStorage().accountRecognizeApiKeys[account.id];
    return apiKey ?? renewKey();
  }

  Future<String> renewKey() async {
    _log.info("[renewKey] $account");
    final token = ++_token;
    return _mutex.protect(() async {
      if (token != _token) {
        // already renewed
        final currentKey = SessionStorage().accountRecognizeApiKeys[account.id];
        if (currentKey != null) {
          return currentKey;
        }
        // only continue if previous call failed
      }
      final response = await ApiUtil.fromAccount(
        account,
      ).ocs().ncPhotosServer().recognizeApiKey().get();
      if (!response.isGood) {
        _log.severe("[renewKey] Failed requesting server: $response");
        if (response.statusCode == 501) {
          throw const RecognizeNotInstalledError();
        } else if (response.statusCode == 404) {
          throw const ServerAppNotInstalledError();
        }
        throw ApiException(
          response: response,
          message: "Server responed with an error: HTTP ${response.statusCode}",
        );
      }

      try {
        final apiResult = api.RecognizeApiKeyParser().parse(response.body);
        final apiKey = apiResult.apiKey;
        _log.fine("[renewKey] New API Key: $apiKey");
        SessionStorage().accountRecognizeApiKeys[account.id] = apiKey;
        return apiKey;
      } catch (e, stackTrace) {
        _log.severe("[renewKey] Failed while parse", e, stackTrace);
        rethrow;
      }
    });
  }

  final Account account;

  static final _mutex = Mutex();
  static var _token = 0;
}
