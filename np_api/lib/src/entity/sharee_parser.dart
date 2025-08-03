import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/util.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'sharee_parser.g.dart';

@npLog
class ShareeParser {
  Future<List<Sharee>> parse(String response) =>
      compute(_parseShareesIsolate, response);

  List<Sharee> _parse(JsonObj json) {
    final jsons = json["ocs"]["data"].cast<String, dynamic>();
    final products = <Sharee>[];
    for (final t in _types) {
      for (final j in jsons[t] ?? []) {
        try {
          products.add(_parseSingle(j, t));
        } catch (e) {
          _log.severe("[_parse] Failed parsing json: ${jsonEncode(j)}", e);
        }
      }
    }
    return products;
  }

  Sharee _parseSingle(JsonObj json, String type) {
    return Sharee(
      type: type,
      label: json["label"],
      shareType: json["value"]["shareType"],
      shareWith: json["value"]["shareWith"],
      shareWithDisplayNameUnique: json["shareWithDisplayNameUnique"],
    );
  }
}

List<Sharee> _parseShareesIsolate(String response) {
  initMyLog();
  final json = (jsonDecode(response) as Map).cast<String, dynamic>();
  return ShareeParser()._parse(json);
}

const _types = {
  "users",
  "groups",
  "remotes",
  "remote_groups",
  "emails",
  "circles",
  "rooms",
  "deck",
  "lookup",
};
