import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:xml/xml.dart';

class TagParser extends XmlResponseParser {
  Future<List<Tag>> parse(String response) =>
      compute(_parseTagsIsolate, response);

  List<Tag> _parse(XmlDocument xml) => parseT<Tag>(xml, _toTag);

  /// Map <DAV:response> contents to Tag
  Tag? _toTag(XmlElement element) {
    String? href;
    int? id;
    String? displayName;
    bool? userVisible;
    bool? userAssignable;

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
        id = propParser.id;
        displayName = propParser.displayName;
        userVisible = propParser.userVisible;
        userAssignable = propParser.userAssignable;
      }
    }
    if (id == null) {
      // the first returned item is not a valid tag
      return null;
    }

    return Tag(
      href: href!,
      id: id,
      displayName: displayName!,
      userVisible: userVisible!,
      userAssignable: userAssignable!,
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
      if (child.matchQualifiedName("id",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _id = int.parse(child.innerText);
      } else if (child.matchQualifiedName("display-name",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _displayName = child.innerText;
      } else if (child.matchQualifiedName("user-visible",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _userVisible = child.innerText == "true";
      } else if (child.matchQualifiedName("user-assignable",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _userAssignable = child.innerText == "true";
      }
    }
  }

  int? get id => _id;
  String? get displayName => _displayName;
  bool? get userVisible => _userVisible;
  bool? get userAssignable => _userAssignable;

  final Map<String, String> namespaces;

  int? _id;
  String? _displayName;
  bool? _userVisible;
  bool? _userAssignable;
}

List<Tag> _parseTagsIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return TagParser()._parse(xml);
}
