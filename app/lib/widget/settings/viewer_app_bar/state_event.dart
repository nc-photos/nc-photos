part of '../viewer_app_bar_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.buttons, this.error});

  factory _State.init({required List<ViewerAppBarButtonType> buttons}) {
    return _State(buttons: buttons);
  }

  @override
  String toString() => _$toString();

  final List<ViewerAppBarButtonType> buttons;

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

  const _MoveButton.first({required ViewerAppBarButtonType which})
    : this._(which: which);

  const _MoveButton.before({
    required ViewerAppBarButtonType which,
    required ViewerAppBarButtonType target,
  }) : this._(which: which, before: target);

  const _MoveButton.after({
    required ViewerAppBarButtonType which,
    required ViewerAppBarButtonType target,
  }) : this._(which: which, after: target);

  @override
  String toString() => _$toString();

  final ViewerAppBarButtonType which;
  final ViewerAppBarButtonType? before;
  final ViewerAppBarButtonType? after;
}

@toString
class _RemoveButton implements _Event {
  const _RemoveButton(this.value);

  @override
  String toString() => _$toString();

  final ViewerAppBarButtonType value;
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
