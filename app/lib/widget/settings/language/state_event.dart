part of '../language_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.selected, this.error});

  factory _State.init({required language_util.AppLanguage selected}) {
    return _State(selected: selected);
  }

  @override
  String toString() => _$toString();

  final language_util.AppLanguage selected;

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
class _SelectLanguage implements _Event {
  const _SelectLanguage(this.lang);

  @override
  String toString() => _$toString();

  final language_util.AppLanguage lang;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
