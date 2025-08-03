import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/util.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'face_recognition_person_parser.g.dart';

@npLog
class FaceRecognitionPersonParser {
  Future<List<FaceRecognitionPerson>> parse(String response) =>
      compute(_parsePersonsIsolate, response);

  List<FaceRecognitionPerson> _parse(JsonObj json) {
    final jsons = json["ocs"]["data"].cast<JsonObj>();
    final products = <FaceRecognitionPerson>[];
    for (final j in jsons) {
      try {
        products.add(_parseSingle(j));
      } catch (e) {
        _log.severe("[_parse] Failed parsing json: ${jsonEncode(j)}", e);
      }
    }
    return products;
  }

  FaceRecognitionPerson _parseSingle(JsonObj json) {
    return FaceRecognitionPerson(
      name: json["name"],
      thumbFaceId: json["thumbFaceId"],
      count: json["count"],
    );
  }
}

List<FaceRecognitionPerson> _parsePersonsIsolate(String response) {
  initMyLog();
  final json = (jsonDecode(response) as Map).cast<String, dynamic>();
  return FaceRecognitionPersonParser()._parse(json);
}
