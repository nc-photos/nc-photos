import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_init.dart' as app_init;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/scan_local_dir.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:nc_photos/mobile/android/permission_util.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/share_handler.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/empty_list_indicator.dart';
import 'package:nc_photos/widget/handler/delete_local_selection_handler.dart';
import 'package:nc_photos/widget/local_file_viewer.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart' as photo_list_util;
import 'package:nc_photos/widget/selectable_item_stream_list_mixin.dart';
import 'package:nc_photos/widget/selection_app_bar.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_async/np_async.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_permission/np_platform_permission.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'enhanced_photo_browser.g.dart';

class EnhancedPhotoBrowserArguments {
  const EnhancedPhotoBrowserArguments(this.filename);

  final String? filename;
}

class EnhancedPhotoBrowser extends StatefulWidget {
  static const routeName = "/enhanced-photo-browser";

  static Route buildRoute(
    EnhancedPhotoBrowserArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute(
    builder: (context) => EnhancedPhotoBrowser.fromArgs(args),
    settings: settings,
  );

  const EnhancedPhotoBrowser({super.key, required this.filename});

  EnhancedPhotoBrowser.fromArgs(EnhancedPhotoBrowserArguments args, {Key? key})
    : this(key: key, filename: args.filename);

  @override
  createState() => _EnhancedPhotoBrowserState();

  final String? filename;
}

@npLog
class _EnhancedPhotoBrowserState extends State<EnhancedPhotoBrowser>
    with SelectableItemStreamListMixin<EnhancedPhotoBrowser> {
  @override
  initState() {
    super.initState();
    _thumbZoomLevel = Pref().getAlbumBrowserZoomLevelOr(0);
    _ensurePermission().then((value) {
      if (value) {
        _initBloc();
      } else {
        if (mounted) {
          setState(() {
            _isNoPermission = true;
          });
        }
      }
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ScanLocalDirBloc, ScanLocalDirBlocState>(
        bloc: _bloc,
        listener: (context, state) => _onStateChange(context, state),
        child: BlocBuilder<ScanLocalDirBloc, ScanLocalDirBlocState>(
          bloc: _bloc,
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  @override
  onItemTap(SelectableItem item, int index) {
    item.as<PhotoListLocalFileItem>()?.run((fileItem) {
      Navigator.pushNamed(
        context,
        LocalFileViewer.routeName,
        arguments: LocalFileViewerArguments(_backingFiles, fileItem.fileIndex),
      );
    });
  }

  void _initBloc() {
    if (_bloc.state is ScanLocalDirBlocInit) {
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

  Widget _buildContent(BuildContext context, ScanLocalDirBlocState state) {
    if (_isNoPermission) {
      return Column(
        children: [
          AppBar(
            title: Text(L10n.global().collectionEditedPhotosLabel),
            elevation: 0,
          ),
          Expanded(
            child: EmptyListIndicator(
              icon: Icons.folder_off_outlined,
              text: L10n.global().errorNoStoragePermission,
            ),
          ),
        ],
      );
    } else if (state is ScanLocalDirBlocSuccess &&
        !_buildItemQueue.isProcessing &&
        itemStreamListItems.isEmpty) {
      return Column(
        children: [
          AppBar(
            title: Text(L10n.global().collectionEditedPhotosLabel),
            elevation: 0,
          ),
          Expanded(
            child: EmptyListIndicator(
              icon: Icons.folder_outlined,
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
              ],
            ),
          ),
          if (state is ScanLocalDirBlocLoading || _buildItemQueue.isProcessing)
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

  Widget _buildNormalAppBar(BuildContext context) =>
      SliverAppBar(title: Text(L10n.global().collectionEditedPhotosLabel));

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
          icon: const Icon(Icons.share_outlined),
          tooltip: L10n.global().shareTooltip,
          onPressed: () {
            _onSelectionSharePressed(context);
          },
        ),
        PopupMenuButton<_SelectionMenuOption>(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: _SelectionMenuOption.delete,
                  child: Text(L10n.global().deletePermanentlyTooltip),
                ),
              ],
          onSelected: (option) => _onSelectionMenuSelected(context, option),
        ),
      ],
    );
  }

  void _onStateChange(BuildContext context, ScanLocalDirBlocState state) {
    if (state is ScanLocalDirBlocInit) {
      itemStreamListItems = [];
    } else if (state is ScanLocalDirBlocLoading) {
      _transformItems(state.files);
    } else if (state is ScanLocalDirBlocSuccess) {
      _transformItems(state.files, isSuccess: true);
    } else if (state is ScanLocalDirBlocFailure) {
      _transformItems(state.files);
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(
            state.exception is PermissionException
                ? L10n.global().errorNoStoragePermission
                : exception_util.toUserString(state.exception),
          ),
          duration: k.snackBarDurationNormal,
        ),
      );
    }
  }

  Future<void> _onSelectionSharePressed(BuildContext context) async {
    final c = KiwiContainer().resolve<DiContainer>();
    final selected =
        selectedListItems
            .whereType<PhotoListLocalFileItem>()
            .map((e) => e.file)
            .toList();
    await ShareHandler(
      c,
      context: context,
      clearSelection: () {
        setState(() {
          clearSelectedItems();
        });
      },
    ).shareLocalFiles(selected);
  }

  void _onSelectionMenuSelected(
    BuildContext context,
    _SelectionMenuOption option,
  ) {
    switch (option) {
      case _SelectionMenuOption.delete:
        _onSelectionDeletePressed(context);
        break;
    }
  }

  Future<void> _onSelectionDeletePressed(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(L10n.global().deletePermanentlyConfirmationDialogTitle),
            content: Text(
              L10n.global().deletePermanentlyLocalConfirmationDialogContent,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(L10n.global().confirmButtonLabel),
              ),
            ],
          ),
    );
    if (result != true) {
      return;
    }

    final selectedFiles =
        selectedListItems
            .whereType<PhotoListLocalFileItem>()
            .map((e) => e.file)
            .toList();
    setState(() {
      clearSelectedItems();
    });
    await const DeleteLocalSelectionHandler()(selectedFiles: selectedFiles);
  }

  void _transformItems(List<LocalFile> files, {bool isSuccess = false}) {
    _buildItemQueue.addJob(_BuilderArguments(files), _buildPhotoListItem, (
      result,
    ) {
      if (mounted) {
        setState(() {
          _backingFiles = result.backingFiles;
          itemStreamListItems = result.listItems;
        });
        if (isSuccess && _isFirstRun) {
          _isFirstRun = false;
          if (widget.filename != null) {
            _openInitialImage(widget.filename!);
          }
        }
      }
    });
  }

  void _openInitialImage(String filename) {
    final index = _backingFiles.indexWhere((f) => f.filename == filename);
    if (index == -1) {
      _log.severe("[openInitialImage] Filename not found: $filename");
      return;
    }
    Navigator.pushNamed(
      context,
      LocalFileViewer.routeName,
      arguments: LocalFileViewerArguments(_backingFiles, index),
    );
  }

  Future<bool> _ensurePermission() async {
    if (getRawPlatform() == NpPlatform.android) {
      if (AndroidInfo().sdkInt >= AndroidVersion.R) {
        if (!await Permission.hasReadMedia()) {
          final results = await requestReadMediaForResult();
          return results[Permission.READ_EXTERNAL_STORAGE] ==
                  PermissionRequestResult.granted ||
              results[Permission.READ_MEDIA_IMAGES] ==
                  PermissionRequestResult.granted;
        }
      } else {
        if (!await Permission.hasWriteExternalStorage()) {
          final results = await requestPermissionsForResult([
            Permission.WRITE_EXTERNAL_STORAGE,
          ]);
          return results[Permission.WRITE_EXTERNAL_STORAGE] ==
              PermissionRequestResult.granted;
        }
      }
    }
    return true;
  }

  void _reqQuery() {
    _bloc.add(
      const ScanLocalDirBlocQuery([
        "Download/Photos (for Nextcloud)/Enhanced Photos",
        "Download/Photos (for Nextcloud)/Edited Photos",
      ]),
    );
  }

  final _bloc = ScanLocalDirBloc();

  var _backingFiles = <LocalFile>[];

  final _buildItemQueue = ComputeQueue<_BuilderArguments, _BuilderResult>();

  var _isFirstRun = true;
  var _thumbZoomLevel = 0;
  int get _thumbSize => photo_list_util.getThumbSize(_thumbZoomLevel);
  var _isNoPermission = false;
}

enum _SelectionMenuOption { delete }

class _BuilderResult {
  const _BuilderResult(this.backingFiles, this.listItems);

  final List<LocalFile> backingFiles;
  final List<SelectableItem> listItems;
}

class _BuilderArguments {
  const _BuilderArguments(this.files);

  final List<LocalFile> files;
}

@npLog
class _Builder {
  _BuilderResult call(List<LocalFile> files) {
    final s = Stopwatch()..start();
    try {
      return _fromSortedItems(_sortItems(files));
    } finally {
      _log.info("[call] Elapsed time: ${s.elapsedMilliseconds}ms");
    }
  }

  List<LocalFile> _sortItems(List<LocalFile> files) {
    // we use last modified here to keep newly enhanced photo at the top
    return files.stableSorted(
      (a, b) => b.lastModified.compareTo(a.lastModified),
    );
  }

  _BuilderResult _fromSortedItems(List<LocalFile> files) {
    final backingFiles = <LocalFile>[];
    final listItems = <SelectableItem>[];
    for (int i = 0; i < files.length; ++i) {
      final f = files[i];
      final item = _buildListItem(i, f);
      if (item != null) {
        backingFiles.add(f);
        listItems.add(item);
      }
    }
    return _BuilderResult(backingFiles, listItems);
  }

  SelectableItem? _buildListItem(int i, LocalFile file) {
    if (file_util.isSupportedImageMime(file.mime ?? "")) {
      return PhotoListLocalImageItem(fileIndex: i, file: file);
    } else {
      _log.shout("[_buildListItem] Unsupported file format: ${file.mime}");
      return null;
    }
  }
}

_BuilderResult _buildPhotoListItem(_BuilderArguments arg) {
  app_init.initLog();
  return _Builder()(arg.files);
}
