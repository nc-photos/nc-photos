import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/navigation_manager.dart';
import 'package:nc_photos/widget/trashbin_browser.dart';

SnackBar buildDeleteResultSnackBar(
  Account account, {
  required int failureCount,
  required bool isMoveToTrash,
  required bool isRemoveSingle,
}) {
  final String successText;
  final String Function(int) failureText;
  if (isRemoveSingle) {
    successText = L10n.global().deleteSuccessNotification;
    failureText = (_) => L10n.global().deleteFailureNotification;
  } else {
    successText = L10n.global().deleteSelectedSuccessNotification;
    failureText =
        (count) => L10n.global().deleteSelectedFailureNotification(count);
  }
  final trashAction =
      isMoveToTrash
          ? SnackBarAction(
            label: L10n.global().albumTrashLabel,
            onPressed: () {
              NavigationManager().getNavigator()?.pushNamed(
                TrashbinBrowser.routeName,
                arguments: TrashbinBrowserArguments(account),
              );
            },
          )
          : null;
  if (failureCount == 0) {
    return SnackBar(
      content: Text(successText),
      duration: k.snackBarDurationNormal,
      action: trashAction,
    );
  } else {
    return SnackBar(
      content: Text(failureText(failureCount)),
      duration: k.snackBarDurationNormal,
      action: trashAction,
    );
  }
}
