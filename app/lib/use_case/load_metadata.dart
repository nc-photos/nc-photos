import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:nc_photos/entity/file.dart';
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
      reader: () => exiv2.readBuffer(binary),
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
    final metadata = {
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
    metadata.removeWhere((key, value) => key.startsWith("0x"));

    var imageWidth = 0, imageHeight = 0;
    // exiv2 doesn't handle exif orientation
    if (metadata.containsKey("Orientation") &&
        metadata["Orientation"] as int >= 5 &&
        metadata["Orientation"] as int <= 8) {
      // 90 deg CW/CCW
      imageWidth = result.height;
      imageHeight = result.width;
    } else {
      imageWidth = result.width;
      imageHeight = result.height;
    }

    return Metadata(
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      exif: metadata.isNotEmpty ? Exif(metadata) : null,
      src: MetadataSrc.exiv2,
    );
  }
}
