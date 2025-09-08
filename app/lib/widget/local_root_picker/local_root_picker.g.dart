// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_root_picker.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<String>? dirs,
    Set<String>? selectedDirs,
    bool? isEnable,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic dirs = copyWithNull,
    dynamic selectedDirs,
    dynamic isEnable,
    dynamic error = copyWithNull,
  }) {
    return _State(
      dirs: dirs == copyWithNull ? that.dirs : dirs as List<String>?,
      selectedDirs: selectedDirs as Set<String>? ?? that.selectedDirs,
      isEnable: isEnable as bool? ?? that.isEnable,
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

  static final log = Logger("widget.local_root_picker.local_root_picker._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {dirs: ${dirs == null ? null : "[length: ${dirs!.length}]"}, selectedDirs: {length: ${selectedDirs.length}}, isEnable: $isEnable, error: $error}";
  }
}

extension _$_ListDirToString on _ListDir {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ListDir {}";
  }
}

extension _$_SelectDirToString on _SelectDir {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SelectDir {value: $value}";
  }
}

extension _$_UnselectDirToString on _UnselectDir {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UnselectDir {value: $value}";
  }
}

extension _$_SaveToString on _Save {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Save {}";
  }
}

extension _$_UpdateEnableLocalFileToString on _UpdateEnableLocalFile {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UpdateEnableLocalFile {value: $value}";
  }
}

extension _$_SetEnableLocalFileToString on _SetEnableLocalFile {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetEnableLocalFile {value: $value}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
