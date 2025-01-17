import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/internal_download_handler.dart';
import 'package:nc_photos/mobile/share.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:nc_photos/widget/set_as_method_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'set_as_handler.g.dart';

/// A special way to share image to other apps
@npLog
class SetAsHandler {
  SetAsHandler(
    this._c, {
    required this.context,
    this.clearSelection,
  });

  Future<void> setAsFile(Account account, FileDescriptor fd) async {
    try {
      final file = (await InflateFileDescriptor(_c)(account, [fd])).first;
      final method = await _askSetAsMethod(file);
      switch (method) {
        case SetAsMethod.preview:
          return await _setAsAsPreview(account, file);
        case SetAsMethod.file:
          return await _setAsAsFile(account, file);
        case null:
          return;
      }
    } catch (e, stackTrace) {
      _log.shout("[setAsFile] Failed while sharing files", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
    } finally {
      if (!isSelectionCleared) {
        clearSelection?.call();
      }
    }
  }

  Future<SetAsMethod?> _askSetAsMethod(File file) {
    return showDialog<SetAsMethod>(
      context: context,
      builder: (context) => const SetAsMethodDialog(),
    );
  }

  Future<void> _setAsAsPreview(Account account, File file) async {
    assert(getRawPlatform() == NpPlatform.android);
    final results = await InternalDownloadHandler(account)
        .downloadPreviews(context, [file]);
    final share = AndroidFileShare(results.entries
        .map((e) => AndroidFileShareFile(e.value as String, e.key.contentType))
        .toList());
    return share.setAs();
  }

  Future<void> _setAsAsFile(Account account, File file) async {
    assert(getRawPlatform() == NpPlatform.android);
    final results =
        await InternalDownloadHandler(account).downloadFiles(context, [file]);
    if (results.isEmpty) {
      return;
    }
    final share = AndroidFileShare(results.entries
        .map((e) => AndroidFileShareFile(e.value as String, e.key.contentType))
        .toList());
    return share.setAs();
  }

  final DiContainer _c;
  final BuildContext context;
  final VoidCallback? clearSelection;
  var isSelectionCleared = false;
}
