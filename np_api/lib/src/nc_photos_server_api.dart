part of 'api.dart';

class ApiOcsNcPhotosServer {
  ApiOcsNcPhotosServer(this.ocs);

  ApiOcsNcPhotosServerRecognizeApiKey recognizeApiKey() =>
      ApiOcsNcPhotosServerRecognizeApiKey(this);

  final ApiOcs ocs;
}

@npLog
class ApiOcsNcPhotosServerRecognizeApiKey {
  ApiOcsNcPhotosServerRecognizeApiKey(this.ncPhotosServer);

  Future<Response> get() async {
    try {
      return await ncPhotosServer.ocs._api.request(
        "GET",
        "ocs/v2.php/apps/nc_photos_server/api/recognize_api_key",
        header: {"OCS-APIRequest": "true"},
        queryParameters: {"format": "json"},
      );
    } catch (e) {
      _log.severe("[get] Failed while get", e);
      rethrow;
    }
  }

  final ApiOcsNcPhotosServer ncPhotosServer;
}
