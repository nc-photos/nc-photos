import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/widget/image_editor/pixel_toolbar_util.dart';
import 'package:nc_photos/widget/image_editor/toolbar_button.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;

class ColorToolbar extends StatefulWidget {
  const ColorToolbar({
    super.key,
    required this.initialState,
    required this.onActiveFiltersChanged,
  });

  @override
  State<StatefulWidget> createState() => _ColorToolbarState();

  final List<PixelArguments> initialState;
  final ValueChanged<Iterable<PixelArguments>> onActiveFiltersChanged;
}

class _ColorToolbarState extends State<ColorToolbar> {
  @override
  void initState() {
    super.initState();
    for (final s in widget.initialState) {
      _filters[s.getToolType()] = s;
    }
  }

  @override
  Widget build(BuildContext context) =>
      Column(children: [_buildFilterOption(context), _buildFilterBar(context)]);

  Widget _buildFilterOption(BuildContext context) {
    Widget? child;
    switch (_selectedFilter) {
      case PixelToolType.brightness:
        child = _buildBrightnessOption(context);
        break;

      case PixelToolType.contrast:
        child = _buildContrastOption(context);
        break;

      case PixelToolType.whitePoint:
        child = _buildWhitePointOption(context);
        break;

      case PixelToolType.blackPoint:
        child = _buildBlackPointOption(context);
        break;

      case PixelToolType.saturation:
        child = _buildSaturationOption(context);
        break;

      case PixelToolType.warmth:
        child = _buildWarmthOption(context);
        break;

      case PixelToolType.tint:
        child = _buildTintOption(context);
        break;

      case null:
      default:
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
                isSelected: _selectedFilter == PixelToolType.brightness,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.brightness)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.contrast,
                label: L10n.global().imageEditColorContrast,
                onPressed: _onContrastPressed,
                isSelected: _selectedFilter == PixelToolType.contrast,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.contrast)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.circle,
                label: L10n.global().imageEditColorWhitePoint,
                onPressed: _onWhitePointPressed,
                isSelected: _selectedFilter == PixelToolType.whitePoint,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.whitePoint)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.circle_outlined,
                label: L10n.global().imageEditColorBlackPoint,
                onPressed: _onBlackPointPressed,
                isSelected: _selectedFilter == PixelToolType.blackPoint,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.blackPoint)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.invert_colors,
                label: L10n.global().imageEditColorSaturation,
                onPressed: _onSaturationPressed,
                isSelected: _selectedFilter == PixelToolType.saturation,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.saturation)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.thermostat,
                label: L10n.global().imageEditColorWarmth,
                onPressed: _onWarmthPressed,
                isSelected: _selectedFilter == PixelToolType.warmth,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.warmth)
                    .run((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.colorize,
                label: L10n.global().imageEditColorTint,
                onPressed: _onTintPressed,
                isSelected: _selectedFilter == PixelToolType.tint,
                activationOrder: _filters.keys
                    .indexOf(PixelToolType.tint)
                    .run((i) => i == -1 ? null : i),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrightnessOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.brightness.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[PixelToolType.brightness] as _BrightnessArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          PixelToolType.brightness,
          _BrightnessArguments(value),
        ),
  );

  Widget _buildContrastOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.contrast.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[PixelToolType.contrast] as _ContrastArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          PixelToolType.contrast,
          _ContrastArguments(value),
        ),
  );

  Widget _buildWhitePointOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.whitePoint.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[PixelToolType.whitePoint] as _WhitePointArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          PixelToolType.whitePoint,
          _WhitePointArguments(value),
        ),
  );

  Widget _buildBlackPointOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.blackPoint.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[PixelToolType.blackPoint] as _BlackPointArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          PixelToolType.blackPoint,
          _BlackPointArguments(value),
        ),
  );

  Widget _buildSaturationOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.saturation.name),
    min: -100,
    max: 100,
    initialValue:
        (_filters[PixelToolType.saturation] as _SaturationArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          PixelToolType.saturation,
          _SaturationArguments(value),
        ),
  );

  Widget _buildWarmthOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.warmth.name),
    min: -100,
    max: 100,
    initialValue: (_filters[PixelToolType.warmth] as _WarmthArguments).value,
    onChangeEnd:
        (value) => _onOptionValueChanged(
          PixelToolType.warmth,
          _WarmthArguments(value),
        ),
  );

  Widget _buildTintOption(BuildContext context) => PixelToolSlider(
    key: Key(PixelToolType.tint.name),
    min: -100,
    max: 100,
    initialValue: (_filters[PixelToolType.tint] as _TintArguments).value,
    onChangeEnd:
        (value) =>
            _onOptionValueChanged(PixelToolType.tint, _TintArguments(value)),
  );

  void _onFilterPressed(PixelToolType type, PixelArguments defArgs) {
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
      _onFilterPressed(PixelToolType.brightness, const _BrightnessArguments(0));
  void _onContrastPressed() =>
      _onFilterPressed(PixelToolType.contrast, const _ContrastArguments(0));
  void _onWhitePointPressed() =>
      _onFilterPressed(PixelToolType.whitePoint, const _WhitePointArguments(0));
  void _onBlackPointPressed() =>
      _onFilterPressed(PixelToolType.blackPoint, const _BlackPointArguments(0));
  void _onSaturationPressed() =>
      _onFilterPressed(PixelToolType.saturation, const _SaturationArguments(0));
  void _onWarmthPressed() =>
      _onFilterPressed(PixelToolType.warmth, const _WarmthArguments(0));
  void _onTintPressed() =>
      _onFilterPressed(PixelToolType.tint, const _TintArguments(0));

  void _onOptionValueChanged(PixelToolType type, PixelArguments args) {
    setState(() {
      _filters[type] = args;
    });
    _notifyFiltersChanged();
  }

  void _notifyFiltersChanged() {
    widget.onActiveFiltersChanged.call(_filters.values);
  }

  final _filters = <PixelToolType, PixelArguments>{};
  PixelToolType? _selectedFilter;
}

class _BrightnessArguments implements PixelArguments {
  const _BrightnessArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.BrightnessEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.brightness;

  final double value;
}

class _ContrastArguments implements PixelArguments {
  const _ContrastArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.ContrastEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.contrast;

  final double value;
}

class _WhitePointArguments implements PixelArguments {
  const _WhitePointArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.WhitePointEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.whitePoint;

  final double value;
}

class _BlackPointArguments implements PixelArguments {
  const _BlackPointArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.BlackPointEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.blackPoint;

  final double value;
}

class _SaturationArguments implements PixelArguments {
  const _SaturationArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.SaturationEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.saturation;

  final double value;
}

class _WarmthArguments implements PixelArguments {
  const _WarmthArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.WarmthEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.warmth;

  final double value;
}

class _TintArguments implements PixelArguments {
  const _TintArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.TintEdit(value / 100);

  @override
  PixelToolType getToolType() => PixelToolType.tint;

  final double value;
}
