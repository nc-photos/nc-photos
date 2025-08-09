import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/exception.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'app_password_exchange.g.dart';

abstract class AppPasswordExchangeBlocEvent {
  const AppPasswordExchangeBlocEvent();
}

/// Group of events that are handled sequentially
abstract class AppPasswordExchangeBlocEventGroup1
    extends AppPasswordExchangeBlocEvent {
  const AppPasswordExchangeBlocEventGroup1();
}

@toString
class AppPasswordExchangeBlocInitiateLogin
    extends AppPasswordExchangeBlocEventGroup1 {
  const AppPasswordExchangeBlocInitiateLogin(this.uri);

  @override
  String toString() => _$toString();

  final Uri uri;
}

@toString
class AppPasswordExchangeBlocPoll extends AppPasswordExchangeBlocEventGroup1 {
  const AppPasswordExchangeBlocPoll(this.pollOptions);

  @override
  String toString() => _$toString();

  final api_util.InitiateLoginPollOptions pollOptions;
}

@toString
class AppPasswordExchangeBlocCancel extends AppPasswordExchangeBlocEvent {
  const AppPasswordExchangeBlocCancel();

  @override
  String toString() => _$toString();
}

@toString
class _AppPasswordExchangeBlocAppPwReceived
    extends AppPasswordExchangeBlocEventGroup1 {
  const _AppPasswordExchangeBlocAppPwReceived(this.appPasswordResponse);

  @override
  String toString() => _$toString();

  final api_util.AppPasswordSuccess appPasswordResponse;
}

@toString
class _AppPasswordExchangeBlocAppPwFailed
    extends AppPasswordExchangeBlocEventGroup1 {
  const _AppPasswordExchangeBlocAppPwFailed(this.exception);

  @override
  String toString() => _$toString();

  final dynamic exception;
}

abstract class AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocState();
}

class AppPasswordExchangeBlocInit extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocInit();
}

@toString
class AppPasswordExchangeBlocInitiateLoginSuccess
    extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocInitiateLoginSuccess(this.result);

  @override
  String toString() => _$toString();

  final api_util.InitiateLoginResponse result;
}

@toString
class AppPasswordExchangeBlocAppPwSuccess extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocAppPwSuccess(this.result);

  @override
  String toString() => _$toString();

  final api_util.AppPasswordSuccess result;
}

@toString
class AppPasswordExchangeBlocFailure extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocFailure(this.exception);

  @override
  String toString() => _$toString();

  final dynamic exception;
}

@toString
class AppPasswordExchangeBlocResult extends AppPasswordExchangeBlocState {
  const AppPasswordExchangeBlocResult(this.result);

  @override
  String toString() => _$toString();

  final Account? result;
}

/// Business Logic Component (BLoC) which handles the App password exchange.
///
/// The flow followed by this component is described in the Nextcloud documentation under
/// https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2
///
/// ```
/// Event [AppPasswordExchangeBlocInitiateLogin]  -> State [AppPasswordExchangeBlocInitiateLoginSuccess]
///                                               -> State [AppPasswordExchangeBlocFailure]
/// Event [AppPasswordExchangeBlocPoll]           -> Event [AppPasswordExchangeBlocAppPwReceived]
///                                               -> Event [AppPasswordExchangeBlocAppPwFailed]
/// Event [AppPasswordExchangeBlocAppPwReceived]  -> State [AppPasswordExchangeBlocAppPwSuccess]
///                                               -> State [AppPasswordExchangeBlocFailure]
/// Event [AppPasswordExchangeBlocAppPwFailed]    -> State [AppPasswordExchangeBlocFailure]
/// ```
@npLog
class AppPasswordExchangeBloc
    extends Bloc<AppPasswordExchangeBlocEvent, AppPasswordExchangeBlocState> {
  AppPasswordExchangeBloc() : super(const AppPasswordExchangeBlocInit()) {
    on<AppPasswordExchangeBlocEventGroup1>(_onEventGroup1);
    on<AppPasswordExchangeBlocCancel>(_onEventCancel);
  }

  @override
  Future<void> close() {
    _pollPasswordSubscription?.cancel();
    return super.close();
  }

  Future<void> _onEventGroup1(
    AppPasswordExchangeBlocEvent event,
    Emitter<AppPasswordExchangeBlocState> emit,
  ) async {
    _log.info("[_onEventGroup1] $event");
    if (_isCanceled) {
      _log.fine("[_onEventGroup1] canceled = true, ignore event");
      return;
    }
    if (event is AppPasswordExchangeBlocInitiateLogin) {
      await _onEventInitiateLogin(event, emit);
    } else if (event is AppPasswordExchangeBlocPoll) {
      await _onEventPoll(event, emit);
    } else if (event is _AppPasswordExchangeBlocAppPwReceived) {
      await _onEventAppPasswordReceived(event, emit);
    } else if (event is _AppPasswordExchangeBlocAppPwFailed) {
      await _onEventAppPasswordFailure(event, emit);
    }
  }

  Future<void> _onEventInitiateLogin(
    AppPasswordExchangeBlocInitiateLogin ev,
    Emitter<AppPasswordExchangeBlocState> emit,
  ) async {
    final uri = ev.uri;
    try {
      final initiateLoginResponse = await api_util.initiateLogin(uri);
      emit(AppPasswordExchangeBlocInitiateLoginSuccess(initiateLoginResponse));
    } on InvalidBaseUrlException catch (e) {
      _log.warning("[_onEventInitiateLogin] Invalid base url");
      emit(AppPasswordExchangeBlocFailure(e));
    } on HandshakeException catch (e) {
      _log.info("[_onEventInitiateLogin] Self-signed cert");
      emit(AppPasswordExchangeBlocFailure(e));
    } catch (e, stacktrace) {
      _log.shout(
        "[_onEventInitiateLogin] Failed while exchanging password",
        e,
        stacktrace,
      );
      emit(AppPasswordExchangeBlocFailure(e));
    }
  }

  Future<void> _onEventPoll(
    AppPasswordExchangeBlocPoll ev,
    Emitter<AppPasswordExchangeBlocState> emit,
  ) async {
    final pollOptions = ev.pollOptions;
    try {
      await _pollPasswordSubscription?.cancel();
      _pollPasswordSubscription = api_util
          .pollAppPassword(pollOptions)
          .listen(_pollAppPasswordStreamListener);
    } catch (e, stacktrace) {
      await _pollPasswordSubscription?.cancel();
      _log.shout(
        "[_onEventPoll] Failed while polling for password",
        e,
        stacktrace,
      );
      emit(AppPasswordExchangeBlocFailure(e));
    }
  }

  Future<void> _pollAppPasswordStreamListener(event) async {
    try {
      final appPasswordResponse = await event;
      if (appPasswordResponse is api_util.AppPasswordSuccess) {
        await _pollPasswordSubscription?.cancel();
        add(_AppPasswordExchangeBlocAppPwReceived(appPasswordResponse));
      }
    } catch (e, stacktrace) {
      _log.shout(
        "[_pollAppPasswordStreamListener] Failed while polling for password",
        e,
        stacktrace,
      );
      add(_AppPasswordExchangeBlocAppPwFailed(e));
    }
  }

  Future<void> _onEventAppPasswordReceived(
    _AppPasswordExchangeBlocAppPwReceived ev,
    Emitter<AppPasswordExchangeBlocState> emit,
  ) async {
    try {
      final response = ev.appPasswordResponse;
      final account = Account(
        id: Account.newId(),
        scheme: response.server.scheme,
        address:
            response.server.authority +
            (response.server.path.isEmpty ? "" : response.server.path),
        userId: response.loginName.toCi(),
        username2: response.loginName,
        password: response.appPassword,
        roots: [""],
      );
      emit(AppPasswordExchangeBlocResult(account));
    } catch (e, stacktrace) {
      _log.shout(
        "[_onEventAppPasswordReceived] Failed while exchanging password",
        e,
        stacktrace,
      );
      emit(AppPasswordExchangeBlocFailure(e));
    }
  }

  Future<void> _onEventAppPasswordFailure(
    _AppPasswordExchangeBlocAppPwFailed ev,
    Emitter<AppPasswordExchangeBlocState> emit,
  ) async {
    await _pollPasswordSubscription?.cancel();
    emit(AppPasswordExchangeBlocFailure(ev.exception));
  }

  Future<void> _onEventCancel(
    AppPasswordExchangeBlocCancel ev,
    Emitter<AppPasswordExchangeBlocState> emit,
  ) async {
    await _pollPasswordSubscription?.cancel();
    _isCanceled = true;
    emit(const AppPasswordExchangeBlocResult(null));
  }

  StreamSubscription<Future<api_util.AppPasswordResponse>>?
  _pollPasswordSubscription;
  bool _isCanceled = false;
}
