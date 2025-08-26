part of 'api.dart';

class ApiOcsFilesSharing {
  ApiOcsFilesSharing(this._ocs);

  ApiOcsFilesSharingShares shares() => ApiOcsFilesSharingShares(this);

  ApiOcsFilesSharingShare share(String shareId) =>
      ApiOcsFilesSharingShare(this, shareId);

  ApiOcsFilesSharingSharees sharees() => ApiOcsFilesSharingSharees(this);

  final ApiOcs _ocs;
}

@npLog
class ApiOcsFilesSharingShares {
  ApiOcsFilesSharingShares(this._filesSharing);

  /// Get Shares from a specific file or folder
  ///
  /// If [sharedWithMe] is not null, [subfiles] and [path] are ignored. This is
  /// a limitation of the server API.
  ///
  /// See: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/OCS/ocs-share-api.html#get-shares-from-a-specific-file-or-folder
  /// See: https://doc.owncloud.com/server/latest/developer_manual/core/apis/ocs-share-api.html#get-all-shares
  Future<Response> get({
    String? path,
    bool? reshares,
    bool? subfiles,
    bool? sharedWithMe,
  }) async {
    try {
      return await _filesSharing._ocs._api.request(
        "GET",
        "ocs/v2.php/apps/files_sharing/api/v1/shares",
        header: {"OCS-APIRequest": "true"},
        queryParameters: {
          "format": "json",
          if (path != null) "path": path,
          if (reshares != null) "reshares": reshares.toString(),
          if (subfiles != null) "subfiles": subfiles.toString(),
          if (sharedWithMe != null) "shared_with_me": sharedWithMe.toString(),
        },
      );
    } catch (e) {
      _log.severe("[get] Failed while get", e);
      rethrow;
    }
  }

  /// Create a new Share
  ///
  /// See: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/OCS/ocs-share-api.html#create-a-new-share
  Future<Response> post({
    required String path,
    required int shareType,
    String? shareWith,
    String? publicUpload,
    String? password,
    int? permissions,
    String? expireDate,
  }) async {
    try {
      return await _filesSharing._ocs._api.request(
        "POST",
        "ocs/v2.php/apps/files_sharing/api/v1/shares",
        header: {
          "OCS-APIRequest": "true",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        queryParameters: {
          "format": "json",
          "path": path,
          "shareType": shareType.toString(),
          if (shareWith != null) "shareWith": shareWith,
          if (publicUpload != null) "publicUpload": publicUpload,
          if (password != null) "password": password,
          if (password != null) "password": password,
          if (expireDate != null) "expireDate": expireDate.toString(),
        },
      );
    } catch (e) {
      _log.severe("[post] Failed while post", e);
      rethrow;
    }
  }

  final ApiOcsFilesSharing _filesSharing;
}

@npLog
class ApiOcsFilesSharingShare {
  ApiOcsFilesSharingShare(this._filesSharing, this._shareId);

  /// Remove the given share
  ///
  /// See: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/OCS/ocs-share-api.html#delete-share
  /// * The type of share ID is listed as int in the document, however, the
  /// share ID returned in [ApiOcsFilesSharingShares.get] is actually a string. To
  /// keep it consistent, we'll use string instead
  Future<Response> delete() async {
    try {
      return await _filesSharing._ocs._api.request(
        "DELETE",
        "ocs/v2.php/apps/files_sharing/api/v1/shares/$_shareId",
        header: {"OCS-APIRequest": "true"},
      );
    } catch (e) {
      _log.severe("[delete] Failed while delete", e);
      rethrow;
    }
  }

  final ApiOcsFilesSharing _filesSharing;
  final String _shareId;
}

@npLog
class ApiOcsFilesSharingSharees {
  ApiOcsFilesSharingSharees(this._filesSharing);

  /// Get all sharees matching a search term
  ///
  /// See: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/OCS/ocs-sharee-api.html#search-sharees
  Future<Response> get({
    String? search,
    bool? lookup,
    int? perPage,
    String? itemType,
  }) async {
    try {
      return await _filesSharing._ocs._api.request(
        "GET",
        "ocs/v1.php/apps/files_sharing/api/v1/sharees",
        header: {"OCS-APIRequest": "true"},
        queryParameters: {
          "format": "json",
          if (search != null) "search": search,
          if (lookup != null) "lookup": lookup.toString(),
          if (perPage != null) "perPage": perPage.toString(),
          if (itemType != null) "itemType": itemType,
        },
      );
    } catch (e) {
      _log.severe("[get] Failed while get", e);
      rethrow;
    }
  }

  final ApiOcsFilesSharing _filesSharing;
}
