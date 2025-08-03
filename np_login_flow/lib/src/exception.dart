import 'package:np_api/np_api.dart';

/// The Nextcloud base URL address is invalid
class InvalidBaseUrlException implements Exception {
  const InvalidBaseUrlException([this.message]);

  @override
  String toString() {
    if (message == null) {
      return "InvalidBaseUrlException";
    } else {
      return "InvalidBaseUrlException: $message";
    }
  }

  final Object? message;
}

class LoginException implements Exception {
  const LoginException({
    required this.response,
    this.message,
  });

  @override
  String toString() {
    if (message == null) {
      return "LoginException";
    } else {
      return "LoginException: $message";
    }
  }

  final Response response;
  final Object? message;
}

class LoginExpiredException implements Exception {
  const LoginExpiredException();

  @override
  String toString() {
    return "LoginExpiredException";
  }
}

class LoginInterruptedException implements Exception {
  const LoginInterruptedException();

  @override
  String toString() {
    return "LoginInterruptedException";
  }
}
