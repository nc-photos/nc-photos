part of 'viewer_detail_pane.dart';

class _EditMetadataProgressDialog extends StatelessWidget {
  const _EditMetadataProgressDialog();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<_EditMetadataProgress?>(
      selector: (state) => state.editMetadataProgress,
      builder: (context, editMetadataProgress) {
        final title = switch (editMetadataProgress?.step) {
          UpdateAnyFileMetadataStep.read =>
            L10n.global().downloadProcessingNotification,
          UpdateAnyFileMetadataStep.write =>
            L10n.global().editMetadataWriteProgressTitle,
          null => L10n.global().genericProcessingDialogContent,
        };
        return AlertDialog(
          title: Text(title),
          content: LinearProgressIndicator(
            value: editMetadataProgress?.progress,
          ),
        );
      },
    );
  }
}
