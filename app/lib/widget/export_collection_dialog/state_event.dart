part of '../export_collection_dialog.dart';

@genCopyWith
class _FormValue {
  const _FormValue({this.name = "", this.provider = _ProviderOption.appAlbum});

  final String name;
  final _ProviderOption provider;
}

@genCopyWith
class _State {
  const _State({
    required this.formValue,
    this.result,
    required this.isExporting,
    this.error,
  });

  factory _State.init() {
    return const _State(formValue: _FormValue(), isExporting: false);
  }

  final _FormValue formValue;
  final Collection? result;
  final bool isExporting;

  final ExceptionEvent? error;
}

abstract class _Event {
  const _Event();
}

abstract class _FormEvent implements _Event {
  const _FormEvent();
}

@toString
class _SubmitName extends _FormEvent {
  const _SubmitName(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _SubmitProvider extends _FormEvent {
  const _SubmitProvider(this.value);

  @override
  String toString() => _$toString();

  final _ProviderOption value;
}

@toString
class _SubmitForm extends _FormEvent {
  const _SubmitForm();

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
