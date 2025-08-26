part of 'place_picker.dart';

@genCopyWith
@toString
class _State {
  const _State({this.position, required this.isDone});

  factory _State.init() => const _State(isDone: false);

  @override
  String toString() => _$toString();

  final CameraPosition? position;
  final bool isDone;
}

abstract class _Event {}

@toString
class _SetPosition implements _Event {
  const _SetPosition(this.value);

  @override
  String toString() => _$toString();

  final CameraPosition value;
}

@toString
class _Done implements _Event {
  const _Done();

  @override
  String toString() => _$toString();
}
