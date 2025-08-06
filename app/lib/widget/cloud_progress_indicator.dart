import 'package:flutter/material.dart';

/// A progress indicator that looks like a cloud
class CloudProgressIndicator extends StatefulWidget {
  const CloudProgressIndicator({super.key, required this.size, this.value});

  @override
  State<StatefulWidget> createState() => _CloudProgressIndicatorState();

  final double size;
  final double? value;
}

class _CloudProgressIndicatorState extends State<CloudProgressIndicator>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    if (widget.value == null) {
      _startIntermediateAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CloudProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _startIntermediateAnimation();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
      _isInvert = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Indicator(
      size: widget.size,
      value: widget.value,
      controller: _controller,
      isInvert: _isInvert,
    );
  }

  void _startIntermediateAnimation() {
    _controller
      ..forward(from: 0)
      ..addStatusListener((status) {
        if (mounted) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _isInvert = true;
            });
            _controller.reverse(from: 1);
          } else if (status == AnimationStatus.dismissed) {
            setState(() {
              _isInvert = false;
            });
            _controller.forward(from: 0);
          }
        }
      });
  }

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3500),
  );

  var _isInvert = false;
}

class _Indicator extends AnimatedWidget {
  const _Indicator({
    required this.size,
    required this.value,
    required this.isInvert,
    required AnimationController controller,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final thisValue = value ?? _progress.value;
    final stroke = size * .07;
    const curve = Curves.easeInOutQuad;
    return Transform.scale(
      scaleX: isInvert ? -1 : 1,
      child: Container(
        width: size,
        padding: EdgeInsets.all(stroke / 2),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(
                  strokeWidth: stroke,
                  value: curve.transform((thisValue * 3).clamp(0, 1)),
                ),
              ),
            ),
            Expanded(
              flex: 11,
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(
                  strokeWidth: stroke,
                  value: curve.transform((thisValue * 3 - 1).clamp(0, 1)),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(
                  strokeWidth: stroke,
                  value: curve.transform((thisValue * 3 - 2).clamp(0, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Animation<double> get _progress => listenable as Animation<double>;

  final double size;
  final double? value;
  final bool isInvert;
}
