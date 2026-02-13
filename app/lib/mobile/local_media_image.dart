import 'dart:ui' as ui show Codec, ImmutableBuffer;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:np_common/size.dart';
import 'package:np_platform_local_media/np_platform_local_media.dart';
import 'package:to_string/to_string.dart';

part 'local_media_image.g.dart';

@toString
class LocalMediaImage extends ImageProvider<LocalMediaImage>
    with EquatableMixin {
  /// Creates an object that load an image file specified by the
  /// [platformIdentifier] as an image.
  const LocalMediaImage(
    this.platformIdentifier, {
    this.thumbnailSizeHint,
    this.scale = 1.0,
  });

  @override
  Future<LocalMediaImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalMediaImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    LocalMediaImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.platformIdentifier,
      informationCollector:
          () => <DiagnosticsNode>[
            ErrorDescription("Platform identifier: $platformIdentifier"),
          ],
    );
  }

  Future<ui.Codec> _loadAsync(
    LocalMediaImage key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final Uint8List bytes;
    if (thumbnailSizeHint == null) {
      bytes = await LocalMedia.readFile(platformIdentifier);
    } else {
      bytes = await LocalMedia.readThumbnail(
        platformIdentifier,
        width: thumbnailSizeHint!.width,
        height: thumbnailSizeHint!.height,
      );
    }
    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError(
        "$platformIdentifier is empty and cannot be loaded as an image.",
      );
    }
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      bytes,
    );
    return decode(buffer);
  }

  @override
  List<Object?> get props => [platformIdentifier, thumbnailSizeHint, scale];

  @override
  String toString() => _$toString();

  final String platformIdentifier;

  /// If provided, a thumbnail will be generated instead of returning the
  /// original file
  final SizeInt? thumbnailSizeHint;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;
}
