// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhancement_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? isSaveEditResultToServer,
    SizeInt? maxSize,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic isSaveEditResultToServer,
    dynamic maxSize,
    dynamic error = copyWithNull,
  }) {
    return _State(
      isSaveEditResultToServer:
          isSaveEditResultToServer as bool? ?? that.isSaveEditResultToServer,
      maxSize: maxSize as SizeInt? ?? that.maxSize,
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

  static final log = Logger("widget.settings.enhancement_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isSaveEditResultToServer: $isSaveEditResultToServer, maxSize: $maxSize, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetSaveEditResultToServerToString on _SetSaveEditResultToServer {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSaveEditResultToServer {value: $value}";
  }
}

extension _$_SetMaxSizeToString on _SetMaxSize {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetMaxSize {value: $value}";
  }
}
