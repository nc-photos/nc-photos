import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/widget/protected_page_password_auth_dialog.dart';
import 'package:nc_photos/widget/protected_page_pin_auth_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'protected_page_handler.g.dart';

enum ProtectedPageAuthType {
  biometric,
  pin,
  password,
  ;
}

class ProtectedPageAuthException implements Exception {
  const ProtectedPageAuthException([this.message]);

  @override
  String toString() => "ProtectedPageAuthException: $message";

  final dynamic message;
}

extension ProtectedPageBuildContextExtension on NavigatorState {
  Future<T?>
      pushReplacementNamedProtected<T extends Object?, U extends Object?>(
    String routeName, {
    U? result,
    Object? arguments,
  }) async {
    if (await authProtectedPage()) {
      return pushReplacementNamed(routeName,
          arguments: arguments, result: result);
    } else {
      throw const ProtectedPageAuthException();
    }
  }

  Future<T?> pushNamedProtected<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    if (await authProtectedPage()) {
      return pushNamed(routeName, arguments: arguments);
    } else {
      throw const ProtectedPageAuthException();
    }
  }

  Future<T?> pushProtected<T extends Object?>(Route<T> route) async {
    if (await authProtectedPage()) {
      return push(route);
    } else {
      throw const ProtectedPageAuthException();
    }
  }

  Future<bool> authProtectedPage() async {
    final securePrefController = context.read<SecurePrefController>();
    switch (securePrefController.protectedPageAuthTypeValue) {
      case null:
        // unprotected
        return true;
      case ProtectedPageAuthType.biometric:
        return _authBiometric(securePrefController);
      case ProtectedPageAuthType.pin:
        return _authPin(securePrefController);
      case ProtectedPageAuthType.password:
        return _authPassword(securePrefController);
    }
  }

  Future<bool> _authBiometric(SecurePrefController securePrefController) async {
    if (await _BiometricAuthHandler().auth()) {
      return true;
    } else {
      if (securePrefController.protectedPageAuthPasswordValue != null) {
        return _authPassword(securePrefController);
      } else {
        return _authPin(securePrefController);
      }
    }
  }

  Future<bool> _authPin(SecurePrefController securePrefController) =>
      _PinAuthHandler(context, securePrefController.protectedPageAuthPinValue!)
          .auth();

  Future<bool> _authPassword(SecurePrefController securePrefController) =>
      _PasswordAuthHandler(
              context, securePrefController.protectedPageAuthPasswordValue!)
          .auth();
}

abstract class _AuthHandler {
  Future<bool> auth();
}

@npLog
class _BiometricAuthHandler implements _AuthHandler {
  @override
  Future<bool> auth() async {
    try {
      final localAuth = LocalAuthentication();
      final available = await localAuth.getAvailableBiometrics();
      if (available.isEmpty) {
        return false;
      }
      return await localAuth.authenticate(
        localizedReason: L10n.global().appLockUnlockHint,
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e, stackTrace) {
      _log.severe("[auth] Exception", e, stackTrace);
      return false;
    }
  }
}

class _PinAuthHandler implements _AuthHandler {
  const _PinAuthHandler(this.context, this.pin);

  @override
  Future<bool> auth() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProtectedPagePinAuthDialog(pin: pin),
    );
    return result == true;
  }

  final BuildContext context;
  final CiString pin;
}

class _PasswordAuthHandler implements _AuthHandler {
  const _PasswordAuthHandler(this.context, this.password);

  @override
  Future<bool> auth() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProtectedPagePasswordAuthDialog(password: password),
    );
    return result == true;
  }

  final BuildContext context;
  final CiString password;
}
