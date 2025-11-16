import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/persons_controller.dart';
import 'package:nc_photos/controller/places_controller.dart';
import 'package:nc_photos/entity/collection/builder.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/collection_browser/collection_browser.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/people_browser/people_browser.dart';
import 'package:nc_photos/widget/person_thumbnail.dart';
import 'package:nc_photos/widget/places_browser/places_browser.dart';
import 'package:nc_photos/widget/settings/account_settings.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'bloc.dart';
part 'search_landing.g.dart';
part 'state_event.dart';
part 'type.dart';
part 'view.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;

class SearchLanding extends StatelessWidget {
  const SearchLanding({super.key, this.onFavoritePressed, this.onVideoPressed});

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (_) => _Bloc(
            account: accountController.account,
            personsController: accountController.personsController,
            placesController: accountController.placesController,
          ),
      child: _WrappedSearchLanding(
        onFavoritePressed: onFavoritePressed,
        onVideoPressed: onVideoPressed,
      ),
    );
  }

  final VoidCallback? onFavoritePressed;
  final VoidCallback? onVideoPressed;
}

class _WrappedSearchLanding extends StatefulWidget {
  const _WrappedSearchLanding({this.onFavoritePressed, this.onVideoPressed});

  @override
  State<StatefulWidget> createState() => _WrappedSearchLandingState();

  final VoidCallback? onFavoritePressed;
  final VoidCallback? onVideoPressed;
}

@npLog
class _WrappedSearchLandingState extends State<_WrappedSearchLanding> {
  @override
  void initState() {
    super.initState();
    _bloc
      ..add(const _LoadPersons())
      ..add(const _LoadPlaces());
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction >= 0.2;
        if (isVisible != _isVisible) {
          if (mounted) {
            setState(() {
              _isVisible = isVisible;
            });
          }
        }
      },
      child: MultiBlocListener(
        listeners: [
          _BlocListener(
            listenWhen:
                (previous, current) => previous.persons != current.persons,
            listener: (context, state) {
              _bloc.add(_TransformPersonItems(state.persons));
            },
          ),
          _BlocListener(
            listenWhen:
                (previous, current) => previous.places != current.places,
            listener: (context, state) {
              _bloc.add(_TransformPlaceItems(state.places));
            },
          ),
          _BlocListener(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null && _isVisible == true) {
                if (state.error is ApiException) {
                  final e = state.error as ApiException;
                  if (e.response.statusCode == 404) {
                    // face recognition app probably not installed, ignore
                    return;
                  }
                }
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            },
          ),
        ],
        child: Column(
          children: [
            ValueStreamBuilder<PersonProvider>(
              stream:
                  context
                      .read<AccountController>()
                      .accountPrefController
                      .personProvider,
              builder: (context, snapshot) {
                if (snapshot.requireData == PersonProvider.none) {
                  return const SizedBox.shrink();
                } else {
                  return const _PeopleSection();
                }
              },
            ),
            const _PlaceSection(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(L10n.global().categoriesLabel),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.star_border),
              title: Text(L10n.global().collectionFavoritesLabel),
              onTap: widget.onFavoritePressed,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(height: 1),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.ondemand_video_outlined),
              title: Text(L10n.global().searchLandingCategoryVideosLabel),
              onTap: widget.onVideoPressed,
            ),
          ],
        ),
      ),
    );
  }

  late final _bloc = context.read<_Bloc>();

  final _key = GlobalKey();
  bool? _isVisible;
}

class _PeopleSection extends StatelessWidget {
  const _PeopleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(L10n.global().collectionPeopleLabel),
          trailing: _BlocBuilder(
            buildWhen:
                (previous, current) =>
                    previous.transformedPersonItems !=
                    current.transformedPersonItems,
            builder:
                (context, state) =>
                    state.transformedPersonItems.isEmpty
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AccountSettings.routeName,
                                  arguments: const AccountSettingsArguments(
                                    highlight:
                                        AccountSettingsOption.personProvider,
                                  ),
                                );
                              },
                              tooltip: L10n.global().accountSettingsTooltip,
                              icon: const Icon(Icons.settings_outlined),
                            ),
                            IconButton(
                              onPressed: () {
                                launch(help_util.peopleUrl);
                              },
                              tooltip: L10n.global().helpTooltip,
                              icon: const Icon(Icons.help_outline),
                            ),
                          ],
                        )
                        : TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(PeopleBrowser.routeName);
                          },
                          child: Text(L10n.global().showAllButtonLabel),
                        ),
          ),
        ),
        _BlocBuilder(
          buildWhen:
              (previous, current) =>
                  previous.isPersonsLoading != current.isPersonsLoading ||
                  previous.transformedPersonItems !=
                      current.transformedPersonItems,
          builder: (context, state) {
            if (state.isPersonsLoading) {
              return const SizedBox(
                height: 48,
                child: Center(
                  child: AppIntermediateCircularProgressIndicator(),
                ),
              );
            } else {
              if (state.transformedPersonItems.isEmpty) {
                return SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: Text(
                        L10n.global().searchLandingPeopleListEmptyText2,
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  height: 128,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.transformedPersonItems.length,
                    itemBuilder: (context, i) {
                      final item = state.transformedPersonItems[i];
                      return _PersonItemView(
                        account: context.read<_Bloc>().account,
                        item: item,
                        onTap: () => _onItemTap(context, item.person),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }

  void _onItemTap(BuildContext context, Person person) {
    Navigator.pushNamed(
      context,
      CollectionBrowser.routeName,
      arguments: CollectionBrowserArguments(
        CollectionBuilder.byPerson(context.read<_Bloc>().account, person),
      ),
    );
  }
}

class _PlaceSection extends StatelessWidget {
  const _PlaceSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(L10n.global().collectionPlacesLabel),
          trailing: _BlocBuilder(
            buildWhen:
                (previous, current) =>
                    previous.transformedPlaceItems !=
                    current.transformedPlaceItems,
            builder:
                (context, state) =>
                    state.transformedPlaceItems.isEmpty
                        ? const SizedBox.shrink()
                        : TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(PlacesBrowser.routeName);
                          },
                          child: Text(L10n.global().showAllButtonLabel),
                        ),
          ),
        ),
        _BlocBuilder(
          buildWhen:
              (previous, current) =>
                  previous.isPlacesLoading != current.isPlacesLoading ||
                  previous.transformedPlaceItems !=
                      current.transformedPlaceItems,
          builder: (context, state) {
            if (state.isPlacesLoading) {
              return const SizedBox(
                height: 48,
                child: Center(
                  child: AppIntermediateCircularProgressIndicator(),
                ),
              );
            } else {
              if (state.transformedPlaceItems.isEmpty) {
                return SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Center(child: Text(L10n.global().listNoResultsText)),
                  ),
                );
              } else {
                return SizedBox(
                  height: 128,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.transformedPlaceItems.length,
                    itemBuilder: (context, i) {
                      final item = state.transformedPlaceItems[i];
                      return _PlaceItemView(
                        account: context.read<_Bloc>().account,
                        item: item,
                        onTap: () => _onItemTap(context, item.place),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }

  void _onItemTap(BuildContext context, LocationGroup place) {
    Navigator.of(context).pushNamed(
      CollectionBrowser.routeName,
      arguments: CollectionBrowserArguments(
        CollectionBuilder.byLocationGroup(context.read<_Bloc>().account, place),
      ),
    );
  }
}
