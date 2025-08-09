import 'package:flutter/material.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';

class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({super.key, required this.text});

  @override
  build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIntermediateCircularProgressIndicator(),
            const SizedBox(width: 24),
            Text(text),
          ],
        ),
      ),
    );
  }

  final String text;
}

class ProcessingOverlay extends StatelessWidget {
  const ProcessingOverlay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.black38),
        Center(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIntermediateCircularProgressIndicator(),
                const SizedBox(width: 24),
                Text(text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final String text;
}
