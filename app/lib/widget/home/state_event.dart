part of 'home.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.isInitDone, required this.page});

  factory _State.init() {
    return const _State(isInitDone: false, page: 0);
  }

  @override
  String toString() => _$toString();

  final bool isInitDone;
  final int page;
}

abstract interface class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _ChangePage implements _Event {
  const _ChangePage(this.value);

  @override
  String toString() => _$toString();

  final int value;
}
