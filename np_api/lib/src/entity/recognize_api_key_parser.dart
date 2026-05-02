import 'dart:convert';

import 'package:np_api/src/entity/entity.dart';

class RecognizeApiKeyParser {
  RecognizeApiKey parse(String response) {
    return RecognizeApiKey.fromJson(jsonDecode(response));
  }
}
