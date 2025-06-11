import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'any_files_controller.g.dart';

@npLog
class AnyFilesController {
  AnyFilesController({
    required this.filesController,
    required this.localFilesController,
  });

  void dispose() {}

  Stream<ExceptionEvent> get errorStream => _dataErrorStreamController.stream;

  Future<void> queryByAfId(List<String> afIds) {
    return handleAnyFileIdByType(
      afIds,
      nextcloudHandler:
          (ids) =>
              filesController.queryByFileId(ids.map((e) => e.fileId).toList()),
      localHandler:
          (ids) => localFilesController.queryByFileId(
            ids.map((e) => e.fileId).toList(),
          ),
    );
  }

  Future<void> remove(
    List<AnyFile> files, {
    Exception? Function(List<AnyFile> files)? errorBuilder,
  }) async {
    final groups = groupBy(
      files,
      (e) => switch (e.provider) {
        AnyFileNextcloudProvider _ => AnyFileProviderType.nextcloud,
        AnyFileLocalProvider _ => AnyFileProviderType.local,
      },
    );
    final failures = <AnyFile>[];
    await Future.wait([
      if (groups[AnyFileProviderType.nextcloud]?.isNotEmpty == true)
        filesController.remove(
          groups[AnyFileProviderType.nextcloud]!
              .map((e) => (e.provider as AnyFileNextcloudProvider).file)
              .toList(),
          errorBuilder:
              errorBuilder == null
                  ? null
                  : (files) {
                    failures.addAll(files.map((e) => e.toAnyFile()));
                    return null;
                  },
        ),
      if (groups[AnyFileProviderType.local]?.isNotEmpty == true)
        localFilesController.trash(
          groups[AnyFileProviderType.local]!
              .map((e) => (e.provider as AnyFileLocalProvider).file)
              .toList(),
          errorBuilder:
              errorBuilder == null
                  ? null
                  : (files) {
                    failures.addAll(files.map((e) => e.toAnyFile()));
                    return null;
                  },
        ),
    ]);
    (errorBuilder ?? AnyFileRemoveFailureError.new)
        .call(failures)
        ?.let((e) => _dataErrorStreamController.add(ExceptionEvent(e)));
  }

  final FilesController filesController;
  final LocalFilesController localFilesController;

  final _dataErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();
}

@toString
class AnyFileRemoveFailureError implements Exception {
  const AnyFileRemoveFailureError(this.files);

  @override
  String toString() => _$toString();

  final List<AnyFile> files;
}
