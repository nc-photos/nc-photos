import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/use_case/recognize_face/recognize_api_key_manager.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_log/np_log.dart';

part 'check_server_app_health.g.dart';

abstract class ServerAppHealth {
  bool get canGetRecognizeApiKey;
}

@npLog
class CheckServerAppHealth {
  const CheckServerAppHealth({required this.account});

  Future<ServerAppHealth> check() async {
    final response = await ApiUtil.fromAccount(
      account,
    ).ocs().ncPhotosServer().health().get();
    if (!response.isGood) {
      _log.severe("[check] Failed requesting server: $response");
      if (response.statusCode == 404) {
        throw const ServerAppNotInstalledError();
      }
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    try {
      final apiResult = api.NcPhotosServerHealthParser().parse(response.body);
      _log.fine("[check] Result: $apiResult");
      return _ServerAppHealthImpl(serverResult: apiResult);
    } catch (e, stackTrace) {
      _log.severe("[check] Failed while parse", e, stackTrace);
      rethrow;
    }
  }

  final Account account;
}

class _ServerAppHealthImpl implements ServerAppHealth {
  const _ServerAppHealthImpl({required this.serverResult});

  @override
  bool get canGetRecognizeApiKey =>
      serverResult.version >= 10000 && serverResult.recognizeOk;

  final api.NcPhotosServerHealth serverResult;
}
