part of 'effect_toolbar.dart';

enum _FaceReshapeOptionType { jawline, eyeSize }

enum _SketchOptionType { edge, hatching }

enum _ToonOptionType { edge, quantization }

@genCopyWith
@toString
class _State {
  const _State({
    required this.filters,
    this.selectedFilter,
    required this.faceReshapeOptionType,
    required this.sketchOptionType,
    required this.toonOptionType,
  });

  factory _State.init({required List<PixelArguments> initialFilters}) {
    final filters = {for (final f in initialFilters) f.getToolType(): f};
    return _State(
      filters: filters,
      faceReshapeOptionType: _FaceReshapeOptionType.jawline,
      sketchOptionType: _SketchOptionType.edge,
      toonOptionType: _ToonOptionType.edge,
    );
  }

  @override
  String toString() => _$toString();

  final Map<PixelToolType, PixelArguments> filters;
  final PixelToolType? selectedFilter;

  final _FaceReshapeOptionType faceReshapeOptionType;
  final _SketchOptionType sketchOptionType;
  final _ToonOptionType toonOptionType;
}

sealed class _Event {}

@toString
class _ToggleActiveTool implements _Event {
  const _ToggleActiveTool(this.value);

  @override
  String toString() => _$toString();

  final PixelToolType value;
}

@toString
class _SetFaceReshapeOptionType implements _Event {
  const _SetFaceReshapeOptionType(this.value);

  @override
  String toString() => _$toString();

  final _FaceReshapeOptionType value;
}

@toString
class _SetFaceReshapeOptionJawline implements _Event {
  const _SetFaceReshapeOptionJawline(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetFaceReshapeOptionEyeSize implements _Event {
  const _SetFaceReshapeOptionEyeSize(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetPixelationOption implements _Event {
  const _SetPixelationOption(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetPosterizationOption implements _Event {
  const _SetPosterizationOption(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetSketchOptionType implements _Event {
  const _SetSketchOptionType(this.value);

  @override
  String toString() => _$toString();

  final _SketchOptionType value;
}

@toString
class _SetSketchOptionEdge implements _Event {
  const _SetSketchOptionEdge(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetSketchOptionHatching implements _Event {
  const _SetSketchOptionHatching(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetToonOptionType implements _Event {
  const _SetToonOptionType(this.value);

  @override
  String toString() => _$toString();

  final _ToonOptionType value;
}

@toString
class _SetToonOptionEdge implements _Event {
  const _SetToonOptionEdge(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetToonOptionQuantization implements _Event {
  const _SetToonOptionQuantization(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

class _EtBloc extends Bloc<_Event, _State> {
  _EtBloc({
    required this.initialFilters,
    required this.onActiveFiltersChanged,
    required this.isFaceSelectionModeChanged,
    this.onFaceFilterValueChanged,
  }) : super(_State.init(initialFilters: initialFilters)) {
    on<_ToggleActiveTool>(_onToggleActiveTool);
    on<_SetFaceReshapeOptionType>(_onSetFaceReshapeOptionType);
    on<_SetFaceReshapeOptionJawline>(_onSetFaceReshapeOptionJawline);
    on<_SetFaceReshapeOptionEyeSize>(_onSetFaceReshapeOptionEyeSize);
    on<_SetPixelationOption>(_onSetPixelationOption);
    on<_SetPosterizationOption>(_onSetPosterizationOption);
    on<_SetSketchOptionType>(_onSetSketchOptionType);
    on<_SetSketchOptionEdge>(_onSetSketchOptionEdge);
    on<_SetSketchOptionHatching>(_onSetSketchOptionHatching);
    on<_SetToonOptionType>(_onSetToonOptionType);
    on<_SetToonOptionEdge>(_onSetToonOptionEdge);
    on<_SetToonOptionQuantization>(_onSetToonOptionQuantization);
  }

  void _onToggleActiveTool(_ToggleActiveTool ev, _Emitter emit) {
    _log.info(ev);
    if (state.selectedFilter == ev.value) {
      // deactivate
      emit(
        state.copyWith(
          selectedFilter: null,
          filters: state.filters.removed(ev.value),
        ),
      );
      if (ev.value == PixelToolType.faceReshape) {
        isFaceSelectionModeChanged(false);
      }
    } else {
      // activate
      if (state.selectedFilter == PixelToolType.faceReshape) {
        isFaceSelectionModeChanged(false);
      }
      final next = Map.of(state.filters);
      next[ev.value] ??= switch (ev.value) {
        PixelToolType.faceReshape => const _FaceReshapeArguments(
          jawline: 0,
          eyeSize: 0,
        ),
        PixelToolType.halftone => const _HalftoneArguments(),
        PixelToolType.pixelation => const _PixelationArguments(0),
        PixelToolType.posterization => const _PosterizationArguments(5),
        PixelToolType.sketch => const _SketchArguments(edge: .3, hatching: .2),
        PixelToolType.toon => const _ToonArguments(edge: .3, quantization: .5),
        _ => throw ArgumentError("Unknown PixelToolType: ${ev.value}"),
      };
      emit(state.copyWith(selectedFilter: ev.value, filters: next));
      if (ev.value == PixelToolType.faceReshape) {
        isFaceSelectionModeChanged(true);
      }
    }
    onActiveFiltersChanged(state.filters.values);
  }

  void _onSetFaceReshapeOptionType(
    _SetFaceReshapeOptionType ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    emit(state.copyWith(faceReshapeOptionType: ev.value));
  }

  void _onSetFaceReshapeOptionJawline(
    _SetFaceReshapeOptionJawline ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.faceReshape] = (next[PixelToolType.faceReshape]
            as _FaceReshapeArguments)
        .copyWith(jawline: ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
    onFaceFilterValueChanged?.call();
  }

  void _onSetFaceReshapeOptionEyeSize(
    _SetFaceReshapeOptionEyeSize ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.faceReshape] = (next[PixelToolType.faceReshape]
            as _FaceReshapeArguments)
        .copyWith(eyeSize: ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
    onFaceFilterValueChanged?.call();
  }

  void _onSetPixelationOption(_SetPixelationOption ev, _Emitter emit) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.pixelation] = _PixelationArguments(ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
  }

  void _onSetPosterizationOption(_SetPosterizationOption ev, _Emitter emit) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.posterization] = _PosterizationArguments(ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
  }

  void _onSetSketchOptionType(_SetSketchOptionType ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(sketchOptionType: ev.value));
  }

  void _onSetSketchOptionEdge(_SetSketchOptionEdge ev, _Emitter emit) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.sketch] = (next[PixelToolType.sketch]
            as _SketchArguments)
        .copyWith(edge: ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
  }

  void _onSetSketchOptionHatching(_SetSketchOptionHatching ev, _Emitter emit) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.sketch] = (next[PixelToolType.sketch]
            as _SketchArguments)
        .copyWith(hatching: ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
  }

  void _onSetToonOptionType(_SetToonOptionType ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(toonOptionType: ev.value));
  }

  void _onSetToonOptionEdge(_SetToonOptionEdge ev, _Emitter emit) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.toon] = (next[PixelToolType.toon] as _ToonArguments)
        .copyWith(edge: ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
  }

  void _onSetToonOptionQuantization(
    _SetToonOptionQuantization ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    final next = Map.of(state.filters);
    next[PixelToolType.toon] = (next[PixelToolType.toon] as _ToonArguments)
        .copyWith(quantization: ev.value);
    emit(state.copyWith(filters: next));
    onActiveFiltersChanged(state.filters.values);
  }

  final List<PixelArguments> initialFilters;
  final ValueChanged<Iterable<PixelArguments>> onActiveFiltersChanged;
  final ValueChanged<bool> isFaceSelectionModeChanged;
  final VoidCallback? onFaceFilterValueChanged;

  static final _log = Logger("EffectToolbarBloc");
}
