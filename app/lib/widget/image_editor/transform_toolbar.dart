import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/widget/image_editor/crop_controller.dart';
import 'package:nc_photos/widget/image_editor/orientation_view.dart';
import 'package:nc_photos/widget/image_editor/toolbar_button.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar_util.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';

export 'package:nc_photos/widget/image_editor/transform_toolbar_util.dart';

class TransformToolbar extends StatefulWidget {
  const TransformToolbar({
    super.key,
    required this.initialState,
    required this.onActiveFiltersChanged,
    required this.onActiveToolChanged,
  });

  @override
  State<StatefulWidget> createState() => _TransformToolbarState();

  final List<TransformArguments> initialState;
  final ValueChanged<Iterable<TransformArguments>> onActiveFiltersChanged;
  final ValueChanged<TransformToolType?> onActiveToolChanged;
}

class _TransformToolbarState extends State<TransformToolbar> {
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
      case TransformToolType.orientation:
        child = _buildOrientationOption(context);
        break;

      case TransformToolType.crop:
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
                icon: Icons.crop_outlined,
                label: L10n.global().imageEditTransformCrop,
                onPressed: _onCropPressed,
                isSelected: _selectedFilter == TransformToolType.crop,
                activationOrder: _filters.keys
                    .indexOf(TransformToolType.crop)
                    .let((i) => i == -1 ? null : i),
              ),
              ToolbarButton(
                icon: Icons.rotate_90_degrees_ccw_outlined,
                label: L10n.global().imageEditTransformOrientation,
                onPressed: _onOrientationPressed,
                isSelected: _selectedFilter == TransformToolType.orientation,
                activationOrder: _filters.keys
                    .indexOf(TransformToolType.orientation)
                    .let((i) => i == -1 ? null : i),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrientationOption(BuildContext context) {
    final value =
        (_filters[TransformToolType.orientation] as OrientationArguments).value;
    return _OrientationOption(
      value: value,
      onValuePressed: (value) {
        setState(() {
          _filters[TransformToolType.orientation] = OrientationArguments(value);
        });
        _notifyFiltersChanged();
      },
    );
  }

  void _onFilterPressed(TransformToolType type, TransformArguments defArgs) {
    var isChanged = false;
    if (_selectedFilter == type) {
      // deactivate filter
      setState(() {
        _selectedFilter = null;
        _filters.remove(type);
      });
      isChanged = true;
    } else {
      setState(() {
        _selectedFilter = type;
        _filters[type] ??= defArgs;
      });
    }
    widget.onActiveToolChanged(_selectedFilter);
    if (isChanged) {
      _notifyFiltersChanged();
    }
  }

  void _onCropPressed() =>
      _onFilterPressed(TransformToolType.crop, const CropArguments(0, 0, 1, 1));
  void _onOrientationPressed() => _onFilterPressed(
    TransformToolType.orientation,
    const OrientationArguments(0),
  );

  void _notifyFiltersChanged() {
    widget.onActiveFiltersChanged.call(_filters.values);
  }

  final _filters = <TransformToolType, TransformArguments>{};
  TransformToolType? _selectedFilter;
}

class _OrientationOption extends StatelessWidget {
  const _OrientationOption({required this.value, required this.onValuePressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _OrientationButton(
                  label:
                      "180\n${L10n.global().imageEditTransformOrientationCounterclockwise}",
                  isSelected: value == 180,
                  onPressed: () => onValuePressed(180),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _OrientationButton(
                  label:
                      "90\n${L10n.global().imageEditTransformOrientationCounterclockwise}",
                  isSelected: value == 90,
                  onPressed: () => onValuePressed(90),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _OrientationButton(
                  label: "0\n ",
                  isSelected: value == 0,
                  onPressed: () => onValuePressed(0),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _OrientationButton(
                  label:
                      "90\n${L10n.global().imageEditTransformOrientationClockwise}",
                  isSelected: value == -90,
                  onPressed: () => onValuePressed(-90),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _OrientationButton(
                  label:
                      "180\n${L10n.global().imageEditTransformOrientationClockwise}",
                  isSelected: value == -180,
                  onPressed: () => onValuePressed(-180),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final int value;
  final void Function(int value) onValuePressed;
}

class _OrientationButton extends StatelessWidget {
  const _OrientationButton({
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : null,
                // borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
}
