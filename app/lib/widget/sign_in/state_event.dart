part of '../sign_in.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.scheme,
    required this.serverUrl,
    required this.username,
    required this.password,
    required this.shouldObscurePassword,
    this.connectArg,
    this.connectedAccount,
    required this.isConnecting,
    required this.isCompleted,
    required this.method,
    this.error,
  });

  factory _State.init() => const _State(
        scheme: _Scheme.https,
        serverUrl: "",
        username: "",
        password: "",
        shouldObscurePassword: true,
        isConnecting: false,
        isCompleted: false,
        method: _SignInMethod.serverFlowV2,
      );

  @override
  String toString() => _$toString();

  final _Scheme scheme;
  final String serverUrl;
  final String username;
  final String password;
  final bool shouldObscurePassword;
  final _ConnectArg? connectArg;
  final Account? connectedAccount;
  final bool isConnecting;
  final bool isCompleted;

  final _SignInMethod method;

  final ExceptionEvent? error;
}

abstract class _Event {}

@toString
class _SetScheme implements _Event {
  const _SetScheme(this.value);

  @override
  String toString() => _$toString();

  final _Scheme value;
}

@toString
class _SetServerUrl implements _Event {
  const _SetServerUrl(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _Connect implements _Event {
  const _Connect();

  @override
  String toString() => _$toString();
}

@toString
class _SetConnectedAccount implements _Event {
  const _SetConnectedAccount(this.value);

  @override
  String toString() => _$toString();

  final Account value;
}

@toString
class _SetSignInMethod implements _Event {
  const _SetSignInMethod(this.value);

  @override
  String toString() => _$toString();

  final _SignInMethod value;
}

@toString
class _SetUsername implements _Event {
  const _SetUsername(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _SetPassword implements _Event {
  const _SetPassword(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _SetObscurePassword implements _Event {
  const _SetObscurePassword(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
