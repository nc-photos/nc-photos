import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';

enum SetAsMethod { file, preview }

class SetAsMethodDialog extends StatelessWidget {
  const SetAsMethodDialog({super.key, this.isSupportPerview = true});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(L10n.global().setAsTooltip),
      children: [
        if (isSupportPerview)
          SimpleDialogOption(
            child: ListTile(
              title: Text(L10n.global().shareMethodPreviewTitle),
              subtitle: Text(L10n.global().shareMethodPreviewDescription),
            ),
            onPressed: () {
              Navigator.of(context).pop(SetAsMethod.preview);
            },
          ),
        SimpleDialogOption(
          child: ListTile(
            title: Text(L10n.global().shareMethodOriginalFileTitle),
            subtitle: Text(L10n.global().shareMethodOriginalFileDescription),
          ),
          onPressed: () {
            Navigator.of(context).pop(SetAsMethod.file);
          },
        ),
      ],
    );
  }

  final bool isSupportPerview;
}
