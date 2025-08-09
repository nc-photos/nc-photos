// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_picker.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({CameraPosition? position, bool? isDone});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic position = copyWithNull, dynamic isDone}) {
    return _State(
      position:
          position == copyWithNull
              ? that.position
              : position as CameraPosition?,
      isDone: isDone as bool? ?? that.isDone,
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

extension _$_WrappedPlacePickerNpLog on _WrappedPlacePicker {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.place_picker.place_picker._WrappedPlacePicker",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.place_picker.place_picker._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {position: $position, isDone: $isDone}";
  }
}

extension _$_SetPositionToString on _SetPosition {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPosition {value: $value}";
  }
}

extension _$_DoneToString on _Done {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Done {}";
  }
}
