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
class _Confirm implements _Event {
  const _Confirm();

  @override
  String toString() => _$toString();
}

@genCopyWith
@toString
class _State {
  const _State({required this.uploadRelativePath, this.result});

  factory _State.init({required String uploadRelativePath}) {
    return _State(uploadRelativePath: uploadRelativePath);
  }

  @override
  String toString() => _$toString();

  final String uploadRelativePath;

  final UploadConfig? result;
}
