// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    String? uploadRelativePath,
    ConvertConfig? convertConfig,
    UploadConfig? result,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic uploadRelativePath,
    dynamic convertConfig = copyWithNull,
    dynamic result = copyWithNull,
  }) {
    return _State(
      uploadRelativePath:
          uploadRelativePath as String? ?? that.uploadRelativePath,
      convertConfig:
          convertConfig == copyWithNull
              ? that.convertConfig
              : convertConfig as ConvertConfig?,
      result: result == copyWithNull ? that.result : result as UploadConfig?,
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

  static final log = Logger("widget.upload_dialog.upload_dialog._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$UploadConfigToString on UploadConfig {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "UploadConfig {relativePath: $relativePath, convertConfig: $convertConfig}";
  }
}

extension _$_SetUploadRelativePathToString on _SetUploadRelativePath {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetUploadRelativePath {value: $value}";
  }
}

extension _$_SetEnableConvertToString on _SetEnableConvert {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetEnableConvert {value: $value}";
  }
}

extension _$_SetConvertFormatToString on _SetConvertFormat {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetConvertFormat {value: ${value.name}}";
  }
}

extension _$_SetConvertQualityToString on _SetConvertQuality {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetConvertQuality {value: $value}";
  }
}

extension _$_SetConvertDownsizeMpToString on _SetConvertDownsizeMp {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetConvertDownsizeMp {value: ${value == null ? null : "${value!.toStringAsFixed(3)}"}}";
  }
}

extension _$_ConfirmToString on _Confirm {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Confirm {}";
  }
}

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {uploadRelativePath: $uploadRelativePath, convertConfig: $convertConfig, result: $result}";
  }
}
