import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/util.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'share_parser.g.dart';

@npLog
class ShareParser {
  Future<List<Share>> parse(String response) =>
      compute(_parseSharesIsolate, response);

  List<Share> _parse(JsonObj json) {
    final jsons = json["ocs"]["data"].cast<JsonObj>();
    final products = <Share>[];
    for (final j in jsons) {
      try {
        products.add(_parseSingle(j));
      } catch (e) {
        _log.severe("[_parse] Failed parsing json: ${jsonEncode(j)}", e);
      }
    }
    return products;
  }

  Share _parseSingle(JsonObj json) {
    return Share(
      id: json["id"],
      shareType: json["share_type"],
      stime: json["stime"],
      uidOwner: json["uid_owner"],
      displaynameOwner: json["displayname_owner"],
      uidFileOwner: json["uid_file_owner"],
      path: json["path"],
      itemType: json["item_type"],
      mimeType: json["mimetype"],
      itemSource: json["item_source"],
      shareWith: json["share_with"],
      shareWithDisplayName: json["share_with_displayname"],
      url: json["url"],
    );
  }
}

List<Share> _parseSharesIsolate(String response) {
  initMyLog();
  final json = (jsonDecode(response) as Map).cast<String, dynamic>();
  return ShareParser()._parse(json);
}
