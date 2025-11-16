// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_collection_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_FormValueCopyWithWorker {
  _FormValue call({String? name, _ProviderOption? provider});
}

class _$_FormValueCopyWithWorkerImpl implements $_FormValueCopyWithWorker {
  _$_FormValueCopyWithWorkerImpl(this.that);

  @override
  _FormValue call({dynamic name, dynamic provider}) {
    return _FormValue(
      name: name as String? ?? that.name,
      provider: provider as _ProviderOption? ?? that.provider,
    );
  }

  final _FormValue that;
}

extension $_FormValueCopyWith on _FormValue {
  $_FormValueCopyWithWorker get copyWith => _$copyWith;
  $_FormValueCopyWithWorker get _$copyWith =>
      _$_FormValueCopyWithWorkerImpl(this);
}

abstract class $_StateCopyWithWorker {
  _State call({
    _FormValue? formValue,
    Collection? result,
    bool? isExporting,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic formValue,
    dynamic result = copyWithNull,
    dynamic isExporting,
    dynamic error = copyWithNull,
  }) {
    return _State(
      formValue: formValue as _FormValue? ?? that.formValue,
      result: result == copyWithNull ? that.result : result as Collection?,
      isExporting: isExporting as bool? ?? that.isExporting,
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

extension _$_WrappedExportCollectionDialogStateNpLog
    on _WrappedExportCollectionDialogState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.export_collection_dialog.export_collection_dialog._WrappedExportCollectionDialogState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.export_collection_dialog.export_collection_dialog._Bloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_SubmitNameToString on _SubmitName {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SubmitName {value: $value}";
  }
}

extension _$_SubmitProviderToString on _SubmitProvider {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SubmitProvider {value: ${value.name}}";
  }
}

extension _$_SubmitFormToString on _SubmitForm {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SubmitForm {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
