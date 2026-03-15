import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/widget/image_editor/pixel_toolbar_util.dart';
import 'package:nc_photos/widget/image_editor/toolbar_button.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'arguments.dart';
part 'bloc.dart';
part 'buttons.dart';
part 'effect_toolbar.g.dart';

class EffectToolbar extends StatelessWidget {
  const EffectToolbar({
    super.key,
    required this.initialFilters,
    required this.onActiveFiltersChanged,
    required this.isFaceSelectionModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _EtBloc(
            initialFilters: initialFilters,
            onActiveFiltersChanged: onActiveFiltersChanged,
            isFaceSelectionModeChanged: isFaceSelectionModeChanged,
          ),
      child: const _WrappedEffectToolbar(),
    );
  }

  final List<PixelArguments> initialFilters;
  final ValueChanged<Iterable<PixelArguments>> onActiveFiltersChanged;
  final ValueChanged<bool> isFaceSelectionModeChanged;
}

class _WrappedEffectToolbar extends StatelessWidget {
  const _WrappedEffectToolbar();

  @override
  Widget build(BuildContext context) {
    return const Column(children: [_EffectOption(), _EffectBar()]);
  }
}

class _EffectOption extends StatelessWidget {
  const _EffectOption();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.selectedFilter,
      builder:
          (context, selectedFilter) => Container(
            height: 80,
            alignment: Alignment.bottomCenter,
            child: switch (selectedFilter) {
              PixelToolType.faceReshape => const _FaceReshapeOption(),
              PixelToolType.halftone => null,
              PixelToolType.pixelation => _PixelationOption(
                (context.state.filters[PixelToolType.pixelation]
                        as _PixelationArguments)
                    .value,
              ),
              PixelToolType.posterization => _PosterizationOption(
                (context.state.filters[PixelToolType.posterization]
                        as _PosterizationArguments)
                    .value,
              ),
              PixelToolType.sketch => const _SketchOption(),
              PixelToolType.toon => const _ToonOption(),
              null || _ => null,
            },
          ),
    );
  }
}

class _EffectBar extends StatelessWidget {
  const _EffectBar();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _FaceReshapeButton(),
              _HalftoneButton(),
              _PixelationButton(),
              _PosterizationButton(),
              _SketchButton(),
              _ToonButton(),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_EtBloc, _State>;
// typedef _BlocListener = BlocListener<_EtBloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_EtBloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_EtBloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _EtBloc get bloc => read();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
