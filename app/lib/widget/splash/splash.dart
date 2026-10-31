import 'dart:async';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/activity.dart';
import 'package:nc_photos/protected_page_handler.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/use_case/compat/v29.dart';
import 'package:nc_photos/use_case/compat/v46.dart';
import 'package:nc_photos/use_case/compat/v55.dart';
import 'package:nc_photos/use_case/compat/v75.dart';
import 'package:nc_photos/use_case/compat/v77.dart';
import 'package:nc_photos/use_case/compat/v79.dart';
import 'package:nc_photos/use_case/compat/v81.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/changelog/changelog.dart';
import 'package:nc_photos/widget/home/home.dart';
import 'package:nc_photos/widget/setup.dart';
import 'package:nc_photos/widget/sign_in/sign_in.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_exit_info/np_platform_exit_info.dart';
import 'package:np_platform_log/np_platform_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_string/to_string.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      create: (context) =>
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
            _BlocListener(
              listenWhen: (previous, current) =>
                  previous.isDone != current.isDone,
              listener: (context, state) {
                if (state.isDone) {
                  if (state.exitInfo != null) {
                    _askReportAndExit(context);
                  } else {
                    _exit(context);
                  }
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

  Future<void> _askReportAndExit(BuildContext context) async {
    _log.info("[_askReportAndExit]");
    final result = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => const _CrashReportDialog(),
    );
    if (result != true) {
      return _exit(context);
    }
    try {
      await _exportLog(context);
      await showAdaptiveDialog(
        context: context,
        builder: (context) => const _CrashReportSubmitDialog(),
      );
    } catch (e, stackTrace) {
      _log.shout("[_askReportAndExit] Failed while _exportLog", e, stackTrace);
      SnackBarManager().showSnackBar(
        const SnackBar(
          content: Text("Failed to save the log, please contact the developer"),
        ),
      );
    } finally {
      _exit(context);
    }
  }

  Future<void> _exportLog(BuildContext context) async {
    final log = await PlatformLog.dump();
    final exitInfo = context.state.exitInfo!;
    const appInfo = "App version: ${k.versionStr}";
    await FlutterFileSaver().writeFileAsString(
      fileName: "nc_photos_log.txt",
      data: "$exitInfo\n$appInfo\n$log",
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

class _CrashReportDialog extends StatelessWidget {
  const _CrashReportDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: Text(L10n.global().postCrashReportDialogText),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}

class _CrashReportSubmitDialog extends StatelessWidget {
  const _CrashReportSubmitDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: Text(L10n.global().postCrashReportSubmitDialogText),
      actions: [
        TextButton(
          onPressed: () {
            launchUrlString(
              "mailto:${help_util.contactEmail}?subject=nc-photos Crash Report&body=<Please attach the exported log file and briefly describe what happened before the crash>",
              mode: LaunchMode.externalNonBrowserApplication,
            );
            Navigator.of(context).pop();
          },
          child: Text(L10n.global().postCrashReportSubmitEmailButton),
        ),
        TextButton(
          onPressed: () {
            launch("https://nc-photos.web.app/link/issue");
            Navigator.of(context).pop();
          },
          child: const Text("GitHub"),
        ),
      ],
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
