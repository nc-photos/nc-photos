// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expert_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({bool? isNewHttpEngine, _Event? lastSuccessful});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic isNewHttpEngine,
    dynamic lastSuccessful = copyWithNull,
  }) {
    return _State(
      isNewHttpEngine: isNewHttpEngine as bool? ?? that.isNewHttpEngine,
      lastSuccessful:
          lastSuccessful == copyWithNull
              ? that.lastSuccessful
              : lastSuccessful as _Event?,
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

extension _$_WrappedExpertSettingsStateNpLog on _WrappedExpertSettingsState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.expert_settings._WrappedExpertSettingsState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.settings.expert_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isNewHttpEngine: $isNewHttpEngine, lastSuccessful: $lastSuccessful}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_ClearCacheDatabaseToString on _ClearCacheDatabase {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ClearCacheDatabase {}";
  }
}

extension _$_SetNewHttpEngineToString on _SetNewHttpEngine {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetNewHttpEngine {value: $value}";
  }
}
