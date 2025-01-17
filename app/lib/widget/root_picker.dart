import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/widget/dir_picker.dart';
import 'package:nc_photos/widget/processing_dialog.dart';
import 'package:np_log/np_log.dart';

part 'root_picker.g.dart';

class RootPickerArguments {
  RootPickerArguments(this.account);

  final Account account;
}

class RootPicker extends StatefulWidget {
  static const routeName = "/root-picker";

  static Route buildRoute(RootPickerArguments args, RouteSettings settings) =>
      MaterialPageRoute<Account>(
        builder: (context) => RootPicker.fromArgs(args),
        settings: settings,
      );

  const RootPicker({
    super.key,
    required this.account,
  });

  RootPicker.fromArgs(RootPickerArguments args, {Key? key})
      : this(
          key: key,
          account: args.account,
        );

  @override
  createState() => _RootPickerState();

  final Account account;
}

@npLog
class _RootPickerState extends State<RootPicker> {
  @override
  initState() {
    super.initState();
    _initAccount();
  }

  Future<void> _initAccount() async {
    final c = KiwiContainer().resolve<DiContainer>();
    final files = <File>[];
    for (final r in widget.account.roots) {
      try {
        if (r.isNotEmpty) {
          _ensureInitDialog();
          files.add(await LsSingleFile(c.withRemoteFileRepo())(
              widget.account, file_util.unstripPath(widget.account, r)));
        }
      } catch (e, stackTrace) {
        _log.severe("[_initAccount] Failed", e, stackTrace);
      }
    }
    _dismissInitDialog();
    setState(() {
      _initialPicks = files;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
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
                  L10n.global().rootPickerHeaderText,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    L10n.global().rootPickerSubHeaderText,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _initialPicks == null
                ? Container()
                : DirPicker(
                    key: _pickerKey,
                    account: widget.account,
                    strippedRootDir: "",
                    initialPicks: _initialPicks,
                    onConfirmed: (picks) => _onPickerConfirmed(context, picks),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _onSkipPressed(context),
                  child: Text(L10n.global().skipButtonLabel),
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

  void _onSkipPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content:
                  Text(L10n.global().rootPickerSkipConfirmationDialogContent2),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            )).then((value) {
      if (value == true) {
        Navigator.of(context).pop(widget.account.copyWith(roots: [""]));
      }
    });
  }

  void _onConfirmPressed() {
    _pickerKey.currentState?.confirm();
  }

  void _onPickerConfirmed(BuildContext context, List<File> picks) {
    final roots = picks.map((e) => e.strippedPath).toList();
    if (roots.isEmpty) {
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().rootPickerListEmptyNotification),
        duration: k.snackBarDurationNormal,
      ));
      return;
    }
    final newAccount = widget.account.copyWith(roots: roots);
    _log.info("[_onPickerConfirmed] Account is good: $newAccount");
    Navigator.of(context).pop(newAccount);
  }

  void _ensureInitDialog() {
    if (_isInitDialogShown) {
      return;
    }
    _isInitDialogShown = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ProcessingDialog(
              text: L10n.global().genericProcessingDialogContent),
        );
      }
    });
  }

  void _dismissInitDialog() {
    if (!_isInitDialogShown) {
      return;
    }
    Navigator.of(context).pop();
  }

  final _pickerKey = GlobalKey<DirPickerState>();
  List<File>? _initialPicks;

  bool _isInitDialogShown = false;
}
