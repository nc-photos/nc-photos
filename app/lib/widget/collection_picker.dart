import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/util.dart' as collection_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/app_bar_circular_progress_indicator.dart';
import 'package:nc_photos/widget/collection_grid_item.dart';
import 'package:nc_photos/widget/new_collection_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'collection_picker.g.dart';
part 'collection_picker/bloc.dart';
part 'collection_picker/state_event.dart';
part 'collection_picker/type.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;

/// Show a list of [Collection]s and return the one picked by the user
class CollectionPicker extends StatelessWidget {
  static const routeName = "/collection-picker";

  static Route buildRoute(RouteSettings settings) =>
      MaterialPageRoute<Collection>(
        builder: (context) => const CollectionPicker(),
        settings: settings,
      );

  const CollectionPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _Bloc(
        account: context.read<AccountController>().account,
        controller: context.read<AccountController>().collectionsController,
      ),
      child: const _WrappedCollectionPicker(),
    );
  }
}

class _WrappedCollectionPicker extends StatefulWidget {
  const _WrappedCollectionPicker();

  @override
  State<StatefulWidget> createState() => _WrappedCollectionPickerState();
}

@npLog
class _WrappedCollectionPickerState extends State<_WrappedCollectionPicker> {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _LoadCollections());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<_Bloc, _State>(
            listenWhen: (previous, current) =>
                previous.collections != current.collections,
            listener: (context, state) {
              _bloc.add(_TransformItems(state.collections));
            },
          ),
          BlocListener<_Bloc, _State>(
            listenWhen: (previous, current) =>
                previous.result != current.result,
            listener: (context, state) {
              if (state.result != null) {
                Navigator.of(context).pop(state.result!);
              }
            },
          ),
          BlocListener<_Bloc, _State>(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null) {
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            const _AppBar(),
            _BlocBuilder(
              buildWhen: (previous, current) =>
                  previous.transformedItems != current.transformedItems,
              builder: (context, state) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverStaggeredGrid.extentBuilder(
                  maxCrossAxisExtent: 256,
                  staggeredTileBuilder: (_) => const StaggeredTile.count(1, 1),
                  itemCount: state.transformedItems.length + 1,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return _NewAlbumView();
                    } else {
                      final item = state.transformedItems[index - 1];
                      return _ItemView(
                        account: _bloc.account,
                        item: item,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final _Bloc _bloc = context.read();
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => SliverAppBar(
        title: Text(L10n.global().addItemToCollectionTooltip),
        floating: true,
        leading: state.isLoading ? const AppBarProgressIndicator() : null,
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({
    required this.account,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CollectionGridItem(
          cover: _CollectionCover(
            account: account,
            url: item.coverUrl,
            mime: item.coverMime,
          ),
          title: item.name,
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                context.read<_Bloc>().add(_SelectCollection(item.collection));
              },
            ),
          ),
        ),
      ],
    );
  }

  final Account account;
  final _Item item;
}

class _CollectionCover extends StatelessWidget {
  const _CollectionCover({
    required this.account,
    required this.url,
    required this.mime,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Theme.of(context).listPlaceholderBackgroundColor,
        constraints: const BoxConstraints.expand(),
        child: url != null
            ? FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: CachedNetworkImageBuilder(
                  type: CachedNetworkImageType.cover,
                  imageUrl: url!,
                  mime: mime,
                  account: account,
                  errorWidget: (context, url, error) {
                    // just leave it empty
                    return Container();
                  },
                ).build(),
              )
            : Icon(
                Icons.panorama,
                color: Theme.of(context).listPlaceholderForegroundColor,
                size: 88,
              ),
      ),
    );
  }

  final Account account;
  final String? url;
  final String? mime;
}

@npLog
class _NewAlbumView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CollectionGridItem(
          cover: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Theme.of(context).listPlaceholderBackgroundColor,
              constraints: const BoxConstraints.expand(),
              child: Icon(
                Icons.add,
                color: Theme.of(context).listPlaceholderForegroundColor,
                size: 88,
              ),
            ),
          ),
          title: L10n.global().createAlbumTooltip,
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => _onNewPressed(context),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onNewPressed(BuildContext context) async {
    try {
      final collection = await showDialog<Collection>(
        context: context,
        builder: (_) => NewCollectionDialog(
          account: context.read<_Bloc>().account,
          isAllowDynamic: false,
        ),
      );
      if (collection == null) {
        // user canceled
        return;
      }
      context.read<_Bloc>().add(_SelectCollection(collection));
    } catch (e, stackTrace) {
      _log.shout("[_onNewPressed] Failed while showDialog", e, stackTrace);
      context.read<_Bloc>().add(_SetError(e, stackTrace));
    }
  }
}
