part of 'account_picker_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.accountController,
    required this.prefController,
    required this.db,
  }) : super(_State.init(accounts: prefController.accountsValue)) {
    on<_ToggleDropdown>(_onToggleDropdown);
    on<_SwitchAccount>(_onSwitchAccount);
    on<_DeleteAccount>(_onDeleteAccount);
    on<_SetDarkTheme>(_onSetDarkTheme);

    on<_SetError>(_onSetError);
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

  @override
  String get tag => _log.fullName;

  void _onToggleDropdown(_ToggleDropdown ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isOpenDropdown: !state.isOpenDropdown));
  }

  Future<void> _onSwitchAccount(_SwitchAccount ev, Emitter<_State> emit) async {
    _log.info(ev);
    await _prefLock.protect(() async {
      final index = state.accounts.indexOf(ev.account);
      if (index == -1) {
        throw StateError("Account not found");
      }
      await prefController.setCurrentAccountIndex(index);
      emit(state.copyWith(newSelectAccount: ev.account));
    });
  }

  Future<void> _onDeleteAccount(_DeleteAccount ev, Emitter<_State> emit) async {
    _log.info(ev);
    emit(
      state.copyWith(
        accounts: state.accounts.where((a) => a.id != ev.account.id).toList(),
      ),
    );
    try {
      await _prefLock.protect(() async {
        final accounts = prefController.accountsValue;
        final currentAccount =
            accounts[prefController.currentAccountIndexValue!];
        accounts.remove(ev.account);
        final newAccountIndex = accounts.indexOf(currentAccount);
        if (newAccountIndex == -1) {
          throw StateError(
            "Active account not found in resulting account list",
          );
        }
        try {
          await AccountPref.of(ev.account).provider.clear();
        } catch (e, stackTrace) {
          _log.shout(
            "[_onDeleteAccount] Failed while removing account pref",
            e,
            stackTrace,
          );
        }
        await prefController.setAccounts(accounts);
        await prefController.setCurrentAccountIndex(newAccountIndex);

        // check if the same account (server + userId) still exists in known
        // accounts
        if (!accounts.any(
          (a) => a.url == ev.account.url && a.userId == ev.account.userId,
        )) {
          // account removed, clear cache db
          unawaited(_removeAccountFromDb(ev.account));
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  void _onSetDarkTheme(_SetDarkTheme ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setDarkTheme(ev.value);
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  Future<void> _removeAccountFromDb(Account account) async {
    try {
      await db.deleteAccount(account.toDb());
    } catch (e, stackTrace) {
      _log.shout(
        "[_removeAccountFromDb] Failed while removing account from db",
        e,
        stackTrace,
      );
    }
  }

  final AccountController accountController;
  final PrefController prefController;
  final NpDb db;
  late final Account activeAccount = accountController.account;

  final _prefLock = Mutex();
  var _isHandlingError = false;
}
