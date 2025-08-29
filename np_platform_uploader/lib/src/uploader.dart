import 'package:flutter/services.dart';
import 'package:np_platform_uploader/src/k.dart' as k;
import 'package:np_platform_util/np_platform_util.dart';

abstract class Uploadable {
  String get uploadPath;
}

abstract class AndroidUploadable implements Uploadable {
  String get contentUri;
}

enum ConvertFormat {
  jpeg(0),
  jxl(1),
  ;

  const ConvertFormat(this.value);

  final int value;
}

class ConvertConfig {
  const ConvertConfig({
    required this.format,
    required this.quality,
    this.downsizeMp,
  });

  final ConvertFormat format;
  final int quality;
  final double? downsizeMp;
}

class Uploader {
  static Future<void> asyncUpload({
    required List<Uploadable> uploadables,
    required Map<String, String> headers,
    ConvertConfig? convertConfig,
  }) {
    if (getRawPlatform() == NpPlatform.android) {
      return _asyncUploadAndroid(
        uploadables: uploadables,
        headers: headers,
        convertConfig: convertConfig,
      );
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<void> _asyncUploadAndroid({
    required List<Uploadable> uploadables,
    required Map<String, String> headers,
    ConvertConfig? convertConfig,
  }) async {
    final androidUploadables = uploadables.cast<AndroidUploadable>();
    await _methodChannel.invokeMethod("asyncUpload", {
      "contentUris": androidUploadables.map((e) => e.contentUri).toList(),
      "endPoints": uploadables.map((e) => e.uploadPath).toList(),
      "headers": headers,
      "convertFormat": convertConfig?.format.value,
      "convertQuality": convertConfig?.quality,
      "convertDownsizeMp": convertConfig?.downsizeMp,
    });
  }

  static const _methodChannel = MethodChannel("${k.libId}/uploader_method");
}
