part of 'api.dart';

class ApiRecognize {
  const ApiRecognize(this.api, this.userId);

  ApiRecognizeFaces faces() => ApiRecognizeFaces(this);
  ApiRecognizeFace face(String name) => ApiRecognizeFace(this, name);

  String get _userPath => "$path/$userId";

  static String get path => "remote.php/dav/recognize";

  final Api api;
  final String userId;
}

@npLog
class ApiRecognizeFaces {
  const ApiRecognizeFaces(this.recognize);

  Future<Response> propfind() async {
    final endpoint = "${recognize._userPath}/faces";
    try {
      return await api.request("PROPFIND", endpoint);
    } catch (e) {
      _log.severe("[propfind] Failed while propfind", e);
      rethrow;
    }
  }

  Api get api => recognize.api;
  final ApiRecognize recognize;
}

@npLog
class ApiRecognizeFace {
  const ApiRecognizeFace(this.recognize, this.name);

  Future<Response> propfind({
    getcontentlength,
    getcontenttype,
    getetag,
    getlastmodified,
    faceDetections,
    fileMetadataSize,
    hasPreview,
    realpath,
    favorite,
    fileid,
  }) async {
    final endpoint = _path;
    try {
      final bool hasDavNs =
          (getcontentlength != null ||
              getcontenttype != null ||
              getetag != null ||
              getlastmodified != null);
      final bool hasNcNs =
          (faceDetections != null ||
              fileMetadataSize != null ||
              hasPreview != null ||
              realpath != null);
      final bool hasOcNs = (favorite != null || fileid != null);
      if (!hasDavNs && !hasOcNs && !hasNcNs) {
        // no body
        return await api.request("PROPFIND", endpoint);
      }

      final namespaces = {
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

  String get _path => "${recognize._userPath}/faces/$name";

  Api get api => recognize.api;
  final ApiRecognize recognize;
  final String name;
}
