import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/controller/trusted_cert_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/widget/empty_list_indicator.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/server_cert_error_dialog.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'trusted_cert_manager.g.dart';
part 'trusted_cert_manager/bloc.dart';
part 'trusted_cert_manager/state_event.dart';
part 'trusted_cert_manager/view.dart';

class TrustedCertManager extends StatelessWidget {
  static const routeName = "/trusted-cert-manager";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
        builder: (_) => const TrustedCertManager(),
        settings: settings,
      );

  const TrustedCertManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(
        trustedCertController: context.read(),
        prefController: context.read(),
      )..add(const _Load()),
      child: const _WrappedTrustedCertManager(),
    );
  }
}

class _WrappedTrustedCertManager extends StatefulWidget {
  const _WrappedTrustedCertManager();

  @override
  State<StatefulWidget> createState() => _WrappedTrustedCertManagerState();
}

@npLog
class _WrappedTrustedCertManagerState extends State<_WrappedTrustedCertManager>
    with RouteAware, PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null && isPageVisible()) {
              if (state.error is TrustedCertControllerRemoveError) {
                SnackBarManager().showSnackBar(SnackBar(
                  content: Text(
                      L10n.global().trustedCertManagerFailedToRemoveCertError),
                  duration: k.snackBarDurationNormal,
                ));
              } else {
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.global().trustedCertManagerPageTitle),
          actions: [
            IconButton(
              onPressed: () => _onAddPressed(context),
              icon: const Icon(Icons.add_outlined),
            ),
          ],
        ),
        body: _BlocSelector<bool>(
          selector: (state) => state.isCertsReady,
          builder: (context, isCertsReady) =>
              isCertsReady ? const _ContentView() : const _InitView(),
        ),
      ),
    );
  }

  Future<void> _onAddPressed(BuildContext context) async {
    final result = await showDialog<Account>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.bloc,
        child: const _AccountDialog(),
      ),
    );
    if (result == null) {
      return;
    }
    try {
      await ApiUtil.fromAccount(result).status().get();
      // no exception == cert trusted either by system or by us
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().trustedCertManagerAlreadyTrustedError),
        duration: k.snackBarDurationNormal,
      ));
    } on HandshakeException {
      _onSelfSignedCert(context);
    }
  }

  void _onSelfSignedCert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ServerCertErrorDialog(),
    ).then((value) {
      if (value != true) {
        return;
      }
      showDialog(
        context: context,
        builder: (context) => const WhitelistLastBadCertDialog(),
      ).then((value) {
        if (value != true) {
          return;
        }
        context.addEvent(const _TrustCert());
      });
    });
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
