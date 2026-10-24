import 'package:flutter/material.dart';

/// Slider with state
class StatefulSlider extends StatefulWidget {
  const StatefulSlider({
    super.key,
    required this.initialValue,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<StatefulWidget> createState() => _StatefulSliderState();

  final double initialValue;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
}

class _StatefulSliderState extends State<StatefulSlider> {
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
        widget.onChanged?.call(value);
      },
      onChangeEnd: widget.onChangeEnd,
    );
  }

  late double _value;
}
