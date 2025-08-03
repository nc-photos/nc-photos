import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/util.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'face_recognition_face_parser.g.dart';

@npLog
class FaceRecognitionFaceParser {
  Future<List<FaceRecognitionFace>> parse(String response) =>
      compute(_parseFacesIsolate, response);

  List<FaceRecognitionFace> _parse(JsonObj json) {
    final jsons = json["ocs"]["data"].cast<JsonObj>();
    final products = <FaceRecognitionFace>[];
    for (final j in jsons) {
      try {
        products.add(_parseSingle(j));
      } catch (e) {
        _log.severe("[_parse] Failed parsing json: ${jsonEncode(j)}", e);
      }
    }
    return products;
  }

  FaceRecognitionFace _parseSingle(JsonObj json) {
    return FaceRecognitionFace(
      id: json["id"],
      fileId: json["fileId"],
    );
  }
}

List<FaceRecognitionFace> _parseFacesIsolate(String response) {
  initMyLog();
  final json = (jsonDecode(response) as Map).cast<String, dynamic>();
  return FaceRecognitionFaceParser()._parse(json);
}
