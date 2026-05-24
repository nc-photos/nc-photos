import 'dart:async';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:np_exiv2/np_exiv2.dart' as exiv2;
import 'package:time_machine2/time_machine2.dart';

enum UpdateAnyFileMetadataStep { read, write }

class UpdateAnyFileMetadata {
  const UpdateAnyFileMetadata(this._c, this.prefController);

  // Currently only work with remote file
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
  final PrefController prefController;
}
