import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';

/// A dialog to show the current download progress
class DownloadProgressDialog extends StatelessWidget {
  const DownloadProgressDialog({
    super.key,
    required this.max,
    required this.current,
    required this.progress,
    this.label,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().shareDownloadingDialogContent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (current + (progress ?? 0).clamp(0, 1)) / max,
          ),
          if (max > 1)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                "${current + 1}/$max",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          if (label != null) ...[const SizedBox(height: 4), Text(label!)],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  }

  /// Total number of items
  final int max;

  /// Current item index
  final int current;

  /// Download progress for the current item, normalized between 0 to 1
  final double? progress;

  /// Label of the current download
  final String? label;

  /// Called when the cancel button is pressed
  final VoidCallback? onCancel;
}
