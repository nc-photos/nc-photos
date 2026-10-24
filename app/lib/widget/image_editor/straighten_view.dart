import 'dart:math';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar_util.dart';
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:np_ui/np_ui.dart';

part 'straighten_view.g.dart';

@genCopyWith
class StraightenArguments implements TransformArguments {
  const StraightenArguments({required this.degree, required this.position});

  @override
  image_editor.Edit toEdit() =>
      image_editor.StraightenEdit(degree: degree, position: position);

  @override
  TransformToolType getToolType() => TransformToolType.straighten;

  final int degree;
  final Offset position;
}

class StraightenView extends StatefulWidget {
  const StraightenView({
    super.key,
    required this.image,
    required this.value,
    required this.position,
    required this.onPositionChanged,
  });

  @override
  State<StatefulWidget> createState() => _StraightenViewState();

  final Rgba8Image image;
  final int value;
  final Offset position;
  final ValueChanged<Offset> onPositionChanged;
}

class _StraightenViewState extends State<StraightenView> {
  @override
  void initState() {
    super.initState();
    _position = widget.position;
  }

  @override
  void didUpdateWidget(covariant StraightenView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position) {
      _position = widget.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    final angle = widget.value * pi / 180;
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = _containedSize(
          constraints.biggest,
          widget.image.width / widget.image.height,
        );
        final rectSize = _findBestRectSize(imageSize, angle);
        final range = _movableRange(imageSize, rectSize, angle);
        final offset = _positionToOffset(_position, range, angle);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            setState(() {
              _position = _offsetToPosition(
                _positionToOffset(_position, range, angle) - details.delta,
                range,
                angle,
                _position,
              );
            });
          },
          onPanEnd: (_) {
            widget.onPositionChanged(_position);
          },
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Transform.translate(
                    offset: -offset,
                    child: SizedBox.fromSize(
                      size: imageSize,
                      child: Transform.rotate(
                        angle: angle,
                        child: Image(
                          image: PixelImage(
                            widget.image.pixel,
                            widget.image.width,
                            widget.image.height,
                          ),
                          fit: BoxFit.fill,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomPaint(
                  painter: _StraightenOverlayPainter(rectSize: rectSize),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Size _movableRange(Size imageSize, Size rectSize, double theta) {
    final sinA = sin(theta).abs();
    final cosA = cos(theta).abs();
    return Size(
      max(
        0.0,
        (imageSize.width - rectSize.width * cosA - rectSize.height * sinA) /
            2.0,
      ),
      max(
        0.0,
        (imageSize.height - rectSize.width * sinA - rectSize.height * cosA) /
            2.0,
      ),
    );
  }

  static Offset _positionToOffset(Offset position, Size range, double theta) {
    final localX = position.dx * range.width;
    final localY = position.dy * range.height;
    final sinT = sin(theta);
    final cosT = cos(theta);
    return Offset(cosT * localX - sinT * localY, sinT * localX + cosT * localY);
  }

  static Offset _offsetToPosition(
    Offset offset,
    Size range,
    double theta,
    Offset fallback,
  ) {
    final sinT = sin(theta);
    final cosT = cos(theta);
    final localX = cosT * offset.dx + sinT * offset.dy;
    final localY = -sinT * offset.dx + cosT * offset.dy;
    return Offset(
      range.width > 0 ? (localX / range.width).clamp(-1.0, 1.0) : fallback.dx,
      range.height > 0 ? (localY / range.height).clamp(-1.0, 1.0) : fallback.dy,
    );
  }

  static Size _containedSize(Size box, double aspectRatio) {
    return box.width / box.height > aspectRatio
        ? Size(box.height * aspectRatio, box.height)
        : Size(box.width, box.width / aspectRatio);
  }

  // return the rect size that best fit the current rotated angle
  static Size _findBestRectSize(Size size, double theta) {
    final ratio = size.width / size.height;
    final sinA = sin(theta).abs();
    final cosA = cos(theta).abs();
    final halfH = min(
      size.width / (2 * (ratio * cosA + sinA)),
      size.height / (2 * (ratio * sinA + cosA)),
    );
    return Size(ratio * halfH * 2, halfH * 2);
  }

  late Offset _position;
}

class _StraightenOverlayPainter extends CustomPainter {
  const _StraightenOverlayPainter({required this.rectSize});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: rectSize.width,
      height: rectSize.height,
    );
    final dimPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRect(rect),
    );
    canvas.drawPath(
      dimPath,
      Paint()..color = Colors.black.withValues(alpha: .75),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _StraightenOverlayPainter oldDelegate) =>
      oldDelegate.rectSize != rectSize;

  final Size rectSize;
}
