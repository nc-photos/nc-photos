part of 'double_tap_exit_container.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.isDoubleTapExit, required this.canPop});

  factory _State.init({required bool isDoubleTapExit}) =>
      _State(isDoubleTapExit: isDoubleTapExit, canPop: false);

  @override
  String toString() => _$toString();

  final bool isDoubleTapExit;
  final bool canPop;
}

abstract class _Event {}

@toString
class _SetDoubleTapExit implements _Event {
  const _SetDoubleTapExit(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetCanPop implements _Event {
  const _SetCanPop(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _OnPopInvoked implements _Event {
  const _OnPopInvoked(this.didPop);

  @override
  String toString() => _$toString();

  final bool didPop;
}
