import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/list_album_share_outlier.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/ci_string.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/share/data_source.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/string_extension.dart';
import 'package:nc_photos/use_case/create_share.dart';
import 'package:nc_photos/use_case/remove_share.dart';
import 'package:nc_photos/widget/empty_list_indicator.dart';
import 'package:nc_photos/widget/unbounded_list_tile.dart';

class AlbumShareOutlierBrowserArguments {
  const AlbumShareOutlierBrowserArguments(this.account, this.album);

  final Account account;
  final Album album;
}

class AlbumShareOutlierBrowser extends StatefulWidget {
  static const routeName = "/album-share-outlier-browser";

  static Route buildRoute(AlbumShareOutlierBrowserArguments args) =>
      MaterialPageRoute(
        builder: (context) => AlbumShareOutlierBrowser.fromArgs(args),
      );

  const AlbumShareOutlierBrowser({
    Key? key,
    required this.account,
    required this.album,
  }) : super(key: key);

  AlbumShareOutlierBrowser.fromArgs(AlbumShareOutlierBrowserArguments args,
      {Key? key})
      : this(
          key: key,
          account: args.account,
          album: args.album,
        );

  @override
  createState() => _AlbumShareOutlierBrowserState();

  final Account account;
  final Album album;
}

class _AlbumShareOutlierBrowserState extends State<AlbumShareOutlierBrowser> {
  @override
  initState() {
    super.initState();
    _initBloc();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ListAlbumShareOutlierBloc,
          ListAlbumShareOutlierBlocState>(
        bloc: _bloc,
        listener: (context, state) => _onStateChange(context, state),
        child: BlocBuilder<ListAlbumShareOutlierBloc,
            ListAlbumShareOutlierBlocState>(
          bloc: _bloc,
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  void _initBloc() {
    if (_bloc.state is ListAlbumShareOutlierBlocInit) {
      _log.info("[_initBloc] Initialize bloc");
    } else {
      // process the current state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _onStateChange(context, _bloc.state);
        });
      });
    }
    _reqQuery();
  }

  Widget _buildContent(
      BuildContext context, ListAlbumShareOutlierBlocState state) {
    if ((state is ListAlbumShareOutlierBlocSuccess ||
            state is ListAlbumShareOutlierBlocFailure) &&
        state.items.isEmpty) {
      return _buildEmptyContent(context);
    } else {
      return Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildItem(context, _items[index]),
                  childCount: _items.length,
                ),
              ),
            ],
          ),
          if (state is ListAlbumShareOutlierBlocLoading)
            const Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            ),
        ],
      );
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(L10n.global().fixSharesTooltip),
      floating: true,
      actions: [
        PopupMenuButton<_MenuOption>(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _MenuOption.fixAll,
              child: Text(L10n.global().fixAllTooltip),
            ),
          ],
          onSelected: (option) {
            switch (option) {
              case _MenuOption.fixAll:
                _onFixAllPressed(context);
                break;

              default:
                _log.shout("[_buildAppBar] Unknown option: $option");
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(L10n.global().fixSharesTooltip),
          elevation: 0,
        ),
        Expanded(
          child: EmptyListIndicator(
            icon: Icons.share_outlined,
            text: L10n.global().listEmptyText,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, _ListItem item) {
    if (item is _MissingShareeItem) {
      return _buildMissingShareeItem(context, item);
    } else if (item is _ExtraShareItem) {
      return _buildExtraShareItem(context, item);
    } else {
      throw StateError("Unknown item type: ${item.runtimeType}");
    }
  }

  Widget _buildMissingShareeItem(
      BuildContext context, _MissingShareeItem item) {
    final Widget trailing;
    switch (_getItemStatus(item.file.path, item.shareWith)) {
      case null:
        trailing = _buildFixButton(
          onPressed: () {
            _fixMissingSharee(item);
          },
        );
        break;

      case _ItemStatus.processing:
        trailing = _buildProcessingIcon(context);
        break;

      case _ItemStatus.fixed:
        trailing = _buildFixedIcon(context);
        break;
    }

    return UnboundedListTile(
      leading: _buildFileThumbnail(item.file),
      title: Text(
        _buildFilename(item.file),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(L10n.global().missingShareDescription(
          item.shareWithDisplayName ?? item.shareWith)),
      trailing: trailing,
    );
  }

  Widget _buildExtraShareItem(BuildContext context, _ExtraShareItem item) {
    final Widget trailing;
    switch (_getItemStatus(item.file.path, item.share.shareWith!)) {
      case null:
        trailing = _buildFixButton(
          onPressed: () {
            _fixExtraShare(item);
          },
        );
        break;

      case _ItemStatus.processing:
        trailing = _buildProcessingIcon(context);
        break;

      case _ItemStatus.fixed:
        trailing = _buildFixedIcon(context);
        break;
    }

    return UnboundedListTile(
      leading: _buildFileThumbnail(item.file),
      title: Text(
        _buildFilename(item.file),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
          L10n.global().extraShareDescription(item.share.shareWithDisplayName)),
      trailing: trailing,
    );
  }

  Widget _buildFileThumbnail(File file) {
    final Widget child;
    if (file_util.isAlbumFile(widget.account, file)) {
      child = const Icon(Icons.photo_album, size: 32);
    } else {
      child = CachedNetworkImage(
        cacheManager: ThumbnailCacheManager.inst,
        imageUrl: api_util.getFilePreviewUrl(widget.account, file,
            width: k.photoThumbSize, height: k.photoThumbSize),
        httpHeaders: {
          "Authorization": Api.getAuthorizationHeaderValue(widget.account),
        },
        fadeInDuration: const Duration(),
        filterQuality: FilterQuality.high,
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorWidget: (context, url, error) =>
            const Icon(Icons.image_not_supported, size: 32),
      );
    }
    return SizedBox(
      width: 56,
      height: 56,
      child: child,
    );
  }

  String _buildFilename(File file) {
    if (widget.album.albumFile?.path.equalsIgnoreCase(file.path) == true) {
      return widget.album.name;
    } else {
      return file.filename;
    }
  }

  Widget _buildFixButton({
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.handyman_outlined),
      tooltip: L10n.global().fixTooltip,
    );
  }

  Widget _buildProcessingIcon(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildFixedIcon(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Icon(Icons.check),
    );
  }

  void _onStateChange(
      BuildContext context, ListAlbumShareOutlierBlocState state) {
    if (state is ListAlbumShareOutlierBlocInit) {
      _items = [];
    } else if (state is ListAlbumShareOutlierBlocSuccess ||
        state is ListAlbumShareOutlierBlocLoading) {
      _transformItems(state.items);
    } else if (state is ListAlbumShareOutlierBlocFailure) {
      _transformItems(state.items);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(state.exception)),
        duration: k.snackBarDurationNormal,
      ));
    }
  }

  Future<void> _onFixAllPressed(BuildContext context) async {
    // select only items that are not fixed/being fixed
    final items = _items.where((i) {
      if (i is _MissingShareeItem) {
        return _getItemStatus(i.file.path, i.shareWith) == null;
      } else if (i is _ExtraShareItem) {
        return _getItemStatus(i.file.path, i.share.shareWith!) == null;
      } else {
        // ?
        return false;
      }
    }).toList();
    setState(() {
      for (final i in items) {
        if (i is _MissingShareeItem) {
          _setItemStatus(i.file.path, i.shareWith, _ItemStatus.processing);
        } else if (i is _ExtraShareItem) {
          _setItemStatus(
              i.file.path, i.share.shareWith!, _ItemStatus.processing);
        }
      }
    });
    for (final i in items) {
      if (i is _MissingShareeItem) {
        await _fixMissingSharee(i);
      } else if (i is _ExtraShareItem) {
        await _fixExtraShare(i);
      }
    }
  }

  void _transformItems(List<ListAlbumShareOutlierItem> items) {
    _items = () sync* {
      for (final item in items) {
        for (final si in item.shareItems) {
          if (si is ListAlbumShareOutlierMissingShareItem) {
            yield _MissingShareeItem(
                item.file, si.shareWith, si.shareWithDisplayName);
          } else if (si is ListAlbumShareOutlierExtraShareItem) {
            yield _ExtraShareItem(item.file, si.share);
          }
        }
      }
    }()
        .toList();
  }

  Future<void> _fixMissingSharee(_MissingShareeItem item) async {
    final shareRepo = ShareRepo(ShareRemoteDataSource());
    setState(() {
      _setItemStatus(item.file.path, item.shareWith, _ItemStatus.processing);
    });
    try {
      await CreateUserShare(shareRepo)(
          widget.account, item.file, item.shareWith.raw);
      if (mounted) {
        setState(() {
          _setItemStatus(item.file.path, item.shareWith, _ItemStatus.fixed);
        });
      }
    } catch (e, stackTrace) {
      _log.shout(
          "[_fixMissingSharee] Failed while CreateUserShare", e, stackTrace);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(e)),
        duration: k.snackBarDurationNormal,
      ));
      if (mounted) {
        setState(() {
          _removeItemStatus(item.file.path, item.shareWith);
        });
      }
    }
  }

  Future<void> _fixExtraShare(_ExtraShareItem item) async {
    final shareRepo = ShareRepo(ShareRemoteDataSource());
    setState(() {
      _setItemStatus(
          item.file.path, item.share.shareWith!, _ItemStatus.processing);
    });
    try {
      await RemoveShare(shareRepo)(widget.account, item.share);
      if (mounted) {
        setState(() {
          _setItemStatus(
              item.file.path, item.share.shareWith!, _ItemStatus.fixed);
        });
      }
    } catch (e, stackTrace) {
      _log.shout("[_fixExtraShare] Failed while RemoveShare", e, stackTrace);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(e)),
        duration: k.snackBarDurationNormal,
      ));
      if (mounted) {
        setState(() {
          _removeItemStatus(item.file.path, item.share.shareWith!);
        });
      }
    }
  }

  void _reqQuery() {
    _bloc.add(ListAlbumShareOutlierBlocQuery(widget.account, widget.album));
  }

  _ItemStatus? _getItemStatus(String fileKey, CiString shareeKey) {
    final temp = _itemStatuses[fileKey];
    if (temp == null) {
      return null;
    } else {
      return temp[shareeKey];
    }
  }

  void _setItemStatus(String fileKey, CiString shareeKey, _ItemStatus value) {
    if (!_itemStatuses.containsKey(fileKey)) {
      _itemStatuses[fileKey] = {};
    }
    _itemStatuses[fileKey]![shareeKey] = value;
  }

  void _removeItemStatus(String fileKey, CiString shareeKey) {
    if (!_itemStatuses.containsKey(fileKey)) {
      return;
    }
    _itemStatuses[fileKey]!.remove(shareeKey);
  }

  late final _bloc =
      ListAlbumShareOutlierBloc(KiwiContainer().resolve<DiContainer>());

  var _items = <_ListItem>[];
  final _itemStatuses = <String, Map<CiString, _ItemStatus>>{};

  static final _log = Logger(
      "widget.album_share_outlier_browser._AlbumShareOutlierBrowserState");
}

abstract class _ListItem {
  const _ListItem();
}

class _ExtraShareItem extends _ListItem {
  const _ExtraShareItem(this.file, this.share);

  final File file;
  final Share share;
}

class _MissingShareeItem extends _ListItem {
  const _MissingShareeItem(
      this.file, this.shareWith, this.shareWithDisplayName);

  final File file;
  final CiString shareWith;
  final String? shareWithDisplayName;
}

enum _ItemStatus {
  processing,
  fixed,
}

enum _MenuOption {
  fixAll,
}
