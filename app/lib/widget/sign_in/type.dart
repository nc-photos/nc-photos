part of '../sign_in.dart';

enum _Scheme {
  http,
  https;

  String toValueString() {
    switch (this) {
      case http:
        return "http";

      case https:
        return "https";
    }
  }
}

@toString
class _ConnectArg {
  const _ConnectArg({
    required this.scheme,
    required this.address,
    this.username,
    this.password,
  });

  @override
  String toString() => _$toString();

  final String scheme;
  final String address;
  final String? username;
  final String? password;
}

enum _SignInMethod {
  serverFlowV2,
  usernamePassword,
}
