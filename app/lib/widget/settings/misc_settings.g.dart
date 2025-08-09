// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? isDoubleTapExit,
    ProtectedPageAuthType? appLockType,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic isDoubleTapExit,
    dynamic appLockType = copyWithNull,
    dynamic error = copyWithNull,
  }) {
    return _State(
      isDoubleTapExit: isDoubleTapExit as bool? ?? that.isDoubleTapExit,
      appLockType:
          appLockType == copyWithNull
              ? that.appLockType
              : appLockType as ProtectedPageAuthType?,
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

  static final log = Logger("widget.settings.misc_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isDoubleTapExit: $isDoubleTapExit, appLockType: ${appLockType == null ? null : "${appLockType!.name}"}, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetDoubleTapExitToString on _SetDoubleTapExit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDoubleTapExit {value: $value}";
  }
}
