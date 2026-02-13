import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nc_photos_plugin/src/k.dart' as k;

class ContentUri {
  static Future<String> getUriForFile(String filePath) async {
    return await _methodChannel.invokeMethod("getUriForFile", <String, dynamic>{
      "filePath": filePath,
    });
  }

  static const _methodChannel = MethodChannel("${k.libId}/content_uri_method");
}
