part of '../app_lock_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.appLockType});

  factory _State.init({ProtectedPageAuthType? appLockType}) =>
      _State(appLockType: appLockType);

  @override
  String toString() => _$toString();

  final ProtectedPageAuthType? appLockType;
}

abstract class _Event {
  const _Event();
}

@toString
class _SetAppLockType implements _Event {
  const _SetAppLockType(this.value);

  @override
  String toString() => _$toString();

  final ProtectedPageAuthType? value;
}
