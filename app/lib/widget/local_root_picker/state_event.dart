part of 'local_root_picker.dart';

@genCopyWith
@toString
class _State {
  const _State({this.dirs, required this.selectedDirs, this.error});

  factory _State.init({required Set<String> selectedDirs}) {
    return _State(selectedDirs: selectedDirs);
  }

  final List<String>? dirs;
  final Set<String> selectedDirs;

  final ExceptionEvent? error;
}

sealed class _Event {}

@toString
class _ListDir implements _Event {
  const _ListDir();

  @override
  String toString() => _$toString();
}

@toString
class _SelectDir implements _Event {
  const _SelectDir(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _UnselectDir implements _Event {
  const _UnselectDir(this.value);

  @override
  String toString() => _$toString();

  final String value;
}

@toString
class _Save implements _Event {
  const _Save();

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
