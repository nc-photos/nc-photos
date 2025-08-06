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
import 'package:nc_photos/controller/places_controller.dart';
import 'package:nc_photos/entity/collection/builder.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:nc_photos/widget/about_geocoding_dialog.dart';
import 'package:nc_photos/widget/collection_browser.dart';
import 'package:nc_photos/widget/collection_list_item.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'places_browser.g.dart';
part 'places_browser/bloc.dart';
part 'places_browser/state_event.dart';
part 'places_browser/type.dart';
part 'places_browser/view.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;

/// Show a list of all people associated with this account
class PlacesBrowser extends StatelessWidget {
  static const routeName = "/places-browser";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) => const PlacesBrowser(),
    settings: settings,
  );

  const PlacesBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (_) => _Bloc(
            account: accountController.account,
            placesController: accountController.placesController,
          ),
      child: const _WrappedPlacesBrowser(),
    );
  }
}

class _WrappedPlacesBrowser extends StatefulWidget {
  const _WrappedPlacesBrowser();

  @override
  State<StatefulWidget> createState() => _WrappedPlacesBrowserState();
}

@npLog
class _WrappedPlacesBrowserState extends State<_WrappedPlacesBrowser>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _LoadPlaces());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen: (previous, current) => previous.places != current.places,
          listener: (context, state) {
            _bloc.add(_TransformItems(state.places));
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
                  _CountryList(
                    onTap: (_, item) {
                      _onTap(context, item);
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  _ContentList(
                    onTap: (_, item) {
                      _onTap(context, item);
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

  void _onTap(BuildContext context, _Item item) {
    Navigator.pushNamed(
      context,
      CollectionBrowser.routeName,
      arguments: CollectionBrowserArguments(
        CollectionBuilder.byLocationGroup(_bloc.account, item.place),
      ),
    );
  }

  late final _bloc = context.read<_Bloc>();
}
