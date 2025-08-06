// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? isEnable,
    bool? isWifiOnly,
    bool? isFallback,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic isEnable,
    dynamic isWifiOnly,
    dynamic isFallback,
    dynamic error = copyWithNull,
  }) {
    return _State(
      isEnable: isEnable as bool? ?? that.isEnable,
      isWifiOnly: isWifiOnly as bool? ?? that.isWifiOnly,
      isFallback: isFallback as bool? ?? that.isFallback,
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

  static final log = Logger("widget.settings.metadata_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isEnable: $isEnable, isWifiOnly: $isWifiOnly, isFallback: $isFallback, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetEnableToString on _SetEnable {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetEnable {value: $value}";
  }
}

extension _$_SetWifiOnlyToString on _SetWifiOnly {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetWifiOnly {value: $value}";
  }
}

extension _$_SetFallbackToString on _SetFallback {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFallback {value: $value}";
  }
}
