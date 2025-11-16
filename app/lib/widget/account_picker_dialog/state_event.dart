part of 'account_picker_dialog.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.accounts,
    required this.isOpenDropdown,
    this.newSelectAccount,
    this.error,
  });

  factory _State.init({required List<Account> accounts}) =>
      _State(accounts: accounts, isOpenDropdown: false);

  @override
  String toString() => _$toString();

  final List<Account> accounts;
  final bool isOpenDropdown;
  final Account? newSelectAccount;

  final ExceptionEvent? error;
}

abstract class _Event {
  const _Event();
}

@toString
class _ToggleDropdown implements _Event {
  const _ToggleDropdown();

  @override
  String toString() => _$toString();
}

@toString
class _SwitchAccount implements _Event {
  const _SwitchAccount(this.account);

  @override
  String toString() => _$toString();

  final Account account;
}

@toString
class _DeleteAccount implements _Event {
  const _DeleteAccount(this.account);

  @override
  String toString() => _$toString();

  final Account account;
}

@toString
class _SetDarkTheme implements _Event {
  const _SetDarkTheme(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
