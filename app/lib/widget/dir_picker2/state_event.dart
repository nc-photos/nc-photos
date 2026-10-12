part of 'dir_picker.dart';

@toString
class _DpItem {
  const _DpItem(this.file, {this.isE2ee = false});

  @override
  String toString() => _$toString();

  final File file;
  final bool isE2ee;
}

@genCopyWith
@toString
class _State {
  const _State({
    required this.currentDir,
    required this.items,
    required this.isLoading,
    required this.picks,
    this.message,
    this.error,
  });

  factory _State.init({required File currentDir, required List<File> picks}) {
    return _State(
      currentDir: currentDir,
      items: const [],
      isLoading: true,
      picks: picks,
    );
  }

  @override
  String toString() => _$toString();

  final File currentDir;
  final List<_DpItem> items;
  final bool isLoading;
  final List<File> picks;

  final StateMessage? message;
  final ExceptionEvent? error;
}

sealed class _Event {}

@toString
class _Navigate implements _Event {
  const _Navigate(this.dir);

  @override
  String toString() => _$toString();

  final File dir;
}

// for multi-selection only
@toString
class _Pick implements _Event {
  const _Pick(this.dir);

  @override
  String toString() => _$toString();

  final File dir;
}

@toString
class _Unpick implements _Event {
  const _Unpick(this.dir);

  @override
  String toString() => _$toString();

  final File dir;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
