import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:np_api/np_api.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_login_flow/src/exception.dart';
import 'package:np_login_flow/src/login.dart';
import 'package:np_login_flow/src/type.dart';
import 'package:to_string/to_string.dart';
import 'package:url_launcher/url_launcher.dart';

part 'server_flow_v2.g.dart';

@npLog
class ServerFlowV2 implements LoginFlow {
  ServerFlowV2() {
    _lifecycleListener = AppLifecycleListener(
      onHide: () {
        _isForeground = false;
      },
      onShow: () {
        _isForeground = true;
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
  }

  @override
  Future<LoginResult> login({
    required Uri uri,
  }) async {
    _log.info("[login] $uri");
    final initiateLoginResponse = await _initiateLogin(uri);
    launchUrl(Uri.parse(initiateLoginResponse.login),
        mode: LaunchMode.externalApplication);
    final loginResponse = await _pollLoginResult(initiateLoginResponse.poll);
    return LoginResult(
      server: loginResponse.server,
      username: loginResponse.loginName,
      password: loginResponse.appPassword,
    );
  }

  @override
  void interrupt() {
    _shouldRun = false;
  }

  /// Initiate a login with Nextcloud login flow v2: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2
  Future<_InitiateLoginResponse> _initiateLogin(Uri uri) async {
    final response = await Api.fromBaseUrl(uri).request(
      "POST",
      "index.php/login/v2",
    );
    if (response.isGood) {
      return _InitiateLoginResponse.fromJson(jsonDecode(response.body));
    } else {
      _log.severe(
          "[_initiateLogin] Failed while requesting app password: $response");
      throw LoginException(
        response: response,
        message: "Server responded with an error: HTTP ${response.statusCode}",
      );
    }
  }

  /// Polls the app password endpoint every 5 seconds as lang as the token is
  /// valid.
  ///
  /// See https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2
  Future<_PollLoginResponse> _pollLoginResult(
      _InitiateLoginPollOptions options) async {
    while (true) {
      if (!_shouldRun) {
        _log.fine("[_pollLoginResult] Login interrupted");
        throw const LoginInterruptedException();
      }
      if (!options.isTokenValid()) {
        _log.severe("[_pollLoginResult] Token expired");
        throw const LoginExpiredException();
      }

      if (_isForeground) {
        try {
          final result = await _pollLoginResultOnce(options);
          if (result != null) {
            return result;
          }
        } on ClientException catch (e) {
          if (e.message ==
              "Connection closed before full header was received") {
            _log.fine("[_pollLoginResult] connection workaround");
          } else {
            rethrow;
          }
        }
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<_PollLoginResponse?> _pollLoginResultOnce(
      _InitiateLoginPollOptions options) async {
    final Uri uri;
    if (options.endpoint.scheme == "http") {
      uri = Uri.http(options.endpoint.authority);
    } else {
      uri = Uri.https(options.endpoint.authority);
    }
    final response = await Api.fromBaseUrl(uri).request(
      "POST",
      options.endpoint.pathSegments.join("/"),
      header: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "token=${options.token}",
    );
    if (response.statusCode == 200) {
      return _PollLoginResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      // not yet available
      return null;
    } else {
      _log.severe(
          "[_pollLoginResult] Failed while requesting app password: $response");
      throw LoginException(
        response: response,
        message: "Server responded with an error: HTTP ${response.statusCode}",
      );
    }
  }

  late AppLifecycleListener _lifecycleListener;
  var _isForeground = true;
  var _shouldRun = true;
}

@toString
class _InitiateLoginResponse {
  const _InitiateLoginResponse({
    required this.poll,
    required this.login,
  });

  factory _InitiateLoginResponse.fromJson(JsonObj json) {
    return _InitiateLoginResponse(
      poll: _InitiateLoginPollOptions(
          json["poll"]["token"], json["poll"]["endpoint"]),
      login: json["login"],
    );
  }

  @override
  String toString() => _$toString();

  final _InitiateLoginPollOptions poll;
  final String login;
}

@toString
class _InitiateLoginPollOptions {
  _InitiateLoginPollOptions(this.token, String endpoint)
      : endpoint = Uri.parse(endpoint),
        _validUntil = clock.now().add(const Duration(minutes: 20));

  @override
  String toString() => _$toString();

  bool isTokenValid() {
    return clock.now().isBefore(_validUntil);
  }

  @Format(r"${isDevMode ? $? : '***'}")
  final String token;
  final Uri endpoint;
  final DateTime _validUntil;
}

@toString
class _PollLoginResponse {
  const _PollLoginResponse({
    required this.server,
    required this.loginName,
    required this.appPassword,
  });

  factory _PollLoginResponse.fromJson(JsonObj json) {
    return _PollLoginResponse(
      server: Uri.parse(json["server"]),
      loginName: json["loginName"],
      appPassword: json["appPassword"],
    );
  }

  @override
  String toString() => _$toString();

  final Uri server;
  final String loginName;
  @Format(r"${isDevMode ? appPassword : '***'}")
  final String appPassword;
}
