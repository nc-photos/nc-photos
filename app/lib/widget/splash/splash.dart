import 'dart:async';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/activity.dart';
import 'package:nc_photos/mobile/android/permission_util.dart';
import 'package:nc_photos/protected_page_handler.dart';
import 'package:nc_photos/use_case/compat/v29.dart';
import 'package:nc_photos/use_case/compat/v46.dart';
import 'package:nc_photos/use_case/compat/v55.dart';
import 'package:nc_photos/use_case/compat/v75.dart';
import 'package:nc_photos/use_case/compat/v77.dart';
import 'package:nc_photos/use_case/compat/v79.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/changelog/changelog.dart';
import 'package:nc_photos/widget/home/home.dart';
import 'package:nc_photos/widget/setup.dart';
import 'package:nc_photos/widget/sign_in/sign_in.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_permission/np_platform_permission.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'splash.g.dart';
part 'state_event.dart';
part 'view.dart';

class Splash extends StatelessWidget {
  static const routeName = "/splash";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (context) => const Splash(),
    settings: settings,
  );

  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              _Bloc(prefController: context.read(), npDb: context.read())
                ..add(const _Init()),
      child: const _WrappedSplash(),
    );
  }
}

@npLog
class _WrappedSplash extends StatelessWidget {
  const _WrappedSplash();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            _BlocListenerT<int?>(
              selector: (state) => state.changelogFromVersion,
              listener: (context, changelogFromVersion) {
                if (changelogFromVersion != null) {
                  Navigator.of(context)
                      .pushNamed(
                        Changelog.routeName,
                        arguments: ChangelogArguments(changelogFromVersion),
                      )
                      .whenComplete(() {
                        if (context.mounted) {
                          context.addEvent(const _ChangelogDismissed());
                        }
                      });
                }
              },
            ),
            _BlocListenerT<bool>(
              selector: (state) => state.isDone,
              listener: (context, isDone) {
                if (isDone) {
                  _exit(context);
                }
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud,
                      size: 96,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      L10n.global().appTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 64,
                  child: _UpgradeProgressView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _exit(BuildContext context) {
    _log.info("[_exit]");
    final account = context.read<PrefController>().currentAccountValue;
    if (isNeedSetup()) {
      Navigator.of(context).pushReplacementNamed(Setup.routeName);
    } else if (account == null) {
      Navigator.of(context).pushReplacementNamed(SignIn.routeName);
    } else {
      Navigator.of(context)
          .pushReplacementNamedProtected(
            Home.routeName,
            arguments: HomeArguments(account),
          )
          .then((value) async {
            if (getRawPlatform() == NpPlatform.android) {
              final initialRoute = await Activity.consumeInitialRoute();
              if (initialRoute != null) {
                unawaited(Navigator.of(context).pushNamed(initialRoute));
              }
            }
          })
          .onError<ProtectedPageAuthException>((_, __) async {
            _log.warning("[_exit] Auth failed");
            await Future.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              _exit(context);
            }
            return null;
          });
    }
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
