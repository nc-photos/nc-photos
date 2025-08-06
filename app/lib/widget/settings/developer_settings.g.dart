// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    _Event? lastSuccessful,
    ExceptionEvent? error,
    StateMessage? message,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic lastSuccessful = copyWithNull,
    dynamic error = copyWithNull,
    dynamic message = copyWithNull,
  }) {
    return _State(
      lastSuccessful:
          lastSuccessful == copyWithNull
              ? that.lastSuccessful
              : lastSuccessful as _Event?,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
      message:
          message == copyWithNull ? that.message : message as StateMessage?,
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

extension _$_WrappedDeveloperSettingsStateNpLog
    on _WrappedDeveloperSettingsState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.developer_settings._WrappedDeveloperSettingsState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.settings.developer_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {lastSuccessful: $lastSuccessful, error: $error, message: $message}";
  }
}

extension _$_ClearImageCacheToString on _ClearImageCache {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ClearImageCache {}";
  }
}

extension _$_VacuumDbToString on _VacuumDb {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_VacuumDb {}";
  }
}

extension _$_ExportDbToString on _ExportDb {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ExportDb {}";
  }
}

extension _$_ClearCertWhitelistToString on _ClearCertWhitelist {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ClearCertWhitelist {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
