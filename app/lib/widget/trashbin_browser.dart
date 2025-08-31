import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/ls_trashbin.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:nc_photos/use_case/restore_trashbin.dart';
import 'package:nc_photos/widget/builder/photo_list_item_builder.dart';
import 'package:nc_photos/widget/empty_list_indicator.dart';
import 'package:nc_photos/widget/handler/remove_selection_handler.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart' as photo_list_util;
import 'package:nc_photos/widget/selectable_item_stream_list_mixin.dart';
import 'package:nc_photos/widget/selection_app_bar.dart';
import 'package:nc_photos/widget/trashbin_viewer.dart';
import 'package:nc_photos/widget/zoom_menu_button.dart';
import 'package:np_async/np_async.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';

part 'trashbin_browser.g.dart';

class TrashbinBrowserArguments {
  TrashbinBrowserArguments(this.account);

  final Account account;
}

class TrashbinBrowser extends StatefulWidget {
  static const routeName = "/trashbin-browser";

  static Route buildRoute(
    TrashbinBrowserArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute(
    builder: (context) => TrashbinBrowser.fromArgs(args),
    settings: settings,
  );

  const TrashbinBrowser({super.key, required this.account});

  TrashbinBrowser.fromArgs(TrashbinBrowserArguments args, {Key? key})
    : this(key: key, account: args.account);

  @override
  createState() => _TrashbinBrowserState();

  final Account account;
}

@npLog
class _TrashbinBrowserState extends State<TrashbinBrowser>
    with SelectableItemStreamListMixin<TrashbinBrowser> {
  @override
  initState() {
    super.initState();
    _initBloc();
    _thumbZoomLevel = Pref().getAlbumBrowserZoomLevelOr(0);
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LsTrashbinBloc, LsTrashbinBlocState>(
        bloc: _bloc,
        listener: (context, state) => _onStateChange(context, state),
        child: BlocBuilder<LsTrashbinBloc, LsTrashbinBlocState>(
          bloc: _bloc,
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  @override
  onItemTap(SelectableItem item, int index) {
    item.as<PhotoListFileItem>()?.run((fileItem) {
      Navigator.pushNamed(
        context,
        TrashbinViewer.routeName,
        arguments: TrashbinViewerArguments(
          widget.account,
          _backingFiles,
          fileItem.fileIndex,
        ),
      );
    });
  }

  void _initBloc() {
    _bloc = LsTrashbinBloc.of(widget.account);
    if (_bloc.state is LsTrashbinBlocInit) {
      _log.info("[_initBloc] Initialize bloc");
      _reqQuery();
    } else {
      // process the current state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _onStateChange(context, _bloc.state);
          });
        }
        _reqQuery();
      });
    }
  }

  Widget _buildContent(BuildContext context, LsTrashbinBlocState state) {
    if (state is LsTrashbinBlocSuccess &&
        !_buildItemQueue.isProcessing &&
        itemStreamListItems.isEmpty) {
      return Column(
        children: [
          AppBar(title: Text(L10n.global().albumTrashLabel), elevation: 0),
          Expanded(
            child: EmptyListIndicator(
              icon: Icons.delete_outlined,
              text: L10n.global().listEmptyText,
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          buildItemStreamListOuter(
            context,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                buildItemStreamList(maxCrossAxisExtent: _thumbSize.toDouble()),
                const SliverSafeBottom(),
              ],
            ),
          ),
          if (state is LsTrashbinBlocLoading || _buildItemQueue.isProcessing)
            const Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            ),
        ],
      );
    }
  }

  Widget _buildAppBar(BuildContext context) {
    if (isSelectionMode) {
      return _buildSelectionAppBar(context);
    } else {
      return _buildNormalAppBar(context);
    }
  }

  Widget _buildSelectionAppBar(BuildContext context) {
    return SelectionAppBar(
      count: selectedListItems.length,
      onClosePressed: () {
        setState(() {
          clearSelectedItems();
        });
      },
      actions: [
        IconButton(
          icon: const Icon(Icons.restore_outlined),
          tooltip: L10n.global().restoreTooltip,
          onPressed: () {
            _onSelectionAppBarRestorePressed();
          },
        ),
        PopupMenuButton<_SelectionAppBarMenuOption>(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: _SelectionAppBarMenuOption.delete,
                  child: Text(L10n.global().deletePermanentlyTooltip),
                ),
              ],
          onSelected: (option) {
            switch (option) {
              case _SelectionAppBarMenuOption.delete:
                _onSelectionAppBarDeletePressed(context);
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildNormalAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(L10n.global().albumTrashLabel),
      floating: true,
      actions: [
        ZoomMenuButton(
          initialZoom: _thumbZoomLevel,
          minZoom: 0,
          maxZoom: 2,
          onZoomChanged: (value) {
            setState(() {
              _thumbZoomLevel = value.round();
            });
            Pref().setAlbumBrowserZoomLevel(_thumbZoomLevel);
          },
        ),
        PopupMenuButton<_AppBarMenuOption>(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: _AppBarMenuOption.empty,
                  child: Text(L10n.global().emptyTrashbinTooltip),
                ),
              ],
          onSelected: (option) {
            switch (option) {
              case _AppBarMenuOption.empty:
                _onEmptyTrashPressed(context);
                break;
            }
          },
        ),
      ],
    );
  }

  void _onStateChange(BuildContext context, LsTrashbinBlocState state) {
    if (state is LsTrashbinBlocInit) {
      itemStreamListItems = [];
    } else if (state is LsTrashbinBlocSuccess ||
        state is LsTrashbinBlocLoading) {
      _transformItems(state.items);
    } else if (state is LsTrashbinBlocFailure) {
      _transformItems(state.items);
      SnackBarManager().showSnackBarForException(state.exception);
    } else if (state is LsTrashbinBlocInconsistent) {
      _reqQuery();
    }
  }

  Future<void> _onEmptyTrashPressed(BuildContext context) async {
    unawaited(
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(L10n.global().emptyTrashbinConfirmationDialogTitle),
              content: Text(
                L10n.global().emptyTrashbinConfirmationDialogContent,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteFiles(_backingFiles);
                  },
                  child: Text(L10n.global().confirmButtonLabel),
                ),
              ],
            ),
      ),
    );
  }

  Future<void> _onSelectionAppBarRestorePressed() async {
    SnackBarManager().showSnackBar(
      SnackBar(
        content: Text(
          L10n.global().restoreSelectedProcessingNotification(
            selectedListItems.length,
          ),
        ),
        duration: k.snackBarDurationShort,
      ),
    );
    final selection =
        selectedListItems
            .whereType<PhotoListFileItem>()
            .map((e) => e.file)
            .toList();
    setState(() {
      clearSelectedItems();
    });
    final c = KiwiContainer().resolve<DiContainer>();
    final selectedFiles = await InflateFileDescriptor(c)(
      widget.account,
      selection,
    );
    final failures = <File>[];
    for (final f in selectedFiles) {
      try {
        await RestoreTrashbin(c)(widget.account, f);
      } catch (e, stacktrace) {
        _log.shout(
          "[_onSelectionAppBarRestorePressed] Failed while restoring file: ${logFilename(f.path)}",
          e,
          stacktrace,
        );
        failures.add(f);
      }
    }
    if (failures.isEmpty) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().restoreSelectedSuccessNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
    } else {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(
            L10n.global().restoreSelectedFailureNotification(failures.length),
          ),
          duration: k.snackBarDurationNormal,
        ),
      );
    }
  }

  Future<void> _onSelectionAppBarDeletePressed(BuildContext context) async {
    unawaited(
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(
                L10n.global().deletePermanentlyConfirmationDialogTitle,
              ),
              content: Text(
                L10n.global().deletePermanentlyConfirmationDialogContent,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteSelected();
                  },
                  child: Text(L10n.global().confirmButtonLabel),
                ),
              ],
            ),
      ),
    );
  }

  void _transformItems(List<File> files) {
    _buildItemQueue.addJob(
      PhotoListItemBuilderArguments(
        widget.account,
        files,
        sorter: _fileSorter,
        locale:
            language_util.getSelectedLocale() ??
            PlatformDispatcher.instance.locale,
      ),
      buildPhotoListItem,
      (result) {
        if (mounted) {
          setState(() {
            _backingFiles = result.backingFiles.cast();
            itemStreamListItems = result.listItems;
          });
        }
      },
    );
  }

  Future<void> _deleteSelected() async {
    final selectedFiles =
        selectedListItems
            .whereType<PhotoListFileItem>()
            .map((e) => e.file)
            .toList();
    setState(() {
      clearSelectedItems();
    });
    return _deleteFiles(selectedFiles);
  }

  Future<void> _deleteFiles(List<FileDescriptor> files) async {
    await RemoveSelectionHandler(
      filesController: context.read<AccountController>().filesController,
    )(account: widget.account, selection: files, shouldCleanupAlbum: false);
  }

  void _reqQuery() {
    _bloc.add(LsTrashbinBlocQuery(widget.account));
  }

  late LsTrashbinBloc _bloc;

  var _backingFiles = <File>[];

  final _buildItemQueue =
      ComputeQueue<PhotoListItemBuilderArguments, PhotoListItemBuilderResult>();

  var _thumbZoomLevel = 0;
  int get _thumbSize => photo_list_util.getThumbSize(_thumbZoomLevel);
}

enum _AppBarMenuOption { empty }

enum _SelectionAppBarMenuOption { delete }

int _fileSorter(FileDescriptor fdA, FileDescriptor fdB) {
  final a = fdA as File;
  final b = fdB as File;
  if (a.trashbinDeletionTime == null && b.trashbinDeletionTime == null) {
    // ?
    return 0;
  } else if (a.trashbinDeletionTime == null) {
    return -1;
  } else if (b.trashbinDeletionTime == null) {
    return 1;
  } else {
    return b.trashbinDeletionTime!.compareTo(a.trashbinDeletionTime!);
  }
}
