import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_init.dart' as app_init;
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/widget/my_app.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app_init.init(app_init.InitIsolateType.main);

  if (getRawPlatform().isMobile) {
    // reset orientation override just in case, see #59
    unawaited(SystemChrome.setPreferredOrientations([]));
  }
  Bloc.observer = const _BlocObserver();
  Bloc.transformer = sequential();
  runApp(const MyApp());
}

@npLog
class _BlocObserver extends BlocObserver {
  const _BlocObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is BlocLogger) {
      final bl = bloc as BlocLogger;
      final tag = bl.tag ?? bloc.runtimeType;
      if (bl.shouldLog?.call(change.currentState, change.nextState) ?? true) {
        _log.finer("$tag newState: ${change.nextState}");
      }
    } else {
      _log.finer("${bloc.runtimeType} newState: ${change.nextState}");
    }
  }
}
