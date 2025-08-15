import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/widget/dir_picker.dart';
import 'package:np_log/np_log.dart';

part 'upload_folder_picker.g.dart';

class UploadFolderPickerArguments {
  const UploadFolderPickerArguments(this.account, this.initialValue);

  final Account account;
  final String initialValue;
}

class UploadFolderPicker extends StatefulWidget {
  static const routeName = "/upload-folder-picker";

  static Route buildRoute(
    UploadFolderPickerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute<String>(
    builder: (context) => UploadFolderPicker.fromArgs(args),
    settings: settings,
  );

  const UploadFolderPicker({
    super.key,
    required this.account,
    required this.initialValue,
  });

  UploadFolderPicker.fromArgs(UploadFolderPickerArguments args, {Key? key})
    : this(key: key, account: args.account, initialValue: args.initialValue);

  @override
  State<StatefulWidget> createState() => _UploadFolderPickerState();

  final Account account;
  final String initialValue;
}

@npLog
class _UploadFolderPickerState extends State<UploadFolderPicker> {
  @override
  void initState() {
    super.initState();
    _path = "/${widget.initialValue}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Text(
                  L10n.global().uploadFolderPickerTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(_path),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: DirPicker(
                key: _pickerKey,
                account: widget.account,
                strippedRootDir: "",
                initialPicks: [
                  if (widget.initialValue.isNotEmpty)
                    File(
                      path: file_util.unstripPath(
                        widget.account,
                        widget.initialValue,
                      ),
                    ),
                ],
                isMultipleSelections: false,
                onConfirmed: (picks) => _onPickerConfirmed(context, picks),
                onChanged: (picks) => _onPickerChanged(context, picks),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickerKey.currentState?.confirm();
                    },
                    child: Text(L10n.global().confirmButtonLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPickerChanged(BuildContext context, List<File> picks) {
    setState(() {
      if (picks.isEmpty) {
        _path = "/";
      } else {
        _path = "/${picks.first.strippedPath}";
      }
    });
  }

  void _onPickerConfirmed(BuildContext context, List<File> picks) {
    if (picks.isEmpty) {
      _log.info("[_onPickerConfirmed] Picked: /}");
      Navigator.of(context).pop("");
    } else {
      _log.info("[_onPickerConfirmed] Picked: ${picks.first.strippedPath}");
      Navigator.of(context).pop(picks.first.strippedPath);
    }
  }

  final _pickerKey = GlobalKey<DirPickerState>();

  late String _path;
}
