import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';

class UploadConvertWarningDialog extends StatelessWidget {
  const UploadConvertWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(L10n.global().uploadBatchConvertWarningText1),
          const Text(" "),
          Text("\u2022 ${L10n.global().uploadBatchConvertWarningText2}"),
          Text("\u2022 ${L10n.global().uploadBatchConvertWarningText3}"),
          const Text(" "),
          Text(L10n.global().uploadBatchConvertWarningText4),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<PrefController>().setShowUploadConvertWarning(false);
            Navigator.of(context).pop();
          },
          child: Text(L10n.global().dontShowAgain),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
