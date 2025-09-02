// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploader.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $ConvertConfigCopyWithWorker {
  ConvertConfig call({ConvertFormat? format, int? quality, double? downsizeMp});
}

class _$ConvertConfigCopyWithWorkerImpl
    implements $ConvertConfigCopyWithWorker {
  _$ConvertConfigCopyWithWorkerImpl(this.that);

  @override
  ConvertConfig call({
    dynamic format,
    dynamic quality,
    dynamic downsizeMp = copyWithNull,
  }) {
    return ConvertConfig(
      format: format as ConvertFormat? ?? that.format,
      quality: quality as int? ?? that.quality,
      downsizeMp:
          downsizeMp == copyWithNull ? that.downsizeMp : downsizeMp as double?,
    );
  }

  final ConvertConfig that;
}

extension $ConvertConfigCopyWith on ConvertConfig {
  $ConvertConfigCopyWithWorker get copyWith => _$copyWith;
  $ConvertConfigCopyWithWorker get _$copyWith =>
      _$ConvertConfigCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$ConvertConfigToString on ConvertConfig {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ConvertConfig {format: $format, quality: $quality, downsizeMp: $downsizeMp}";
  }
}
