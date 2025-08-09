// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_sharer_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    ShareMethod? method,
    _PreviewState? previewState,
    _FileState? fileState,
    _PublicLinkState? publicLinkState,
    _PasswordLinkState? passwordLinkState,
    bool? result,
    ExceptionEvent? error,
    String? message,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic method = copyWithNull,
    dynamic previewState = copyWithNull,
    dynamic fileState = copyWithNull,
    dynamic publicLinkState = copyWithNull,
    dynamic passwordLinkState = copyWithNull,
    dynamic result = copyWithNull,
    dynamic error = copyWithNull,
    dynamic message = copyWithNull,
  }) {
    return _State(
      method: method == copyWithNull ? that.method : method as ShareMethod?,
      previewState:
          previewState == copyWithNull
              ? that.previewState
              : previewState as _PreviewState?,
      fileState:
          fileState == copyWithNull ? that.fileState : fileState as _FileState?,
      publicLinkState:
          publicLinkState == copyWithNull
              ? that.publicLinkState
              : publicLinkState as _PublicLinkState?,
      passwordLinkState:
          passwordLinkState == copyWithNull
              ? that.passwordLinkState
              : passwordLinkState as _PasswordLinkState?,
      result: result == copyWithNull ? that.result : result as bool?,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
      message: message == copyWithNull ? that.message : message as String?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

abstract class $_PreviewStateCopyWithWorker {
  _PreviewState call({int? index, int? count});
}

class _$_PreviewStateCopyWithWorkerImpl
    implements $_PreviewStateCopyWithWorker {
  _$_PreviewStateCopyWithWorkerImpl(this.that);

  @override
  _PreviewState call({dynamic index, dynamic count}) {
    return _PreviewState(
      index: index as int? ?? that.index,
      count: count as int? ?? that.count,
    );
  }

  final _PreviewState that;
}

extension $_PreviewStateCopyWith on _PreviewState {
  $_PreviewStateCopyWithWorker get copyWith => _$copyWith;
  $_PreviewStateCopyWithWorker get _$copyWith =>
      _$_PreviewStateCopyWithWorkerImpl(this);
}

abstract class $_FileStateCopyWithWorker {
  _FileState call({
    int? index,
    double? progress,
    int? count,
    Download? download,
    bool? shouldRun,
  });
}

class _$_FileStateCopyWithWorkerImpl implements $_FileStateCopyWithWorker {
  _$_FileStateCopyWithWorkerImpl(this.that);

  @override
  _FileState call({
    dynamic index,
    dynamic progress = copyWithNull,
    dynamic count,
    dynamic download = copyWithNull,
    dynamic shouldRun,
  }) {
    return _FileState(
      index: index as int? ?? that.index,
      progress: progress == copyWithNull ? that.progress : progress as double?,
      count: count as int? ?? that.count,
      download:
          download == copyWithNull ? that.download : download as Download?,
      shouldRun: shouldRun as bool? ?? that.shouldRun,
    );
  }

  final _FileState that;
}

extension $_FileStateCopyWith on _FileState {
  $_FileStateCopyWithWorker get copyWith => _$copyWith;
  $_FileStateCopyWithWorker get _$copyWith =>
      _$_FileStateCopyWithWorkerImpl(this);
}

abstract class $_PasswordLinkStateCopyWithWorker {
  _PasswordLinkState call({String? password});
}

class _$_PasswordLinkStateCopyWithWorkerImpl
    implements $_PasswordLinkStateCopyWithWorker {
  _$_PasswordLinkStateCopyWithWorkerImpl(this.that);

  @override
  _PasswordLinkState call({dynamic password = copyWithNull}) {
    return _PasswordLinkState(
      password: password == copyWithNull ? that.password : password as String?,
    );
  }

  final _PasswordLinkState that;
}

extension $_PasswordLinkStateCopyWith on _PasswordLinkState {
  $_PasswordLinkStateCopyWithWorker get copyWith => _$copyWith;
  $_PasswordLinkStateCopyWithWorker get _$copyWith =>
      _$_PasswordLinkStateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.file_sharer_dialog._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {method: ${method == null ? null : "${method!.name}"}, previewState: $previewState, fileState: $fileState, publicLinkState: $publicLinkState, passwordLinkState: $passwordLinkState, result: $result, error: $error, message: $message}";
  }
}

extension _$_PreviewStateToString on _PreviewState {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PreviewState {index: $index, count: $count}";
  }
}

extension _$_FileStateToString on _FileState {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_FileState {index: $index, progress: ${progress == null ? null : "${progress!.toStringAsFixed(3)}"}, count: $count, download: $download, shouldRun: $shouldRun}";
  }
}

extension _$_PublicLinkStateToString on _PublicLinkState {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PublicLinkState {}";
  }
}

extension _$_PasswordLinkStateToString on _PasswordLinkState {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PasswordLinkState {password: $password}";
  }
}

extension _$_SetMethodToString on _SetMethod {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetMethod {method: ${method.name}}";
  }
}

extension _$_SetResultToString on _SetResult {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetResult {result: $result}";
  }
}

extension _$_CancelFileDownloadToString on _CancelFileDownload {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_CancelFileDownload {}";
  }
}

extension _$_SetPublicLinkDetailsToString on _SetPublicLinkDetails {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPublicLinkDetails {albumName: $albumName}";
  }
}

extension _$_SetPasswordLinkDetailsToString on _SetPasswordLinkDetails {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPasswordLinkDetails {albumName: $albumName, password: $password}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
