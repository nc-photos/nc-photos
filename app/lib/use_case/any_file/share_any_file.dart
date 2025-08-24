import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/mobile/share.dart';
import 'package:nc_photos/use_case/download_file.dart';
import 'package:nc_photos/use_case/download_preview.dart';
import 'package:nc_photos/widget/share_method_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'share_any_file.g.dart';

class ShareAnyFileProgress {
  const ShareAnyFileProgress({
    required this.max,
    required this.current,
    required this.progress,
    required this.filename,
  });

  final int max;
  final int current;
  final double progress;
  final String filename;
}

@npLog
class ShareAnyFile {
  /// Share [files] with other apps
  ///
  /// Only [ShareMethod.preview] and [ShareMethod.file] are supported
  Future<void> call(
    List<AnyFile> files, {
    required Account account,
    required ShareMethod remoteMethod,
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(Object error, StackTrace? stackTrace)? onError,
    Stream<void>? cancelSignal,
  }) async {
    cancelSignal?.listen((_) {
      isCanceled = true;
    });
    final groups = groupBy(
      files,
      (e) => switch (e.provider) {
        AnyFileNextcloudProvider _ => AnyFileProviderType.nextcloud,
        AnyFileLocalProvider _ => AnyFileProviderType.local,
      },
    );
    final uris = <(AnyFile, String)>[];
    if (groups[AnyFileProviderType.nextcloud]?.isNotEmpty == true) {
      // we need to first download the remote files
      uris.addAll(
        await _prepNextcloudFileUris(
          groups[AnyFileProviderType.nextcloud]!,
          account: account,
          remoteMethod: remoteMethod,
          onProgress: onProgress,
          onError: onError,
        ),
      );
    }
    if (groups[AnyFileProviderType.local]?.isNotEmpty == true) {
      uris.addAll(_prepLocalFileUris(groups[AnyFileProviderType.local]!));
    }
    if (isCanceled) {
      throw const InterruptedException();
    }
    if (uris.isEmpty) {
      // oops, all files have failed
      return;
    }
    if (getRawPlatform() == NpPlatform.android) {
      final share = AndroidFileShare(
        uris.map((e) => AndroidFileShareFile(e.$2, e.$1.mime)).toList(),
      );
      return share.share();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Future<List<(AnyFile, String)>> _prepNextcloudFileUris(
    List<AnyFile> files, {
    required Account account,
    required ShareMethod remoteMethod,
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(Object error, StackTrace? stackTrace)? onError,
  }) async {
    final results = <(AnyFile, String)>[];
    for (final (i, af) in files.indexed) {
      if (isCanceled) {
        throw const InterruptedException();
      }
      final f = (af.provider as AnyFileNextcloudProvider).file;
      onProgress?.call(
        ShareAnyFileProgress(
          max: files.length,
          current: i,
          progress: 0,
          filename: af.name,
        ),
      );
      try {
        switch (remoteMethod) {
          case ShareMethod.file:
            results.add((
              af,
              await DownloadFile()(account, f, shouldNotify: false),
            ));
            break;

          case ShareMethod.preview:
            final dynamic uri;
            if (file_util.isSupportedImageFormat(f) &&
                f.fdMime != "image/gif") {
              uri = await DownloadPreview()(account, f);
            } else {
              uri = await DownloadFile()(account, f, shouldNotify: false);
            }
            results.add((af, uri));
            break;

          case ShareMethod.publicLink:
          case ShareMethod.passwordLink:
            throw UnsupportedError(
              "Only ShareMethod.file and ShareMethod.preview are supported",
            );
        }
      } catch (e, stackTrace) {
        _log.severe(
          "[_prepNextcloudFileUris] Failed while downloading file: $f",
          e,
          stackTrace,
        );
        onError?.call(e, stackTrace);
      }
    }
    return results;
  }

  List<(AnyFile, String)> _prepLocalFileUris(List<AnyFile> files) {
    final results = <(AnyFile, String)>[];
    for (final af in files) {
      final f = (af.provider as AnyFileLocalProvider).file;
      try {
        if (f is! LocalUriFile) {
          throw UnsupportedError("Unsupported local file");
        }
        results.add((af, f.uri));
      } catch (e, stackTrace) {
        _log.shout(
          "[_prepLocalFileUris] Failed while getting file uri: $f",
          e,
          stackTrace,
        );
      }
    }
    return results;
  }

  var isCanceled = false;
}
