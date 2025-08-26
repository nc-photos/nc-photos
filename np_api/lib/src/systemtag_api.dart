part of 'api.dart';

@npLog
class ApiSystemtags {
  const ApiSystemtags(this.api);

  /// Retrieve a list of all tags
  ///
  /// See: https://doc.owncloud.com/server/10.10/developer_manual/webdav_api/tags.html#list-tags
  Future<Response> propfind({
    id,
    displayName,
    userVisible,
    userAssignable,
  }) async {
    const endpoint = "remote.php/dav/systemtags";
    try {
      if (id == null &&
          displayName == null &&
          userVisible == null &&
          userAssignable == null) {
        // no body
        return await api.request("PROPFIND", endpoint);
      }

      final namespaces = <String, String>{
        "DAV:": "d",
        "http://owncloud.org/ns": "oc",
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
                if (id != null) {
                  builder.element("oc:id");
                }
                if (displayName != null) {
                  builder.element("oc:display-name");
                }
                if (userVisible != null) {
                  builder.element("oc:user-visible");
                }
                if (userAssignable != null) {
                  builder.element("oc:user-assignable");
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

  final Api api;
}

class ApiSystemtagsRelations {
  const ApiSystemtagsRelations(this.api);

  ApiSystemtagsRelationsFiles files(int fileId) =>
      ApiSystemtagsRelationsFiles(this, fileId);

  final Api api;
}

@npLog
class ApiSystemtagsRelationsFiles {
  const ApiSystemtagsRelationsFiles(this.systemtagsRelations, this.fileId);

  /// Retrieve the tag ids and metadata of a given file
  ///
  /// See: https://doc.owncloud.com/server/10.10/developer_manual/webdav_api/tags.html#retrieve-the-tag-ids-and-metadata-of-a-given-file
  Future<Response> propfind({
    id,
    displayName,
    userVisible,
    userAssignable,
    canAssign,
  }) async {
    final endpoint = "remote.php/dav/systemtags-relations/files/$fileId";
    try {
      if (id == null &&
          displayName == null &&
          userVisible == null &&
          userAssignable == null &&
          canAssign == null) {
        // no body
        return await systemtagsRelations.api.request("PROPFIND", endpoint);
      }

      final namespaces = <String, String>{
        "DAV:": "d",
        "http://owncloud.org/ns": "oc",
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
                if (id != null) {
                  builder.element("oc:id");
                }
                if (displayName != null) {
                  builder.element("oc:display-name");
                }
                if (userVisible != null) {
                  builder.element("oc:user-visible");
                }
                if (userAssignable != null) {
                  builder.element("oc:user-assignable");
                }
                if (canAssign != null) {
                  builder.element("oc:can-assign");
                }
              },
            );
          },
        );
      return await systemtagsRelations.api.request(
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

  final ApiSystemtagsRelations systemtagsRelations;
  final int fileId;
}
