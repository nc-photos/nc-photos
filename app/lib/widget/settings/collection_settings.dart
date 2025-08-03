import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/settings/collections_nav_bar_settings.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'collection/bloc.dart';
part 'collection/state_event.dart';
part 'collection_settings.g.dart';

typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

class CollectionSettings extends StatelessWidget {
  const CollectionSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(
        prefController: context.read(),
      ),
      child: const _WrappedAlbumSettings(),
    );
  }
}

class _WrappedAlbumSettings extends StatefulWidget {
  const _WrappedAlbumSettings();

  @override
  State<StatefulWidget> createState() => _WrappedAlbumSettingsState();
}

@npLog
class _WrappedAlbumSettingsState extends State<_WrappedAlbumSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          _BlocListener(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null && isPageVisible()) {
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(L10n.global().collectionsTooltip),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _BlocSelector<bool>(
                    selector: (state) => state.isBrowserShowDate,
                    builder: (context, state) {
                      return SwitchListTile(
                        title: Text(L10n.global().settingsShowDateInAlbumTitle),
                        subtitle: Text(
                            L10n.global().settingsShowDateInAlbumDescription),
                        value: state,
                        onChanged: (value) {
                          _bloc.add(_SetBrowserShowDate(value));
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text(L10n.global()
                        .settingsCollectionsCustomizeNavigationBarTitle),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CollectionsNavBarSettings(),
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
