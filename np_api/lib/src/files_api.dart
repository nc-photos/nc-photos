part of 'api.dart';

@npLog
class ApiFiles {
  ApiFiles(this._api);

  final Api _api;

  Future<Response> delete({required String path}) async {
    try {
      return await _api.request("DELETE", path);
    } catch (e) {
      _log.severe("[delete] Failed while delete", e);
      rethrow;
    }
  }

  Future<Response> get({required String path}) async {
    try {
      return await _api.request("GET", path, isResponseString: false);
    } catch (e) {
      _log.severe("[get] Failed while get", e);
      rethrow;
    }
  }

  Future<Response> put({
    required String path,
    String mime = "application/octet-stream",
    required Uint8List content,
  }) async {
    try {
      return await _api.request(
        "PUT",
        path,
        header: {"Content-Type": mime},
        bodyBytes: content,
      );
    } catch (e) {
      _log.severe("[put] Failed while put", e);
      rethrow;
    }
  }

  Future<Response> propfind({
    required String path,
    int? depth,
    getlastmodified,
    getetag,
    getcontenttype,
    resourcetype,
    getcontentlength,
    id,
    fileid,
    favorite,
    commentsHref,
    commentsCount,
    commentsUnread,
    ownerId,
    ownerDisplayName,
    shareTypes,
    checksums,
    hasPreview,
    size,
    richWorkspace,
    trashbinFilename,
    trashbinOriginalLocation,
    trashbinDeletionTime,
    metadataPhotosIfd0,
    metadataPhotosExif,
    metadataPhotosGps,
    metadataPhotosSize,
    Map<String, String>? customNamespaces,
    List<String>? customProperties,
  }) async {
    try {
      final bool hasDavNs =
          (getlastmodified != null ||
              getetag != null ||
              getcontenttype != null ||
              resourcetype != null ||
              getcontentlength != null);
      final bool hasOcNs =
          (id != null ||
              fileid != null ||
              favorite != null ||
              commentsHref != null ||
              commentsCount != null ||
              commentsUnread != null ||
              ownerId != null ||
              ownerDisplayName != null ||
              shareTypes != null ||
              checksums != null ||
              size != null);
      final bool hasNcNs =
          (hasPreview != null ||
              richWorkspace != null ||
              trashbinFilename != null ||
              trashbinOriginalLocation != null ||
              trashbinDeletionTime != null ||
              metadataPhotosIfd0 != null ||
              metadataPhotosExif != null ||
              metadataPhotosGps != null ||
              metadataPhotosSize != null);
      if (!hasDavNs && !hasOcNs && !hasNcNs) {
        // no body
        return await _api.request("PROPFIND", path);
      }

      final namespaces = <String, String>{
        "DAV:": "d",
        if (hasOcNs) "http://owncloud.org/ns": "oc",
        if (hasNcNs) "http://nextcloud.org/ns": "nc",
      }..addAll(customNamespaces ?? {});
      final builder = XmlBuilder();
      builder
        ..processing("xml", "version=\"1.0\"")
        ..element(
          "d:propfind",
          namespaces: namespaces,
          nest: () {
            builder.element(
              "d:prop",
              nest: () {
                if (getlastmodified != null) {
                  builder.element("d:getlastmodified");
                }
                if (getetag != null) {
                  builder.element("d:getetag");
                }
                if (getcontenttype != null) {
                  builder.element("d:getcontenttype");
                }
                if (resourcetype != null) {
                  builder.element("d:resourcetype");
                }
                if (getcontentlength != null) {
                  builder.element("d:getcontentlength");
                }
                if (id != null) {
                  builder.element("oc:id");
                }
                if (fileid != null) {
                  builder.element("oc:fileid");
                }
                if (favorite != null) {
                  builder.element("oc:favorite");
                }
                if (commentsHref != null) {
                  builder.element("oc:comments-href");
                }
                if (commentsCount != null) {
                  builder.element("oc:comments-count");
                }
                if (commentsUnread != null) {
                  builder.element("oc:comments-unread");
                }
                if (ownerId != null) {
                  builder.element("oc:owner-id");
                }
                if (ownerDisplayName != null) {
                  builder.element("oc:owner-display-name");
                }
                if (shareTypes != null) {
                  builder.element("oc:share-types");
                }
                if (checksums != null) {
                  builder.element("oc:checksums");
                }
                if (size != null) {
                  builder.element("oc:size");
                }
                if (hasPreview != null) {
                  builder.element("nc:has-preview");
                }
                if (richWorkspace != null) {
                  builder.element("nc:rich-workspace");
                }
                if (trashbinFilename != null) {
                  builder.element("nc:trashbin-filename");
                }
                if (trashbinOriginalLocation != null) {
                  builder.element("nc:trashbin-original-location");
                }
                if (trashbinDeletionTime != null) {
                  builder.element("nc:trashbin-deletion-time");
                }
                if (metadataPhotosIfd0 != null) {
                  builder.element("nc:metadata-photos-ifd0");
                }
                if (metadataPhotosExif != null) {
                  builder.element("nc:metadata-photos-exif");
                }
                if (metadataPhotosGps != null) {
                  builder.element("nc:metadata-photos-gps");
                }
                if (metadataPhotosSize != null) {
                  builder.element("nc:metadata-photos-size");
                }
                for (final p in customProperties ?? []) {
                  builder.element(p);
                }
              },
            );
          },
        );
      return await _api.request(
        "PROPFIND",
        path,
        header: {
          "Content-Type": "application/xml",
          if (depth != null) "Depth": depth.toString(),
        },
        body: builder.buildDocument().toXmlString(),
      );
    } catch (e) {
      _log.severe("[propfind] Failed while propfind", e);
      rethrow;
    }
  }

  /// Set or remove custom properties
  ///
  /// [namespaces] should be specified in the format {"URI": "prefix"}, eg,
  /// {"DAV:": "d"}
  Future<Response> proppatch({
    required String path,
    Map<String, String>? namespaces,
    Map<String, dynamic>? set,
    List<String>? remove,
  }) async {
    try {
      final ns = <String, String>{"DAV:": "d"}..addAll(namespaces ?? {});
      final builder = XmlBuilder();
      builder
        ..processing("xml", "version=\"1.0\"")
        ..element(
          "d:propertyupdate",
          namespaces: ns,
          nest: () {
            if (set != null && set.isNotEmpty) {
              builder.element(
                "d:set",
                nest: () {
                  builder.element(
                    "d:prop",
                    nest: () {
                      for (final e in set.entries) {
                        builder.element(
                          e.key,
                          nest: () {
                            builder.text("${e.value}");
                          },
                        );
                      }
                    },
                  );
                },
              );
            }
            if (remove != null && remove.isNotEmpty) {
              builder.element(
                "d:remove",
                nest: () {
                  builder.element(
                    "d:prop",
                    nest: () {
                      for (final e in remove) {
                        builder.element(e);
                      }
                    },
                  );
                },
              );
            }
          },
        );
      return await _api.request(
        "PROPPATCH",
        path,
        header: {"Content-Type": "application/xml"},
        body: builder.buildDocument().toXmlString(),
      );
    } catch (e) {
      _log.severe("[proppatch] Failed while proppatch", e);
      rethrow;
    }
  }

  /// A folder can be created by sending a MKCOL request to the folder
  Future<Response> mkcol({required String path}) async {
    try {
      return await _api.request("MKCOL", path);
    } catch (e) {
      _log.severe("[mkcol] Failed while MKCOL", e);
      rethrow;
    }
  }

  /// A file or folder can be copied by sending a COPY request to the file or
  /// folder and specifying the [destinationUrl] as full url
  Future<Response> copy({
    required String path,
    required String destinationUrl,
    bool? overwrite,
  }) async {
    try {
      return await _api.request(
        "COPY",
        path,
        header: {
          "Destination": Uri.parse(destinationUrl).toString(),
          if (overwrite != null) "Overwrite": overwrite ? "T" : "F",
        },
      );
    } catch (e) {
      _log.severe("[copy] Failed while delete", e);
      rethrow;
    }
  }

  /// A file or folder can be moved by sending a MOVE request to the file or
  /// folder and specifying the [destinationUrl] as full url
  Future<Response> move({
    required String path,
    required String destinationUrl,
    bool? overwrite,
  }) async {
    try {
      return await _api.request(
        "MOVE",
        path,
        header: {
          "Destination": Uri.parse(destinationUrl).toString(),
          if (overwrite != null) "Overwrite": overwrite ? "T" : "F",
        },
      );
    } catch (e) {
      _log.severe("[move] Failed while delete", e);
      rethrow;
    }
  }

  // SERVER_BUG: 26 to unknown. path is ignored by server
  Future<Response> report({
    required String path,
    bool? favorite,
    List<int>? systemtag,
  }) async {
    try {
      final namespaces = <String, String>{
        "DAV:": "d",
        "http://owncloud.org/ns": "oc",
      };
      final builder = XmlBuilder();
      builder
        ..processing("xml", "version=\"1.0\"")
        ..element(
          "oc:filter-files",
          namespaces: namespaces,
          nest: () {
            builder.element(
              "oc:filter-rules",
              nest: () {
                if (favorite != null) {
                  builder.element(
                    "oc:favorite",
                    nest: () {
                      builder.text(favorite ? "1" : "0");
                    },
                  );
                }
                for (final t in systemtag ?? []) {
                  builder.element(
                    "oc:systemtag",
                    nest: () {
                      builder.text(t);
                    },
                  );
                }
              },
            );
            builder.element(
              "d:prop",
              nest: () {
                builder.element("oc:fileid");
              },
            );
          },
        );
      return await _api.request(
        "REPORT",
        path,
        header: {"Content-Type": "application/xml"},
        body: builder.buildDocument().toXmlString(),
      );
    } catch (e) {
      _log.severe("[report] Failed while report", e);
      rethrow;
    }
  }
}
