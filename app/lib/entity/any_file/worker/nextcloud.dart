import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/any_files_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/download_handler.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/adapter_mixin.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/set_as_handler.dart';
import 'package:nc_photos/use_case/copy.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/use_case/put_file_binary.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';

part 'nextcloud.g.dart';

class AnyFileNextcloudCapabilityWorker implements AnyFileCapabilityWorker {
  const AnyFileNextcloudCapabilityWorker();

  @override
  bool isPermitted(AnyFileCapability capability) {
    return switch (capability) {
      AnyFileCapability.favorite ||
      AnyFileCapability.archive ||
      AnyFileCapability.edit ||
      AnyFileCapability.download ||
      AnyFileCapability.delete ||
      AnyFileCapability.remoteShare ||
      AnyFileCapability.collection => true,
      AnyFileCapability.upload || AnyFileCapability.localShare => false,
    };
  }
}

class AnyFileNextcloudFavoriteWorker implements AnyFileFavoriteWorker {
  AnyFileNextcloudFavoriteWorker(AnyFile file, {required this.filesController})
    : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<void> favorite() async {
    return filesController.updateProperty([_provider.file], isFavorite: true);
  }

  @override
  Future<void> unfavorite() async {
    return filesController.updateProperty([_provider.file], isFavorite: false);
  }

  final FilesController filesController;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudArchiveWorker implements AnyFileArchiveWorker {
  AnyFileNextcloudArchiveWorker(AnyFile file, {required this.filesController})
    : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<void> archive() async {
    return filesController.updateProperty([
      _provider.file,
    ], isArchived: const OrNull(true));
  }

  @override
  Future<void> unarchive() async {
    return filesController.updateProperty([
      _provider.file,
    ], isArchived: const OrNull(false));
  }

  final FilesController filesController;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudDownloadWorker implements AnyFileDownloadWorker {
  AnyFileNextcloudDownloadWorker(
    AnyFile file, {
    required this.account,
    required this.c,
  }) : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<void> download() {
    return DownloadHandler(c).downloadFiles(account, [_provider.file]);
  }

  final Account account;
  final DiContainer c;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudDeleteWorker implements AnyFileDeleteWorker {
  AnyFileNextcloudDeleteWorker(AnyFile file, {required this.filesController})
    : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<bool> delete({AnyFileRemoveHint hint = AnyFileRemoveHint.both}) async {
    var isGood = true;
    await filesController.remove(
      [_provider.file],
      errorBuilder: (fileIds) {
        isGood = false;
        return RemoveFailureError(fileIds);
      },
    );
    return isGood;
  }

  final FilesController filesController;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudSetAsWorker implements AnyFileSetAsWorker {
  AnyFileNextcloudSetAsWorker(
    AnyFile file, {
    required this.account,
    required this.c,
  }) : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<void> setAs(BuildContext context) {
    // TODO move ui code out of this
    return SetAsHandler(c, context: context).setAsFile(account, _provider.file);
  }

  final Account account;
  final DiContainer c;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudUploadWorker
    with AnyFileWorkerNoUploadTag
    implements AnyFileUploadWorker {
  const AnyFileNextcloudUploadWorker();
}

@npLog
class AnyFileNextcloudReplaceWithBackupWorker
    implements AnyFileReplaceWithBackupWorker {
  AnyFileNextcloudReplaceWithBackupWorker(
    AnyFile file, {
    required this.account,
    required this.c,
  }) : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<void> replace(
    io.File srcFile, {
    void Function(double progress)? onProgress,
    required bool shouldBackup,
  }) async {
    final filePath = _provider.file.fdPath;
    // to play safe, we first backup the orig file
    if (shouldBackup) {
      try {
        await Copy(c.fileRepo)(account, _provider.file, "${filePath}_original");
      } on ApiException catch (e, stackTrace) {
        if (e.response.statusCode == 412) {
          _log.fine("[replace] Original file already backed up, skip");
        } else {
          _log.severe(
            "[replace] Failed while Copy on original file",
            e,
            stackTrace,
          );
          rethrow;
        }
      } catch (e, stackTrace) {
        _log.severe(
          "[replace] Failed while Copy on original file",
          e,
          stackTrace,
        );
        rethrow;
      }
    } else {
      _log.info("[replace] Backup skipped by pref");
    }
    // then upload new file to replace
    try {
      final bytes = await srcFile.readAsBytes();
      await PutFileBinary(c.fileRepo)(
        account,
        filePath,
        bytes,
        onProgress: onProgress,
      );
      // update db
      unawaited(LsSingleFile(c)(account, filePath));
    } catch (e, stackTrace) {
      _log.severe("[replace] Failed while PutFileBinary", e, stackTrace);
      rethrow;
    }
  }

  final Account account;
  final DiContainer c;

  final AnyFileNextcloudProvider _provider;
}
