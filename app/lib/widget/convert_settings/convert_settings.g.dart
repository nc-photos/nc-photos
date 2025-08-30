// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_settings.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({ConvertFormat? format, int? quality, double? downsizeMp});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic format,
    dynamic quality,
    dynamic downsizeMp = copyWithNull,
  }) {
    return _State(
      format: format as ConvertFormat? ?? that.format,
      quality: quality as int? ?? that.quality,
      downsizeMp:
          downsizeMp == copyWithNull ? that.downsizeMp : downsizeMp as double?,
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

  static final log = Logger("widget.convert_settings.convert_settings._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {format: ${format.name}, quality: $quality, downsizeMp: ${downsizeMp == null ? null : "${downsizeMp!.toStringAsFixed(3)}"}}";
  }
}

extension _$_SetFormatToString on _SetFormat {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFormat {value: ${value.name}}";
  }
}

extension _$_SetQualityToString on _SetQuality {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetQuality {value: $value}";
  }
}

extension _$_SetDownsizeMpToString on _SetDownsizeMp {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDownsizeMp {value: ${value == null ? null : "${value!.toStringAsFixed(3)}"}}";
  }
}

extension _$_SaveToString on _Save {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Save {}";
  }
}
