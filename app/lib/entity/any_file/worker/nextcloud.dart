import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/download_handler.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/set_as_handler.dart';
import 'package:nc_photos/share_handler.dart';
import 'package:np_common/or_null.dart';

class AnyFileNextcloudCapabilityWorker implements AnyFileCapabilityWorker {
  const AnyFileNextcloudCapabilityWorker();

  @override
  bool isPermitted(AnyFileCapability capability) {
    return switch (capability) {
      AnyFileCapability.favorite ||
      AnyFileCapability.archive ||
      AnyFileCapability.edit ||
      AnyFileCapability.download ||
      AnyFileCapability.delete => true,
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
  Future<bool> delete() async {
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

class AnyFileNextcloudShareWorker implements AnyFileShareWorker {
  AnyFileNextcloudShareWorker(
    AnyFile file, {
    required this.account,
    required this.c,
  }) : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<void> share(BuildContext context) {
    // TODO move ui code out of this
    return ShareHandler(
      c,
      context: context,
    ).shareFiles(account, [_provider.file]);
  }

  final Account account;
  final DiContainer c;

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
