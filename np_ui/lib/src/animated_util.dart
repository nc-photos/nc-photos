import 'package:flutter/widgets.dart';

class AnimatedEnterScale extends StatefulWidget {
  const AnimatedEnterScale({
    super.key,
    this.from = 0.0,
    this.to = 1.0,
    this.alignment = Alignment.center,
    this.curve = Curves.linear,
    required this.duration,
    this.onEnd,
    required this.child,
  });

  @override
  State<AnimatedEnterScale> createState() => _AnimatedEnterScaleState();

  final Widget child;
  final double from;
  final double to;
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  final VoidCallback? onEnd;
}

class _AnimatedEnterScaleState extends State<AnimatedEnterScale> {
  @override
  void initState() {
    super.initState();
    _scale = widget.from;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scale = widget.to;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      alignment: widget.alignment,
      curve: widget.curve,
      duration: widget.duration,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }

  late double _scale;
}

class AnimatedEnterOpacity extends StatefulWidget {
  const AnimatedEnterOpacity({
    super.key,
    this.from = 0.0,
    this.to = 1.0,
    this.curve = Curves.linear,
    required this.duration,
    this.onEnd,
    this.alwaysIncludeSemantics = false,
    required this.child,
  });

  @override
  State<AnimatedEnterOpacity> createState() => _AnimatedEnterOpacityState();

  final Widget child;
  final double from;
  final double to;
  final Curve curve;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool alwaysIncludeSemantics;
}

class _AnimatedEnterOpacityState extends State<AnimatedEnterOpacity> {
  @override
  void initState() {
    super.initState();
    _opacity = widget.from;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = widget.to;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      curve: widget.curve,
      duration: widget.duration,
      onEnd: widget.onEnd,
      alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
      child: widget.child,
    );
  }

  late double _opacity;
}
