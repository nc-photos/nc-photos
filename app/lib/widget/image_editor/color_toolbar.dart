import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/widget/image_editor/toolbar_button.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_platform_image_processor/np_platform_image_processor.dart';
import 'package:np_string/np_string.dart';
import 'package:np_ui/np_ui.dart';

enum ColorToolType {
  brightness,
  contrast,
  whitePoint,
  blackPoint,
  saturation,
  warmth,
  tint,
}

abstract class ColorArguments {
  ImageFilter toImageFilter();

  ColorToolType _getToolType();
}

class ColorToolbar extends StatefulWidget {
  const ColorToolbar({
    super.key,
    required this.initialState,
    required this.onActiveFiltersChanged,
  });

  @override
  createState() => _ColorToolbarState();

  final List<ColorArguments> initialState;
  final ValueChanged<Iterable<ColorArguments>> onActiveFiltersChanged;
}

class _ColorToolbarState extends State<ColorToolbar> {
  @override
  initState() {
    super.initState();
    for (final s in widget.initialState) {
      _filters[s._getToolType()] = s;
    }
  }

  @override
  build(BuildContext context) =>
      Column(children: [_buildFilterOption(context), _buildFilterBar(context)]);

  Widget _buildFilterOption(BuildContext context) {
    Widget? child;
    switch (_selectedFilter) {
      case ColorToolType.brightness:
        child = _buildBrightnessOption(context);
        break;

      case ColorToolType.contrast:
        child = _buildContrastOption(context);
        break;

      case ColorToolType.whitePoint:
        child = _buildWhitePointOption(context);
        break;

      case ColorToolType.blackPoint:
        child = _buildBlackPointOption(context);
        break;

      case ColorToolType.saturation:
        child = _buildSaturationOption(context);
        break;

      case ColorToolType.warmth:
        child = _buildWarmthOption(context);
        break;

      case ColorToolType.tint:
        child = _buildTintOption(context);
        break;

      case null:
        child = null;
        break;
    }
    return Container(
      height: 80,
      alignment: Alignment.bottomCenter,
      child: child,
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 16),
              ToolbarButton(
                icon: Icons.brightness_medium,
                label: L10n.global().imageEditColorBrightness,
                onPressed: _onBrightnessPressed,
                isSelected: _selectedFilter == ColorToolType.brightness,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.brightness)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.contrast,
                label: L10n.global().imageEditColorContrast,
                onPressed: _onContrastPressed,
                isSelected: _selectedFilter == ColorToolType.contrast,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.contrast)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.circle,
                label: L10n.global().imageEditColorWhitePoint,
                onPressed: _onWhitePointPressed,
                isSelected: _selectedFilter == ColorToolType.whitePoint,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.whitePoint)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.circle_outlined,
                label: L10n.global().imageEditColorBlackPoint,
                onPressed: _onBlackPointPressed,
                isSelected: _selectedFilter == ColorToolType.blackPoint,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.blackPoint)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.invert_colors,
                label: L10n.global().imageEditColorSaturation,
                onPressed: _onSaturationPressed,
                isSelected: _selectedFilter == ColorToolType.saturation,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.saturation)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.thermostat,
                label: L10n.global().imageEditColorWarmth,
                onPressed: _onWarmthPressed,
                isSelected: _selectedFilter == ColorToolType.warmth,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.warmth)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.colorize,
                label: L10n.global().imageEditColorTint,
                onPressed: _onTintPressed,
                isSelected: _selectedFilter == ColorToolType.tint,
                activationOrder: _filters.keys
                    .indexOf(ColorToolType.tint)
                    .run((i) => i == -1 ? null : i),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderOption(
    BuildContext context, {
    required Key key,
    required double min,
    required double max,
    required double initialValue,
    ValueChanged<double>? onChangeEnd,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(min.toStringAsFixedTruncated(1)),
                ),
                if (min < 0 && max > 0)
                  const Align(
                    alignment: AlignmentDirectional.center,
                    child: Text("0"),
                  ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(max.toStringAsFixedTruncated(1)),
                ),
              ],
            ),
          ),
          StatefulSlider(
            key: key,
            initialValue: initialValue.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }

  Widget _buildBrightnessOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.brightness.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[ColorToolType.brightness] as _BrightnessArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          ColorToolType.brightness,
          _BrightnessArguments(value),
        ),
  );

  Widget _buildContrastOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.contrast.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[ColorToolType.contrast] as _ContrastArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          ColorToolType.contrast,
          _ContrastArguments(value),
        ),
  );

  Widget _buildWhitePointOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.whitePoint.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[ColorToolType.whitePoint] as _WhitePointArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          ColorToolType.whitePoint,
          _WhitePointArguments(value),
        ),
  );

  Widget _buildBlackPointOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.blackPoint.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[ColorToolType.blackPoint] as _BlackPointArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          ColorToolType.blackPoint,
          _BlackPointArguments(value),
        ),
  );

  Widget _buildSaturationOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.saturation.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[ColorToolType.saturation] as _SaturationArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          ColorToolType.saturation,
          _SaturationArguments(value),
        ),
  );

  Widget _buildWarmthOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.warmth.name),
    min: -100,
    max: 100,
    initialValue: (_filters[ColorToolType.warmth] as _WarmthArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          ColorToolType.warmth,
          _WarmthArguments(value),
        ),
  );

  Widget _buildTintOption(BuildContext context) => _buildSliderOption(
    context,
    key: Key(ColorToolType.tint.name),
    min: -100,
    max: 100,
    initialValue: (_filters[ColorToolType.tint] as _TintArguments).value,
    onChangeEnd:
        (value) =>
            _onOptionValueChanged(ColorToolType.tint, _TintArguments(value)),
  );

  void _onFilterPressed(ColorToolType type, ColorArguments defArgs) {
    if (_selectedFilter == type) {
      // deactivate filter
      setState(() {
        _selectedFilter = null;
        _filters.remove(type);
      });
    } else {
      setState(() {
        _selectedFilter = type;
        _filters[type] ??= defArgs;
      });
    }
    _notifyFiltersChanged();
  }

  void _onBrightnessPressed() =>
      _onFilterPressed(ColorToolType.brightness, const _BrightnessArguments(0));
  void _onContrastPressed() =>
      _onFilterPressed(ColorToolType.contrast, const _ContrastArguments(0));
  void _onWhitePointPressed() =>
      _onFilterPressed(ColorToolType.whitePoint, const _WhitePointArguments(0));
  void _onBlackPointPressed() =>
      _onFilterPressed(ColorToolType.blackPoint, const _BlackPointArguments(0));
  void _onSaturationPressed() =>
      _onFilterPressed(ColorToolType.saturation, const _SaturationArguments(0));
  void _onWarmthPressed() =>
      _onFilterPressed(ColorToolType.warmth, const _WarmthArguments(0));
  void _onTintPressed() =>
      _onFilterPressed(ColorToolType.tint, const _TintArguments(0));

  void _onOptionValueChanged(ColorToolType type, ColorArguments args) {
    setState(() {
      _filters[type] = args;
    });
    _notifyFiltersChanged();
  }

  void _notifyFiltersChanged() {
    widget.onActiveFiltersChanged.call(_filters.values);
  }

  final _filters = <ColorToolType, ColorArguments>{};
  ColorToolType? _selectedFilter;
}

class _BrightnessArguments implements ColorArguments {
  const _BrightnessArguments(this.value);

  @override
  toImageFilter() => ColorBrightnessFilter(value / 100);

  @override
  _getToolType() => ColorToolType.brightness;

  final double value;
}

class _ContrastArguments implements ColorArguments {
  const _ContrastArguments(this.value);

  @override
  toImageFilter() => ColorContrastFilter(value / 100);

  @override
  _getToolType() => ColorToolType.contrast;

  final double value;
}

class _WhitePointArguments implements ColorArguments {
  const _WhitePointArguments(this.value);

  @override
  toImageFilter() => ColorWhitePointFilter(value / 100);

  @override
  _getToolType() => ColorToolType.whitePoint;

  final double value;
}

class _BlackPointArguments implements ColorArguments {
  const _BlackPointArguments(this.value);

  @override
  toImageFilter() => ColorBlackPointFilter(value / 100);

  @override
  _getToolType() => ColorToolType.blackPoint;

  final double value;
}

class _SaturationArguments implements ColorArguments {
  const _SaturationArguments(this.value);

  @override
  toImageFilter() => ColorSaturationFilter(value / 100);

  @override
  _getToolType() => ColorToolType.saturation;

  final double value;
}

class _WarmthArguments implements ColorArguments {
  const _WarmthArguments(this.value);

  @override
  toImageFilter() => ColorWarmthFilter(value / 100);

  @override
  _getToolType() => ColorToolType.warmth;

  final double value;
}

class _TintArguments implements ColorArguments {
  const _TintArguments(this.value);

  @override
  toImageFilter() => ColorTintFilter(value / 100);

  @override
  _getToolType() => ColorToolType.tint;

  final double value;
}
