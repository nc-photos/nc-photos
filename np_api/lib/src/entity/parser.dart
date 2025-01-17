import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_log/np_log.dart';
import 'package:xml/xml.dart';

part 'parser.g.dart';

@npLog
class XmlResponseParser {
  List<T> parseT<T>(XmlDocument xml, T? Function(XmlElement) mapper) {
    namespaces = _parseNamespaces(xml);
    final body = () {
      try {
        return xml.children.whereType<XmlElement>().firstWhere((element) =>
            element.matchQualifiedName("multistatus",
                prefix: "DAV:", namespaces: namespaces));
      } catch (_) {
        _log.shout("[_parse] Missing element: multistatus");
        rethrow;
      }
    }();
    return body.children
        .whereType<XmlElement>()
        .where((e) => e.matchQualifiedName("response",
            prefix: "DAV:", namespaces: namespaces))
        .map((e) {
          try {
            return mapper(e);
          } catch (e, stackTrace) {
            _log.shout("[_parse] Failed parsing XML", e, stackTrace);
            return null;
          }
        })
        .whereType<T>()
        .toList();
  }

  Map<String, String> _parseNamespaces(XmlDocument xml) {
    final namespaces = <String, String>{};
    final xmlContent = xml.descendants.whereType<XmlElement>().firstWhere(
        (element) => !element.name.qualified.startsWith("?"),
        orElse: () => XmlElement(XmlName.fromString("")));
    for (final a in xmlContent.attributes) {
      if (a.name.prefix == "xmlns") {
        namespaces[a.name.local] = a.value;
      } else if (a.name.local == "xmlns") {
        namespaces["!"] = a.value;
      }
    }
    // _log.fine("[_parseNamespaces] Namespaces: $namespaces");
    return namespaces;
  }

  @protected
  var namespaces = <String, String>{};
}

extension XmlElementExtension on XmlElement {
  bool matchQualifiedName(
    String local, {
    required String prefix,
    required Map<String, String> namespaces,
  }) {
    final localNamespaces = <String, String>{};
    for (final a in attributes) {
      if (a.name.prefix == "xmlns") {
        localNamespaces[a.name.local] = a.value;
      } else if (a.name.local == "xmlns") {
        localNamespaces["!"] = a.value;
      }
    }
    return name.local == local &&
        (name.prefix == prefix ||
            // match default namespace
            (name.prefix == null && namespaces["!"] == prefix) ||
            // match global namespace
            namespaces.entries
                .where((element2) => element2.value == prefix)
                .any((element) => element.key == name.prefix) ||
            // match local namespace
            localNamespaces.entries
                .where((element2) => element2.value == prefix)
                .any((element) => element.key == name.prefix));
  }
}
