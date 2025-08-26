part of '../developer_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({this.lastSuccessful, this.error, this.message});

  @override
  String toString() => _$toString();

  final _Event? lastSuccessful;

  final ExceptionEvent? error;
  final StateMessage? message;
}

abstract class _Event {}

@toString
class _ClearImageCache implements _Event {
  const _ClearImageCache();

  @override
  String toString() => _$toString();
}

@toString
class _VacuumDb implements _Event {
  const _VacuumDb();

  @override
  String toString() => _$toString();
}

@toString
class _ExportDb implements _Event {
  const _ExportDb();

  @override
  String toString() => _$toString();
}

@toString
class _ClearCertWhitelist implements _Event {
  const _ClearCertWhitelist();

  @override
  String toString() => _$toString();
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
