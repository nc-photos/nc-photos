import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'double_tap_exit_container.g.dart';
part 'state_event.dart';

class DoubleTapExitContainer extends StatelessWidget {
  const DoubleTapExitContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(prefController: context.read()),
      child: _WrappedDoubleTapExitContainer(child: child),
    );
  }

  final Widget child;
}

class _WrappedDoubleTapExitContainer extends StatelessWidget {
  const _WrappedDoubleTapExitContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.isDoubleTapExit != current.isDoubleTapExit ||
              previous.canPop != current.canPop,
      builder:
          (context, state) => PopScope(
            canPop: !state.isDoubleTapExit || state.canPop,
            onPopInvokedWithResult: (didPop, result) {
              context.addEvent(_OnPopInvoked(didPop));
            },
            child: child,
          ),
    );
  }

  final Widget child;
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
// typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
