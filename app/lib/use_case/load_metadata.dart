import 'dart:io' as io;
import 'dart:typed_data';

import 'package:exifdart/exifdart.dart' as exifdart;
import 'package:exifdart/exifdart_io.dart';
import 'package:exifdart/exifdart_memory.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:nc_photos/entity/file.dart' as app;
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/file_extension.dart';
import 'package:nc_photos/image_size_getter_util.dart';
import 'package:np_log/np_log.dart';

part 'load_metadata.g.dart';

@npLog
class LoadMetadata {
  /// Load metadata of [binary], which is the content of [file]
  Future<app.Metadata> loadRemote(
      Account account, app.File file, Uint8List binary) {
    return _loadMetadata(
      mime: file.contentType ?? "",
      exifdartReaderBuilder: () => MemoryBlobReader(binary),
      imageSizeGetterInputBuilder: () => AsyncMemoryInput(binary),
      filename: file.path,
    );
  }

  Future<app.Metadata> loadLocal(
    io.File file, {
    String? mime,
  }) async {
    mime = mime ?? await file.readMime();
    return _loadMetadata(
      mime: mime ?? "",
      exifdartReaderBuilder: () => FileReader(file),
      imageSizeGetterInputBuilder: () => AsyncFileInput(file),
      filename: file.path,
    );
  }

  Future<app.Metadata> _loadMetadata({
    required String mime,
    required exifdart.AbstractBlobReader Function() exifdartReaderBuilder,
    required AsyncImageInput Function() imageSizeGetterInputBuilder,
    String? filename,
  }) async {
    var metadata = exifdart.Metadata();
    if (file_util.isMetadataSupportedMime(mime)) {
      try {
        metadata = await exifdart.readMetadata(exifdartReaderBuilder());
      } catch (e, stacktrace) {
        _log.shout(
            "[_loadMetadata] Failed while readMetadata for $mime file: ${logFilename(filename)}",
            e,
            stacktrace);
        // ignore exif
      }
    }

    int imageWidth = 0, imageHeight = 0;
    if (metadata.imageWidth == null || metadata.imageHeight == null) {
      try {
        final resolution =
            await AsyncImageSizeGetter.getSize(imageSizeGetterInputBuilder());
        // image size getter doesn't handle exif orientation
        if (metadata.exif?.containsKey("Orientation") == true &&
            metadata.exif!["Orientation"] >= 5 &&
            metadata.exif!["Orientation"] <= 8) {
          // 90 deg CW/CCW
          imageWidth = resolution.height;
          imageHeight = resolution.width;
        } else {
          imageWidth = resolution.width;
          imageHeight = resolution.height;
        }
      } catch (e, stacktrace) {
        // is this even an image file?
        _log.shout(
            "[_loadMetadata] Failed while getSize for $mime file: ${logFilename(filename)}",
            e,
            stacktrace);
      }
    } else {
      if (metadata.rotateAngleCcw != null &&
          metadata.rotateAngleCcw! % 180 != 0) {
        imageWidth = metadata.imageHeight!;
        imageHeight = metadata.imageWidth!;
      } else {
        imageWidth = metadata.imageWidth!;
        imageHeight = metadata.imageHeight!;
      }
    }

    final map = {
      if (metadata.exif != null) "exif": metadata.exif,
      if (imageWidth > 0 && imageHeight > 0)
        "resolution": {
          "width": imageWidth,
          "height": imageHeight,
        },
    };
    return _buildMetadata(map);
  }

  app.Metadata _buildMetadata(Map<String, dynamic> map) {
    int? imageWidth, imageHeight;
    Exif? exif;
    if (map.containsKey("resolution")) {
      imageWidth = map["resolution"]["width"];
      imageHeight = map["resolution"]["height"];
    }
    if (map.containsKey("exif")) {
      exif = Exif(map["exif"]);
    }
    return app.Metadata(
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      exif: exif,
    );
  }
}
