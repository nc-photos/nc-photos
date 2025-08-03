import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:np_log/np_log.dart';

part 'image_editor_persist_option_dialog.g.dart';

@npLog
class ImageEditorPersistOptionDialog extends StatelessWidget {
  const ImageEditorPersistOptionDialog({
    super.key,
    required this.isFromEditor,
  });

  @override
  build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().imageSaveOptionDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(L10n.global().imageSaveOptionDialogContent),
          const SizedBox(height: 24),
          Text(L10n.global().setupSettingsModifyLaterHint),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (isFromEditor) {
              launch(help_util.editPhotosUrl);
            } else {
              launch(help_util.enhanceUrl);
            }
          },
          child: Text(L10n.global().learnMoreButtonLabel),
        ),
        TextButton(
          onPressed: () => _onDevicePressed(context),
          child: Text(L10n.global().imageSaveOptionDialogDeviceButtonLabel),
        ),
        TextButton(
          onPressed: () => _onServerPressed(context),
          child: Text(L10n.global().imageSaveOptionDialogServerButtonLabel),
        ),
      ],
    );
  }

  Future<void> _onDevicePressed(BuildContext context) =>
      _onOptionSelected(context, false);
  Future<void> _onServerPressed(BuildContext context) =>
      _onOptionSelected(context, true);

  Future<void> _onOptionSelected(
      BuildContext context, bool isSaveEditResultToServer) async {
    final c = KiwiContainer().resolve<DiContainer>();
    if (!await c.pref.setSaveEditResultToServer(isSaveEditResultToServer)) {
      _log.severe("[_onDevicePressed] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      return;
    }

    unawaited(c.pref.setHasShownSaveEditResultDialog(true));
    Navigator.of(context).pop();
  }

  /// Whether this dialog is displayed in editor or enhancer
  final bool isFromEditor;
}
