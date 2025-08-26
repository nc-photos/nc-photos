part of 'connect.dart';

@genCopyWith
@toString
class _State {
  const _State({
    this.result,
    required this.askWebDavUrlRequest,
    this.userId,
    required this.cancelRequest,
    this.error,
  });

  factory _State.init() =>
      _State(askWebDavUrlRequest: Unique(null), cancelRequest: false);

  @override
  String toString() => _$toString();

  final Account? result;
  final Unique<_AskWebDavUrlRequest?> askWebDavUrlRequest;
  final String? userId;
  final bool cancelRequest;

  final ({Object error, StackTrace? stackTrace})? error;
}

abstract interface class _Event {}

@toString
class _Login implements _Event {
  const _Login();

  @override
  String toString() => _$toString();
}

@toString
class _Cancel implements _Event {
  const _Cancel();

  @override
  String toString() => _$toString();
}

@toString
class _SetUserId implements _Event {
  const _SetUserId(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
