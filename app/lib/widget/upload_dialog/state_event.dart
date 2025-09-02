part of 'upload_dialog.dart';

sealed class _Event {}

@toString
class _SetUploadRelativePath implements _Event {
  const _SetUploadRelativePath(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _SetEnableConvert implements _Event {
  const _SetEnableConvert(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetConvertFormat implements _Event {
  const _SetConvertFormat(this.value);

  @override
  String toString() => _$toString();

  final ConvertFormat value;
}

@toString
class _SetConvertQuality implements _Event {
  const _SetConvertQuality(this.value);

  @override
  String toString() => _$toString();

  final int value;
}

@toString
class _SetConvertDownsizeMp implements _Event {
  const _SetConvertDownsizeMp(this.value);

  @override
  String toString() => _$toString();

  final double? value;
}

@toString
class _Confirm implements _Event {
  const _Confirm();

  @override
  String toString() => _$toString();
}

@genCopyWith
@toString
class _State {
  const _State({
    required this.uploadRelativePath,
    required this.convertConfig,
    this.result,
  });

  factory _State.init({
    required String uploadRelativePath,
    required ConvertConfig? convertConfig,
  }) {
    return _State(
      uploadRelativePath: uploadRelativePath,
      convertConfig: convertConfig,
    );
  }

  @override
  String toString() => _$toString();

  final String uploadRelativePath;
  final ConvertConfig? convertConfig;

  final UploadConfig? result;
}
