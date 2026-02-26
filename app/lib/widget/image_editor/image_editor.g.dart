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
    List<ColorArguments>? colorFilters,
    List<TransformArguments>? transformFilters,
    TransformArguments? cropFilter,
    _ToolType? activeTool,
    bool? isCropMode,
    Unique<void>? quitRequest,
    bool? isSaved,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic src = copyWithNull,
    dynamic dst = copyWithNull,
    dynamic colorFilters,
    dynamic transformFilters,
    dynamic cropFilter = copyWithNull,
    dynamic activeTool,
    dynamic isCropMode,
    dynamic quitRequest = copyWithNull,
    dynamic isSaved,
    dynamic error = copyWithNull,
  }) {
    return _State(
      src: src == copyWithNull ? that.src : src as Rgba8Image?,
      dst: dst == copyWithNull ? that.dst : dst as Rgba8Image?,
      colorFilters: colorFilters as List<ColorArguments>? ?? that.colorFilters,
      transformFilters:
          transformFilters as List<TransformArguments>? ??
          that.transformFilters,
      cropFilter:
          cropFilter == copyWithNull
              ? that.cropFilter
              : cropFilter as TransformArguments?,
      activeTool: activeTool as _ToolType? ?? that.activeTool,
      isCropMode: isCropMode as bool? ?? that.isCropMode,
      quitRequest:
          quitRequest == copyWithNull
              ? that.quitRequest
              : quitRequest as Unique<void>?,
      isSaved: isSaved as bool? ?? that.isSaved,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
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
    return "_State {src: $src, dst: $dst, colorFilters: [length: ${colorFilters.length}], transformFilters: [length: ${transformFilters.length}], cropFilter: $cropFilter, activeTool: ${activeTool.name}, isCropMode: $isCropMode, quitRequest: $quitRequest, isSaved: $isSaved, error: $error}";
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

extension _$_SetCropModeToString on _SetCropMode {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCropMode {value: $value}";
  }
}

extension _$_SetColorFiltersToString on _SetColorFilters {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetColorFilters {value: [length: ${value.length}]}";
  }
}

extension _$_SetTransformFiltersToString on _SetTransformFilters {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetTransformFilters {value: [length: ${value.length}]}";
  }
}

extension _$_SetCropFilterToString on _SetCropFilter {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCropFilter {value: $value}";
  }
}

extension _$_SetDstToString on _SetDst {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDst {value: $value}";
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
