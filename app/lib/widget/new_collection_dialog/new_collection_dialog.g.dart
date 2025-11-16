// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_collection_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_FormValueCopyWithWorker {
  _FormValue call({
    String? name,
    _ProviderOption? provider,
    List<File>? dirs,
    List<Tag>? tags,
  });
}

class _$_FormValueCopyWithWorkerImpl implements $_FormValueCopyWithWorker {
  _$_FormValueCopyWithWorkerImpl(this.that);

  @override
  _FormValue call({
    dynamic name,
    dynamic provider,
    dynamic dirs,
    dynamic tags,
  }) {
    return _FormValue(
      name: name as String? ?? that.name,
      provider: provider as _ProviderOption? ?? that.provider,
      dirs: dirs as List<File>? ?? that.dirs,
      tags: tags as List<Tag>? ?? that.tags,
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
    bool? showDialog,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic formValue,
    dynamic result = copyWithNull,
    dynamic showDialog,
    dynamic error = copyWithNull,
  }) {
    return _State(
      supportedProviders: that.supportedProviders,
      formValue: formValue as _FormValue? ?? that.formValue,
      result: result == copyWithNull ? that.result : result as Collection?,
      showDialog: showDialog as bool? ?? that.showDialog,
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

extension _$_WrappedNewCollectionDialogStateNpLog
    on _WrappedNewCollectionDialogState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.new_collection_dialog.new_collection_dialog._WrappedNewCollectionDialogState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.new_collection_dialog.new_collection_dialog._Bloc",
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

extension _$_SubmitDirsToString on _SubmitDirs {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SubmitDirs {value: [length: ${value.length}]}";
  }
}

extension _$_SubmitTagsToString on _SubmitTags {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SubmitTags {value: [length: ${value.length}]}";
  }
}

extension _$_SubmitFormToString on _SubmitForm {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SubmitForm {}";
  }
}

extension _$_HideDialogToString on _HideDialog {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_HideDialog {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
