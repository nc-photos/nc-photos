part of '../collections_nav_bar_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.buttons, this.error});

  factory _State.init({required List<PrefHomeCollectionsNavButton> buttons}) {
    return _State(buttons: buttons);
  }

  @override
  String toString() => _$toString();

  final List<PrefHomeCollectionsNavButton> buttons;

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
class _MoveButton implements _Event {
  const _MoveButton._({required this.which, this.before, this.after});

  const _MoveButton.first({required HomeCollectionsNavBarButtonType which})
    : this._(which: which);

  const _MoveButton.before({
    required HomeCollectionsNavBarButtonType which,
    required HomeCollectionsNavBarButtonType target,
  }) : this._(which: which, before: target);

  const _MoveButton.after({
    required HomeCollectionsNavBarButtonType which,
    required HomeCollectionsNavBarButtonType target,
  }) : this._(which: which, after: target);

  @override
  String toString() => _$toString();

  final HomeCollectionsNavBarButtonType which;
  final HomeCollectionsNavBarButtonType? before;
  final HomeCollectionsNavBarButtonType? after;
}

@toString
class _RemoveButton implements _Event {
  const _RemoveButton(this.value);

  @override
  String toString() => _$toString();

  final HomeCollectionsNavBarButtonType value;
}

@toString
class _ToggleMinimized implements _Event {
  const _ToggleMinimized(this.value);

  @override
  String toString() => _$toString();

  final HomeCollectionsNavBarButtonType value;
}

@toString
class _RevertDefault implements _Event {
  const _RevertDefault();

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
