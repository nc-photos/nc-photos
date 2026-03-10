// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_result_viewer.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({bool? isShowAppBar});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic isShowAppBar}) {
    return _State(isShowAppBar: isShowAppBar as bool? ?? that.isShowAppBar);
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

extension _$_LrvBlocNpLog on _LrvBloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.local_result_viewer.local_result_viewer._LrvBloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isShowAppBar: $isShowAppBar}";
  }
}

extension _$_ToggleAppBarToString on _ToggleAppBar {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleAppBar {}";
  }
}

extension _$_ShareToString on _Share {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Share {}";
  }
}
