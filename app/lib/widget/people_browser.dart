import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/persons_controller.dart';
import 'package:nc_photos/entity/collection/builder.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/collection_browser.dart';
import 'package:nc_photos/widget/collection_list_item.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/person_thumbnail.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'people_browser.g.dart';
part 'people_browser/bloc.dart';
part 'people_browser/state_event.dart';
part 'people_browser/type.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;

/// Show a list of all people associated with this account
class PeopleBrowser extends StatelessWidget {
  static const routeName = "/people-browser";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
        builder: (_) => const PeopleBrowser(),
        settings: settings,
      );

  const PeopleBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create: (_) => _Bloc(
        account: accountController.account,
        personsController: accountController.personsController,
      ),
      child: const _WrappedPeopleBrowser(),
    );
  }
}

class _WrappedPeopleBrowser extends StatefulWidget {
  const _WrappedPeopleBrowser();

  @override
  State<StatefulWidget> createState() => _WrappedPeopleBrowserState();
}

@npLog
class _WrappedPeopleBrowserState extends State<_WrappedPeopleBrowser>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _LoadPersons());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen: (previous, current) =>
              previous.persons != current.persons,
          listener: (context, state) {
            _bloc.add(_TransformItems(state.persons));
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
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                _bloc.add(const _Reload());
                await _bloc.stream.first;
              },
              child: CustomScrollView(
                slivers: [
                  const _AppBar(),
                  SliverToBoxAdapter(
                    child: _BlocBuilder(
                      buildWhen: (previous, current) =>
                          previous.isLoading != current.isLoading,
                      builder: (context, state) => state.isLoading
                          ? const LinearProgressIndicator()
                          : const SizedBox(height: 4),
                    ),
                  ),
                  _ContentList(
                    onTap: (_, item) {
                      Navigator.pushNamed(
                        context,
                        CollectionBrowser.routeName,
                        arguments: CollectionBrowserArguments(
                          CollectionBuilder.byPerson(
                              _bloc.account, item.person),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
      title: Text(L10n.global().collectionPeopleLabel),
      floating: true,
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.transformedItems != current.transformedItems,
      builder: (context, state) => SliverStaggeredGrid.extentBuilder(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        itemCount: state.transformedItems.length,
        itemBuilder: (context, index) {
          final item = state.transformedItems[index];
          return _ItemView(
            account: context.read<_Bloc>().account,
            item: item,
            onTap: onTap == null
                ? null
                : () {
                    onTap!.call(index, item);
                  },
          );
        },
        staggeredTileBuilder: (_) => const StaggeredTile.count(1, 1),
      ),
    );
  }

  final Function(int index, _Item item)? onTap;
}

class _ItemView extends StatelessWidget {
  const _ItemView({
    required this.account,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CollectionListSmall(
      label: item.name,
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => PersonThumbnail(
          account: account,
          coverUrl: item.coverUrl,
          coverMime: item.coverMime,
          person: item.person,
          dimension: constraints.maxWidth,
        ),
      ),
    );
  }

  final Account account;
  final _Item item;
  final VoidCallback? onTap;
}
