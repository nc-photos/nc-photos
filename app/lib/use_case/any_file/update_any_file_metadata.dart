import 'dart:async';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/entity/exif_util.dart';
import 'package:np_exiv2/np_exiv2.dart' as exiv2;
import 'package:np_gps_map/np_gps_map.dart';
import 'package:time_machine2/time_machine2.dart';

enum UpdateAnyFileMetadataStep { read, write }

class UpdateAnyFileMetadata {
  const UpdateAnyFileMetadata(
    this._c, {
    required this.filesController,
    required this.prefController,
  });

  Future<void> setDateTimeOriginal(
    AnyFile file,
    ZonedDateTime dateTime, {
    required Account account,
    void Function(UpdateAnyFileMetadataStep step, double progress)? onProgress,
  }) async {
    final getter = AnyFileContentGetterFactory.privateFileCopy(
      file,
      account: account,
      isPreferRemote: true,
    );
    final result = await getter.get(
      onProgress: (progress) {
        onProgress?.call(UpdateAnyFileMetadataStep.read, progress);
      },
    );
    try {
      if (!await exiv2.writeFileDateTimeOriginal(result.path, dateTime)) {
        throw Exception("Failed to write DateTimeOriginal");
      }
      final worker = AnyFileWorkerFactory.replaceWithBackup(
        file,
        filesController: filesController,
        account: account,
        c: _c,
      );
      await worker.replace(
        result,
        onProgress: (progress) {
          onProgress?.call(UpdateAnyFileMetadataStep.write, progress);
        },
        shouldBackup: prefController.isBackupOnRemoteExifEditValue,
      );
    } finally {
      unawaited(result.delete());
    }
  }

  // Set or remove GPS data
  Future<void> setGps(
    AnyFile file,
    MapCoord? gps, {
    required Account account,
    void Function(UpdateAnyFileMetadataStep step, double progress)? onProgress,
  }) async {
    final String? gpsLatitudeRef;
    final List<exiv2.Rational>? gpsLatitude;
    final String? gpsLongitudeRef;
    final List<exiv2.Rational>? gpsLongitude;
    if (gps == null) {
      gpsLatitudeRef = null;
      gpsLatitude = null;
      gpsLongitudeRef = null;
      gpsLongitude = null;
    } else {
      gpsLatitudeRef = gps.latitude.isNegative ? "S" : "N";
      gpsLatitude = gpsDoubleToDms(gps.latitude);
      gpsLongitudeRef = gps.longitude.isNegative ? "W" : "E";
      gpsLongitude = gpsDoubleToDms(gps.longitude);
    }

    final getter = AnyFileContentGetterFactory.privateFileCopy(
      file,
      account: account,
      isPreferRemote: true,
    );
    final result = await getter.get(
      onProgress: (progress) {
        onProgress?.call(UpdateAnyFileMetadataStep.read, progress);
      },
    );
    try {
      if (!await exiv2.writeFileGps(
        result.path,
        latitudeRef: gpsLatitudeRef,
        latitude: gpsLatitude,
        longitudeRef: gpsLongitudeRef,
        longitude: gpsLongitude,
      )) {
        throw Exception("Failed to write GPS data");
      }
      final worker = AnyFileWorkerFactory.replaceWithBackup(
        file,
        filesController: filesController,
        account: account,
        c: _c,
      );
      await worker.replace(
        result,
        onProgress: (progress) {
          onProgress?.call(UpdateAnyFileMetadataStep.write, progress);
        },
        shouldBackup: prefController.isBackupOnRemoteExifEditValue,
      );
    } finally {
      unawaited(result.delete());
    }
  }

  final DiContainer _c;
  final FilesController filesController;
  final PrefController prefController;
}
