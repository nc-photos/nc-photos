import 'dart:math';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/mobile/share.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/copy.dart';
import 'package:nc_photos/use_case/create_dir.dart';
import 'package:nc_photos/use_case/create_share.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'share_any_file.g.dart';

class ShareAnyFileProgress {
  const ShareAnyFileProgress({
    required this.max,
    required this.current,
    required this.filename,
  });

  final int max;
  final int current;
  final String filename;
}

enum ShareAnyFileMethod { file, preview, link }

@npLog
class ShareAnyFile {
  ShareAnyFile(this._c);

  /// Share [files] with other apps
  ///
  /// If [linkPassword] is not null and [method] is [ShareAnyFileMethod.link],
  /// the generated link will be password protected, otherwise it will be a
  /// public link
  Future<void> call(
    List<AnyFile> files, {
    required Account account,
    required ShareAnyFileMethod method,
    String? linkName,
    String? linkPassword,
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(AnyFile? file, Object error, StackTrace? stackTrace)? onError,
    Stream<void>? cancelSignal,
  }) async {
    cancelSignal?.listen((_) {
      isCanceled = true;
    });
    switch (method) {
      case ShareAnyFileMethod.file:
      case ShareAnyFileMethod.preview:
        await _shareActualFiles(
          files,
          account: account,
          method: method,
          onProgress: onProgress,
          onError: onError,
        );
        break;

      case ShareAnyFileMethod.link:
        await _shareFileLinks(
          files,
          account: account,
          name: linkName,
          password: linkPassword,
          onProgress: onProgress,
          onError: onError,
        );
        break;
    }
  }

  Future<void> _shareActualFiles(
    List<AnyFile> files, {
    required Account account,
    required ShareAnyFileMethod method,
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(AnyFile? file, Object error, StackTrace? stackTrace)? onError,
  }) async {
    var i = 0;
    final uris =
        (await files.asyncMap((f) async {
          if (isCanceled) {
            throw const InterruptedException();
          }
          onProgress?.call(
            ShareAnyFileProgress(
              max: files.length,
              current: i++,
              filename: f.name,
            ),
          );
          try {
            if (method == ShareAnyFileMethod.file) {
              return (
                f,
                await AnyFileContentGetterFactory.localFileUri(
                  f,
                  account: account,
                ).get(),
              );
            } else {
              return (
                f,
                await AnyFileContentGetterFactory.localPreviewUri(
                  f,
                  account: account,
                ).get(),
              );
            }
          } catch (e, stackTrace) {
            _log.severe(
              "[_shareActualFiles] Failed while getting local file uri: $f",
              e,
              stackTrace,
            );
            onError?.call(f, e, stackTrace);
            return null;
          }
        })).nonNulls.toList();
    if (isCanceled) {
      throw const InterruptedException();
    }
    if (uris.isEmpty) {
      // oops, all files have failed
      return;
    }
    if (getRawPlatform() == NpPlatform.android) {
      final share = AndroidFileShare(
        uris
            .map((e) => AndroidFileShareFile(e.$2.toString(), e.$1.mime))
            .toList(),
      );
      return share.share();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Future<void> _shareFileLinks(
    List<AnyFile> anyFiles, {
    required Account account,
    String? name,
    String? password,
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(AnyFile? file, Object error, StackTrace? stackTrace)? onError,
  }) async {
    final files =
        anyFiles
            .map((af) {
              final provider = af.provider;
              FileDescriptor? f;
              switch (provider) {
                case AnyFileNextcloudProvider _:
                  f = provider.file;
                  break;
                case AnyFileMergedProvider _:
                  f = provider.remote.file;
                  break;
                default:
                  onError?.call(
                    af,
                    ArgumentError("Unsupported provider type"),
                    null,
                  );
                  break;
              }
              return f?.let((e) => (af, e));
            })
            .nonNulls
            .toList();
    return await _shareRemoteFilesAsLink(
      files,
      account: account,
      name: name,
      password: password,
    );
  }

  Future<void> _shareRemoteFilesAsLink(
    List<(AnyFile, FileDescriptor)> files, {
    required Account account,
    String? name,
    String? password,
  }) async {
    if (files.length == 1) {
      return _shareNextcloudFileAsLink(
        files.first.$2.strippedPath,
        account: account,
        password: password,
      );
    } else {
      name ??= "Shared";
      _log.info("[_shareRemoteFilesAsLink] Share as folder: $name");
      final path = await _createDir(account: account, name: name);
      await _copyFilesToDir(files, account: account, dirPath: path);
      return _shareNextcloudFileAsLink(
        File(path: path).strippedPath,
        account: account,
        password: password,
      );
    }
  }

  Future<void> _shareNextcloudFileAsLink(
    String relativePath, {
    required Account account,
    String? password,
  }) async {
    try {
      final share = await CreateLinkShare(_c.shareRepo)(
        account,
        relativePath,
        password: password,
      );
      if (getRawPlatform() == NpPlatform.android) {
        final textShare = AndroidTextShare(share.url!);
        await textShare.share();
      }
    } catch (e, stackTrace) {
      _log.shout(
        "[_shareNextcloudFileAsLink] Failed while CreateLinkShare",
        e,
        stackTrace,
      );
    }
  }

  Future<String> _createDir({
    required Account account,
    required String name,
  }) async {
    // add a intermediate dir to allow shared dirs having the same name. Since
    // the dir names are public, we can't add random pre/suffix
    final timestamp = clock.now().millisecondsSinceEpoch;
    final random = Random().nextInt(0xFFFFFF);
    final dirName =
        "${timestamp.toRadixString(16)}-${random.toRadixString(16).padLeft(6, "0")}";
    final path =
        "${remote_storage_util.getRemoteLinkSharesDir(account)}/$dirName/$name";
    await CreateDir(_c.fileRepo)(account, path);
    return path;
  }

  Future<void> _copyFilesToDir(
    List<(AnyFile, FileDescriptor)> files, {
    required Account account,
    required String dirPath,
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(AnyFile file, Object error, StackTrace? stackTrace)? onError,
  }) async {
    // TODO isCanceled handling
    var i = 0;
    for (final f in files) {
      onProgress?.call(
        ShareAnyFileProgress(
          max: files.length,
          current: i++,
          filename: f.$1.name,
        ),
      );
      try {
        await Copy(_c.fileRepo)(account, f.$2, "$dirPath/${f.$1.name}");
      } catch (e, stackTrace) {
        _log.severe(
          "[_copyFilesToDir] Failed while copying file: $f",
          e,
          stackTrace,
        );
        onError?.call(f.$1, e, stackTrace);
      }
    }
  }

  final DiContainer _c;

  var isCanceled = false;
}
