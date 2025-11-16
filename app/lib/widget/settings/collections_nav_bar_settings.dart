import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/draggable.dart' as my;
import 'package:nc_photos/widget/fade_out_list.dart';
import 'package:nc_photos/widget/home_collections/home_collections.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'collections_nav_bar/bloc.dart';
part 'collections_nav_bar/buttons.dart';
part 'collections_nav_bar/state_event.dart';
part 'collections_nav_bar/view.dart';
part 'collections_nav_bar_settings.g.dart';

class CollectionsNavBarSettings extends StatelessWidget {
  const CollectionsNavBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(isBottom: true, prefController: context.read()),
      child: const _WrappedCollectionsNavBarSettings(),
    );
  }
}

class _WrappedCollectionsNavBarSettings extends StatefulWidget {
  const _WrappedCollectionsNavBarSettings();

  @override
  State<StatefulWidget> createState() =>
      _WrappedCollectionsNavBarSettingsState();
}

@npLog
class _WrappedCollectionsNavBarSettingsState
    extends State<_WrappedCollectionsNavBarSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        final prefController = context.bloc.prefController;
        final from = prefController.homeCollectionsNavBarButtonsValue;
        final to = context.state.buttons;
        if (!listEquals(from, to)) {
          _log.info("[build] Updated: ${to.toReadableString()}");
          prefController.setHomeCollectionsNavBarButtons(to);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            L10n.global().settingsCollectionsCustomizeNavigationBarTitle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.addEvent(const _RevertDefault());
              },
              child: Text(L10n.global().defaultButtonLabel),
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            _BlocListener(
              listenWhen:
                  (previous, current) => previous.error != current.error,
              listener: (context, state) {
                if (state.error != null && isPageVisible()) {
                  SnackBarManager().showSnackBarForException(
                    state.error!.error,
                  );
                }
              },
            ),
          ],
          child: Column(
            children: [
              const _DemoView(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Text(
                  L10n.global().customizeCollectionsNavBarDescription,
                ),
              ),
              const Expanded(child: _CandidateGrid()),
            ],
          ),
        ),
      ),
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
