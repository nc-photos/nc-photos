// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? isEnableMemories,
    int? memoriesRange,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic isEnableMemories,
    dynamic memoriesRange,
    dynamic error = copyWithNull,
  }) {
    return _State(
      isEnableMemories: isEnableMemories as bool? ?? that.isEnableMemories,
      memoriesRange: memoriesRange as int? ?? that.memoriesRange,
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

  static final log = Logger("widget.settings.photos_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isEnableMemories: $isEnableMemories, memoriesRange: $memoriesRange, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetEnableMemoriesToString on _SetEnableMemories {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetEnableMemories {value: $value}";
  }
}

extension _$_SetMemoriesRangeToString on _SetMemoriesRange {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetMemoriesRange {value: $value}";
  }
}
