import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'app_password_exchange_bloc.g.dart';

abstract class AppPasswordExchangeBlocEvent {
  const AppPasswordExchangeBlocEvent();
}

@toString
class AppPasswordExchangeBlocConnect extends AppPasswordExchangeBlocEvent {
  const AppPasswordExchangeBlocConnect(this.account);

  @override
  String toString() => _$toString();

  final Account account;
}

abstract class AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocState();
}

class AppPasswordExchangeBlocInit extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocInit();
}

@toString
class AppPasswordExchangeBlocSuccess extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocSuccess(this.password);

  @override
  String toString() => _$toString();

  @Format(r"${isDevMode ? password : '***'}")
  final String password;
}

@toString
class AppPasswordExchangeBlocFailure extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocFailure(this.exception);

  @override
  String toString() => _$toString();

  final dynamic exception;
}

/// Legacy sign in support, may be removed any time in the future
@npLog
class AppPasswordExchangeBloc
    extends Bloc<AppPasswordExchangeBlocEvent, AppPasswordExchangeBlocState> {
  AppPasswordExchangeBloc() : super(const AppPasswordExchangeBlocInit()) {
    on<AppPasswordExchangeBlocEvent>(_onEvent);
  }

  Future<void> _onEvent(AppPasswordExchangeBlocEvent event,
      Emitter<AppPasswordExchangeBlocState> emit) async {
    _log.info("[_onEvent] $event");
    if (event is AppPasswordExchangeBlocConnect) {
      await _onEventConnect(event, emit);
    }
  }

  Future<void> _onEventConnect(AppPasswordExchangeBlocConnect ev,
      Emitter<AppPasswordExchangeBlocState> emit) async {
    final account = ev.account;
    try {
      final appPwd = await _exchangePassword(account);
      emit(AppPasswordExchangeBlocSuccess(appPwd));
    } on InvalidBaseUrlException catch (e) {
      _log.warning("[_onEventConnect] Invalid base url");
      emit(AppPasswordExchangeBlocFailure(e));
    } on HandshakeException catch (e) {
      _log.info("[_onEventConnect] Self-signed cert");
      emit(AppPasswordExchangeBlocFailure(e));
    } catch (e, stacktrace) {
      if (e is ApiException && e.response.statusCode == 401) {
        // wrong password, normal
        _log.warning("[_onEventConnect] Server response 401, wrong password?");
      } else {
        _log.shout("[_onEventConnect] Failed while exchanging password", e,
            stacktrace);
      }
      emit(AppPasswordExchangeBlocFailure(e));
    }
  }

  /// Query the app password for [account]
  static Future<String> _exchangePassword(Account account) async {
    final response = await ApiUtil.fromAccount(account).request(
      "GET",
      "ocs/v2.php/core/getapppassword",
      header: {
        "OCS-APIRequest": "true",
      },
    );
    if (response.isGood) {
      try {
        final appPwdRegex = RegExp(r"<apppassword>(.*)</apppassword>");
        final appPwdMatch = appPwdRegex.firstMatch(response.body);
        return appPwdMatch!.group(1)!;
      } catch (_) {
        // this happens when the address is not the base URL and so Nextcloud
        // returned the login page
        throw InvalidBaseUrlException();
      }
    } else if (response.statusCode == 403) {
      // If the client is authenticated with an app password a 403 will be
      // returned
      _log.info("[_exchangePassword] Already an app password");
      return account.password;
    } else {
      _log.severe(
          "[_exchangePassword] Failed while requesting app password: $response");
      throw ApiException(
          response: response,
          message:
              "Server responed with an error: HTTP ${response.statusCode}");
    }
  }

  static final _log = _$AppPasswordExchangeBlocNpLog.log;
}
