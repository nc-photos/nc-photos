import 'dart:math';

import 'package:copy_with/copy_with.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/animation_util.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:np_collection/np_collection.dart';
import 'package:np_common/unique.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'protected_page_pin_auth_dialog.g.dart';
part 'protected_page_pin_auth_dialog/bloc.dart';
part 'protected_page_pin_auth_dialog/state_event.dart';
part 'protected_page_pin_auth_dialog/view.dart';

class ProtectedPagePinAuthDialog extends StatelessWidget {
  const ProtectedPagePinAuthDialog({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _Bloc(
            pin: pin,
            removeItemBuilder:
                (_, animation, value) =>
                    _RemoveItem(animation: animation, value: value),
          ),
      child: _WrappedProtectedPagePinAuthDialog(),
    );
  }

  final CiString pin;
}

class _WrappedProtectedPagePinAuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.isAuthorized,
          listener: (context, isAuthorized) {
            if (isAuthorized) {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
      child: AlertDialog(
        title: Text(L10n.global().appLockUnlockHint),
        scrollable: true,
        content: const _DialogBody(),
      ),
    );
  }
}

class ProtectedPagePinSetupDialog extends StatelessWidget {
  const ProtectedPagePinSetupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _Bloc(
            pin: null,
            removeItemBuilder:
                (_, animation, value) =>
                    _RemoveItem(animation: animation, value: value),
          ),
      child: _WrappedProtectedPagePinSetupDialog(),
    );
  }
}

class _WrappedProtectedPagePinSetupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.setupResult,
          listener: (context, setupResult) {
            if (setupResult != null) {
              Navigator.of(context).pop(setupResult);
            }
          },
        ),
      ],
      child: AlertDialog(
        title: Text(L10n.global().settingsAppLockSetupPinDialogTitle),
        scrollable: true,
        content: const _DialogBody(),
      ),
    );
  }
}

class ProtectedPagePinConfirmDialog extends StatelessWidget {
  const ProtectedPagePinConfirmDialog({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _Bloc(
            pin: pin,
            removeItemBuilder:
                (_, animation, value) =>
                    _RemoveItem(animation: animation, value: value),
          ),
      child: _WrappedProtectedPagePinConfirmDialog(),
    );
  }

  final CiString pin;
}

class _WrappedProtectedPagePinConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.isAuthorized,
          listener: (context, isAuthorized) {
            if (isAuthorized) {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
      child: AlertDialog(
        title: Text(L10n.global().settingsAppLockConfirmPinDialogTitle),
        scrollable: true,
        content: const _DialogBody(),
      ),
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
