// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_nav_bar_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<PrefHomeCollectionsNavButton>? buttons,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic buttons, dynamic error = copyWithNull}) {
    return _State(
      buttons: buttons as List<PrefHomeCollectionsNavButton>? ?? that.buttons,
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

extension _$_WrappedCollectionsNavBarSettingsStateNpLog
    on _WrappedCollectionsNavBarSettingsState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.collections_nav_bar_settings._WrappedCollectionsNavBarSettingsState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.collections_nav_bar_settings._Bloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {buttons: [length: ${buttons.length}], error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_MoveButtonToString on _MoveButton {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_MoveButton {which: ${which.name}, before: ${before == null ? null : "${before!.name}"}, after: ${after == null ? null : "${after!.name}"}}";
  }
}

extension _$_RemoveButtonToString on _RemoveButton {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RemoveButton {value: ${value.name}}";
  }
}

extension _$_ToggleMinimizedToString on _ToggleMinimized {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleMinimized {value: ${value.name}}";
  }
}

extension _$_RevertDefaultToString on _RevertDefault {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RevertDefault {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
