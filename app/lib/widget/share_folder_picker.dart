import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/dir_picker2/dir_picker.dart';
import 'package:np_log/np_log.dart';

part 'share_folder_picker.g.dart';

class ShareFolderPickerArguments {
  const ShareFolderPickerArguments(this.account, this.initialValue);

  final Account account;
  final String initialValue;
}

class ShareFolderPicker extends StatefulWidget {
  static const routeName = "/share-folder-picker";

  static Route buildRoute(
    ShareFolderPickerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute<String>(
    builder: (context) => ShareFolderPicker.fromArgs(args),
    settings: settings,
  );

  const ShareFolderPicker({
    super.key,
    required this.account,
    required this.initialValue,
  });

  ShareFolderPicker.fromArgs(ShareFolderPickerArguments args, {Key? key})
    : this(key: key, account: args.account, initialValue: args.initialValue);

  @override
  State<StatefulWidget> createState() => _ShareFolderPickerState();

  final Account account;
  final String initialValue;
}

@npLog
class _ShareFolderPickerState extends State<ShareFolderPicker> {
  @override
  void initState() {
    super.initState();
    _path = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      L10n.global().settingsShareFolderDialogTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(L10n.global().settingsShareFolderPickerDescription),
                  const SizedBox(height: 8),
                  Text("/$_path"),
                ],
              ),
            ),
            Expanded(
              child: DirPicker(
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
                onChanged: (picks) => _onPickerChanged(context, picks),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _onDefaultPressed(context);
                    },
                    child: Text(L10n.global().defaultButtonLabel),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _onConfirmPressed(context);
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

  void _onDefaultPressed(BuildContext context) {
    Navigator.of(context).pop("");
  }

  void _onPickerChanged(BuildContext context, List<File> picks) {
    setState(() {
      if (picks.isEmpty) {
        _path = "";
      } else {
        _path = picks.first.strippedPath;
      }
    });
  }

  void _onConfirmPressed(BuildContext context) {
    if (_path.isEmpty) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().albumDirPickerListEmptyNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
    } else {
      _log.info("[_onConfirmPressed] Picked: $_path");
      Navigator.of(context).pop(_path);
    }
  }

  late String _path;
}
