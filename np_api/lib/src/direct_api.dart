part of 'api.dart';

@npLog
class ApiOcsDavDirect {
  ApiOcsDavDirect(this._dav);

  Future<Response> post({required int fileId}) async {
    try {
      return await _dav._ocs._api.request(
        "POST",
        "ocs/v2.php/apps/dav/api/v1/direct",
        header: {
          "OCS-APIRequest": "true",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        queryParameters: {"format": "json"},
        body: "fileId=$fileId",
      );
    } catch (e) {
      _log.severe("[post] Failed while post", e);
      rethrow;
    }
  }

  final ApiOcsDav _dav;
}
