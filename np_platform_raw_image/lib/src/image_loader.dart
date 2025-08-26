import 'dart:async';

import 'package:flutter/services.dart';
import 'package:np_platform_raw_image/src/k.dart' as k;
import 'package:np_platform_raw_image/src/rgba8_image.dart';

enum ImageLoaderResizeMethod { fit, fill }

class ImageLoader {
  static Future<Rgba8Image> loadUri(
    Uri fileUri,
    int maxWidth,
    int maxHeight,
    ImageLoaderResizeMethod resizeMethod, {
    bool isAllowSwapSide = false,
    bool shouldUpscale = false,
    bool shouldFixOrientation = false,
  }) async {
    final result = await _methodChannel
        .invokeMethod<Map>("loadUri", <String, dynamic>{
          "fileUri": fileUri.toString(),
          "maxWidth": maxWidth,
          "maxHeight": maxHeight,
          "resizeMethod": resizeMethod.index,
          "isAllowSwapSide": isAllowSwapSide,
          "shouldUpscale": shouldUpscale,
          "shouldFixOrientation": shouldFixOrientation,
        });
    return Rgba8Image.fromJson(result!.cast<String, dynamic>());
  }

  static const _methodChannel = MethodChannel("${k.libId}/image_loader_method");
}
