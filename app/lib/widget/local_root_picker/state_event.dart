part of 'local_root_picker.dart';

@genCopyWith
@toString
class _State {
  const _State({
    this.dirs,
    required this.selectedDirs,
    required this.isEnable,
    this.error,
  });

  factory _State.init({
    required Set<String> selectedDirs,
    required bool isEnable,
  }) {
    return _State(selectedDirs: selectedDirs, isEnable: isEnable);
  }

  @override
  String toString() => _$toString();

  final List<String>? dirs;
  final Set<String> selectedDirs;
  final bool isEnable;

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
class _UpdateEnableLocalFile implements _Event {
  const _UpdateEnableLocalFile(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetEnableLocalFile implements _Event {
  const _SetEnableLocalFile(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
