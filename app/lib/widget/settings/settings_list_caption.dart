import 'package:flutter/material.dart';
import 'package:np_ui/np_ui.dart';

class SettingsListCaption extends StatelessWidget {
  const SettingsListCaption({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: Theme.of(context).textStyleColored(
          (textTheme) => textTheme.titleMedium,
          (colorScheme) => colorScheme.primary,
        ),
      ),
    );
  }

  final String label;
}
