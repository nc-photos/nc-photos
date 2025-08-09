// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    int? screenBrightness,
    bool? isForceRotation,
    GpsMapProvider? gpsMapProvider,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic screenBrightness,
    dynamic isForceRotation,
    dynamic gpsMapProvider,
    dynamic error = copyWithNull,
  }) {
    return _State(
      screenBrightness: screenBrightness as int? ?? that.screenBrightness,
      isForceRotation: isForceRotation as bool? ?? that.isForceRotation,
      gpsMapProvider: gpsMapProvider as GpsMapProvider? ?? that.gpsMapProvider,
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

extension _$_WrappedViewerSettingsStateNpLog on _WrappedViewerSettingsState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.viewer_settings._WrappedViewerSettingsState",
  );
}

extension _$_BrightnessDialogStateNpLog on _BrightnessDialogState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.settings.viewer_settings._BrightnessDialogState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.settings.viewer_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {screenBrightness: $screenBrightness, isForceRotation: $isForceRotation, gpsMapProvider: ${gpsMapProvider.name}, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetScreenBrightnessToString on _SetScreenBrightness {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetScreenBrightness {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetForceRotationToString on _SetForceRotation {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetForceRotation {value: $value}";
  }
}

extension _$_SetGpsMapProviderToString on _SetGpsMapProvider {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetGpsMapProvider {value: ${value.name}}";
  }
}
