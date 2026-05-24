part of '../metadata_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.isEnable,
    required this.isFallback,
    required this.isBackupOnRemoteExifEdit,
    this.error,
  });

  @override
  String toString() => _$toString();

  final bool isEnable;
  final bool isFallback;
  final bool isBackupOnRemoteExifEdit;

  final ExceptionEvent? error;
}

abstract class _Event {
  const _Event();
}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _SetEnable implements _Event {
  const _SetEnable(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetFallback implements _Event {
  const _SetFallback(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetBackupOnRemoteExifEdit implements _Event {
  const _SetBackupOnRemoteExifEdit(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}
