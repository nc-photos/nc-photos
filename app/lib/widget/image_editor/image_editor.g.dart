// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_editor.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    Rgba8Image? src,
    Rgba8Image? dst,
    List<PixelArguments>? pixelFilters,
    List<TransformArguments>? transformFilters,
    MarkupArguments? markupFilter,
    Set<int>? appliedStrokeIds,
    bool? isApplyingFilters,
    Rgba8Image? postTransformSrc,
    List<image_editor.FaceDetectorResult>? faceLandmarks,
    List<image_editor.FaceDetectorResult>? selectedFaces,
    Unique<bool>? hasSelectedFaceReset,
    bool? shouldNotifySelectFace,
    _ToolType? activeTool,
    TransformToolType? activeTransformTool,
    Rgba8Image? transformPreviewSrc,
    bool? isFaceSelectionMode,
    Size? faceSelectorImageSize,
    Unique<void>? quitRequest,
    _SaveState? saveState,
    double? downloadProgress,
    io.File? savedFile,
    ExceptionEvent? error,
    ExceptionEvent? initError,
    ExceptionEvent? saveError,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic src = copyWithNull,
    dynamic dst = copyWithNull,
    dynamic pixelFilters,
    dynamic transformFilters,
    dynamic markupFilter,
    dynamic appliedStrokeIds,
    dynamic isApplyingFilters,
    dynamic postTransformSrc = copyWithNull,
    dynamic faceLandmarks = copyWithNull,
    dynamic selectedFaces,
    dynamic hasSelectedFaceReset = copyWithNull,
    dynamic shouldNotifySelectFace,
    dynamic activeTool,
    dynamic activeTransformTool = copyWithNull,
    dynamic transformPreviewSrc = copyWithNull,
    dynamic isFaceSelectionMode,
    dynamic faceSelectorImageSize = copyWithNull,
    dynamic quitRequest = copyWithNull,
    dynamic saveState = copyWithNull,
    dynamic downloadProgress,
    dynamic savedFile = copyWithNull,
    dynamic error = copyWithNull,
    dynamic initError = copyWithNull,
    dynamic saveError = copyWithNull,
  }) {
    return _State(
      src: src == copyWithNull ? that.src : src as Rgba8Image?,
      dst: dst == copyWithNull ? that.dst : dst as Rgba8Image?,
      pixelFilters: pixelFilters as List<PixelArguments>? ?? that.pixelFilters,
      transformFilters:
          transformFilters as List<TransformArguments>? ??
          that.transformFilters,
      markupFilter: markupFilter as MarkupArguments? ?? that.markupFilter,
      appliedStrokeIds: appliedStrokeIds as Set<int>? ?? that.appliedStrokeIds,
      isApplyingFilters: isApplyingFilters as bool? ?? that.isApplyingFilters,
      postTransformSrc: postTransformSrc == copyWithNull
          ? that.postTransformSrc
          : postTransformSrc as Rgba8Image?,
      faceLandmarks: faceLandmarks == copyWithNull
          ? that.faceLandmarks
          : faceLandmarks as List<image_editor.FaceDetectorResult>?,
      selectedFaces:
          selectedFaces as List<image_editor.FaceDetectorResult>? ??
          that.selectedFaces,
      hasSelectedFaceReset: hasSelectedFaceReset == copyWithNull
          ? that.hasSelectedFaceReset
          : hasSelectedFaceReset as Unique<bool>?,
      shouldNotifySelectFace:
          shouldNotifySelectFace as bool? ?? that.shouldNotifySelectFace,
      activeTool: activeTool as _ToolType? ?? that.activeTool,
      activeTransformTool: activeTransformTool == copyWithNull
          ? that.activeTransformTool
          : activeTransformTool as TransformToolType?,
      transformPreviewSrc: transformPreviewSrc == copyWithNull
          ? that.transformPreviewSrc
          : transformPreviewSrc as Rgba8Image?,
      isFaceSelectionMode:
          isFaceSelectionMode as bool? ?? that.isFaceSelectionMode,
      faceSelectorImageSize: faceSelectorImageSize == copyWithNull
          ? that.faceSelectorImageSize
          : faceSelectorImageSize as Size?,
      quitRequest: quitRequest == copyWithNull
          ? that.quitRequest
          : quitRequest as Unique<void>?,
      saveState: saveState == copyWithNull
          ? that.saveState
          : saveState as _SaveState?,
      downloadProgress: downloadProgress as double? ?? that.downloadProgress,
      savedFile: savedFile == copyWithNull
          ? that.savedFile
          : savedFile as io.File?,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
      initError: initError == copyWithNull
          ? that.initError
          : initError as ExceptionEvent?,
      saveError: saveError == copyWithNull
          ? that.saveError
          : saveError as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {src: $src, dst: $dst, pixelFilters: [length: ${pixelFilters.length}], transformFilters: [length: ${transformFilters.length}], markupFilter: $markupFilter, appliedStrokeIds: {length: ${appliedStrokeIds.length}}, isApplyingFilters: $isApplyingFilters, postTransformSrc: $postTransformSrc, faceLandmarks: ${faceLandmarks == null ? null : "[length: ${faceLandmarks!.length}]"}, selectedFaces: [length: ${selectedFaces.length}], hasSelectedFaceReset: $hasSelectedFaceReset, shouldNotifySelectFace: $shouldNotifySelectFace, activeTool: ${activeTool.name}, activeTransformTool: ${activeTransformTool == null ? null : "${activeTransformTool!.name}"}, transformPreviewSrc: $transformPreviewSrc, isFaceSelectionMode: $isFaceSelectionMode, faceSelectorImageSize: $faceSelectorImageSize, quitRequest: $quitRequest, saveState: ${saveState == null ? null : "${saveState!.name}"}, downloadProgress: ${downloadProgress.toStringAsFixed(3)}, savedFile: ${savedFile == null ? null : "${savedFile!.path}"}, error: $error, initError: $initError, saveError: $saveError}";
  }
}

extension _$_InitSrcToString on _InitSrc {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_InitSrc {}";
  }
}

extension _$_SetActiveToolToString on _SetActiveTool {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetActiveTool {value: ${value.name}}";
  }
}

extension _$_SetFaceSelectionModeToString on _SetFaceSelectionMode {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFaceSelectionMode {value: $value}";
  }
}

extension _$_SetFaceSelectorImageSizeToString on _SetFaceSelectorImageSize {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFaceSelectorImageSize {value: $value}";
  }
}

extension _$_SetPixelFiltersToString on _SetPixelFilters {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPixelFilters {value: [length: ${value.length}]}";
  }
}

extension _$_SetTransformFiltersToString on _SetTransformFilters {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetTransformFilters {value: [length: ${value.length}]}";
  }
}

extension _$_UpdateTransformFilterToString on _UpdateTransformFilter {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UpdateTransformFilter {value: $value}";
  }
}

extension _$_SetActiveTransformToolToString on _SetActiveTransformTool {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetActiveTransformTool {value: ${value == null ? null : "${value!.name}"}}";
  }
}

extension _$_SetTransformPreviewSrcToString on _SetTransformPreviewSrc {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetTransformPreviewSrc {value: $value}";
  }
}

extension _$_SetFaceLandmarksToString on _SetFaceLandmarks {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFaceLandmarks {postTransformSrc: $postTransformSrc, landmarks: [length: ${landmarks.length}]}";
  }
}

extension _$_ToggleFaceSelectionToString on _ToggleFaceSelection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleFaceSelection {value: $value}";
  }
}

extension _$_FaceFilterValueChangedToString on _FaceFilterValueChanged {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_FaceFilterValueChanged {}";
  }
}

extension _$_AddBrushStrokeToString on _AddBrushStroke {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_AddBrushStroke {value: [length: ${value.length}]}";
  }
}

extension _$_ClearBrushStrokesToString on _ClearBrushStrokes {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ClearBrushStrokes {}";
  }
}

extension _$_UndoBrushStrokeToString on _UndoBrushStroke {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UndoBrushStroke {}";
  }
}

extension _$_SetBrushColorToString on _SetBrushColor {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetBrushColor {value: $value}";
  }
}

extension _$_SetBrushRadiusToString on _SetBrushRadius {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetBrushRadius {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetAppliedStrokeIdsToString on _SetAppliedStrokeIds {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAppliedStrokeIds {value: {length: ${value.length}}}";
  }
}

extension _$_SetDstToString on _SetDst {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDst {value: $value, appliedStrokeIds: {length: ${appliedStrokeIds.length}}}";
  }
}

extension _$_SetIsApplyingFiltersToString on _SetIsApplyingFilters {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetIsApplyingFilters {value: $value}";
  }
}

extension _$_SaveToString on _Save {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Save {}";
  }
}

extension _$_RequestQuitToString on _RequestQuit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RequestQuit {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}

extension _$_SetSaveErrorToString on _SetSaveError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSaveError {error: $error, stackTrace: $stackTrace}";
  }
}
