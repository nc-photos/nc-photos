// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({ProtectedPageAuthType? appLockType});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic appLockType = copyWithNull}) {
    return _State(
      appLockType:
          appLockType == copyWithNull
              ? that.appLockType
              : appLockType as ProtectedPageAuthType?,
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

  static final log = Logger("widget.settings.app_lock_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {appLockType: ${appLockType == null ? null : "${appLockType!.name}"}}";
  }
}

extension _$_SetAppLockTypeToString on _SetAppLockType {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAppLockType {value: ${value == null ? null : "${value!.name}"}}";
  }
}
