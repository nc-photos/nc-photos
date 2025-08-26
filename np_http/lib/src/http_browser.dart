import 'package:http/browser_client.dart';
import 'package:http/http.dart';

Client makeHttpClientImpl({required String userAgent}) {
  return BrowserClient();
}
