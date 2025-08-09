import 'dart:convert';

import 'package:np_api/src/util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'type.g.dart';

@toString
class Response {
  Response(this.statusCode, this.headers, this.body);

  bool get isGood => isHttpStatusGood(statusCode);

  @override
  String toString() => _$toString();

  final int statusCode;
  @Format(r"...")
  final Map<String, String> headers;

  /// Content of the response body, String if isResponseString == true during
  /// request, Uint8List otherwise
  @Format(
    r"${isDevMode ? $?.toString().replaceAll(RegExp(r'\n\t'), '').slice(0, 200) : '...'}",
  )
  final dynamic body;
}

@toString
class BasicAuth {
  const BasicAuth(this.username, this.password);

  String toHeaderValue() {
    final authString = base64.encode(utf8.encode("$username:$password"));
    return "Basic $authString";
  }

  @override
  String toString() => _$toString();

  final String username;
  final String password;
}
