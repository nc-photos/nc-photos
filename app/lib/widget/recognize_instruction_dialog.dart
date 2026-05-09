import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/url_launcher_util.dart';

class RecognizeInstructionDialog extends StatelessWidget {
  const RecognizeInstructionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().recognizeInstructionDialogTitle),
      content: Text(L10n.global().recognizeInstructionDialogContent),
      actions: [
        TextButton(
          onPressed: () {
            if (Localizations.localeOf(context).languageCode == "ja") {
              launch(help_util.recognizeSetupJaUrl);
            } else {
              launch(help_util.recognizeSetupUrl);
            }
          },
          child: Text(L10n.global().recognizeInstructionDialogButton),
        ),
      ],
    );
  }
}
