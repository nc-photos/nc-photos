import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:logging/logging.dart';
import 'package:np_ffi_image_editor/src/np_ffi_image_editor_bindings_generated.dart'
    as ffi;
import 'package:np_platform_raw_image/np_platform_raw_image.dart';

extension Rgba8ImageExtension on Rgba8Image {
  Future<T> useNative<T>(
    FutureOr<T> Function(Pointer<ffi.Rgba8Image> cImg) fn,
  ) async {
    var cPixel = Pointer<Uint8>.fromAddress(0);
    var cImg = Pointer<ffi.Rgba8Image>.fromAddress(0);
    try {
      cPixel = calloc.allocate<Uint8>(pixel.length);
      final typed = cPixel.asTypedList(pixel.length);
      typed.setAll(0, pixel);
      cImg = calloc<ffi.Rgba8Image>();
      cImg.ref.pixel = cPixel;
      cImg.ref.width = width;
      cImg.ref.height = height;
      return await fn(cImg);
    } catch (e, stackTrace) {
      _log.severe(
        "useNative Failed to convert dart image to native",
        e,
        stackTrace,
      );
      rethrow;
    } finally {
      calloc.free(cPixel);
      calloc.free(cImg);
    }
  }
}

extension FfiRgba8ImageExtension on ffi.Rgba8Image {
  Rgba8Image toDart() {
    final dPixel = Uint8List(width * height * 4);
    dPixel.setAll(0, pixel.asTypedList(dPixel.length));
    return Rgba8Image(dPixel, width, height);
  }
}

final _log = Logger("np_ffi_image_editor.image_util");
