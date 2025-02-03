// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_flow_v2.dart';

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$ServerFlowV2NpLog on ServerFlowV2 {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("src.server_flow_v2.ServerFlowV2");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_InitiateLoginResponseToString on _InitiateLoginResponse {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_InitiateLoginResponse {poll: $poll, login: $login}";
  }
}

extension _$_InitiateLoginPollOptionsToString on _InitiateLoginPollOptions {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_InitiateLoginPollOptions {token: ${isDevMode ? token : '***'}, endpoint: $endpoint, _validUntil: $_validUntil}";
  }
}

extension _$_PollLoginResponseToString on _PollLoginResponse {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PollLoginResponse {server: $server, loginName: $loginName, appPassword: ${isDevMode ? appPassword : '***'}}";
  }
}
