import 'package:flutter/material.dart';
import 'package:nc_photos/controller/any_files_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/adapter_mixin.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/entity/any_file/worker/local.dart';
import 'package:nc_photos/entity/any_file/worker/nextcloud.dart';

class AnyFileMergedCapabilityWorker implements AnyFileCapabilityWorker {
  const AnyFileMergedCapabilityWorker();

  @override
  bool isPermitted(AnyFileCapability capability) {
    return switch (capability) {
      AnyFileCapability.favorite ||
      AnyFileCapability.archive ||
      AnyFileCapability.edit ||
      AnyFileCapability.delete ||
      AnyFileCapability.remoteShare ||
      AnyFileCapability.localShare ||
      AnyFileCapability.collection => true,
      AnyFileCapability.download || AnyFileCapability.upload => false,
    };
  }
}

class AnyFileMergedFavoriteWorker implements AnyFileFavoriteWorker {
  AnyFileMergedFavoriteWorker(
    AnyFile file, {
    required FilesController filesController,
  }) : _delegate = AnyFileNextcloudFavoriteWorker(
         (file.provider as AnyFileMergedProvider).asRemoteFile(),
         filesController: filesController,
       );

  @override
  Future<void> favorite() => _delegate.favorite();

  @override
  Future<void> unfavorite() => _delegate.unfavorite();

  final AnyFileFavoriteWorker _delegate;
}

class AnyFileMergedArchiveWorker implements AnyFileArchiveWorker {
  AnyFileMergedArchiveWorker(
    AnyFile file, {
    required FilesController filesController,
  }) : _delegate = AnyFileNextcloudArchiveWorker(
         (file.provider as AnyFileMergedProvider).asRemoteFile(),
         filesController: filesController,
       );

  @override
  Future<void> archive() => _delegate.archive();

  @override
  Future<void> unarchive() => _delegate.unarchive();

  final AnyFileArchiveWorker _delegate;
}

class AnyFileMergedDownloadWorker
    with AnyFileWorkerNoDownloadTag
    implements AnyFileDownloadWorker {
  const AnyFileMergedDownloadWorker();
}

class AnyFileMergedDeleteWorker implements AnyFileDeleteWorker {
  AnyFileMergedDeleteWorker(
    this.file, {
    required this.filesController,
    required this.localFilesController,
  });

  @override
  Future<bool> delete({AnyFileRemoveHint hint = AnyFileRemoveHint.both}) async {
    final results = await Future.wait([
      if (hint == AnyFileRemoveHint.remote || hint == AnyFileRemoveHint.both)
        AnyFileNextcloudDeleteWorker(
          (file.provider as AnyFileMergedProvider).asRemoteFile(),
          filesController: filesController,
        ).delete(),
      if (hint == AnyFileRemoveHint.local || hint == AnyFileRemoveHint.both)
        AnyFileLocalDeleteWorker(
          (file.provider as AnyFileMergedProvider).asLocalFile(),
          localFilesController: localFilesController,
        ).delete(),
    ]);
    return results.every((e) => e);
  }

  final AnyFile file;
  final FilesController filesController;
  final LocalFilesController localFilesController;
}

class AnyFileMergedSetAsWorker implements AnyFileSetAsWorker {
  AnyFileMergedSetAsWorker(AnyFile file)
    : _delegate = AnyFileLocalSetAsWorker(
        (file.provider as AnyFileMergedProvider).asLocalFile(),
      );

  @override
  Future<void> setAs(BuildContext context) => _delegate.setAs(context);

  final AnyFileSetAsWorker _delegate;
}

class AnyFileMergedUploadWorker
    with AnyFileWorkerNoUploadTag
    implements AnyFileUploadWorker {
  const AnyFileMergedUploadWorker();
}
