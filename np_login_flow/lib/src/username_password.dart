import 'package:logging/logging.dart';
import 'package:np_api/np_api.dart';
import 'package:np_log/np_log.dart';
import 'package:np_login_flow/src/exception.dart';
import 'package:np_login_flow/src/login.dart';
import 'package:np_login_flow/src/type.dart';

part 'username_password.g.dart';

/// Exchange token with username and password (or app password)
@npLog
class UsernamePassword implements LoginFlow {
  UsernamePassword({required this.username, required this.password});

  @override
  void dispose() {}

  @override
  Future<LoginResult> login({required Uri uri}) async {
    _log.info("[login] $uri");
    final api = Api(uri, BasicAuth(username, password));
    final response = await api.request(
      "GET",
      "ocs/v2.php/core/getapppassword",
      header: {"OCS-APIRequest": "true"},
    );
    if (!_shouldRun) {
      _log.fine("[login] Login interrupted");
      throw const LoginInterruptedException();
    }
    if (response.isGood) {
      try {
        final appPwdRegex = RegExp(r"<apppassword>(.*)</apppassword>");
        final appPwdMatch = appPwdRegex.firstMatch(response.body);
        final value = appPwdMatch!.group(1)!;
        return LoginResult(server: uri, username: username, password: value);
      } catch (_) {
        // this happens when the address is not the base URL and so Nextcloud
        // returned the login page
        throw const InvalidBaseUrlException();
      }
    } else if (response.statusCode == 403) {
      // If the client is authenticated with an app password a 403 will be
      // returned
      _log.info("[login] Already an app password");
      return LoginResult(server: uri, username: username, password: password);
    } else {
      _log.severe("[login] Failed while requesting app password: $response");
      throw LoginException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  void interrupt() {
    _shouldRun = false;
  }

  final String username;
  final String password;

  var _shouldRun = true;
}
