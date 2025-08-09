// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double_tap_exit_container.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({bool? isDoubleTapExit, bool? canPop});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic isDoubleTapExit, dynamic canPop}) {
    return _State(
      isDoubleTapExit: isDoubleTapExit as bool? ?? that.isDoubleTapExit,
      canPop: canPop as bool? ?? that.canPop,
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

  static final log = Logger(
    "widget.double_tap_exit_container.double_tap_exit_container._Bloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isDoubleTapExit: $isDoubleTapExit, canPop: $canPop}";
  }
}

extension _$_SetDoubleTapExitToString on _SetDoubleTapExit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDoubleTapExit {value: $value}";
  }
}

extension _$_SetCanPopToString on _SetCanPop {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCanPop {value: $value}";
  }
}

extension _$_OnPopInvokedToString on _OnPopInvoked {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OnPopInvoked {didPop: $didPop}";
  }
}
