import 'package:np_login_flow/src/type.dart';

abstract interface class LoginFlow {
  void dispose();

  Future<LoginResult> login({
    required Uri uri,
  });

  /// Interrupt the login process in a near future
  void interrupt();
}
