import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';

class ZoomMenuButton extends StatelessWidget {
  const ZoomMenuButton({
    super.key,
    required this.initialZoom,
    required this.minZoom,
    required this.maxZoom,
    this.onZoomChanged,
  });

  @override
  build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.photo_size_select_large),
      tooltip: L10n.global().zoomTooltip,
      itemBuilder:
          (context) => [
            _PopupMenuZoom(
              initialValue: initialZoom,
              minValue: minZoom,
              maxValue: maxZoom,
              onChanged: onZoomChanged,
            ),
          ],
    );
  }

  final int initialZoom;
  final int minZoom;
  final int maxZoom;
  final ValueChanged<int>? onZoomChanged;
}

class _PopupMenuZoom extends PopupMenuEntry<void> {
  const _PopupMenuZoom({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.onChanged,
  });

  @override
  represents(void value) => false;

  @override
  createState() => _PopupMenuZoomState();

  @override
  // this value doesn't seems to do anything?
  final double height = 48.0;

  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int>? onChanged;
}

class _PopupMenuZoomState extends State<_PopupMenuZoom> {
  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  build(BuildContext context) {
    return Slider(
      value: _value.toDouble(),
      min: widget.minValue.toDouble(),
      max: widget.maxValue.toDouble(),
      divisions: (widget.maxValue - widget.minValue).round(),
      onChanged: (value) {
        setState(() {
          _value = value.round();
        });
        widget.onChanged?.call(_value);
      },
    );
  }

  late int _value;
}
