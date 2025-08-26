import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/platform/download.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/use_case/download_file.dart';
import 'package:nc_photos/use_case/download_preview.dart';
import 'package:nc_photos/widget/download_progress_dialog.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'internal_download_handler.g.dart';

/// Download file to internal dir
@npLog
class InternalDownloadHandler {
  const InternalDownloadHandler(this.account);

  Future<Map<File, dynamic>> downloadPreviews(
    BuildContext context,
    List<File> files,
  ) async {
    if (files.isEmpty) {
      return {};
    }
    final controller = BehaviorSubject.seeded(
      const _DownloadProgress(current: 0),
    );
    bool shouldRun = true;
    Download? download;
    unawaited(
      showDialog(
        context: context,
        builder:
            (context) => ValueStreamBuilder<_DownloadProgress>(
              stream: controller.stream,
              builder:
                  (_, snapshot) => DownloadProgressDialog(
                    max: files.length,
                    current: snapshot.requireData.current,
                    progress: snapshot.requireData.progress,
                    label: files[snapshot.requireData.current].filename,
                    onCancel: () {
                      download?.cancel();
                      shouldRun = false;
                    },
                  ),
            ),
      ),
    );
    try {
      final results = <MapEntry<File, dynamic>>[];
      for (final (:i, e: f) in files.withIndex()) {
        controller.add(_DownloadProgress(current: i));
        try {
          final dynamic result;
          if (file_util.isSupportedImageFormat(f) &&
              f.contentType != "image/gif") {
            result = await DownloadPreview()(account, f);
          } else {
            download = DownloadFile().build(
              account,
              f,
              shouldNotify: false,
              onProgress: (progress) {
                controller.add(
                  _DownloadProgress(current: i, progress: progress),
                );
              },
            );
            result = await download();
          }
          if (!shouldRun) {
            throw const JobCanceledException();
          }
          results.add(MapEntry(f, result));
        } catch (e, stacktrace) {
          _log.shout(
            "[downloadPreviews] Failed while DownloadPreview",
            e,
            stacktrace,
          );
          SnackBarManager().showSnackBarForException(e);
        }
      }
      return results.toMap();
    } finally {
      // dismiss the dialog
      Navigator.of(context).pop();
    }
  }

  Future<Map<File, dynamic>> downloadFiles(
    BuildContext context,
    List<File> files,
  ) async {
    if (files.isEmpty) {
      return {};
    }
    final controller = BehaviorSubject.seeded(
      const _DownloadProgress(current: 0),
    );
    bool shouldRun = true;
    Download? download;
    unawaited(
      showDialog(
        context: context,
        builder:
            (context) => ValueStreamBuilder<_DownloadProgress>(
              stream: controller.stream,
              builder:
                  (_, snapshot) => DownloadProgressDialog(
                    max: files.length,
                    current: snapshot.requireData.current,
                    progress: snapshot.requireData.progress,
                    label: files[snapshot.requireData.current].filename,
                    onCancel: () {
                      download?.cancel();
                      shouldRun = false;
                    },
                  ),
            ),
      ),
    );
    try {
      final results = <MapEntry<File, dynamic>>[];
      for (final (:i, e: f) in files.withIndex()) {
        controller.add(_DownloadProgress(current: i));
        try {
          download = DownloadFile().build(
            account,
            f,
            shouldNotify: false,
            onProgress: (progress) {
              controller.add(_DownloadProgress(current: i, progress: progress));
            },
          );
          final result = await download();
          if (!shouldRun) {
            throw const JobCanceledException();
          }
          results.add(MapEntry(f, result));
        } on PermissionException catch (_) {
          _log.warning("[downloadFiles] Permission not granted");
          SnackBarManager().showSnackBar(
            SnackBar(
              content: Text(L10n.global().errorNoStoragePermission),
              duration: k.snackBarDurationNormal,
            ),
          );
          rethrow;
        } on JobCanceledException catch (_) {
          _log.info("[downloadFiles] Job canceled");
          return {};
        } catch (e, stacktrace) {
          _log.shout(
            "[downloadFiles] Failed while downloadFile",
            e,
            stacktrace,
          );
          SnackBarManager().showSnackBarForException(e);
        }
      }
      return results.toMap();
    } finally {
      // dismiss the dialog
      Navigator.of(context).pop();
    }
  }

  final Account account;
}

class _DownloadProgress {
  const _DownloadProgress({required this.current, this.progress});

  final int current;
  final double? progress;
}
