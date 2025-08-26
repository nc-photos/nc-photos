import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AnimatedSmoothClipRRect extends ImplicitlyAnimatedWidget {
  const AnimatedSmoothClipRRect({
    super.key,
    required this.child,
    this.smoothness = 0.0,
    required this.borderRadius,
    this.side = BorderSide.none,
    super.curve,
    required super.duration,
    super.onEnd,
  });

  @override
  ImplicitlyAnimatedWidgetState<AnimatedSmoothClipRRect> createState() =>
      _AnimatedSmoothClipRRectState();

  final Widget child;
  final BorderRadius borderRadius;
  final double smoothness;
  final BorderSide side;
}

class _AnimatedSmoothClipRRectState
    extends AnimatedWidgetBaseState<AnimatedSmoothClipRRect> {
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _borderRadius =
        visitor(
              _borderRadius,
              widget.borderRadius,
              (dynamic value) =>
                  Tween<BorderRadius>(begin: value as BorderRadius),
            )
            as Tween<BorderRadius>?;
    _side =
        visitor(
              _side,
              widget.side,
              (dynamic value) => BorderSideTween(begin: value as BorderSide),
            )
            as BorderSideTween?;
  }

  @override
  Widget build(BuildContext context) {
    return SmoothClipRRect(
      smoothness: widget.smoothness,
      side: _side?.evaluate(animation) ?? BorderSide.none,
      borderRadius: _borderRadius?.evaluate(animation) ?? BorderRadius.zero,
      child: widget.child,
    );
  }

  Tween<BorderRadius>? _borderRadius;
  BorderSideTween? _side;
}

class BorderSideTween extends Tween<BorderSide?> {
  /// Creates an [BorderSide] tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  BorderSideTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  BorderSide? lerp(double t) => BorderSide.lerp(begin!, end!, t);
}
