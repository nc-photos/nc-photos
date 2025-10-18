import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/adapter_mixin.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/mobile/share.dart';
import 'package:nc_photos/use_case/local_file/upload_local_file.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';
import 'package:np_platform_util/np_platform_util.dart';

class AnyFileLocalCapabilityWorker implements AnyFileCapabilityWorker {
  const AnyFileLocalCapabilityWorker();

  @override
  bool isPermitted(AnyFileCapability capability) {
    return switch (capability) {
      AnyFileCapability.delete ||
      AnyFileCapability.edit ||
      AnyFileCapability.upload => true,
      AnyFileCapability.favorite ||
      AnyFileCapability.archive ||
      AnyFileCapability.download ||
      AnyFileCapability.remoteShare ||
      AnyFileCapability.collection => false,
    };
  }
}

class AnyFileLocalFavoriteWorker
    with AnyFileWorkerNoFavoriteTag
    implements AnyFileFavoriteWorker {
  const AnyFileLocalFavoriteWorker();
}

class AnyFileLocalArchiveWorker
    with AnyFileWorkerNoArchiveTag
    implements AnyFileArchiveWorker {
  const AnyFileLocalArchiveWorker();
}

class AnyFileLocalDownloadWorker
    with AnyFileWorkerNoDownloadTag
    implements AnyFileDownloadWorker {
  const AnyFileLocalDownloadWorker();
}

class AnyFileLocalDeleteWorker implements AnyFileDeleteWorker {
  AnyFileLocalDeleteWorker(AnyFile file, {required this.localFilesController})
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<bool> delete() async {
    var isGood = true;
    await localFilesController.trash(
      [_provider.file],
      errorBuilder: (fileIds) {
        isGood = false;
        return LocalFileRemoveFailureError(fileIds);
      },
    );
    return isGood;
  }

  final LocalFilesController localFilesController;

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalShareWorker implements AnyFileShareWorker {
  AnyFileLocalShareWorker(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<void> share(BuildContext context) {
    final f = _provider.file;
    if (f is LocalUriFile) {
      if (getRawPlatform() == NpPlatform.android) {
        final share = AndroidFileShare([AndroidFileShareFile(f.uri, f.mime)]);
        return share.share();
      }
    }
    throw UnsupportedError("Unsupported file");
  }

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalSetAsWorker implements AnyFileSetAsWorker {
  AnyFileLocalSetAsWorker(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<void> setAs(BuildContext context) async {
    final f = _provider.file;
    if (f is LocalUriFile) {
      if (getRawPlatform() == NpPlatform.android) {
        final share = AndroidFileShare([AndroidFileShareFile(f.uri, f.mime)]);
        return share.setAs();
      }
    }
    throw UnsupportedError("Unsupported file");
  }

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalUploadWorker implements AnyFileUploadWorker {
  AnyFileLocalUploadWorker(AnyFile file, {required this.account})
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  void upload(String relativePath, {ConvertConfig? convertConfig}) {
    final f = _provider.file;
    UploadLocalFile(account: account)(
      f,
      relativePath: relativePath,
      convertConfig: convertConfig,
    );
  }

  final Account account;

  final AnyFileLocalProvider _provider;
}
