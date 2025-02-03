// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call(
      {Account? result,
      Unique<_AskWebDavUrlRequest?>? askWebDavUrlRequest,
      String? userId,
      bool? cancelRequest,
      ({Object error, StackTrace? stackTrace})? error});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call(
      {dynamic result = copyWithNull,
      dynamic askWebDavUrlRequest,
      dynamic userId = copyWithNull,
      dynamic cancelRequest,
      dynamic error = copyWithNull}) {
    return _State(
        result: result == copyWithNull ? that.result : result as Account?,
        askWebDavUrlRequest:
            askWebDavUrlRequest as Unique<_AskWebDavUrlRequest?>? ??
                that.askWebDavUrlRequest,
        userId: userId == copyWithNull ? that.userId : userId as String?,
        cancelRequest: cancelRequest as bool? ?? that.cancelRequest,
        error: error == copyWithNull
            ? that.error
            : error as ({Object error, StackTrace? stackTrace})?);
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

  static final log = Logger("widget.connect2.connect._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {result: $result, askWebDavUrlRequest: $askWebDavUrlRequest, userId: $userId, cancelRequest: $cancelRequest, error: $error}";
  }
}

extension _$_LoginToString on _Login {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Login {}";
  }
}

extension _$_CancelToString on _Cancel {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Cancel {}";
  }
}

extension _$_SetUserIdToString on _SetUserId {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetUserId {value: $value}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
