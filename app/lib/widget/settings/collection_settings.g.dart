// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({bool? isBrowserShowDate, ExceptionEvent? error});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic isBrowserShowDate, dynamic error = copyWithNull}) {
    return _State(
      isBrowserShowDate: isBrowserShowDate as bool? ?? that.isBrowserShowDate,
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

extension _$_WrappedAlbumSettingsStateNpLog on _WrappedAlbumSettingsState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.collection_settings._WrappedAlbumSettingsState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.settings.collection_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isBrowserShowDate: $isBrowserShowDate, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetBrowserShowDateToString on _SetBrowserShowDate {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetBrowserShowDate {value: $value}";
  }
}
