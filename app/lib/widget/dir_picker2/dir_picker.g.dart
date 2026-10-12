// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dir_picker.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    File? currentDir,
    List<_DpItem>? items,
    bool? isLoading,
    List<File>? picks,
    StateMessage? message,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic currentDir,
    dynamic items,
    dynamic isLoading,
    dynamic picks,
    dynamic message = copyWithNull,
    dynamic error = copyWithNull,
  }) {
    return _State(
      currentDir: currentDir as File? ?? that.currentDir,
      items: items as List<_DpItem>? ?? that.items,
      isLoading: isLoading as bool? ?? that.isLoading,
      picks: picks as List<File>? ?? that.picks,
      message: message == copyWithNull
          ? that.message
          : message as StateMessage?,
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

extension _$_DpBlocNpLog on _DpBloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.dir_picker2.dir_picker._DpBloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_DpItemToString on _DpItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DpItem {file: ${file.path}, isE2ee: $isE2ee}";
  }
}

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {currentDir: ${currentDir.path}, items: [length: ${items.length}], isLoading: $isLoading, picks: [length: ${picks.length}], message: $message, error: $error}";
  }
}

extension _$_NavigateToString on _Navigate {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Navigate {dir: ${dir.path}}";
  }
}

extension _$_PickToString on _Pick {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Pick {dir: ${dir.path}}";
  }
}

extension _$_UnpickToString on _Unpick {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Unpick {dir: ${dir.path}}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
