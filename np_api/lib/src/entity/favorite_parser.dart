import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:xml/xml.dart';

class FavoriteParser extends XmlResponseParser {
  Future<List<Favorite>> parse(String response) =>
      compute(_parseFavoritesIsolate, response);

  List<Favorite> _parse(XmlDocument xml) => parseT<Favorite>(xml, _toFavorite);

  /// Map <DAV:response> contents to Favorite
  Favorite _toFavorite(XmlElement element) {
    String? href;
    int? fileId;

    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName("href",
          prefix: "DAV:", namespaces: namespaces)) {
        href = Uri.decodeComponent(child.innerText);
      } else if (child.matchQualifiedName("propstat",
          prefix: "DAV:", namespaces: namespaces)) {
        final status = child.children
            .whereType<XmlElement>()
            .firstWhere((element) => element.matchQualifiedName("status",
                prefix: "DAV:", namespaces: namespaces))
            .innerText;
        if (!status.contains(" 200 ")) {
          continue;
        }
        final prop = child.children.whereType<XmlElement>().firstWhere(
            (element) => element.matchQualifiedName("prop",
                prefix: "DAV:", namespaces: namespaces));
        final propParser = _PropParser(namespaces: namespaces);
        propParser.parse(prop);
        fileId = propParser.fileId;
      }
    }

    return Favorite(
      href: href!,
      fileId: fileId!,
    );
  }
}

class _PropParser {
  _PropParser({
    this.namespaces = const {},
  });

  /// Parse <DAV:prop> element contents
  void parse(XmlElement element) {
    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName("fileid",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _fileId = int.parse(child.innerText);
      }
    }
  }

  int? get fileId => _fileId;

  final Map<String, String> namespaces;

  int? _fileId;
}

List<Favorite> _parseFavoritesIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return FavoriteParser()._parse(xml);
}
