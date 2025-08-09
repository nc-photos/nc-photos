import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:np_common/type.dart';
import 'package:xml/xml.dart';

class NcAlbumParser extends XmlResponseParser {
  Future<List<NcAlbum>> parse(String response) =>
      compute(_parseNcAlbumsIsolate, response);

  List<NcAlbum> _parse(XmlDocument xml) => parseT<NcAlbum>(xml, _toNcAlbum);

  /// Map <DAV:response> contents to NcAlbum
  NcAlbum _toNcAlbum(XmlElement element) {
    String? href;
    int? lastPhoto;
    int? nbItems;
    String? location;
    JsonObj? dateRange;
    List<NcAlbumCollaborator>? collaborators;

    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName(
        "href",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        href = Uri.decodeComponent(child.innerText);
      } else if (child.matchQualifiedName(
        "propstat",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        final status =
            child.children
                .whereType<XmlElement>()
                .firstWhere(
                  (element) => element.matchQualifiedName(
                    "status",
                    prefix: "DAV:",
                    namespaces: namespaces,
                  ),
                )
                .innerText;
        if (!status.contains(" 200 ")) {
          continue;
        }
        final prop = child.children.whereType<XmlElement>().firstWhere(
          (element) => element.matchQualifiedName(
            "prop",
            prefix: "DAV:",
            namespaces: namespaces,
          ),
        );
        final propParser = _PropParser(namespaces: namespaces);
        propParser.parse(prop);
        lastPhoto = propParser.lastPhoto;
        nbItems = propParser.nbItems;
        location = propParser.location;
        dateRange = propParser.dateRange;
        collaborators = propParser.collaborators;
      }
    }

    return NcAlbum(
      href: href!,
      lastPhoto: lastPhoto,
      nbItems: nbItems,
      location: location,
      dateRange: dateRange,
      collaborators: collaborators ?? const [],
    );
  }
}

class _PropParser {
  _PropParser({this.namespaces = const {}});

  /// Parse <DAV:prop> element contents
  void parse(XmlElement element) {
    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName(
        "last-photo",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _lastPhoto =
            child.innerText.isEmpty ? null : int.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "nbItems",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _nbItems = child.innerText.isEmpty ? null : int.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "location",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _location = child.innerText.isEmpty ? null : child.innerText;
      } else if (child.matchQualifiedName(
        "dateRange",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _dateRange =
            child.innerText.isEmpty ? null : jsonDecode(child.innerText);
      } else if (child.matchQualifiedName(
        "collaborators",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        for (final cc in child.children.whereType<XmlElement>()) {
          if (cc.matchQualifiedName(
            "collaborator",
            prefix: "http://nextcloud.org/ns",
            namespaces: namespaces,
          )) {
            _collaborators ??= [];
            _collaborators!.add(_parseCollaborator(cc));
          }
        }
      }
    }
  }

  NcAlbumCollaborator _parseCollaborator(XmlElement element) {
    late String id;
    late String label;
    late int type;
    for (final child in element.children.whereType<XmlElement>()) {
      switch (child.localName) {
        case "id":
          id = child.innerText;
          break;
        case "label":
          label = child.innerText;
          break;
        case "type":
          type = int.parse(child.innerText);
          break;
      }
    }
    return NcAlbumCollaborator(id: id, label: label, type: type);
  }

  int? get lastPhoto => _lastPhoto;
  int? get nbItems => _nbItems;
  String? get location => _location;
  JsonObj? get dateRange => _dateRange;
  List<NcAlbumCollaborator>? get collaborators => _collaborators;

  final Map<String, String> namespaces;

  int? _lastPhoto;
  int? _nbItems;
  String? _location;
  JsonObj? _dateRange;
  List<NcAlbumCollaborator>? _collaborators;
}

List<NcAlbum> _parseNcAlbumsIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return NcAlbumParser()._parse(xml);
}
