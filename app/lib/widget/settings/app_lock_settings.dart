import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/protected_page_handler.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/protected_page_password_auth_dialog/protected_page_password_auth_dialog.dart';
import 'package:nc_photos/widget/protected_page_pin_auth_dialog/protected_page_pin_auth_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'app_lock/bloc.dart';
part 'app_lock/state_event.dart';
part 'app_lock_settings.g.dart';

class AppLockSettings extends StatelessWidget {
  const AppLockSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(securePrefController: context.read()),
      child: const _WrappedAppLockSettings(),
    );
  }
}

class _WrappedAppLockSettings extends StatelessWidget {
  const _WrappedAppLockSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.global().settingsAppLock),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _BlocSelector<ProtectedPageAuthType?>(
                    selector: (state) => state.appLockType,
                    builder:
                        (context, appLockType) => Icon(
                          appLockType == null
                              ? Icons.lock_open_outlined
                              : Icons.lock_outlined,
                          size: 24,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _BlocSelector<ProtectedPageAuthType?>(
                    selector: (state) => state.appLockType,
                    builder:
                        (context, appLockType) => Text(
                          appLockType == null
                              ? L10n.global().disabledText
                              : L10n.global().enabledText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textStyleColored(
                            (textTheme) => textTheme.titleSmall,
                            (colorScheme) =>
                                appLockType == null
                                    ? colorScheme.error
                                    : colorScheme.primary,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(L10n.global().settingsAppLockDescription),
                  ),
                  const SizedBox(height: 16),
                  _BlocSelector<ProtectedPageAuthType?>(
                    selector: (state) => state.appLockType,
                    builder:
                        (context, appLockType) => RadioListTile(
                          value: null,
                          groupValue: appLockType,
                          title: Text(L10n.global().disabledText),
                          onChanged: (value) async {
                            if (await _confirmDisable(context)) {
                              context.addEvent(_SetAppLockType(value));
                            }
                          },
                        ),
                  ),
                  _BlocSelector<ProtectedPageAuthType?>(
                    selector: (state) => state.appLockType,
                    builder:
                        (context, appLockType) => RadioListTile(
                          value: ProtectedPageAuthType.biometric,
                          groupValue: appLockType,
                          title: Text(
                            L10n.global().settingsAppLockTypeBiometric,
                          ),
                          onChanged: (value) async {
                            if (await _confirmBiometric(context) == true) {
                              context.addEvent(_SetAppLockType(value));
                            }
                          },
                        ),
                  ),
                  _BlocSelector<ProtectedPageAuthType?>(
                    selector: (state) => state.appLockType,
                    builder:
                        (context, appLockType) => RadioListTile(
                          value: ProtectedPageAuthType.pin,
                          groupValue: appLockType,
                          title: Text(L10n.global().settingsAppLockTypePin),
                          onChanged: (value) async {
                            if (await _confirmPin(context) == true) {
                              context.addEvent(_SetAppLockType(value));
                            }
                          },
                        ),
                  ),
                  _BlocSelector<ProtectedPageAuthType?>(
                    selector: (state) => state.appLockType,
                    builder:
                        (context, appLockType) => RadioListTile(
                          value: ProtectedPageAuthType.password,
                          groupValue: appLockType,
                          title: Text(
                            L10n.global().settingsAppLockTypePassword,
                          ),
                          onChanged: (value) async {
                            if (await _confirmPassword(context) == true) {
                              context.addEvent(_SetAppLockType(value));
                            }
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDisable(BuildContext context) async {
    final prefController = context.read<SecurePrefController>();
    final result = await prefController.setProtectedPageAuthType(null);
    if (result) {
      return true;
    } else {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().writePreferenceFailureNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      return false;
    }
  }

  Future<bool?> _confirmBiometric(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (_) => SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Text(
                  L10n.global()
                      .settingsAppLockSetupBiometricFallbackDialogTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SimpleDialogOption(
                child: ListTile(
                  title: Text(L10n.global().settingsAppLockTypePin),
                ),
                onPressed: () async {
                  final result = await _enterPin(context);
                  if (result == true) {
                    Navigator.of(context).pop(true);
                  } else if (result == false) {
                    SnackBarManager().showSnackBar(
                      SnackBar(
                        content: Text(
                          L10n.global().writePreferenceFailureNotification,
                        ),
                        duration: k.snackBarDurationNormal,
                      ),
                    );
                  }
                },
              ),
              SimpleDialogOption(
                child: ListTile(
                  title: Text(L10n.global().settingsAppLockTypePassword),
                ),
                onPressed: () async {
                  final result = await _enterPassword(context);
                  if (result == true) {
                    Navigator.of(context).pop(true);
                  } else if (result == false) {
                    SnackBarManager().showSnackBar(
                      SnackBar(
                        content: Text(
                          L10n.global().writePreferenceFailureNotification,
                        ),
                        duration: k.snackBarDurationNormal,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
    if (result != true) {
      return result;
    }
    return context.bloc.securePrefController.setProtectedPageAuthType(
      ProtectedPageAuthType.biometric,
    );
  }

  Future<bool?> _confirmPin(BuildContext context) async {
    final result = await _enterPin(context);
    if (result == true) {
      return context.bloc.securePrefController.setProtectedPageAuthType(
        ProtectedPageAuthType.pin,
      );
    } else if (result == false) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().writePreferenceFailureNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      return false;
    } else {
      return null;
    }
  }

  Future<bool?> _confirmPassword(BuildContext context) async {
    final result = await _enterPassword(context);
    if (result == true) {
      return context.bloc.securePrefController.setProtectedPageAuthType(
        ProtectedPageAuthType.password,
      );
    } else if (result == false) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().writePreferenceFailureNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      return false;
    } else {
      return null;
    }
  }

  Future<bool?> _enterPin(BuildContext context) async {
    final result = await showDialog<CiString>(
      context: context,
      builder: (_) => const ProtectedPagePinSetupDialog(),
    );
    if (result == null) {
      return null;
    }
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ProtectedPagePinConfirmDialog(pin: result),
    );
    if (isConfirmed != true) {
      return null;
    }
    return context.bloc.securePrefController.setProtectedPageAuthPin(result);
  }

  Future<bool?> _enterPassword(BuildContext context) async {
    final result = await showDialog<CiString>(
      context: context,
      builder: (_) => const ProtectedPagePasswordSetupDialog(),
    );
    if (result == null) {
      return null;
    }
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ProtectedPagePasswordConfirmDialog(password: result),
    );
    if (isConfirmed != true) {
      return null;
    }
    return context.bloc.securePrefController.setProtectedPageAuthPassword(
      result,
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
