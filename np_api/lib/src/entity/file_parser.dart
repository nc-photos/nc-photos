import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:np_log/np_log.dart';
import 'package:xml/xml.dart';

part 'file_parser.g.dart';

@npLog
class FileParser extends XmlResponseParser {
  Future<List<File>> parse(String response) =>
      compute(_parseFilesIsolate, response);

  List<File> _parse(XmlDocument xml) => parseT<File>(xml, _toFile);

  /// Map <DAV:response> contents to File
  File _toFile(XmlElement element) {
    String? href;
    DateTime? lastModified;
    String? etag;
    String? contentType;
    bool? isCollection;
    int? contentLength;
    int? fileId;
    bool? favorite;
    String? ownerId;
    String? ownerDisplayName;
    bool? hasPreview;
    String? trashbinFilename;
    String? trashbinOriginalLocation;
    DateTime? trashbinDeletionTime;
    Map<String, String>? metadataPhotosIfd0;
    Map<String, String>? metadataPhotosExif;
    Map<String, String>? metadataPhotosGps;
    Map<String, String>? metadataPhotosSize;
    Map<String, String>? customProperties;

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
        contentLength = propParser.contentLength;
        contentType = propParser.contentType;
        etag = propParser.etag;
        lastModified = propParser.lastModified;
        isCollection = propParser.isCollection;
        hasPreview = propParser.hasPreview;
        fileId = propParser.fileId;
        ownerId = propParser.ownerId;
        ownerDisplayName = propParser.ownerDisplayName;
        trashbinFilename = propParser.trashbinFilename;
        trashbinOriginalLocation = propParser.trashbinOriginalLocation;
        trashbinDeletionTime = propParser.trashbinDeletionTime;
        metadataPhotosIfd0 = propParser.metadataPhotosIfd0;
        metadataPhotosExif = propParser.metadataPhotosExif;
        metadataPhotosGps = propParser.metadataPhotosGps;
        metadataPhotosSize = propParser.metadataPhotosSize;
        customProperties = propParser.customProperties;
      }
    }

    return File(
      href: href!,
      lastModified: lastModified,
      etag: etag,
      contentType: contentType,
      isCollection: isCollection,
      contentLength: contentLength,
      fileId: fileId,
      favorite: favorite,
      ownerId: ownerId,
      ownerDisplayName: ownerDisplayName,
      hasPreview: hasPreview,
      trashbinFilename: trashbinFilename,
      trashbinOriginalLocation: trashbinOriginalLocation,
      trashbinDeletionTime: trashbinDeletionTime,
      metadataPhotosIfd0: metadataPhotosIfd0,
      metadataPhotosExif: metadataPhotosExif,
      metadataPhotosGps: metadataPhotosGps,
      metadataPhotosSize: metadataPhotosSize,
      customProperties: customProperties,
    );
  }
}

class _PropParser {
  _PropParser({this.namespaces = const {}});

  /// Parse <DAV:prop> element contents
  void parse(XmlElement element) {
    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName(
        "getlastmodified",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _lastModified = HttpDate.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "getetag",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _etag = child.innerText.replaceAll("\"", "");
      } else if (child.matchQualifiedName(
        "getcontenttype",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _contentType = child.innerText;
      } else if (child.matchQualifiedName(
        "resourcetype",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _isCollection = child.children.whereType<XmlElement>().any(
          (element) => element.matchQualifiedName(
            "collection",
            prefix: "DAV:",
            namespaces: namespaces,
          ),
        );
      } else if (child.matchQualifiedName(
        "getcontentlength",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _contentLength = int.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "fileid",
        prefix: "http://owncloud.org/ns",
        namespaces: namespaces,
      )) {
        _fileId = int.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "favorite",
        prefix: "http://owncloud.org/ns",
        namespaces: namespaces,
      )) {
        _favorite = child.innerText != "0";
      } else if (child.matchQualifiedName(
        "owner-id",
        prefix: "http://owncloud.org/ns",
        namespaces: namespaces,
      )) {
        _ownerId = child.innerText;
      } else if (child.matchQualifiedName(
        "owner-display-name",
        prefix: "http://owncloud.org/ns",
        namespaces: namespaces,
      )) {
        _ownerDisplayName = child.innerText;
      } else if (child.matchQualifiedName(
        "has-preview",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _hasPreview = child.innerText == "true";
      } else if (child.matchQualifiedName(
        "trashbin-filename",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _trashbinFilename = child.innerText;
      } else if (child.matchQualifiedName(
        "trashbin-original-location",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _trashbinOriginalLocation = child.innerText;
      } else if (child.matchQualifiedName(
        "trashbin-deletion-time",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _trashbinDeletionTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(child.innerText) * 1000,
        );
      } else if (child.matchQualifiedName(
        "metadata-photos-ifd0",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        for (final ifd0Child in child.children.whereType<XmlElement>()) {
          (_metadataPhotosIfd0 ??= {})[ifd0Child.localName] =
              ifd0Child.innerText;
        }
      } else if (child.matchQualifiedName(
        "metadata-photos-exif",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        for (final c in child.children.whereType<XmlElement>()) {
          (_metadataPhotosExif ??= {})[c.localName] = c.innerText;
        }
      } else if (child.matchQualifiedName(
        "metadata-photos-gps",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        for (final c in child.children.whereType<XmlElement>()) {
          (_metadataPhotosGps ??= {})[c.localName] = c.innerText;
        }
      } else if (child.matchQualifiedName(
        "metadata-photos-size",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        for (final c in child.children.whereType<XmlElement>()) {
          (_metadataPhotosSize ??= {})[c.localName] = c.innerText;
        }
      } else {
        final key =
            child.name.prefix == null
                ? child.localName
                : "${_expandNamespace(child, namespaces)}:${child.localName}";
        (_customProperties ??= {})[key] = child.innerText;
      }
    }
  }

  DateTime? get lastModified => _lastModified;
  String? get etag => _etag;
  String? get contentType => _contentType;
  bool? get isCollection => _isCollection;
  int? get contentLength => _contentLength;
  int? get fileId => _fileId;
  bool? get favorite => _favorite;
  String? get ownerId => _ownerId;
  String? get ownerDisplayName => _ownerDisplayName;
  bool? get hasPreview => _hasPreview;
  String? get trashbinFilename => _trashbinFilename;
  String? get trashbinOriginalLocation => _trashbinOriginalLocation;
  DateTime? get trashbinDeletionTime => _trashbinDeletionTime;
  Map<String, String>? get metadataPhotosIfd0 => _metadataPhotosIfd0;
  Map<String, String>? get metadataPhotosExif => _metadataPhotosExif;
  Map<String, String>? get metadataPhotosGps => _metadataPhotosGps;
  Map<String, String>? get metadataPhotosSize => _metadataPhotosSize;
  Map<String, String>? get customProperties => _customProperties;

  final Map<String, String> namespaces;

  DateTime? _lastModified;
  String? _etag;
  String? _contentType;
  bool? _isCollection;
  int? _contentLength;
  int? _fileId;
  bool? _favorite;
  String? _ownerId;
  String? _ownerDisplayName;
  bool? _hasPreview;
  String? _trashbinFilename;
  String? _trashbinOriginalLocation;
  DateTime? _trashbinDeletionTime;
  Map<String, String>? _metadataPhotosIfd0;
  Map<String, String>? _metadataPhotosExif;
  Map<String, String>? _metadataPhotosGps;
  Map<String, String>? _metadataPhotosSize;
  Map<String, String>? _customProperties;
}

List<File> _parseFilesIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return FileParser()._parse(xml);
}

String _expandNamespace(XmlElement element, Map<String, String> namespaces) {
  if (namespaces.containsKey(element.name.prefix)) {
    return namespaces[element.name.prefix]!;
  }
  final localNamespaces = <String, String>{};
  for (final a in element.attributes) {
    if (a.name.prefix == "xmlns") {
      localNamespaces[a.name.local] = a.value;
    }
  }
  return localNamespaces[element.name.prefix] ?? element.name.prefix!;
}
