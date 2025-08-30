import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/local.dart';
import 'package:nc_photos/entity/any_file/worker/nextcloud.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';

abstract interface class AnyFileWorkerFactory {
  static AnyFileCapabilityWorker capability(AnyFile file) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return const AnyFileNextcloudCapabilityWorker();
      case AnyFileLocalProvider _:
        return const AnyFileLocalCapabilityWorker();
    }
  }

  static AnyFileFavoriteWorker favorite(
    AnyFile file, {
    required FilesController filesController,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudFavoriteWorker(
          file,
          filesController: filesController,
        );
      case AnyFileLocalProvider _:
        return const AnyFileLocalFavoriteWorker();
    }
  }

  static AnyFileArchiveWorker archive(
    AnyFile file, {
    required FilesController filesController,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudArchiveWorker(
          file,
          filesController: filesController,
        );
      case AnyFileLocalProvider _:
        return const AnyFileLocalArchiveWorker();
    }
  }

  static AnyFileDownloadWorker download(
    AnyFile file, {
    required Account account,
    required DiContainer c,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudDownloadWorker(file, account: account, c: c);
      case AnyFileLocalProvider _:
        return const AnyFileLocalDownloadWorker();
    }
  }

  static AnyFileDeleteWorker delete(
    AnyFile file, {
    required FilesController filesController,
    required LocalFilesController localFilesController,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudDeleteWorker(
          file,
          filesController: filesController,
        );
      case AnyFileLocalProvider _:
        return AnyFileLocalDeleteWorker(
          file,
          localFilesController: localFilesController,
        );
    }
  }

  static AnyFileShareWorker share(
    AnyFile file, {
    required Account account,
    required DiContainer c,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudShareWorker(file, account: account, c: c);
      case AnyFileLocalProvider _:
        return AnyFileLocalShareWorker(file);
    }
  }

  static AnyFileSetAsWorker setAs(
    AnyFile file, {
    required Account account,
    required DiContainer c,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudSetAsWorker(file, account: account, c: c);
      case AnyFileLocalProvider _:
        return AnyFileLocalSetAsWorker(file);
    }
  }

  static AnyFileUploadWorker upload(AnyFile file, {required Account account}) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return const AnyFileNextcloudUploadWorker();
      case AnyFileLocalProvider _:
        return AnyFileLocalUploadWorker(file, account: account);
    }
  }
}

abstract interface class AnyFileCapabilityWorker {
  /// Return if this capability is available at this moment
  bool isPermitted(AnyFileCapability capability);
}

abstract interface class AnyFileFavoriteWorker {
  Future<void> favorite();
  Future<void> unfavorite();
}

abstract interface class AnyFileArchiveWorker {
  Future<void> archive();
  Future<void> unarchive();
}

abstract interface class AnyFileDownloadWorker {
  Future<void> download();
}

abstract interface class AnyFileDeleteWorker {
  Future<bool> delete();
}

abstract interface class AnyFileShareWorker {
  Future<void> share(BuildContext context);
}

abstract interface class AnyFileSetAsWorker {
  Future<void> setAs(BuildContext context);
}

abstract interface class AnyFileUploadWorker {
  void upload(String relativePath, {ConvertConfig? convertConfig});
}
