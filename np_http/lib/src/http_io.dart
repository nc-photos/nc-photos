import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

Client makeHttpClientImpl({required String userAgent}) {
  return IOClient(HttpClient()..userAgent = userAgent);
}
