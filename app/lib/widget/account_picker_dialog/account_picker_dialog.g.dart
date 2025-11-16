// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_picker_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<Account>? accounts,
    bool? isOpenDropdown,
    Account? newSelectAccount,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic accounts,
    dynamic isOpenDropdown,
    dynamic newSelectAccount = copyWithNull,
    dynamic error = copyWithNull,
  }) {
    return _State(
      accounts: accounts as List<Account>? ?? that.accounts,
      isOpenDropdown: isOpenDropdown as bool? ?? that.isOpenDropdown,
      newSelectAccount:
          newSelectAccount == copyWithNull
              ? that.newSelectAccount
              : newSelectAccount as Account?,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.account_picker_dialog.account_picker_dialog._Bloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {accounts: [length: ${accounts.length}], isOpenDropdown: $isOpenDropdown, newSelectAccount: $newSelectAccount, error: $error}";
  }
}

extension _$_ToggleDropdownToString on _ToggleDropdown {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleDropdown {}";
  }
}

extension _$_SwitchAccountToString on _SwitchAccount {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SwitchAccount {account: $account}";
  }
}

extension _$_DeleteAccountToString on _DeleteAccount {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DeleteAccount {account: $account}";
  }
}

extension _$_SetDarkThemeToString on _SetDarkTheme {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDarkTheme {value: $value}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
