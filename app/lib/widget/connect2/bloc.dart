part of 'connect.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocErrorCatcher<_Event, _State> {
  _Bloc({
    required this.uri,
    required this.login,
  }) : super(_State.init()) {
    on<_Login>(_onLogin);
    on<_SetUserId>(_onSetUserId);
    on<_SetError>(_onSetError);
    on<_Cancel>(_onCancel);
  }

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  @override
  void handleBlocError(Object error, StackTrace stackTrace) {
    add(_SetError(error, stackTrace));
  }

  Future<void> _onLogin(_Login ev, _Emitter emit) async {
    _log.info(ev);
    try {
      final result = await login.login(uri: uri);
      if (isClosed) {
        return;
      }
      final account = Account(
        id: Account.newId(),
        scheme: uri.scheme,
        address: uri.authority + (uri.path.isEmpty ? "" : uri.path),
        userId: result.username.toCi(),
        username2: result.username,
        password: result.password,
        roots: [""],
      );
      await _checkWebDavUrl(account);
      emit(state.copyWith(result: account));
    } on LoginInterruptedException catch (_) {
      // do nothing
    } on _InvalidWevDavUrlException catch (e) {
      emit(state.copyWith(
        askWebDavUrlRequest: Unique(_AskWebDavUrlRequest(e.account)),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(error: (error: e, stackTrace: stackTrace)));
    }
  }

  Future<void> _onSetUserId(_SetUserId ev, _Emitter emit) async {
    _log.info(ev);
    final account = state.askWebDavUrlRequest.value!.account.copyWith(
      userId: ev.value.toCi(),
    );
    try {
      await _checkWebDavUrl(account);
      emit(state.copyWith(result: account));
    } on _InvalidWevDavUrlException catch (e) {
      emit(state.copyWith(
        askWebDavUrlRequest: Unique(_AskWebDavUrlRequest(e.account)),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(error: (error: e, stackTrace: stackTrace)));
    }
  }

  void _onSetError(_SetError ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(error: (error: ev.error, stackTrace: ev.stackTrace)));
  }

  void _onCancel(_Cancel ev, _Emitter emit) {
    _log.info(ev);
    login.interrupt();
    emit(state.copyWith(cancelRequest: true));
  }

  // check the WebDAV URL
  Future<void> _checkWebDavUrl(Account account) async {
    _log.info("[_checkWebDavUrl] $account");
    try {
      final c = KiwiContainer().resolve<DiContainer>();
      await LsSingleFile(c.withRemoteFileRepo())(
          account, file_util.unstripPath(account, ""));
      _log.info("[_checkWebDavUrl] Account is good: $account");
    } on ApiException catch (e) {
      if (e.response.statusCode == 404) {
        throw _InvalidWevDavUrlException(account: account);
      }
      rethrow;
    } on StateError catch (_) {
      // Nextcloud for some reason doesn't return HTTP error when listing home
      // dir of other users
      throw _InvalidWevDavUrlException(account: account);
    } catch (e, stackTrace) {
      _log.shout("[_checkWebDavUrl] Failed", e, stackTrace);
      rethrow;
    }
  }

  final Uri uri;
  final LoginFlow login;

  final _subscriptions = <StreamSubscription>[];
}
