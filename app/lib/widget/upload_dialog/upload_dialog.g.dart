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
  _State call({String? uploadRelativePath, UploadConfig? result});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic uploadRelativePath, dynamic result = copyWithNull}) {
    return _State(
      uploadRelativePath:
          uploadRelativePath as String? ?? that.uploadRelativePath,
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
    return "UploadConfig {relativePath: $relativePath}";
  }
}

extension _$_SetUploadRelativePathToString on _SetUploadRelativePath {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetUploadRelativePath {value: $value}";
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
    return "_State {uploadRelativePath: $uploadRelativePath, result: $result}";
  }
}
