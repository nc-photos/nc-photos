import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'request_public_link.g.dart';

@npLog
class RequestPublicLink {
  /// Request a temporary unique public link to [file]
  Future<String> call(Account account, FileDescriptor file) async {
    final response = await ApiUtil.fromAccount(account)
        .ocs()
        .dav()
        .direct()
        .post(fileId: file.fdId);
    if (!response.isGood) {
      _log.severe("[call] Failed requesting server: $response");
      throw ApiException(
          response: response,
          message:
              "Server responed with an error: HTTP ${response.statusCode}");
    }
    final JsonObj json = jsonDecode(response.body)["ocs"];
    if (json["meta"]["statuscode"] != 200) {
      _log.shout(
          "[call] Failed requesting server: ${jsonEncode(json["meta"])}");
      throw ApiException(
          response: response,
          message:
              "Server responed with an error: HTTP ${json["meta"]["statuscode"]} ${json["meta"]["message"]}");
    }
    return json["data"]["url"];
  }
}
