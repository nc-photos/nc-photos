import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:np_api/src/type.dart';
import 'package:np_api/src/util.dart';
import 'package:np_http/np_http.dart';
import 'package:np_log/np_log.dart';
import 'package:xml/xml.dart';

part 'api.g.dart';
part 'direct_api.dart';
part 'face_recognition_api.dart';
part 'files_api.dart';
part 'files_sharing_api.dart';
part 'photos_api.dart';
part 'recognize_api.dart';
part 'status_api.dart';
part 'systemtag_api.dart';

@npLog
class Api {
  const Api(this.baseUrl, BasicAuth this.auth);

  const Api.fromBaseUrl(this.baseUrl) : auth = null;

  ApiFiles files() => ApiFiles(this);

  ApiOcs ocs() => ApiOcs(this);

  ApiPhotos photos(String userId) => ApiPhotos(this, userId);

  ApiRecognize recognize(String userId) => ApiRecognize(this, userId);

  ApiStatus status() => ApiStatus(this);

  ApiSystemtags systemtags() => ApiSystemtags(this);

  ApiSystemtagsRelations systemtagsRelations() => ApiSystemtagsRelations(this);

  Future<Response> request(
    String method,
    String endpoint, {
    Map<String, String>? header,
    Map<String, String>? queryParameters,
    String? body,
    Uint8List? bodyBytes,
    bool isResponseString = true,
  }) async {
    final url = _makeUri(endpoint, queryParameters: queryParameters);
    final req = http.Request(method, url);
    if (auth != null) {
      req.headers.addAll({"authorization": auth!.toHeaderValue()});
    }
    if (header != null) {
      // turn all to lower case, since HTTP headers are case-insensitive, this
      // smooths our processing (if any)
      req.headers.addEntries(
        header.entries.map((e) => MapEntry(e.key.toLowerCase(), e.value)),
      );
    }
    if (body != null) {
      req.body = body;
    } else if (bodyBytes != null) {
      req.bodyBytes = bodyBytes;
    }
    _log.finer(req.url);
    final response = await http.Response.fromStream(
      await getHttpClient().send(req),
    );
    if (!isHttpStatusGood(response.statusCode)) {
      if (response.statusCode == 404) {
        _log.severe(
          "[request] HTTP $method (${response.statusCode}): $endpoint",
        );
      } else {
        _log.severe(
          "[request] HTTP $method (${response.statusCode}): $endpoint",
          response.body,
        );
      }
    }
    return Response(
      response.statusCode,
      response.headers,
      isResponseString ? response.body : response.bodyBytes,
    );
  }

  Uri _makeUri(String endpoint, {Map<String, String>? queryParameters}) {
    final path = "${baseUrl.path}/$endpoint";
    if (baseUrl.scheme == "http") {
      return Uri.http(baseUrl.authority, path, queryParameters);
    } else {
      return Uri.https(baseUrl.authority, path, queryParameters);
    }
  }

  final Uri baseUrl;
  final BasicAuth? auth;
}

class ApiOcs {
  ApiOcs(this._api);

  ApiOcsDav dav() => ApiOcsDav(this);

  ApiOcsFacerecognition facerecognition() => ApiOcsFacerecognition(this);

  ApiOcsFilesSharing filesSharing() => ApiOcsFilesSharing(this);

  final Api _api;
}

class ApiOcsDav {
  ApiOcsDav(this._ocs);

  ApiOcsDavDirect direct() => ApiOcsDavDirect(this);

  final ApiOcs _ocs;
}
