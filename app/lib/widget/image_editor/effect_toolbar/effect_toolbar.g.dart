// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effect_toolbar.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_FaceReshapeArgumentsCopyWithWorker {
  _FaceReshapeArguments call({double? jawline, double? eyeSize});
}

class _$_FaceReshapeArgumentsCopyWithWorkerImpl
    implements $_FaceReshapeArgumentsCopyWithWorker {
  _$_FaceReshapeArgumentsCopyWithWorkerImpl(this.that);

  @override
  _FaceReshapeArguments call({dynamic jawline, dynamic eyeSize}) {
    return _FaceReshapeArguments(
      jawline: jawline as double? ?? that.jawline,
      eyeSize: eyeSize as double? ?? that.eyeSize,
    );
  }

  final _FaceReshapeArguments that;
}

extension $_FaceReshapeArgumentsCopyWith on _FaceReshapeArguments {
  $_FaceReshapeArgumentsCopyWithWorker get copyWith => _$copyWith;
  $_FaceReshapeArgumentsCopyWithWorker get _$copyWith =>
      _$_FaceReshapeArgumentsCopyWithWorkerImpl(this);
}

abstract class $_SketchArgumentsCopyWithWorker {
  _SketchArguments call({double? edge, double? hatching});
}

class _$_SketchArgumentsCopyWithWorkerImpl
    implements $_SketchArgumentsCopyWithWorker {
  _$_SketchArgumentsCopyWithWorkerImpl(this.that);

  @override
  _SketchArguments call({dynamic edge, dynamic hatching}) {
    return _SketchArguments(
      edge: edge as double? ?? that.edge,
      hatching: hatching as double? ?? that.hatching,
    );
  }

  final _SketchArguments that;
}

extension $_SketchArgumentsCopyWith on _SketchArguments {
  $_SketchArgumentsCopyWithWorker get copyWith => _$copyWith;
  $_SketchArgumentsCopyWithWorker get _$copyWith =>
      _$_SketchArgumentsCopyWithWorkerImpl(this);
}

abstract class $_ToonArgumentsCopyWithWorker {
  _ToonArguments call({double? edge, double? quantization});
}

class _$_ToonArgumentsCopyWithWorkerImpl
    implements $_ToonArgumentsCopyWithWorker {
  _$_ToonArgumentsCopyWithWorkerImpl(this.that);

  @override
  _ToonArguments call({dynamic edge, dynamic quantization}) {
    return _ToonArguments(
      edge: edge as double? ?? that.edge,
      quantization: quantization as double? ?? that.quantization,
    );
  }

  final _ToonArguments that;
}

extension $_ToonArgumentsCopyWith on _ToonArguments {
  $_ToonArgumentsCopyWithWorker get copyWith => _$copyWith;
  $_ToonArgumentsCopyWithWorker get _$copyWith =>
      _$_ToonArgumentsCopyWithWorkerImpl(this);
}

abstract class $_StateCopyWithWorker {
  _State call({
    Map<PixelToolType, PixelArguments>? filters,
    PixelToolType? selectedFilter,
    _FaceReshapeOptionType? faceReshapeOptionType,
    _SketchOptionType? sketchOptionType,
    _ToonOptionType? toonOptionType,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic filters,
    dynamic selectedFilter = copyWithNull,
    dynamic faceReshapeOptionType,
    dynamic sketchOptionType,
    dynamic toonOptionType,
  }) {
    return _State(
      filters: filters as Map<PixelToolType, PixelArguments>? ?? that.filters,
      selectedFilter: selectedFilter == copyWithNull
          ? that.selectedFilter
          : selectedFilter as PixelToolType?,
      faceReshapeOptionType:
          faceReshapeOptionType as _FaceReshapeOptionType? ??
          that.faceReshapeOptionType,
      sketchOptionType:
          sketchOptionType as _SketchOptionType? ?? that.sketchOptionType,
      toonOptionType: toonOptionType as _ToonOptionType? ?? that.toonOptionType,
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
    return "_State {filters: {length: ${filters.length}}, selectedFilter: ${selectedFilter == null ? null : "${selectedFilter!.name}"}, faceReshapeOptionType: ${faceReshapeOptionType.name}, sketchOptionType: ${sketchOptionType.name}, toonOptionType: ${toonOptionType.name}}";
  }
}

extension _$_ToggleActiveToolToString on _ToggleActiveTool {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleActiveTool {value: ${value.name}}";
  }
}

extension _$_SetFaceReshapeOptionTypeToString on _SetFaceReshapeOptionType {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFaceReshapeOptionType {value: ${value.name}}";
  }
}

extension _$_SetFaceReshapeOptionJawlineToString
    on _SetFaceReshapeOptionJawline {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFaceReshapeOptionJawline {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetFaceReshapeOptionEyeSizeToString
    on _SetFaceReshapeOptionEyeSize {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFaceReshapeOptionEyeSize {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetPixelationOptionToString on _SetPixelationOption {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPixelationOption {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetPosterizationOptionToString on _SetPosterizationOption {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPosterizationOption {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetSketchOptionTypeToString on _SetSketchOptionType {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSketchOptionType {value: ${value.name}}";
  }
}

extension _$_SetSketchOptionEdgeToString on _SetSketchOptionEdge {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSketchOptionEdge {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetSketchOptionHatchingToString on _SetSketchOptionHatching {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSketchOptionHatching {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetToonOptionTypeToString on _SetToonOptionType {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetToonOptionType {value: ${value.name}}";
  }
}

extension _$_SetToonOptionEdgeToString on _SetToonOptionEdge {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetToonOptionEdge {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetToonOptionQuantizationToString on _SetToonOptionQuantization {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetToonOptionQuantization {value: ${value.toStringAsFixed(3)}}";
  }
}
