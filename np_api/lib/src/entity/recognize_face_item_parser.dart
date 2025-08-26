import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:np_common/type.dart';
import 'package:xml/xml.dart';

class RecognizeFaceItemParser extends XmlResponseParser {
  Future<List<RecognizeFaceItem>> parse(String response) =>
      compute(_parseRecognizeFaceItemsIsolate, response);

  List<RecognizeFaceItem> _parse(XmlDocument xml) =>
      parseT<RecognizeFaceItem>(xml, _toRecognizeFaceItem);

  /// Map <DAV:response> contents to RecognizeFaceItem
  RecognizeFaceItem _toRecognizeFaceItem(XmlElement element) {
    String? href;
    int? contentLength;
    String? contentType;
    String? etag;
    DateTime? lastModified;
    List<JsonObj>? faceDetections;
    Object? fileMetadataSize;
    bool? hasPreview;
    String? realPath;
    bool? favorite;
    int? fileId;

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
        faceDetections = propParser.faceDetections;
        fileMetadataSize = propParser.fileMetadataSize;
        hasPreview = propParser.hasPreview;
        realPath = propParser.realPath;
        favorite = propParser.favorite;
        fileId = propParser.fileId;
      }
    }

    return RecognizeFaceItem(
      href: href!,
      contentLength: contentLength,
      contentType: contentType,
      etag: etag,
      lastModified: lastModified,
      faceDetections: faceDetections,
      fileMetadataSize:
          fileMetadataSize is Map
              ? fileMetadataSize.cast<String, dynamic>()
              : null,
      hasPreview: hasPreview,
      realPath: realPath,
      favorite: favorite,
      fileId: fileId,
    );
  }
}

class _PropParser {
  _PropParser({this.namespaces = const {}});

  /// Parse <DAV:prop> element contents
  void parse(XmlElement element) {
    for (final child in element.children.whereType<XmlElement>()) {
      if (child.matchQualifiedName(
        "getcontentlength",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _contentLength = int.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "getcontenttype",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _contentType = child.innerText;
      } else if (child.matchQualifiedName(
        "getetag",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _etag = child.innerText.replaceAll("\"", "");
      } else if (child.matchQualifiedName(
        "getlastmodified",
        prefix: "DAV:",
        namespaces: namespaces,
      )) {
        _lastModified = HttpDate.parse(child.innerText);
      } else if (child.matchQualifiedName(
        "face-detections",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _faceDetections =
            child.innerText.isEmpty
                ? null
                : (jsonDecode(child.innerText) as List).cast<JsonObj>();
      } else if (child.matchQualifiedName(
        "file-metadata-size",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _fileMetadataSize =
            child.innerText.isEmpty ? null : jsonDecode(child.innerText);
      } else if (child.matchQualifiedName(
        "has-preview",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _hasPreview = child.innerText == "true";
      } else if (child.matchQualifiedName(
        "realpath",
        prefix: "http://nextcloud.org/ns",
        namespaces: namespaces,
      )) {
        _realPath = child.innerText;
      } else if (child.matchQualifiedName(
        "favorite",
        prefix: "http://owncloud.org/ns",
        namespaces: namespaces,
      )) {
        _favorite = child.innerText != "0";
      } else if (child.matchQualifiedName(
        "fileid",
        prefix: "http://owncloud.org/ns",
        namespaces: namespaces,
      )) {
        _fileId = int.parse(child.innerText);
      }
    }
  }

  int? get contentLength => _contentLength;
  String? get contentType => _contentType;
  String? get etag => _etag;
  DateTime? get lastModified => _lastModified;
  List<JsonObj>? get faceDetections => _faceDetections;
  Object? get fileMetadataSize => _fileMetadataSize;
  bool? get hasPreview => _hasPreview;
  String? get realPath => _realPath;
  bool? get favorite => _favorite;
  int? get fileId => _fileId;

  final Map<String, String> namespaces;

  int? _contentLength;
  String? _contentType;
  String? _etag;
  DateTime? _lastModified;
  List<JsonObj>? _faceDetections;
  // size can be a map or a list if the size is not known (well...)
  Object? _fileMetadataSize;
  bool? _hasPreview;
  String? _realPath;
  bool? _favorite;
  int? _fileId;
}

List<RecognizeFaceItem> _parseRecognizeFaceItemsIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return RecognizeFaceItemParser()._parse(xml);
}
