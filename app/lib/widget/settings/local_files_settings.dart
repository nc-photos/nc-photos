import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/widget/local_root_picker/local_root_picker.dart';

class LocalFilesSettings extends StatefulWidget {
  const LocalFilesSettings({super.key});

  @override
  State<StatefulWidget> createState() => _LocalFilesSettingsState();
}

class _LocalFilesSettingsState extends State<LocalFilesSettings> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _key.currentState?.save();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(L10n.global().settingsDeviceMediaTitle)),
        body: LocalRootPicker(
          key: _key,
          switchTitle: L10n.global().enableButtonLabel2,
        ),
      ),
    );
  }

  final _key = GlobalKey<LocalRootPickerState>();
}
