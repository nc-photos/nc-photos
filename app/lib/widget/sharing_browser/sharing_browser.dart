import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/sharings_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/data_source.dart';
import 'package:nc_photos/entity/collection/builder.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/import_potential_shared_album.dart';
import 'package:nc_photos/widget/collection_browser/collection_browser.dart';
import 'package:nc_photos/widget/empty_list_indicator.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/shared_file_viewer.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'sharing_browser.g.dart';
part 'state_event.dart';
part 'type.dart';

class SharingBrowserArguments {
  SharingBrowserArguments(this.account);

  final Account account;
}

/// Show a list of all shares associated with this account
class SharingBrowser extends StatelessWidget {
  static const routeName = "/sharing-browser";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) => const SharingBrowser(),
    settings: settings,
  );

  const SharingBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (_) => _Bloc(
            account: accountController.account,
            accountPrefController: accountController.accountPrefController,
            sharingsController: accountController.sharingsController,
          ),
      child: const _WrappedSharingBrowser(),
    );
  }
}

class _WrappedSharingBrowser extends StatefulWidget {
  const _WrappedSharingBrowser();

  @override
  State<StatefulWidget> createState() => _WrappedSharingBrowserState();
}

@npLog
class _WrappedSharingBrowserState extends State<_WrappedSharingBrowser>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _Init());
    if (context.bloc.accountPrefController.hasNewSharedAlbumValue) {
      context.bloc.accountPrefController.setNewSharedAlbum(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen: (previous, current) => previous.items != current.items,
          listener: (context, state) {
            _bloc.add(_TransformItems(state.items));
          },
        ),
        _BlocListener(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null && isPageVisible()) {
              SnackBarManager().showSnackBarForException(state.error!.error);
            }
          },
        ),
      ],
      child: Scaffold(
        body: _BlocBuilder(
          buildWhen:
              (previous, current) =>
                  previous.items.isEmpty != current.items.isEmpty ||
                  previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.items.isEmpty && !state.isLoading) {
              return const _EmptyContentList();
            } else {
              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      const _AppBar(),
                      SliverToBoxAdapter(
                        child: _BlocBuilder(
                          buildWhen:
                              (previous, current) =>
                                  previous.isLoading != current.isLoading,
                          builder:
                              (context, state) =>
                                  state.isLoading
                                      ? const LinearProgressIndicator()
                                      : const SizedBox(height: 4),
                        ),
                      ),
                      const _ContentList(),
                      const SliverSafeBottom(),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  late final _bloc = context.read<_Bloc>();
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(L10n.global().collectionSharingLabel),
      floating: true,
    );
  }
}

class _EmptyContentList extends StatelessWidget {
  const _EmptyContentList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text(L10n.global().collectionSharingLabel), elevation: 0),
        Expanded(
          child: EmptyListIndicator(
            icon: Icons.share_outlined,
            text: L10n.global().listEmptyText,
          ),
        ),
      ],
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.transformedItems != current.transformedItems,
      builder:
          (_, state) => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildItem(context, state.transformedItems[index]),
              childCount: state.transformedItems.length,
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, _Item data) {
    if (data is _FileShareItem) {
      return _buildFileItem(context, data);
    } else if (data is _AlbumShareItem) {
      return _buildAlbumItem(context, data);
    } else {
      throw ArgumentError("Unknown item type: ${data.runtimeType}");
    }
  }

  Widget _buildFileItem(BuildContext context, _FileShareItem item) {
    return _FileTile(
      account: item.account,
      item: item,
      isLinkShare: item.shares.any((e) => e.url?.isNotEmpty == true),
      onTap: () {
        Navigator.of(context).pushNamed(
          SharedFileViewer.routeName,
          arguments: SharedFileViewerArguments(
            item.account,
            item.file,
            item.shares,
          ),
        );
      },
    );
  }

  Widget _buildAlbumItem(BuildContext context, _AlbumShareItem item) {
    return _AlbumTile(
      account: item.account,
      item: item,
      onTap: () {
        Navigator.of(context).pushNamed(
          CollectionBrowser.routeName,
          arguments: CollectionBrowserArguments(
            CollectionBuilder.byAlbum(item.account, item.album),
          ),
        );
      },
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.leading,
    required this.label,
    required this.description,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return UnboundedListTile(
      leading: leading,
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(description),
      trailing: trailing,
      onTap: onTap,
    );
  }

  final Widget leading;
  final String label;
  final String description;
  final Widget? trailing;
  final VoidCallback? onTap;
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.account,
    required this.item,
    required this.isLinkShare,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _getDateFormat(context).format(item.sharedTime!.toLocal());
    return _ListTile(
      leading:
          item.shares.first.itemType == ShareItemType.folder
              ? const SizedBox(
                height: _leadingSize,
                width: _leadingSize,
                child: Icon(Icons.folder, size: 32),
              )
              : NetworkRectThumbnail(
                account: account,
                imageUrl: NetworkRectThumbnail.imageUrlForFile(
                  account,
                  item.file,
                ),
                mime: item.file.fdMime,
                dimension: _leadingSize,
                errorBuilder: (_) => const Icon(Icons.folder, size: 32),
              ),
      label: item.name,
      description:
          item.sharedBy == null
              ? L10n.global().fileLastSharedDescription(dateStr)
              : L10n.global().fileLastSharedByOthersDescription(
                item.sharedBy!,
                dateStr,
              ),
      trailing: isLinkShare ? const Icon(Icons.link) : null,
      onTap: onTap,
    );
  }

  final Account account;
  final _FileShareItem item;
  final bool isLinkShare;
  final VoidCallback? onTap;
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.account, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateStr = _getDateFormat(context).format(item.sharedTime!.toLocal());
    final cover = item.album.coverProvider.getCover(item.album);
    return _ListTile(
      leading:
          cover == null
              ? const SizedBox(
                height: _leadingSize,
                width: _leadingSize,
                child: Icon(Icons.photo_album, size: 32),
              )
              : NetworkRectThumbnail(
                account: account,
                imageUrl: NetworkRectThumbnail.imageUrlForFile(account, cover),
                mime: cover.fdMime,
                dimension: _leadingSize,
                errorBuilder: (_) => const Icon(Icons.photo_album, size: 32),
              ),
      label: item.album.name,
      description:
          item.sharedBy == null
              ? L10n.global().fileLastSharedDescription(dateStr)
              : L10n.global().albumLastSharedByOthersDescription(
                item.sharedBy!,
                dateStr,
              ),
      trailing: const Icon(Icons.photo_album_outlined),
      onTap: onTap,
    );
  }

  final Account account;
  final _AlbumShareItem item;
  final VoidCallback? onTap;
}

const _leadingSize = 56.0;

DateFormat _getDateFormat(BuildContext context) => DateFormat(
  DateFormat.YEAR_ABBR_MONTH_DAY,
  Localizations.localeOf(context).languageCode,
);

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
// typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  // void addEvent(_Event event) => bloc.add(event);
}
