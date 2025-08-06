part of '../protected_page_pin_auth_dialog.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.input,
    required this.obsecuredInput,
    required this.isAuthorized,
    required this.isPinError,
    required this.setupResult,
  });

  factory _State.init() => _State(
    input: "",
    obsecuredInput: const [],
    isAuthorized: false,
    isPinError: Unique(null),
    setupResult: null,
  );

  @override
  String toString() => _$toString();

  final String input;
  final List<int> obsecuredInput;
  final bool isAuthorized;
  final Unique<bool?> isPinError;
  final CiString? setupResult;
}

abstract class _Event {
  const _Event();
}

@toString
class _PushDigit implements _Event {
  const _PushDigit(this.digit);

  @override
  String toString() => _$toString();

  final int digit;
}

@toString
class _PopDigit implements _Event {
  const _PopDigit();

  @override
  String toString() => _$toString();
}

@toString
class _SetupConfirmPin implements _Event {
  const _SetupConfirmPin();

  @override
  String toString() => _$toString();
}
