// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protected_page_pin_auth_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    String? input,
    List<int>? obsecuredInput,
    bool? isAuthorized,
    Unique<bool?>? isPinError,
    CiString? setupResult,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic input,
    dynamic obsecuredInput,
    dynamic isAuthorized,
    dynamic isPinError,
    dynamic setupResult = copyWithNull,
  }) {
    return _State(
      input: input as String? ?? that.input,
      obsecuredInput: obsecuredInput as List<int>? ?? that.obsecuredInput,
      isAuthorized: isAuthorized as bool? ?? that.isAuthorized,
      isPinError: isPinError as Unique<bool?>? ?? that.isPinError,
      setupResult:
          setupResult == copyWithNull
              ? that.setupResult
              : setupResult as CiString?,
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

  static final log = Logger("widget.protected_page_pin_auth_dialog._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {input: $input, obsecuredInput: [length: ${obsecuredInput.length}], isAuthorized: $isAuthorized, isPinError: $isPinError, setupResult: $setupResult}";
  }
}

extension _$_PushDigitToString on _PushDigit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PushDigit {digit: $digit}";
  }
}

extension _$_PopDigitToString on _PopDigit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PopDigit {}";
  }
}

extension _$_SetupConfirmPinToString on _SetupConfirmPin {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetupConfirmPin {}";
  }
}
