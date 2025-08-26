import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/widget/collection_viewer/collection_viewer.dart';
import 'package:nc_photos/widget/viewer/viewer.dart';
import 'package:np_log/np_log.dart';

part 'result_viewer.g.dart';

class ResultViewerArguments {
  const ResultViewerArguments(this.resultUrl);

  final String resultUrl;
}

/// This is an intermediate widget in charge of preparing the file to be
/// eventually shown in [Viewer]
class ResultViewer extends StatefulWidget {
  static const routeName = "/result-viewer";

  const ResultViewer({super.key, required this.resultUrl});

  ResultViewer.fromArgs(ResultViewerArguments args, {Key? key})
    : this(key: key, resultUrl: args.resultUrl);

  static Route buildRoute(ResultViewerArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (_) => ResultViewer.fromArgs(args),
        settings: settings,
      );

  @override
  createState() => _ResultViewerState();

  final String resultUrl;
}

@npLog
class _ResultViewerState extends State<ResultViewer> {
  @override
  initState() {
    super.initState();
    _c = KiwiContainer().resolve<DiContainer>();
    _doWork();
  }

  @override
  build(BuildContext context) {
    if (_file == null) {
      return Theme(
        data: buildDarkTheme(context),
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
          body: Container(
            color: Colors.black,
            alignment: Alignment.topCenter,
            child: const LinearProgressIndicator(),
          ),
        ),
      );
    } else {
      return CollectionViewer(
        files: [_file!],
        initialIndex: 0,
        collectionId: null,
      );
    }
  }

  Future<void> _doWork() async {
    _log.info("[_doWork] URL: ${widget.resultUrl}");
    _account = context.read<PrefController>().currentAccountValue;
    if (_account == null) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().errorUnauthenticated),
          duration: k.snackBarDurationNormal,
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    if (!widget.resultUrl.startsWith(
      RegExp(_account!.url, caseSensitive: false),
    )) {
      _log.severe("[_doWork] File url and current account does not match");
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().errorUnauthenticated),
          duration: k.snackBarDurationNormal,
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    // +1 for the slash
    final filePath = widget.resultUrl.substring(_account!.url.length + 1);
    // query remote
    final File file;
    try {
      file = await LsSingleFile(_c)(_account!, filePath);
    } catch (e, stackTrace) {
      _log.severe("[_doWork] Failed while LsSingleFile", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _file = file;
    });
  }

  late final DiContainer _c;
  Account? _account;
  File? _file;
}
