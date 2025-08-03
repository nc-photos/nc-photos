import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:xml/xml.dart';

class RecognizeFaceParser extends XmlResponseParser {
  Future<List<RecognizeFace>> parse(String response) =>
      compute(_parseRecognizeFacesIsolate, response);

  List<RecognizeFace> _parse(XmlDocument xml) =>
      parseT<RecognizeFace>(xml, _toRecognizeFace);

  /// Map <DAV:response> contents to RecognizeFace
  RecognizeFace _toRecognizeFace(XmlElement element) {
    String? href;

    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName("href",
          prefix: "DAV:", namespaces: namespaces)) {
        href = Uri.decodeComponent(child.innerText);
      }
    }

    return RecognizeFace(
      href: href!,
    );
  }
}

List<RecognizeFace> _parseRecognizeFacesIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return RecognizeFaceParser()._parse(xml);
}
