// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protected_page_password_auth_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({Unique<bool?>? isAuthorized, CiString? setupResult});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic isAuthorized, dynamic setupResult = copyWithNull}) {
    return _State(
      isAuthorized: isAuthorized as Unique<bool?>? ?? that.isAuthorized,
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

  static final log = Logger("widget.protected_page_password_auth_dialog._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isAuthorized: $isAuthorized, setupResult: $setupResult}";
  }
}

extension _$_SubmitToString on _Submit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Submit {value: $value}";
  }
}
