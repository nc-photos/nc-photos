import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/draggable.dart' as my;
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/viewer/viewer.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'viewer_app_bar/bloc.dart';
part 'viewer_app_bar/demo_buttons.dart';
part 'viewer_app_bar/grid_buttons.dart';
part 'viewer_app_bar/state_event.dart';
part 'viewer_app_bar/view.dart';
part 'viewer_app_bar_settings.g.dart';

class ViewerAppBarSettings extends StatelessWidget {
  const ViewerAppBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(
        isBottom: false,
        prefController: context.read(),
      ),
      child: const _WrappedViewerAppBarSettings(isBottom: false),
    );
  }
}

class ViewerBottomAppBarSettings extends StatelessWidget {
  const ViewerBottomAppBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(
        isBottom: true,
        prefController: context.read(),
      ),
      child: const _WrappedViewerAppBarSettings(isBottom: true),
    );
  }
}

class _WrappedViewerAppBarSettings extends StatefulWidget {
  const _WrappedViewerAppBarSettings({
    required this.isBottom,
  });

  @override
  State<StatefulWidget> createState() => _WrappedViewerAppBarSettingsState();

  final bool isBottom;
}

@npLog
class _WrappedViewerAppBarSettingsState
    extends State<_WrappedViewerAppBarSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        final prefController = context.bloc.prefController;
        final from = widget.isBottom
            ? prefController.viewerBottomAppBarButtonsValue
            : prefController.viewerAppBarButtonsValue;
        final to = context.state.buttons;
        if (!listEquals(from, to)) {
          _log.info("[build] Updated: ${to.toReadableString()}");
          if (widget.isBottom) {
            prefController.setViewerBottomAppBarButtons(to);
          } else {
            prefController.setViewerAppBarButtons(to);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isBottom
              ? L10n.global().settingsViewerCustomizeBottomAppBarTitle
              : L10n.global().settingsViewerCustomizeAppBarTitle),
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
              listenWhen: (previous, current) =>
                  previous.error != current.error,
              listener: (context, state) {
                if (state.error != null && isPageVisible()) {
                  SnackBarManager()
                      .showSnackBarForException(state.error!.error);
                }
              },
            ),
          ],
          child: Column(
            children: [
              widget.isBottom ? const _DemoBottomView() : const _DemoView(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(L10n.global().dragAndDropRearrangeButtons),
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
