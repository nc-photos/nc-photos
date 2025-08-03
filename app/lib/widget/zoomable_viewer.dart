import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:np_log/np_log.dart';

part 'zoomable_viewer.g.dart';

class ZoomableViewer extends StatefulWidget {
  const ZoomableViewer({
    super.key,
    this.onZoomStarted,
    this.onZoomEnded,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _ZoomableViewerState();

  final VoidCallback? onZoomStarted;
  final VoidCallback? onZoomEnded;
  final Widget child;
}

@npLog
class _ZoomableViewerState extends State<ZoomableViewer>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
    _transformationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        ++_finger;
        if (_finger >= 2) {
          _setIsZooming(true);
        }
      },
      onPointerUp: (event) {
        --_finger;
        if (_finger < 2) {
          _setIsZooming(false);
        }
        _prevFingerPosition = event.position;
      },
      onPointerCancel: (event) {
        --_finger;
        if (_finger < 2) {
          _setIsZooming(false);
        }
      },
      onPointerSignal: (event) {
        if (event is PointerScrollEvent &&
            event.kind == PointerDeviceKind.mouse) {
          if (event.scrollDelta.dy < 0) {
            // scroll up
            _setIsZooming(true);
          } else if (event.scrollDelta.dy > 0) {
            // scroll down
            _setIsZooming(false);
          }
        }
      },
      child: GestureDetector(
        onDoubleTap: () {
          if (_isZoomed) {
            // restore transformation
            _autoZoomOut();
          } else {
            _autoZoomIn();
          }
        },
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.5,
          transformationController: _transformationController,
          panEnabled: _isZoomed,
          // allow the image to be zoomed to fill the whole screen
          child: widget.child,
        ),
      ),
    );
  }

  void _setIsZooming(bool flag) {
    _isZooming = flag;
    if (mounted) {
      setState(() {});
    }
    final next = _isZoomed;
    if (next != _wasZoomed) {
      _wasZoomed = next;
      _log.info("[_setIsZooming] Is zoomed: $next");
      if (next) {
        widget.onZoomStarted?.call();
      } else {
        widget.onZoomEnded?.call();
      }
    }
  }

  /// Called when double tapping the image to zoom in to the default level
  void _autoZoomIn() {
    final animController =
        AnimationController(duration: k.animationDurationShort, vsync: this);
    final originX = -_prevFingerPosition.dx / 2;
    final originY = -_prevFingerPosition.dy / 2;
    final anim = Matrix4Tween(
            begin: Matrix4.identity(),
            end: Matrix4.identity()
              ..scale(2.0)
              ..translate(originX, originY))
        .animate(animController);
    animController
      ..addListener(() {
        _transformationController.value = anim.value;
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _setIsZooming(false);
        }
      })
      ..forward();
    _setIsZooming(true);
  }

  /// Called when double tapping the zoomed image to zoom out
  void _autoZoomOut() {
    final animController =
        AnimationController(duration: k.animationDurationShort, vsync: this);
    final anim = Matrix4Tween(
            begin: _transformationController.value, end: Matrix4.identity())
        .animate(animController);
    animController
      ..addListener(() {
        _transformationController.value = anim.value;
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _setIsZooming(false);
        }
      })
      ..forward();
    _setIsZooming(true);
  }

  bool get _isZoomed =>
      _isZooming || _transformationController.value.getMaxScaleOnAxis() != 1.0;

  final _transformationController = TransformationController();

  var _isZooming = false;
  var _wasZoomed = false;

  var _finger = 0;
  var _prevFingerPosition = const Offset(0, 0);
}
