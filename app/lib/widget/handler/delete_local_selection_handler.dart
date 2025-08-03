import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/delete_local.dart';
import 'package:np_log/np_log.dart';

part 'delete_local_selection_handler.g.dart';

@npLog
class DeleteLocalSelectionHandler {
  const DeleteLocalSelectionHandler();

  /// Delete [selectedFiles] permanently from device
  Future<int> call({
    required List<LocalFile> selectedFiles,
    bool isRemoveOpened = false,
  }) async {
    final c = KiwiContainer().resolve<DiContainer>();
    var failureCount = 0;
    await DeleteLocal(c)(
      selectedFiles,
      onFailure: (file, e, stackTrace) {
        if (e != null) {
          _log.shout(
              "[call] Failed while deleting file: ${logFilename(file.logTag)}",
              e,
              stackTrace);
        }
        ++failureCount;
      },
    );
    if (failureCount == 0) {
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().deleteSelectedSuccessNotification),
        duration: k.snackBarDurationNormal,
      ));
    } else {
      SnackBarManager().showSnackBar(SnackBar(
        content:
            Text(L10n.global().deleteSelectedFailureNotification(failureCount)),
        duration: k.snackBarDurationNormal,
      ));
    }
    return selectedFiles.length - failureCount;
  }
}
