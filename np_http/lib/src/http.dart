import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:np_platform_util/np_platform_util.dart';

import 'http_stub.dart'
    if (dart.library.js_interop) 'http_browser.dart'
    if (dart.library.io) 'http_io.dart';

Future<void> initHttp({
  required String appVersion,
  required bool isNewHttpEngine,
}) async {
  final userAgent = "nc-photos $appVersion";
  Client? client;
  if (isNewHttpEngine) {
    if (getRawPlatform() == NpPlatform.android) {
      try {
        final cronetEngine = CronetEngine.build(
          enableHttp2: true,
          enableQuic: true,
          enableBrotli: true,
          userAgent: userAgent,
        );
        client = CronetClient.fromCronetEngine(cronetEngine, closeEngine: true);
        _log.info("Using cronet backend");
      } catch (e, stackTrace) {
        _log.severe("Failed creating CronetEngine", e, stackTrace);
      }
    } else if (getRawPlatform().isApple) {
      try {
        final urlConfig =
            URLSessionConfiguration.ephemeralSessionConfiguration()
              ..httpAdditionalHeaders = {"User-Agent": userAgent};
        client = CupertinoClient.fromSessionConfiguration(urlConfig);
        _log.info("Using cupertino backend");
      } catch (e, stackTrace) {
        _log.severe("Failed creating URLSessionConfiguration", e, stackTrace);
      }
    }
  }
  if (client == null) {
    _httpClient = makeHttpClientImpl(userAgent: userAgent);
    _log.info("Using dart backend");
  } else {
    _httpClient = client;
  }
}

Client getHttpClient() {
  return _httpClient;
}

late final Client _httpClient;

final _log = Logger("np_http");
