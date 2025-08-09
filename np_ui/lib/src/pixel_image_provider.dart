import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// ImageProvider for raw RGBA pixels
class PixelImage extends ImageProvider<PixelImage> {
  const PixelImage(this.rgba, this.width, this.height, {this.scale = 1.0});

  @override
  Future<PixelImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<PixelImage>(this);

  @override
  ImageStreamCompleter loadImage(PixelImage key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_createImageInfo());

  Future<ImageInfo> _createImageInfo() async {
    final codec =
        await ImageDescriptor.raw(
          await ImmutableBuffer.fromUint8List(rgba),
          width: width,
          height: height,
          pixelFormat: PixelFormat.rgba8888,
        ).instantiateCodec();
    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image, scale: scale);
  }

  final Uint8List rgba;
  final int width;
  final int height;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;
}
