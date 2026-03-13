import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:np_platform_raw_image/src/rgba8_image.dart';

extension Rgba8ImageExtension on Rgba8Image {
  Rgba8Image cropSync(Rect rect) {
    final l = rect.left.round().clamp(0, width);
    final t = rect.top.round().clamp(0, height);
    final r = rect.right.round().clamp(0, width);
    final b = rect.bottom.round().clamp(0, height);
    final newW = r - l;
    final newH = b - t;
    final result = Uint8List(newW * newH * 4);
    for (var y = 0; y < newH; ++y) {
      final srcOffset = ((t + y) * width + l) * 4;
      final dstOffset = y * newW * 4;
      result.setRange(dstOffset, dstOffset + newW * 4, pixel, srcOffset);
    }
    return Rgba8Image(result, newW, newH);
  }

  Future<Rgba8Image> crop(Rect rect) async {
    return Isolate.run(() => cropSync(rect));
  }
}
