import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_common/size.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'video_uri_thumbnail_image_provider.g.dart';

@npLog
@toString
class VideoUriThumbnailImage extends ImageProvider<VideoUriThumbnailImage>
    with EquatableMixin {
  const VideoUriThumbnailImage(
    this.uri, {
    required this.sizeHint,
    this.scale = 1.0,
  });

  @override
  Future<VideoUriThumbnailImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<VideoUriThumbnailImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    VideoUriThumbnailImage key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      _loadAsync(),
      informationCollector:
          () => <DiagnosticsNode>[ErrorDescription("Video content uri: $uri")],
    );
  }

  Future<ImageInfo> _loadAsync() async {
    try {
      final rgba8 = await MediaStore.getVideoThumbnail(uri, sizeHint);
      final codec =
          await ImageDescriptor.raw(
            await ImmutableBuffer.fromUint8List(rgba8.pixel),
            width: rgba8.width,
            height: rgba8.height,
            pixelFormat: PixelFormat.rgba8888,
          ).instantiateCodec();
      final frame = await codec.getNextFrame();
      return ImageInfo(image: frame.image, scale: scale);
    } catch (e, stackTrace) {
      _log.severe("[_loadAsync] Failed loading video thumbnail", e, stackTrace);
      rethrow;
    }
  }

  @override
  List<Object?> get props => [uri, sizeHint, scale];

  @override
  String toString() => _$toString();

  final String uri;
  final SizeInt sizeHint;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;
}
