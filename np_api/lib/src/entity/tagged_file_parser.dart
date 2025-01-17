import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:xml/xml.dart';

class TaggedFileParser extends XmlResponseParser {
  Future<List<TaggedFile>> parse(String response) =>
      compute(_parseTaggedFilesIsolate, response);

  List<TaggedFile> _parse(XmlDocument xml) =>
      parseT<TaggedFile>(xml, _toTaggedFile);

  /// Map <DAV:response> contents to TaggedFile
  TaggedFile? _toTaggedFile(XmlElement element) {
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

    return TaggedFile(
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

List<TaggedFile> _parseTaggedFilesIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return TaggedFileParser()._parse(xml);
}
