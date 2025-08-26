part of '../account_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required Account account,
    required this.prefController,
    required this.accountPrefController,
    required this.npDb,
    this.highlight,
  }) : super(
         _State.init(
           account: account,
           label: accountPrefController.accountLabelValue,
           shareFolder: accountPrefController.shareFolderValue,
           personProvider: accountPrefController.personProviderValue,
         ),
       ) {
    on<_SetLabel>(_onSetLabel);
    on<_OnUpdateLabel>(_onOnUpdateLabel);
    _subscriptions.add(
      accountPrefController.accountLabelChange.listen(
        (event) {
          add(_OnUpdateLabel(event));
        },
        onError: (e, stackTrace) {
          add(_SetError(_WritePrefError(e, stackTrace)));
        },
      ),
    );

    on<_SetAccount>(_onSetAccount);
    on<_OnUpdateAccount>(_onOnUpdateAccount);

    on<_SetShareFolder>(_onSetShareFolder);
    on<_OnUpdateShareFolder>(_onOnUpdateShareFolder);
    _subscriptions.add(
      accountPrefController.shareFolderChange.listen(
        (event) {
          add(_OnUpdateShareFolder(event));
        },
        onError: (e, stackTrace) {
          add(_SetError(_WritePrefError(e, stackTrace)));
        },
      ),
    );

    on<_SetPersonProvider>(_onSetPersonProvider);
    on<_OnUpdatePersonProvider>(_onOnUpdatePersonProvider);
    _subscriptions.add(
      accountPrefController.personProviderChange.listen(
        (event) {
          add(_OnUpdatePersonProvider(event));
        },
        onError: (e, stackTrace) {
          add(_SetError(_WritePrefError(e, stackTrace)));
        },
      ),
    );

    on<_SetError>(_onSetError);
  }

  @override
  String get tag => _log.fullName;

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
    return super.close();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // we need this to prevent onError being triggered recursively
    if (!isClosed && !_isHandlingError) {
      _isHandlingError = true;
      try {
        add(_SetError(error, stackTrace));
      } catch (_) {}
      _isHandlingError = false;
    }
    super.onError(error, stackTrace);
  }

  void _onSetLabel(_SetLabel ev, Emitter<_State> emit) {
    _log.info(ev);
    accountPrefController.setAccountLabel(ev.label);
  }

  void _onOnUpdateLabel(_OnUpdateLabel ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(label: ev.label));
  }

  Future<void> _onSetAccount(_SetAccount ev, Emitter<_State> emit) async {
    _log.info(ev);
    final revert = state.account;
    emit(state.copyWith(account: ev.account, shouldReload: true));
    try {
      final accounts = prefController.accountsValue;
      if (accounts.contains(ev.account)) {
        // conflict with another account. This normally won't happen because
        // the app passwords are unique to each entry, but just in case
        throw const _AccountConflictError();
      }

      final index = accounts.indexWhere((a) => a.id == ev.account.id);
      if (index < 0) {
        _log.shout("[_onSetAccount] Account not found: ${ev.account}");
        throw const _WritePrefError();
      }

      accounts[index] = ev.account;
      if (!await prefController.setAccounts(accounts)) {
        _log.severe("[_onSetAccount] Failed while setAccounts3: ${ev.account}");
        throw const _WritePrefError();
      }
      // clear files in db
      for (final r in {
        ...revert.roots,
        accountPrefController.shareFolderValue,
      }) {
        _log.info("[_onSetAccount] Delete dir: $r");
        try {
          final f = File(path: file_util.unstripPath(revert, r));
          await npDb.truncateDir(account: revert.toDb(), dir: f.toDbKey());
          await npDb.deleteFile(account: revert.toDb(), file: f.toDbKey());
        } catch (e, stackTrace) {
          _log.severe("[_onSetAccount] Failed deleting dir: $r", e, stackTrace);
        }
      }
    } catch (_) {
      emit(state.copyWith(account: revert));
      rethrow;
    }
  }

  void _onOnUpdateAccount(_OnUpdateAccount ev, Emitter<_State> emit) {
    _log.info(ev);
  }

  void _onSetShareFolder(_SetShareFolder ev, Emitter<_State> emit) {
    _log.info(ev);
    accountPrefController.setShareFolder(ev.shareFolder);
    emit(state.copyWith(shouldReload: true));
  }

  void _onOnUpdateShareFolder(_OnUpdateShareFolder ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(shareFolder: ev.shareFolder));
  }

  void _onSetPersonProvider(_SetPersonProvider ev, Emitter<_State> emit) {
    _log.info(ev);
    accountPrefController.setPersonProvider(ev.personProvider);
  }

  void _onOnUpdatePersonProvider(
    _OnUpdatePersonProvider ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    emit(state.copyWith(personProvider: ev.personProvider, shouldResync: true));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final PrefController prefController;
  final AccountPrefController accountPrefController;
  final AccountSettingsOption? highlight;
  final NpDb npDb;

  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
}
