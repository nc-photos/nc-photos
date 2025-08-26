// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? shouldReload,
    Account? account,
    String? label,
    String? shareFolder,
    PersonProvider? personProvider,
    bool? shouldResync,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic shouldReload,
    dynamic account,
    dynamic label = copyWithNull,
    dynamic shareFolder,
    dynamic personProvider,
    dynamic shouldResync,
    dynamic error = copyWithNull,
  }) {
    return _State(
      shouldReload: shouldReload as bool? ?? that.shouldReload,
      account: account as Account? ?? that.account,
      label: label == copyWithNull ? that.label : label as String?,
      shareFolder: shareFolder as String? ?? that.shareFolder,
      personProvider: personProvider as PersonProvider? ?? that.personProvider,
      shouldResync: shouldResync as bool? ?? that.shouldResync,
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

extension _$_WrappedAccountSettingsStateNpLog on _WrappedAccountSettingsState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.account_settings._WrappedAccountSettingsState",
  );
}

extension _$_PersonProviderDialogNpLog on _PersonProviderDialog {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.account_settings._PersonProviderDialog",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.settings.account_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {shouldReload: $shouldReload, account: $account, label: $label, shareFolder: $shareFolder, personProvider: ${personProvider.name}, shouldResync: $shouldResync, error: $error}";
  }
}

extension _$_WritePrefErrorToString on _WritePrefError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_WritePrefError {error: $error, stackTrace: $stackTrace}";
  }
}

extension _$_SetLabelToString on _SetLabel {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetLabel {label: $label}";
  }
}

extension _$_OnUpdateLabelToString on _OnUpdateLabel {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OnUpdateLabel {label: $label}";
  }
}

extension _$_SetAccountToString on _SetAccount {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAccount {account: $account}";
  }
}

extension _$_OnUpdateAccountToString on _OnUpdateAccount {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OnUpdateAccount {account: $account}";
  }
}

extension _$_SetShareFolderToString on _SetShareFolder {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetShareFolder {shareFolder: $shareFolder}";
  }
}

extension _$_OnUpdateShareFolderToString on _OnUpdateShareFolder {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OnUpdateShareFolder {shareFolder: $shareFolder}";
  }
}

extension _$_SetPersonProviderToString on _SetPersonProvider {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPersonProvider {personProvider: ${personProvider.name}}";
  }
}

extension _$_OnUpdatePersonProviderToString on _OnUpdatePersonProvider {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OnUpdatePersonProvider {personProvider: ${personProvider.name}}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
