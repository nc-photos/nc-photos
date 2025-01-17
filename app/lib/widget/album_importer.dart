import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/list_importable_album.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/album/create_album.dart';
import 'package:nc_photos/use_case/preprocess_album.dart';
import 'package:nc_photos/use_case/update_album_with_actual_items.dart';
import 'package:nc_photos/widget/processing_dialog.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'album_importer.g.dart';

class AlbumImporterArguments {
  AlbumImporterArguments(this.account);

  final Account account;
}

class AlbumImporter extends StatefulWidget {
  static const routeName = "/album-importer";

  static Route buildRoute(
          AlbumImporterArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => AlbumImporter.fromArgs(args),
        settings: settings,
      );

  const AlbumImporter({
    super.key,
    required this.account,
  });

  AlbumImporter.fromArgs(AlbumImporterArguments args, {Key? key})
      : this(
          key: key,
          account: args.account,
        );

  @override
  createState() => _AlbumImporterState();

  final Account account;
}

@npLog
class _AlbumImporterState extends State<AlbumImporter> {
  _AlbumImporterState() {
    final c = KiwiContainer().resolve<DiContainer>();
    assert(require(c));
    assert(PreProcessAlbum.require(c));
    _c = c;
  }

  static bool require(DiContainer c) => DiContainer.has(c, DiType.albumRepo);

  @override
  initState() {
    super.initState();
    _initBloc();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ListImportableAlbumBloc, ListImportableAlbumBlocState>(
        bloc: _bloc,
        listener: (context, state) => _onStateChange(context, state),
        child:
            BlocBuilder<ListImportableAlbumBloc, ListImportableAlbumBlocState>(
          bloc: _bloc,
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  void _initBloc() {
    _log.info("[_initBloc] Initialize bloc");
    _bloc = ListImportableAlbumBloc(KiwiContainer().resolve<DiContainer>());
    _bloc.add(ListImportableAlbumBlocQuery(
        widget.account,
        widget.account.roots
            .map((e) => File(path: file_util.unstripPath(widget.account, e)))
            .toList()));
  }

  Widget _buildContent(
      BuildContext context, ListImportableAlbumBlocState state) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  L10n.global().albumImporterHeaderText,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    L10n.global().albumImporterSubHeaderText,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: _buildList(context, state),
                ),
                if (state is ListImportableAlbumBlocLoading)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
                  ),
              ],
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
                  child:
                      Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                ElevatedButton(
                  onPressed: () => _onImportPressed(context),
                  child: Text(L10n.global().importButtonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, ListImportableAlbumBlocState state) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          _buildItem(context, _backingFiles[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _backingFiles.length,
    );
  }

  Widget _buildItem(BuildContext context, File file) {
    final isPicked = _picks.containsIdentical(file);
    onTap() {
      setState(() {
        if (isPicked) {
          _picks.removeWhere((p) => identical(p, file));
        } else {
          _picks.add(file);
        }
      });
    }

    return ListTile(
      dense: true,
      leading: IconButton(
        icon: AnimatedSwitcher(
          duration: k.animationDurationShort,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isPicked ? Icons.check_box : Icons.check_box_outline_blank,
            key: ValueKey(isPicked),
          ),
        ),
        onPressed: onTap,
      ),
      title: Text(file.filename),
      subtitle: Text(file.strippedPath),
      onTap: onTap,
    );
  }

  void _onStateChange(
      BuildContext context, ListImportableAlbumBlocState state) {
    if (state is ListImportableAlbumBlocSuccess ||
        state is ListImportableAlbumBlocLoading) {
      _transformItems(state.items);
    } else if (state is ListImportableAlbumBlocFailure) {
      SnackBarManager().showSnackBarForException(state.exception);
    }
  }

  Future<void> _onImportPressed(BuildContext context) async {
    unawaited(
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            ProcessingDialog(text: L10n.global().albumImporterProgressText),
      ),
    );
    try {
      await _createAllAlbums(context);
    } finally {
      // make sure we dismiss the dialog in any cases
      Navigator.of(context).pop();
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _createAllAlbums(BuildContext context) async {
    for (final p in _picks) {
      try {
        var album = Album(
          name: p.filename,
          provider: AlbumDirProvider(
            dirs: [p],
          ),
          coverProvider: const AlbumAutoCoverProvider(),
          sortProvider: const AlbumTimeSortProvider(isAscending: false),
        );
        _log.info("[_createAllAlbums] Creating dir album: $album");

        final items = await PreProcessAlbum(_c)(widget.account, album);
        album = await UpdateAlbumWithActualItems(null)(
            widget.account, album, items);

        await CreateAlbum(_c.albumRepo)(widget.account, album);
      } catch (e, stacktrace) {
        _log.shout(
            "[_createAllAlbums] Failed creating dir album", e, stacktrace);
        SnackBarManager().showSnackBarForException(e);
      }
    }
  }

  void _transformItems(List<ListImportableAlbumBlocItem> items) {
    _backingFiles = items
        .sorted((a, b) => b.photoCount - a.photoCount)
        .map((e) => e.file)
        .toList();
  }

  late final DiContainer _c;
  late ListImportableAlbumBloc _bloc;

  var _backingFiles = <File>[];
  final _picks = <File>[];
}
