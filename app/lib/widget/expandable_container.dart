import 'package:flutter/material.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/widget/measure.dart';

class ExpandableContainer extends StatefulWidget {
  const ExpandableContainer({
    super.key,
    required this.isShow,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => ExpandableContainerState();

  final bool isShow;
  final Widget child;
}

class ExpandableContainerState extends State<ExpandableContainer>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: k.animationDurationNormal,
      vsync: this,
      value: 0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpandableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isShow != widget.isShow) {
      if (widget.isShow) {
        _animationController.animateTo(1);
      } else {
        _animationController.animateBack(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MatrixTransition(
      animation: _animation,
      onTransform:
          (animationValue) =>
              Matrix4.identity()
                ..translate(
                  0.0,
                  -(_size.height / 2) * (1 - animationValue),
                  0.0,
                )
                ..scale(1.0, animationValue, 1.0),
      child: MeasureSize(
        onChange:
            (size) => setState(() {
              _size = size;
            }),
        child: widget.child,
      ),
    );
  }

  late AnimationController _animationController;
  late Animation<double> _animation;
  var _size = Size.zero;
}
