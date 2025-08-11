import 'dart:io';
import 'dart:typed_data';

import 'package:np_common/size.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:to_string/to_string.dart';

part 'image_format_interface.g.dart';

@toString
class ImageFormatMetadata {
  const ImageFormatMetadata({required this.size});

  @override
  String toString() => _$toString();

  final SizeInt size;
}

abstract interface class ImageFormatInterface {
  /// Decode and return the pixel data of [file].
  ///
  /// If [resize] is not null, the image will be loaded in the specified size.
  Future<Rgba8Image?> load(File file, {SizeInt? resize});

  /// Decode and return the pixel data of [bytes].
  ///
  /// If [resize] is not null, the image will be loaded in the specified size.
  Future<Rgba8Image?> loadBytes(Uint8List bytes, {SizeInt? resize});

  /// Return metadata of [file]
  Future<ImageFormatMetadata?> loadMetadata(File file);

  /// Save [img] as [file] in this format. Format specific configurations are
  /// held in [config]. The content of this map is implementation specific
  Future<bool> save(Rgba8Image img, File file, Map<String, Object?>? config);
}
