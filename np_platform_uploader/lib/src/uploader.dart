import 'package:flutter/services.dart';
import 'package:np_platform_uploader/src/k.dart' as k;
import 'package:np_platform_util/np_platform_util.dart';

abstract class Uploadable {
  String get uploadPath;
}

abstract class AndroidUploadable implements Uploadable {
  String get contentUri;
}

class Uploader {
  static Future<void> asyncUpload({
    required List<Uploadable> uploadables,
    required Map<String, String> headers,
  }) {
    if (getRawPlatform() == NpPlatform.android) {
      return _asyncUploadAndroid(uploadables: uploadables, headers: headers);
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<void> _asyncUploadAndroid({
    required List<Uploadable> uploadables,
    required Map<String, String> headers,
  }) async {
    final androidUploadables = uploadables.cast<AndroidUploadable>();
    await _methodChannel.invokeMethod("asyncUpload", {
      "contentUris": androidUploadables.map((e) => e.contentUri).toList(),
      "endPoints": uploadables.map((e) => e.uploadPath).toList(),
      "headers": headers,
    });
  }

  static const _methodChannel = MethodChannel("${k.libId}/uploader_method");
}
