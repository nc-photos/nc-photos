part of '../misc_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.isDoubleTapExit,
    required this.isEnableAnimation,
    required this.appLockType,
    this.error,
  });

  @override
  String toString() => _$toString();

  final bool isDoubleTapExit;
  final bool isEnableAnimation;
  final ProtectedPageAuthType? appLockType;

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
class _SetDoubleTapExit implements _Event {
  const _SetDoubleTapExit(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetEnableAnimation implements _Event {
  const _SetEnableAnimation(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}
