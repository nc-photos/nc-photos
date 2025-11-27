import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/xmp.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_exiv2/np_exiv2.dart' as exiv2;
import 'package:np_log/np_log.dart';

part 'load_metadata.g.dart';

@npLog
class LoadMetadata {
  /// Load metadata of [binary], which is the content of [file]
  Future<Metadata> loadAnyfile(AnyFile file, Uint8List binary) {
    return _loadMetadata(
      mime: file.mime ?? "",
      reader:
          () => exiv2.readBuffer(
            binary,
            isReadXmp: file_util.isSupportedVideoMime(file.mime ?? ""),
          ),
      logTag: file.displayPath,
    );
  }

  Future<Metadata> _loadMetadata({
    required String mime,
    required exiv2.ReadResult Function() reader,
    String? logTag,
  }) async {
    final exiv2.ReadResult result;
    try {
      result = reader();
    } catch (e, stacktrace) {
      _log.shout(
        "[_loadMetadata] Failed while readMetadata for $mime file: ${logFilename(logTag)}",
        e,
        stacktrace,
      );
      rethrow;
    }
    final exifData = {
      ...result.iptcData
          .map((e) {
            try {
              return MapEntry(e.tagKey, e.value.asTyped());
            } catch (_) {
              _log.shout(
                "[_loadMetadata] Unable to convert IPTC tag: ${e.tagKey}, ${e.value.toDebugString()}",
              );
              return null;
            }
          })
          .nonNulls
          .toMap(),
      ...result.exifData
          .map((e) {
            try {
              return MapEntry(e.tagKey, e.value.asTyped());
            } catch (_) {
              _log.shout(
                "[_loadMetadata] Unable to convert EXIF tag: ${e.tagKey}, ${e.value.toDebugString()}",
              );
              return null;
            }
          })
          .nonNulls
          .toMap(),
    };
    // keys starting with 0x are probably some proprietary values that we'll
    // never use
    exifData.removeWhere((key, value) => key.startsWith("0x"));
    final exif = exifData.isNotEmpty ? Exif(exifData) : null;

    final xmpData =
        result.xmpData
            .map((e) {
              try {
                return MapEntry(e.tagKey, e.value.asTyped());
              } catch (_) {
                _log.shout(
                  "[_loadMetadata] Unable to convert XMP tag: ${e.tagKey}, ${e.value.toDebugString()}",
                );
                return null;
              }
            })
            .nonNulls
            .toMap();
    final xmp = xmpData.isNotEmpty ? Xmp(xmpData) : null;

    int? imageWidth = 0, imageHeight = 0;
    if (mime.startsWith("video")) {
      // for videos, exiv2 always returns 0 for pixel width and height
      imageWidth = xmp?.width;
      imageHeight = xmp?.height;
    } else {
      imageWidth = result.width;
      imageHeight = result.height;
    }
    // exiv2 doesn't handle orientation
    if (exifData.containsKey("Orientation") &&
        exifData["Orientation"] as int >= 5 &&
        exifData["Orientation"] as int <= 8) {
      // 90 deg CW/CCW
      (imageWidth, imageHeight) = (imageHeight, imageWidth);
    }

    return Metadata(
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      exif: exif,
      xmp: xmp,
      src: MetadataSrc.exiv2,
    );
  }
}
