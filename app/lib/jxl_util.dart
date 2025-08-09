import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:np_common/size.dart';
import 'package:np_platform_image_format_jxl/np_platform_image_format_jxl.dart';

/// Return if [bytes] contain an encoded JPEG-XL image
bool isJxl(Uint8List bytes) {
  if (bytes.length < 12) {
    return false;
  }
  return listEquals(bytes.sublist(0, 12), const [
        0,
        0,
        0,
        0x0c,
        0x4a,
        0x58,
        0x4c,
        0x20,
        0x0d,
        0x0a,
        0x87,
        0x0a,
      ]) ||
      listEquals(bytes.sublist(0, 2), const [0xff, 0x0a]);
}

Future<Codec> jxlImageCodec(Uint8List raw, {SizeInt? resize}) async {
  final img = await ImageFormatJxl().loadBytes(raw, resize: resize);
  return ImageDescriptor.raw(
    await ImmutableBuffer.fromUint8List(img!.pixel),
    width: img.width,
    height: img.height,
    pixelFormat: PixelFormat.rgba8888,
  ).instantiateCodec();
}
