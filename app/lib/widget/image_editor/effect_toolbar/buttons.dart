part of 'effect_toolbar.dart';

class _FaceReshapeButton extends StatelessWidget {
  const _FaceReshapeButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.filters != current.filters,
      builder: (context, state) => ToolbarButton(
        icon: Icons.face_retouching_natural_outlined,
        label: L10n.global().imageEditEffectFace,
        onPressed: () {
          context.addEvent(const _ToggleActiveTool(PixelToolType.faceReshape));
        },
        isSelected: state.selectedFilter == PixelToolType.faceReshape,
        activationOrder: state.filters.keys
            .indexOf(PixelToolType.faceReshape)
            .let((i) => i == -1 ? null : i),
      ),
    );
  }
}

class _FaceReshapeOption extends StatelessWidget {
  const _FaceReshapeOption();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _BlocSelector(
              selector: (state) => state.faceReshapeOptionType,
              builder: (context, faceReshapeOptionType) => Row(
                children: [
                  ChoiceChip(
                    label: Text(L10n.global().imageEditEffectParamJawline),
                    selected:
                        faceReshapeOptionType == _FaceReshapeOptionType.jawline,
                    showCheckmark: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onSelected: (value) {
                      context.addEvent(
                        const _SetFaceReshapeOptionType(
                          _FaceReshapeOptionType.jawline,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(L10n.global().imageEditEffectParamEyeSize),
                    selected:
                        faceReshapeOptionType == _FaceReshapeOptionType.eyeSize,
                    showCheckmark: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onSelected: (value) {
                      context.addEvent(
                        const _SetFaceReshapeOptionType(
                          _FaceReshapeOptionType.eyeSize,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _BlocBuilder(
            buildWhen: (previous, current) =>
                previous.faceReshapeOptionType != current.faceReshapeOptionType,
            builder: (context, state) => switch (state.faceReshapeOptionType) {
              _FaceReshapeOptionType.jawline => StatefulSlider(
                key: Key(
                  PixelToolType.faceReshape.name +
                      _FaceReshapeOptionType.jawline.name,
                ),
                min: -1,
                initialValue:
                    (state.filters[PixelToolType.faceReshape]
                            as _FaceReshapeArguments)
                        .jawline,
                onChangeEnd: (value) {
                  context.addEvent(_SetFaceReshapeOptionJawline(value));
                },
              ),
              _FaceReshapeOptionType.eyeSize => StatefulSlider(
                key: Key(
                  PixelToolType.faceReshape.name +
                      _FaceReshapeOptionType.eyeSize.name,
                ),
                initialValue:
                    (state.filters[PixelToolType.faceReshape]
                            as _FaceReshapeArguments)
                        .eyeSize,
                onChangeEnd: (value) {
                  context.addEvent(_SetFaceReshapeOptionEyeSize(value));
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _HalftoneButton extends StatelessWidget {
  const _HalftoneButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.filters != current.filters,
      builder: (context, state) => ToolbarButton(
        icon: Icons.blur_on,
        label: L10n.global().imageEditEffectHalftone,
        onPressed: () {
          context.addEvent(const _ToggleActiveTool(PixelToolType.halftone));
        },
        isSelected: state.selectedFilter == PixelToolType.halftone,
        activationOrder: state.filters.keys
            .indexOf(PixelToolType.halftone)
            .let((i) => i == -1 ? null : i),
      ),
    );
  }
}

class _PixelationButton extends StatelessWidget {
  const _PixelationButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.filters != current.filters,
      builder: (context, state) => ToolbarButton(
        icon: Icons.apps,
        label: L10n.global().imageEditEffectPixelation,
        onPressed: () {
          context.addEvent(const _ToggleActiveTool(PixelToolType.pixelation));
        },
        isSelected: state.selectedFilter == PixelToolType.pixelation,
        activationOrder: state.filters.keys
            .indexOf(PixelToolType.pixelation)
            .let((i) => i == -1 ? null : i),
      ),
    );
  }
}

class _PixelationOption extends StatelessWidget {
  const _PixelationOption(this.initialValue);

  @override
  Widget build(BuildContext context) {
    return PixelToolSlider(
      key: Key(PixelToolType.pixelation.name),
      min: 0,
      max: 100,
      initialValue:
          (context.state.filters[PixelToolType.pixelation]
                  as _PixelationArguments)
              .value,
      onChangeEnd: (value) {
        context.addEvent(_SetPixelationOption(value));
      },
    );
  }

  final double initialValue;
}

class _PosterizationButton extends StatelessWidget {
  const _PosterizationButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.filters != current.filters,
      builder: (context, state) => ToolbarButton(
        icon: Icons.filter_b_and_w,
        label: L10n.global().imageEditEffectPosterization,
        onPressed: () {
          context.addEvent(
            const _ToggleActiveTool(PixelToolType.posterization),
          );
        },
        isSelected: state.selectedFilter == PixelToolType.posterization,
        activationOrder: state.filters.keys
            .indexOf(PixelToolType.posterization)
            .let((i) => i == -1 ? null : i),
      ),
    );
  }
}

class _PosterizationOption extends StatelessWidget {
  const _PosterizationOption(this.initialValue);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Icon(Icons.remove),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          StatefulSlider(
            key: Key(PixelToolType.posterization.name),
            initialValue: initialValue.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChangeEnd: (value) {
              context.addEvent(_SetPosterizationOption(value));
            },
          ),
        ],
      ),
    );
  }

  final double initialValue;
}

class _SketchButton extends StatelessWidget {
  const _SketchButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.filters != current.filters,
      builder: (context, state) => ToolbarButton(
        icon: Icons.draw_outlined,
        label: L10n.global().imageEditEffectSketch,
        onPressed: () {
          context.addEvent(const _ToggleActiveTool(PixelToolType.sketch));
        },
        isSelected: state.selectedFilter == PixelToolType.sketch,
        activationOrder: state.filters.keys
            .indexOf(PixelToolType.sketch)
            .let((i) => i == -1 ? null : i),
      ),
    );
  }
}

class _SketchOption extends StatelessWidget {
  const _SketchOption();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _BlocSelector(
              selector: (state) => state.sketchOptionType,
              builder: (context, sketchOptionType) => Row(
                children: [
                  ChoiceChip(
                    label: Text(L10n.global().imageEditEffectParamEdge),
                    selected: sketchOptionType == _SketchOptionType.edge,
                    showCheckmark: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onSelected: (value) {
                      context.addEvent(
                        const _SetSketchOptionType(_SketchOptionType.edge),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(L10n.global().imageEditEffectParamHatching),
                    selected: sketchOptionType == _SketchOptionType.hatching,
                    showCheckmark: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onSelected: (value) {
                      context.addEvent(
                        const _SetSketchOptionType(_SketchOptionType.hatching),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _BlocBuilder(
            buildWhen: (previous, current) =>
                previous.sketchOptionType != current.sketchOptionType,
            builder: (context, state) => switch (state.sketchOptionType) {
              _SketchOptionType.edge => StatefulSlider(
                key: Key(
                  PixelToolType.sketch.name + _SketchOptionType.edge.name,
                ),
                initialValue:
                    (state.filters[PixelToolType.sketch] as _SketchArguments)
                        .edge,
                onChangeEnd: (value) {
                  context.addEvent(_SetSketchOptionEdge(value));
                },
              ),
              _SketchOptionType.hatching => StatefulSlider(
                key: Key(
                  PixelToolType.sketch.name + _SketchOptionType.hatching.name,
                ),
                initialValue:
                    (state.filters[PixelToolType.sketch] as _SketchArguments)
                        .hatching,
                onChangeEnd: (value) {
                  context.addEvent(_SetSketchOptionHatching(value));
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _ToonButton extends StatelessWidget {
  const _ToonButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.filters != current.filters,
      builder: (context, state) => ToolbarButton(
        icon: Icons.cruelty_free_outlined,
        label: L10n.global().imageEditEffectToon,
        onPressed: () {
          context.addEvent(const _ToggleActiveTool(PixelToolType.toon));
        },
        isSelected: state.selectedFilter == PixelToolType.toon,
        activationOrder: state.filters.keys
            .indexOf(PixelToolType.toon)
            .let((i) => i == -1 ? null : i),
      ),
    );
  }
}

class _ToonOption extends StatelessWidget {
  const _ToonOption();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _BlocSelector(
              selector: (state) => state.toonOptionType,
              builder: (context, toonOptionType) => Row(
                children: [
                  ChoiceChip(
                    label: Text(L10n.global().imageEditEffectParamEdge),
                    selected: toonOptionType == _ToonOptionType.edge,
                    showCheckmark: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onSelected: (value) {
                      context.addEvent(
                        const _SetToonOptionType(_ToonOptionType.edge),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(L10n.global().imageEditEffectParamColor),
                    selected: toonOptionType == _ToonOptionType.quantization,
                    showCheckmark: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onSelected: (value) {
                      context.addEvent(
                        const _SetToonOptionType(_ToonOptionType.quantization),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _BlocBuilder(
            buildWhen: (previous, current) =>
                previous.toonOptionType != current.toonOptionType,
            builder: (context, state) => switch (state.toonOptionType) {
              _ToonOptionType.edge => StatefulSlider(
                key: Key(PixelToolType.toon.name + _ToonOptionType.edge.name),
                initialValue:
                    (state.filters[PixelToolType.toon] as _ToonArguments).edge,
                onChangeEnd: (value) {
                  context.addEvent(_SetToonOptionEdge(value));
                },
              ),
              _ToonOptionType.quantization => StatefulSlider(
                key: Key(
                  PixelToolType.toon.name + _ToonOptionType.quantization.name,
                ),
                initialValue:
                    (state.filters[PixelToolType.toon] as _ToonArguments)
                        .quantization,
                onChangeEnd: (value) {
                  context.addEvent(_SetToonOptionQuantization(value));
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}
