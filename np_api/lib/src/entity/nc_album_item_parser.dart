import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/parser.dart';
import 'package:np_api/src/util.dart';
import 'package:xml/xml.dart';

class NcAlbumItemParser extends XmlResponseParser {
  Future<List<NcAlbumItem>> parse(String response) =>
      compute(_parseNcAlbumItemsIsolate, response);

  List<NcAlbumItem> _parse(XmlDocument xml) =>
      parseT<NcAlbumItem>(xml, _toNcAlbumItem);

  /// Map <DAV:response> contents to NcAlbumItem
  NcAlbumItem _toNcAlbumItem(XmlElement element) {
    String? href;
    int? fileId;
    int? contentLength;
    String? contentType;
    String? etag;
    DateTime? lastModified;
    bool? hasPreview;
    bool? favorite;
    Object? fileMetadataSize;
    // unclear what the value types are
    // "nc:face-detections"
    // "nc:realpath"
    // "oc:permissions"

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
        contentLength = propParser.contentLength;
        contentType = propParser.contentType;
        etag = propParser.etag;
        lastModified = propParser.lastModified;
        hasPreview = propParser.hasPreview;
        favorite = propParser.favorite;
        fileMetadataSize = propParser.fileMetadataSize;
      }
    }

    return NcAlbumItem(
      href: href!,
      fileId: fileId,
      contentLength: contentLength,
      contentType: contentType,
      etag: etag,
      lastModified: lastModified,
      hasPreview: hasPreview,
      favorite: favorite,
      fileMetadataSize: fileMetadataSize is Map
          ? fileMetadataSize.cast<String, dynamic>()
          : null,
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
      if (child.matchQualifiedName("getlastmodified",
          prefix: "DAV:", namespaces: namespaces)) {
        _lastModified = HttpDate.parse(child.innerText);
      } else if (child.matchQualifiedName("getetag",
          prefix: "DAV:", namespaces: namespaces)) {
        _etag = child.innerText.replaceAll("\"", "");
      } else if (child.matchQualifiedName("getcontenttype",
          prefix: "DAV:", namespaces: namespaces)) {
        _contentType = child.innerText;
      } else if (child.matchQualifiedName("getcontentlength",
          prefix: "DAV:", namespaces: namespaces)) {
        _contentLength = int.parse(child.innerText);
      } else if (child.matchQualifiedName("fileid",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _fileId = int.parse(child.innerText);
      } else if (child.matchQualifiedName("favorite",
          prefix: "http://owncloud.org/ns", namespaces: namespaces)) {
        _favorite = child.innerText != "0";
      } else if (child.matchQualifiedName("has-preview",
          prefix: "http://nextcloud.org/ns", namespaces: namespaces)) {
        _hasPreview = child.innerText == "true";
      } else if (child.matchQualifiedName("file-metadata-size",
          prefix: "http://nextcloud.org/ns", namespaces: namespaces)) {
        _fileMetadataSize =
            child.innerText.isEmpty ? null : jsonDecode(child.innerText);
      }
    }
  }

  DateTime? get lastModified => _lastModified;
  String? get etag => _etag;
  String? get contentType => _contentType;
  int? get contentLength => _contentLength;
  int? get fileId => _fileId;
  bool? get favorite => _favorite;
  bool? get hasPreview => _hasPreview;
  Object? get fileMetadataSize => _fileMetadataSize;

  final Map<String, String> namespaces;

  DateTime? _lastModified;
  String? _etag;
  String? _contentType;
  int? _contentLength;
  int? _fileId;
  bool? _favorite;
  bool? _hasPreview;
  Object? _fileMetadataSize;
}

List<NcAlbumItem> _parseNcAlbumItemsIsolate(String response) {
  initMyLog();
  final xml = XmlDocument.parse(response);
  return NcAlbumItemParser()._parse(xml);
}
