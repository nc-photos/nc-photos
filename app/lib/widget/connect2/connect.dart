import 'dart:async';
import 'dart:io';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/widget/cloud_progress_indicator.dart';
import 'package:np_common/unique.dart';
import 'package:np_log/np_log.dart';
import 'package:np_login_flow/np_login_flow.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'connect.g.dart';
part 'state_event.dart';
part 'type.dart';
part 'view.dart';

class ConnectArguments {
  const ConnectArguments(this.uri, this.login);

  final Uri uri;
  final LoginFlow login;
}

class Connect extends StatelessWidget {
  static const routeName = "/connect";

  static Route buildRoute(ConnectArguments args, RouteSettings settings) =>
      MaterialPageRoute<Account>(
        builder: (context) => Connect.fromArgs(args),
        settings: settings,
      );

  const Connect({super.key, required this.uri, required this.login});

  Connect.fromArgs(ConnectArguments args, {Key? key})
    : this(key: key, uri: args.uri, login: args.login);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _Bloc(uri: uri, login: login)..add(const _Login()),
      child: const _WrappedConnect(),
    );
  }

  final Uri uri;
  final LoginFlow login;
}

class _WrappedConnect extends StatelessWidget {
  const _WrappedConnect();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context).copyWith(
        scaffoldBackgroundColor: Theme.of(context).nextcloudBlue,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white,
        ),
      ),
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            context.bloc.login
              ..interrupt()
              ..dispose();
          }
        },
        child: Scaffold(
          body: MultiBlocListener(
            listeners: [
              _BlocListenerT(
                selector: (state) => state.error,
                listener: (context, error) {
                  if (error != null) {
                    if (error.error is HandshakeException &&
                        features.isSupportSelfSignedCert) {
                      if (SelfSignedCertManager().hasBadCert) {
                        _onSelfSignedCert(context);
                      } else {
                        SnackBarManager().showSnackBar(
                          SnackBar(
                            content: Text(L10n.global().errorServerNoCert),
                            duration: k.snackBarDurationNormal,
                          ),
                        );
                        Navigator.of(context).pop(null);
                      }
                    } else if (error.error is LoginException &&
                        (error.error as LoginException).response.statusCode ==
                            401) {
                      SnackBarManager().showSnackBar(
                        SnackBar(
                          content: Text(L10n.global().errorWrongPassword),
                          duration: k.snackBarDurationNormal,
                        ),
                      );
                      Navigator.of(context).pop(null);
                    } else {
                      SnackBarManager().showSnackBar(
                        SnackBar(
                          content: Text(
                            exception_util.toUserString(error.error),
                          ),
                          duration: k.snackBarDurationNormal,
                        ),
                      );
                      Navigator.of(context).pop(null);
                    }
                  }
                },
              ),
              _BlocListenerT(
                selector: (state) => state.askWebDavUrlRequest,
                listener: (context, askWebDavUrlRequest) {
                  if (askWebDavUrlRequest.value != null) {
                    _onCheckWebDavUrlFailed(
                      context,
                      askWebDavUrlRequest.value!.account,
                    );
                  }
                },
              ),
              _BlocListenerT(
                selector: (state) => state.cancelRequest,
                listener: (context, cancelRequest) {
                  if (cancelRequest) {
                    Navigator.of(context).pop(null);
                  }
                },
              ),
              _BlocListenerT(
                selector: (state) => state.result,
                listener: (context, result) {
                  if (result != null) {
                    Navigator.of(context).pop(result);
                  }
                },
              ),
            ],
            child: const SafeArea(child: _Body()),
          ),
        ),
      ),
    );
  }

  Future<void> _onSelfSignedCert(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(L10n.global().serverCertErrorDialogTitle),
            content: Text(L10n.global().serverCertErrorDialogContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(L10n.global().advancedButtonLabel),
              ),
            ],
          ),
    );
    if (context.mounted && result != true) {
      Navigator.of(context).pop(null);
      return;
    }
    final advancedResult = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(L10n.global().whitelistCertDialogTitle),
            content: Text(
              L10n.global().whitelistCertDialogContent(
                SelfSignedCertManager().getLastBadCertHost(),
                SelfSignedCertManager().getLastBadCertFingerprint(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(L10n.global().whitelistCertButtonLabel),
              ),
            ],
          ),
    );
    if (context.mounted && advancedResult != true) {
      Navigator.of(context).pop(null);
      return;
    }
    try {
      await SelfSignedCertManager().whitelistLastBadCert();
    } finally {
      Navigator.of(context).pop(null);
    }
  }

  Future<void> _onCheckWebDavUrlFailed(
    BuildContext context,
    Account account,
  ) async {
    final userId = await _askWebDavUrl(context, account);
    if (userId != null) {
      context.addEvent(_SetUserId(userId));
    }
  }

  Future<String?> _askWebDavUrl(BuildContext context, Account account) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _WebDavUrlDialog(account: account),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Theme.of(context).widthLimitedContentMaxWidth,
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CloudProgressIndicator(size: 192),
                    const SizedBox(height: 16),
                    Text(
                      L10n.global().connectingToServer2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (context.bloc.login is ServerFlowV2)
                      Text(
                        L10n.global().connectingToServerInstruction,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      context.addEvent(const _Cancel());
                    },
                    child: Text(
                      MaterialLocalizations.of(context).cancelButtonLabel,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
// typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
