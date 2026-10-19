part of 'image_editor.dart';

enum _ToolType { color, effect, transform, markup }

enum _SaveState { init, download, process, save }

@genCopyWith
@toString
class _State {
  const _State({
    this.src,
    this.dst,
    required this.pixelFilters,
    required this.transformFilters,
    required this.markupFilter,
    required this.appliedStrokeIds,
    required this.isApplyingFilters,
    this.postTransformSrc,
    this.faceLandmarks,
    required this.selectedFaces,
    this.hasSelectedFaceReset,
    required this.shouldNotifySelectFace,
    required this.activeTool,
    this.activeTransformTool,
    required this.isFaceSelectionMode,
    this.faceSelectorImageSize,
    this.quitRequest,
    this.saveState,
    required this.downloadProgress,
    this.savedFile,
    this.error,
    this.initError,
    this.saveError,
  });

  factory _State.init() {
    return const _State(
      pixelFilters: [],
      transformFilters: [],
      markupFilter: MarkupArguments(strokes: []),
      appliedStrokeIds: {},
      isApplyingFilters: false,
      selectedFaces: [],
      shouldNotifySelectFace: false,
      activeTool: _ToolType.color,
      isFaceSelectionMode: false,
      downloadProgress: 0,
    );
  }

  @override
  String toString() => _$toString();

  bool get isModified =>
      transformFilters.isNotEmpty ||
      pixelFilters.isNotEmpty ||
      markupFilter.strokes.isNotEmpty;

  final Rgba8Image? src;
  final Rgba8Image? dst;

  final List<PixelArguments> pixelFilters;
  final List<TransformArguments> transformFilters;
  final MarkupArguments markupFilter;
  final Set<int> appliedStrokeIds;
  final bool isApplyingFilters;

  // image used for face detection
  final Rgba8Image? postTransformSrc;
  final List<image_editor.FaceDetectorResult>? faceLandmarks;
  final List<image_editor.FaceDetectorResult> selectedFaces;
  final Unique<bool>? hasSelectedFaceReset;
  // not unique as we only want to show once
  final bool shouldNotifySelectFace;

  final _ToolType activeTool;
  final TransformToolType? activeTransformTool;
  final bool isFaceSelectionMode;
  final Size? faceSelectorImageSize;

  final Unique<void>? quitRequest;
  final _SaveState? saveState;
  final double downloadProgress;
  final io.File? savedFile;

  final ExceptionEvent? error;
  final ExceptionEvent? initError;
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
class _SetFaceSelectionMode implements _Event {
  const _SetFaceSelectionMode(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetFaceSelectorImageSize implements _Event {
  const _SetFaceSelectorImageSize(this.value);

  @override
  String toString() => _$toString();

  final Size value;
}

@toString
class _SetPixelFilters implements _Event {
  const _SetPixelFilters(this.value);

  @override
  String toString() => _$toString();

  final List<PixelArguments> value;
}

@toString
class _SetTransformFilters implements _Event {
  const _SetTransformFilters(this.value);

  @override
  String toString() => _$toString();

  final List<TransformArguments> value;
}

@toString
class _UpdateTransformFilter implements _Event {
  const _UpdateTransformFilter(this.value);

  @override
  String toString() => _$toString();

  final TransformArguments value;
}

@toString
class _SetActiveTransformTool implements _Event {
  const _SetActiveTransformTool(this.value);

  @override
  String toString() => _$toString();

  final TransformToolType? value;
}

@toString
class _SetFaceLandmarks implements _Event {
  const _SetFaceLandmarks({this.postTransformSrc, required this.landmarks});

  @override
  String toString() => _$toString();

  final Rgba8Image? postTransformSrc;
  final List<image_editor.FaceDetectorResult> landmarks;
}

@toString
class _ToggleFaceSelection implements _Event {
  const _ToggleFaceSelection(this.value);

  @override
  String toString() => _$toString();

  final image_editor.FaceDetectorResult value;
}

@toString
class _FaceFilterValueChanged implements _Event {
  const _FaceFilterValueChanged();

  @override
  String toString() => _$toString();
}

@toString
class _AddBrushStroke implements _Event {
  const _AddBrushStroke(this.value);

  @override
  String toString() => _$toString();

  final List<Point<double>> value;
}

@toString
class _ClearBrushStrokes implements _Event {
  const _ClearBrushStrokes();

  @override
  String toString() => _$toString();
}

@toString
class _UndoBrushStroke implements _Event {
  const _UndoBrushStroke();

  @override
  String toString() => _$toString();
}

@toString
class _SetBrushColor implements _Event {
  const _SetBrushColor(this.value);

  @override
  String toString() => _$toString();

  final Color value;
}

@toString
class _SetBrushRadius implements _Event {
  const _SetBrushRadius(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetAppliedStrokeIds implements _Event {
  const _SetAppliedStrokeIds(this.value);

  @override
  String toString() => _$toString();

  final Set<int> value;
}

@toString
class _SetDst implements _Event {
  const _SetDst(this.value, this.appliedStrokeIds);

  @override
  String toString() => _$toString();

  final Rgba8Image value;
  final Set<int> appliedStrokeIds;
}

@toString
class _SetIsApplyingFilters implements _Event {
  const _SetIsApplyingFilters(this.value);

  @override
  String toString() => _$toString();

  final bool value;
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
