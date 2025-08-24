import 'dart:ui' as ui show Codec, ImmutableBuffer;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_common/size.dart';
import 'package:to_string/to_string.dart';

part 'content_uri_image_provider.g.dart';

@toString
class ContentUriImage extends ImageProvider<ContentUriImage>
    with EquatableMixin {
  /// Creates an object that decodes a content Uri as an image.
  const ContentUriImage(this.uri, {this.thumbnailSizeHint, this.scale = 1.0});

  @override
  obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ContentUriImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    ContentUriImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.uri,
      informationCollector:
          () => <DiagnosticsNode>[ErrorDescription("Content uri: $uri")],
    );
  }

  Future<ui.Codec> _loadAsync(
    ContentUriImage key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final Uint8List bytes;
    if (thumbnailSizeHint == null) {
      bytes = await ContentUri.readUri(uri);
    } else {
      bytes = await ContentUri.readThumbnail(
        uri: uri,
        width: thumbnailSizeHint!.width,
        height: thumbnailSizeHint!.height,
      );
    }
    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError("$uri is empty and cannot be loaded as an image.");
    }
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      bytes,
    );
    return decode(buffer);
  }

  @override
  List<Object?> get props => [uri, thumbnailSizeHint, scale];

  @override
  String toString() => _$toString();

  final String uri;

  /// If provided, a thumbnail will be generated instead of returning the
  /// original file
  final SizeInt? thumbnailSizeHint;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;
}
