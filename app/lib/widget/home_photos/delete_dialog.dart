part of '../home_photos2.dart';

extension on AnyFileRemoveHint {
  String toDisplayString() {
    return switch (this) {
      AnyFileRemoveHint.remote =>
        L10n.global().deleteMergedFileDialogServerOnlyButton,
      AnyFileRemoveHint.local =>
        L10n.global().deleteMergedFileDialogLocalOnlyButton,
      AnyFileRemoveHint.both => L10n.global().deleteMergedFileDialogBothButton,
    };
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(L10n.global().deleteMergedFileDialogContent),
        ),
        ...AnyFileRemoveHint.values.map(
          (e) => SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(e);
            },
            child: Text(e.toDisplayString()),
          ),
        ),
      ],
    );
  }
}
