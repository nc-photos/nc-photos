part of '../collection_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.isBrowserShowDate, this.error});

  @override
  String toString() => _$toString();

  final bool isBrowserShowDate;

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
class _SetBrowserShowDate implements _Event {
  const _SetBrowserShowDate(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}
