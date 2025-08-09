import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/dir_picker.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'album_dir_picker.g.dart';

class AlbumDirPickerArguments {
  AlbumDirPickerArguments(this.account);

  final Account account;
}

class AlbumDirPicker extends StatefulWidget {
  static const routeName = "/album-dir-picker";

  static Route buildRoute(
    AlbumDirPickerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute<List<File>>(
    builder: (context) => AlbumDirPicker.fromArgs(args),
    settings: settings,
  );

  const AlbumDirPicker({super.key, required this.account});

  AlbumDirPicker.fromArgs(AlbumDirPickerArguments args, {Key? key})
    : this(key: key, account: args.account);

  @override
  createState() => _AlbumDirPickerState();

  final Account account;
}

@npLog
class _AlbumDirPickerState extends State<AlbumDirPicker> {
  @override
  build(BuildContext context) {
    return Scaffold(body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  L10n.global().albumDirPickerHeaderText,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(L10n.global().albumDirPickerSubHeaderText),
                ),
              ],
            ),
          ),
          Expanded(
            child: DirPicker(
              key: _pickerKey,
              account: widget.account,
              strippedRootDir: _strippedRootDir,
              validator: (dir) {
                if (widget.account.roots.contains("")) {
                  return true;
                }
                final root = api_util.getWebdavRootUrlRelative(widget.account);
                return widget.account.roots.any(
                  (r) =>
                      dir.path == "$root/$r" ||
                      dir.path.startsWith("$root/$r/"),
                );
              },
              onConfirmed: (picks) => _onPickerConfirmed(context, picks),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onConfirmPressed,
                  child: Text(L10n.global().confirmButtonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirmPressed() {
    _pickerKey.currentState?.confirm();
  }

  void _onPickerConfirmed(BuildContext context, List<File> picks) {
    if (picks.isEmpty) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().albumDirPickerListEmptyNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
    } else {
      _log.info(
        "[_onPickerConfirmed] Picked: ${picks.map((e) => e.strippedPath).toReadableString()}",
      );
      Navigator.of(context).pop(picks);
    }
  }

  String _getPickerRoot() {
    if (widget.account.roots.length == 1 &&
        widget.account.roots.first.isNotEmpty) {
      return widget.account.roots.first;
    } else {
      return "";
    }
  }

  final _pickerKey = GlobalKey<DirPickerState>();
  late final _strippedRootDir = _getPickerRoot();
}
