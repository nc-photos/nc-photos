import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/navigation_manager.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/trashbin_browser.dart';
import 'package:np_log/np_log.dart';

part 'remove_selection_handler.g.dart';

@npLog
class RemoveSelectionHandler {
  const RemoveSelectionHandler({
    required this.filesController,
  });

  /// Remove [selectedFiles] and return the removed count
  Future<int> call({
    required Account account,
    required List<FileDescriptor> selection,
    bool shouldCleanupAlbum = true,
    bool isRemoveOpened = false,
    bool isMoveToTrash = false,
  }) async {
    final String successText;
    final String Function(int) failureText;
    if (isRemoveOpened) {
      successText = L10n.global().deleteSuccessNotification;
      failureText = (_) => L10n.global().deleteFailureNotification;
    } else {
      successText = L10n.global().deleteSelectedSuccessNotification;
      failureText =
          (count) => L10n.global().deleteSelectedFailureNotification(count);
    }

    var failureCount = 0;
    await filesController.remove(
      selection,
      errorBuilder: (fileIds) {
        failureCount = fileIds.length;
        return RemoveFailureError(fileIds);
      },
    );
    final trashAction = isMoveToTrash
        ? SnackBarAction(
            label: L10n.global().albumTrashLabel,
            onPressed: () {
              NavigationManager().getNavigator()?.pushNamed(
                  TrashbinBrowser.routeName,
                  arguments: TrashbinBrowserArguments(account));
            },
          )
        : null;
    if (failureCount == 0) {
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(successText),
        duration: k.snackBarDurationNormal,
        action: trashAction,
      ));
    } else {
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(failureText(failureCount)),
        duration: k.snackBarDurationNormal,
        action: trashAction,
      ));
    }
    return selection.length - failureCount;
  }

  final FilesController filesController;
}
