part of 'image_editor.dart';

enum _ToolType { color, transform }

enum _SaveState { init, download, process }

@genCopyWith
@toString
class _State {
  const _State({
    this.src,
    this.dst,
    required this.colorFilters,
    required this.transformFilters,
    this.cropFilter,
    required this.activeTool,
    required this.isCropMode,
    this.quitRequest,
    this.saveState,
    required this.downloadProgress,
    required this.isSaved,
    this.error,
    this.saveError,
  });

  factory _State.init() {
    return const _State(
      colorFilters: [],
      transformFilters: [],
      activeTool: _ToolType.color,
      isCropMode: false,
      downloadProgress: 0,
      isSaved: false,
    );
  }

  @override
  String toString() => _$toString();

  bool get isModified =>
      cropFilter != null ||
      transformFilters.isNotEmpty ||
      colorFilters.isNotEmpty;

  final Rgba8Image? src;
  final Rgba8Image? dst;

  final List<ColorArguments> colorFilters;
  final List<TransformArguments> transformFilters;
  final TransformArguments? cropFilter;

  final _ToolType activeTool;
  final bool isCropMode;

  final Unique<void>? quitRequest;
  final _SaveState? saveState;
  final double downloadProgress;
  final bool isSaved;

  final ExceptionEvent? error;
  final ExceptionEvent? saveError;
}

sealed class _Event {}

@toString
class _InitSrc implements _Event {
  const _InitSrc();

  @override
  String toString() => _$toString();
}

@toString
class _SetActiveTool implements _Event {
  const _SetActiveTool(this.value);

  @override
  String toString() => _$toString();

  final _ToolType value;
}

@toString
class _SetCropMode implements _Event {
  const _SetCropMode(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetColorFilters implements _Event {
  const _SetColorFilters(this.value);

  @override
  String toString() => _$toString();

  final List<ColorArguments> value;
}

@toString
class _SetTransformFilters implements _Event {
  const _SetTransformFilters(this.value);

  @override
  String toString() => _$toString();

  final List<TransformArguments> value;
}

@toString
class _SetCropFilter implements _Event {
  const _SetCropFilter(this.value);

  @override
  String toString() => _$toString();

  final TransformArguments? value;
}

@toString
class _SetDst implements _Event {
  const _SetDst(this.value);

  @override
  String toString() => _$toString();

  final Rgba8Image value;
}

@toString
class _Save implements _Event {
  const _Save();

  @override
  String toString() => _$toString();
}

@toString
class _RequestQuit implements _Event {
  const _RequestQuit();

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

@toString
class _SetSaveError implements _Event {
  const _SetSaveError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
