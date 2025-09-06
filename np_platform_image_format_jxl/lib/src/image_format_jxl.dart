import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:np_common/size.dart';
import 'package:np_image_format_interface/np_image_format_interface.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_image_format_jxl/src/messages.g.dart';
import 'package:np_platform_image_format_jxl/src/pigeon_util.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';

part 'image_format_jxl.g.dart';

@npLog
class ImageFormatJxl implements ImageFormatInterface {
  @override
  Future<Rgba8Image?> load(File file, {SizeInt? resize}) async {
    final result = await _hostApi.load(
      file.absolute.path,
      resize?.width,
      resize?.height,
    );
    return result.toInterfaceType();
  }

  @override
  Future<Rgba8Image?> loadBytes(Uint8List bytes, {SizeInt? resize}) async {
    final result = await _hostApi.loadBytes(
      bytes,
      resize?.width,
      resize?.height,
    );
    return result.toInterfaceType();
  }

  @override
  Future<ImageFormatMetadata?> loadMetadata(File file) async {
    final result = await _hostApi.loadMetadata(file.absolute.path);
    return result?.toInterfaceType();
  }

  @override
  Future<bool> save(Rgba8Image img, File file, Map<String, Object?>? config) {
    return _hostApi.save(img.toPigeonType(), file.absolute.path);
  }

  Future<void> convertJpeg(File file, {SizeInt? resize}) {
    return _hostApi.convertJpeg(
      file.absolute.path,
      resize?.width,
      resize?.height,
    );
  }

  final _hostApi = MyHostApi();
}
