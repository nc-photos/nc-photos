import 'dart:convert';

import 'package:np_api/src/entity/entity.dart';

class NcPhotosServerHealthParser {
  NcPhotosServerHealth parse(String response) {
    return NcPhotosServerHealth.fromJson(jsonDecode(response));
  }
}
