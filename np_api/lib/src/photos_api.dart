part of 'api.dart';

class ApiPhotos {
  const ApiPhotos(this.api, this.userId);

  ApiPhotosAlbums albums() => ApiPhotosAlbums(this);
  ApiPhotosSharedAlbums sharedalbums() => ApiPhotosSharedAlbums(this);
  ApiPhotosAlbum album(String name) => ApiPhotosAlbum(this, name);

  static String get path => "remote.php/dav/photos";

  final Api api;
  final String userId;
}

@npLog
class ApiPhotosAlbums {
  const ApiPhotosAlbums(this.photos);

  /// Retrieve all albums associated with a user
  Future<Response> propfind({
    lastPhoto,
    nbItems,
    location,
    dateRange,
    collaborators,
  }) {
    try {
      return _ApiPhotosAlbumsAlike(photos).propfind(
        endpoint: "${ApiPhotos.path}/${photos.userId}/albums",
        lastPhoto: lastPhoto,
        nbItems: nbItems,
        location: location,
        dateRange: dateRange,
        collaborators: collaborators,
      );
    } catch (e) {
      _log.severe("[propfind] Failed while propfind", e);
      rethrow;
    }
  }

  final ApiPhotos photos;
}

@npLog
class ApiPhotosSharedAlbums {
  const ApiPhotosSharedAlbums(this.photos);

  /// Retrieve all albums associated with a user
  Future<Response> propfind({
    lastPhoto,
    nbItems,
    location,
    dateRange,
    collaborators,
  }) {
    try {
      return _ApiPhotosAlbumsAlike(photos).propfind(
        endpoint: "${ApiPhotos.path}/${photos.userId}/sharedalbums",
        lastPhoto: lastPhoto,
        nbItems: nbItems,
        location: location,
        dateRange: dateRange,
        collaborators: collaborators,
      );
    } catch (e) {
      _log.severe("[propfind] Failed while propfind", e);
      rethrow;
    }
  }

  Api get api => photos.api;
  final ApiPhotos photos;
}

class _ApiPhotosAlbumsAlike {
  const _ApiPhotosAlbumsAlike(this.photos);

  /// Retrieve all albums associated with a user
  Future<Response> propfind({
    required String endpoint,
    lastPhoto,
    nbItems,
    location,
    dateRange,
    collaborators,
  }) async {
    if (lastPhoto == null &&
        nbItems == null &&
        location == null &&
        dateRange == null &&
        collaborators == null) {
      // no body
      return await api.request("PROPFIND", endpoint);
    }

    final namespaces = <String, String>{
      "DAV:": "d",
      "http://nextcloud.org/ns": "nc",
    };
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
              if (lastPhoto != null) {
                builder.element("nc:last-photo");
              }
              if (nbItems != null) {
                builder.element("nc:nbItems");
              }
              if (location != null) {
                builder.element("nc:location");
              }
              if (dateRange != null) {
                builder.element("nc:dateRange");
              }
              if (collaborators != null) {
                builder.element("nc:collaborators");
              }
            },
          );
        },
      );
    return await api.request(
      "PROPFIND",
      endpoint,
      header: {"Content-Type": "application/xml"},
      body: builder.buildDocument().toXmlString(),
    );
  }

  Api get api => photos.api;
  final ApiPhotos photos;
}

@npLog
class ApiPhotosAlbum {
  const ApiPhotosAlbum(this.photos, this.albumId);

  /// Retrieve all albums associated with a user
  Future<Response> propfind({
    getcontentlength,
    getcontenttype,
    getetag,
    getlastmodified,
    resourcetype,
    faceDetections,
    fileMetadataSize,
    hasPreview,
    realpath,
    favorite,
    fileid,
    permissions,
  }) async {
    final endpoint = "${ApiPhotos.path}/${photos.userId}/albums/$albumId";
    try {
      final bool hasDavNs =
          (getcontentlength != null ||
              getcontenttype != null ||
              getetag != null ||
              getlastmodified != null ||
              resourcetype != null);
      final bool hasNcNs =
          (faceDetections != null ||
              fileMetadataSize != null ||
              hasPreview != null ||
              realpath != null);
      final bool hasOcNs =
          (favorite != null || fileid != null || permissions != null);
      if (!hasDavNs && !hasOcNs && !hasNcNs) {
        // no body
        return await api.request("PROPFIND", endpoint);
      }

      final namespaces = <String, String>{
        "DAV:": "d",
        if (hasOcNs) "http://owncloud.org/ns": "oc",
        if (hasNcNs) "http://nextcloud.org/ns": "nc",
      };
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
                if (getcontentlength != null) {
                  builder.element("d:getcontentlength");
                }
                if (getcontenttype != null) {
                  builder.element("d:getcontenttype");
                }
                if (getetag != null) {
                  builder.element("d:getetag");
                }
                if (getlastmodified != null) {
                  builder.element("d:getlastmodified");
                }
                if (resourcetype != null) {
                  builder.element("d:resourcetype");
                }
                if (faceDetections != null) {
                  builder.element("nc:face-detections");
                }
                if (fileMetadataSize != null) {
                  builder.element("nc:file-metadata-size");
                }
                if (hasPreview != null) {
                  builder.element("nc:has-preview");
                }
                if (realpath != null) {
                  builder.element("nc:realpath");
                }
                if (favorite != null) {
                  builder.element("oc:favorite");
                }
                if (fileid != null) {
                  builder.element("oc:fileid");
                }
                if (permissions != null) {
                  builder.element("oc:permissions");
                }
              },
            );
          },
        );
      return await api.request(
        "PROPFIND",
        endpoint,
        header: {"Content-Type": "application/xml"},
        body: builder.buildDocument().toXmlString(),
      );
    } catch (e) {
      _log.severe("[propfind] Failed while propfind", e);
      rethrow;
    }
  }

  Future<Response> mkcol() async {
    try {
      final endpoint = "${ApiPhotos.path}/${photos.userId}/albums/$albumId";
      return await api.request("MKCOL", endpoint);
    } catch (e) {
      _log.severe("[mkcol] Failed while MKCOL", e);
      rethrow;
    }
  }

  Future<Response> delete() async {
    try {
      final endpoint = "${ApiPhotos.path}/${photos.userId}/albums/$albumId";
      return await api.request("DELETE", endpoint);
    } catch (e) {
      _log.severe("[delete] Failed while DELETE", e);
      rethrow;
    }
  }

  Api get api => photos.api;
  final ApiPhotos photos;
  final String albumId;
}
