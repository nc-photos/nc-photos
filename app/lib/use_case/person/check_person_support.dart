import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/use_case/check_server_app_health.dart';
import 'package:nc_photos/use_case/recognize_face/recognize_api_key_manager.dart';

enum CheckPersonSupportResult { ok, noop, noServerApp }

class CheckPersonSupport {
  const CheckPersonSupport({
    required this.account,
    required this.accountPrefController,
    required this.serverController,
  });

  Future<CheckPersonSupportResult> check() async {
    final personProvider = accountPrefController.personProviderValue;
    switch (personProvider) {
      case PersonProvider.none:
        return CheckPersonSupportResult.ok;
      case PersonProvider.faceRecognition:
        return CheckPersonSupportResult.ok;
      case PersonProvider.recognize:
        return await _checkRecognize();
    }
  }

  Future<CheckPersonSupportResult> _checkRecognize() async {
    if (serverController.isSupported(ServerFeature.recognizeApiKey)) {
      if (!SessionStorage().hasCheckedRecognizeSupport) {
        try {
          await CheckServerAppHealth(account: account).check();
          return CheckPersonSupportResult.ok;
        } on ServerAppNotInstalledError catch (_) {
          return CheckPersonSupportResult.noServerApp;
        }
      } else {
        return CheckPersonSupportResult.noop;
      }
    }
    return CheckPersonSupportResult.ok;
  }

  final Account account;
  final AccountPrefController accountPrefController;
  final ServerController serverController;
}
