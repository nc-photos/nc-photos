part of '../expert_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.isNewHttpEngine, this.lastSuccessful});

  factory _State.init({required bool isNewHttpEngine}) {
    return _State(isNewHttpEngine: isNewHttpEngine);
  }

  @override
  String toString() => _$toString();

  final bool isNewHttpEngine;

  final _Event? lastSuccessful;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _ClearCacheDatabase implements _Event {
  const _ClearCacheDatabase();

  @override
  String toString() => _$toString();
}

@toString
class _SetNewHttpEngine implements _Event {
  const _SetNewHttpEngine(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}
