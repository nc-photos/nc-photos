import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_image_processor/np_platform_image_processor.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:np_ui/np_ui.dart';

part 'crop_controller.g.dart';

/// Crop editor
///
/// This widget only work when width == device width!
class CropController extends StatelessWidget {
  const CropController({
    super.key,
    required this.image,
    required this.initialState,
    this.onCropChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // to make cropping works on phone using gesture navigation
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: _WrappedCropController(
        image: image,
        initialState: initialState,
        onCropChanged: onCropChanged,
      ),
    );
  }

  final Rgba8Image image;
  final TransformArguments? initialState;
  final ValueChanged<TransformArguments>? onCropChanged;
}

class _WrappedCropController extends StatefulWidget {
  const _WrappedCropController({
    required this.image,
    required this.initialState,
    this.onCropChanged,
  });

  @override
  State<StatefulWidget> createState() => _WrappedCropControllerState();

  final Rgba8Image image;
  final TransformArguments? initialState;
  final ValueChanged<TransformArguments>? onCropChanged;
}

@npLog
class _WrappedCropControllerState extends State<_WrappedCropController> {
  @override
  initState() {
    super.initState();
    if (widget.initialState?.getToolType() == TransformToolType.crop) {
      _initialState = widget.initialState as _CropArguments;
    }
  }

  @override
  build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _prevOrientation ??= orientation;
        if (_prevOrientation != orientation) {
          _onOrientationChanged(orientation);
        } else {
          _tryUpdateSize(context);
        }

        return Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            Opacity(
              opacity: .35,
              child: Image(
                image: PixelImage(
                  widget.image.pixel,
                  widget.image.width,
                  widget.image.height,
                ),
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ),
            ),
            GestureDetector(
              onPanStart: (_) {
                _canMoveRect = true;
              },
              onPanUpdate: (details) {
                if (!_canMoveRect) {
                  return;
                }
                setState(() {
                  if (_size == null) return;
                  final pos = details.localPosition;
                  if (pos.dx > 0 &&
                      pos.dx < _size!.width &&
                      pos.dy > _offsetY &&
                      pos.dy < _size!.height + _offsetY) {
                    _moveRectBy(details.delta);
                  } else {
                    _canMoveRect = false;
                  }
                });
              },
              onPanEnd: (_) {
                widget.onCropChanged?.call(_getCropArgs());
              },
              child: ClipRect(
                clipper: _CropClipper(
                  _left,
                  _top + _offsetY,
                  _size == null ? double.infinity : _size!.width - _right,
                  _size == null
                      ? double.infinity
                      : _size!.height - _bottom + _offsetY,
                ),
                child: Image(
                  image: PixelImage(
                    widget.image.pixel,
                    widget.image.width,
                    widget.image.height,
                  ),
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              ),
            ),
            if (_size != null) ...[
              Positioned(
                top: _top + _offsetY,
                left: _left,
                bottom: _bottom + _offsetY,
                right: _right,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: _top + _offsetY,
                left: _left,
                child: GestureDetector(
                  onPanStart: (_) {
                    _topDrain.reset();
                    _leftDrain.reset();
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (_size == null) return;
                      _moveTopByDy(details.delta.dy);
                      _moveLeftByDx(details.delta.dx);
                    });
                  },
                  onPanEnd: (_) {
                    widget.onCropChanged?.call(_getCropArgs());
                  },
                  child: const _TouchDot(),
                ),
              ),
              Positioned(
                top: _top + _offsetY,
                right: _right,
                child: GestureDetector(
                  onPanStart: (_) {
                    _topDrain.reset();
                    _rightDrain.reset();
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (_size == null) return;
                      _moveTopByDy(details.delta.dy);
                      _moveRightByDx(details.delta.dx);
                    });
                  },
                  onPanEnd: (_) {
                    widget.onCropChanged?.call(_getCropArgs());
                  },
                  child: const _TouchDot(),
                ),
              ),
              Positioned(
                bottom: _bottom + _offsetY,
                left: _left,
                child: GestureDetector(
                  onPanStart: (_) {
                    _bottomDrain.reset();
                    _leftDrain.reset();
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (_size == null) return;
                      _moveBottomByDy(details.delta.dy);
                      _moveLeftByDx(details.delta.dx);
                    });
                  },
                  onPanEnd: (_) {
                    widget.onCropChanged?.call(_getCropArgs());
                  },
                  child: const _TouchDot(),
                ),
              ),
              Positioned(
                bottom: _bottom + _offsetY,
                right: _right,
                child: GestureDetector(
                  onPanStart: (_) {
                    _bottomDrain.reset();
                    _rightDrain.reset();
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (_size == null) return;
                      _moveBottomByDy(details.delta.dy);
                      _moveRightByDx(details.delta.dx);
                    });
                  },
                  onPanEnd: (_) {
                    widget.onCropChanged?.call(_getCropArgs());
                  },
                  child: const _TouchDot(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _onOrientationChanged(Orientation orientation) {
    _reset();
    _prevOrientation = orientation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _tryUpdateSize(BuildContext context) {
    if (_size == null) {
      final renderObj = context.findRenderObject() as RenderBox?;
      if (renderObj?.hasSize == true && renderObj!.size.width > 16) {
        // the renderbox height is always max
        final height =
            renderObj.size.width / widget.image.width * widget.image.height;
        _size = Size(renderObj.size.width, height);
        _offsetY = (renderObj.size.height - height) / 2;
      }
      _log.info("[_tryUpdateSize] size = $_size, offsetY: $_offsetY");
      if (_size == null) {
        _log.info("[_tryUpdateSize] Schedule next");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      } else {
        // apply initial state after getting size
        if (_initialState != null && !_isInitialRestored) {
          _restoreCropArgs(_initialState!);
          _isInitialRestored = true;
        }
      }
    }
  }

  void _moveTopByDy(double dy) {
    if (_topDrain.isAvailable) {
      dy = _topDrain.consume(dy);
    }
    // add distance outside of the view to drain
    _topDrain.add(_addTop(dy));
  }

  double _addTop(double dy) {
    final old = _top;
    final upper = _size!.height - _bottom - _TouchDot.size * 2 - _threshold;
    // ignore if image is too small to allow cropping in this axis
    if (upper >= _top) {
      _top = (_top + dy).clamp(0, upper);
    } else if (dy < 0 && _size!.height - _bottom >= 0) {
      // allow expanding only
      _top = math.max(_top + dy, 0);
    }
    return (old + dy) - _top;
  }

  void _moveLeftByDx(double dx) {
    if (_leftDrain.isAvailable) {
      dx = _leftDrain.consume(dx);
    }
    _leftDrain.add(_addLeft(dx));
  }

  double _addLeft(double dx) {
    final old = _left;
    final upper = _size!.width - _right - _TouchDot.size * 2 - _threshold;
    if (upper >= _left) {
      _left = (_left + dx).clamp(0, upper);
    } else if (dx < 0 && _size!.width - _right >= 0) {
      _left = math.max(_left + dx, 0);
    }
    return (old + dx) - _left;
  }

  void _moveBottomByDy(double dy) {
    if (_bottomDrain.isAvailable) {
      dy = _bottomDrain.consume(dy);
    }
    _bottomDrain.add(_addBottom(dy));
  }

  double _addBottom(double dy) {
    final old = _bottom;
    final upper = _size!.height - _top - _TouchDot.size * 2 - _threshold;
    if (upper >= _bottom) {
      _bottom = (_bottom - dy).clamp(0, upper);
    } else if (dy > 0 && _size!.height - _top >= 0) {
      _bottom = math.max(_bottom - dy, 0);
    }
    return _bottom - (old - dy);
  }

  void _moveRightByDx(double dx) {
    if (_rightDrain.isAvailable) {
      dx = _rightDrain.consume(dx);
    }
    _rightDrain.add(_addRight(dx));
  }

  double _addRight(double dx) {
    final old = _right;
    final upper = _size!.width - _left - _TouchDot.size * 2 - _threshold;
    if (upper >= _right) {
      _right = (_right - dx).clamp(0, upper);
    } else if (dx > 0 && _size!.width - _left >= 0) {
      _right = math.max(_right - dx, 0);
    }
    return _right - (old - dx);
  }

  void _moveRectBy(Offset offset) {
    if (offset.dy < 0) {
      // up
      final actual = math.min(_top, -offset.dy);
      _top -= actual;
      _bottom += actual;
    } else {
      // down
      final actual = math.min(_bottom, offset.dy);
      _top += actual;
      _bottom -= actual;
    }
    if (offset.dx < 0) {
      // left
      final actual = math.min(_left, -offset.dx);
      _left -= actual;
      _right += actual;
    } else {
      // right
      final actual = math.min(_right, offset.dx);
      _left += actual;
      _right -= actual;
    }
  }

  _CropArguments _getCropArgs() {
    final topPercent = _top / _size!.height;
    final leftPercent = _left / _size!.width;
    final bottomPercent = (_size!.height - _bottom) / _size!.height;
    final rightPercent = (_size!.width - _right) / _size!.width;
    return _CropArguments(topPercent, leftPercent, bottomPercent, rightPercent);
  }

  void _restoreCropArgs(_CropArguments args) {
    _top = args.top * _size!.height;
    _left = args.left * _size!.width;
    _bottom = _size!.height - args.bottom * _size!.height;
    _right = _size!.width - args.right * _size!.width;
  }

  /// Reset state after orientation change
  void _reset() {
    _log.info("[reset] Reset state");
    if (_initialState != null) {
      // this is needed to also reset the state of the observer
      widget.onCropChanged?.call(_initialState!);
    }
    _isInitialRestored = false;
    _size = null;
    _offsetY = 0;
    _top = 0;
    _left = 0;
    _bottom = 0;
    _right = 0;
  }

  _CropArguments? _initialState;
  bool _isInitialRestored = false;
  Size? _size;
  double _offsetY = 0;

  var _top = 0.0;
  final _topDrain = _Drain();
  var _left = 0.0;
  final _leftDrain = _Drain();
  var _bottom = 0.0;
  final _bottomDrain = _Drain();
  var _right = 0.0;
  final _rightDrain = _Drain();
  // set this to false when pointer moved outside of the area, making user to
  // start a new pan session to move the rect
  var _canMoveRect = true;

  Orientation? _prevOrientation;

  static const _threshold = 24;
}

class _TouchDot extends StatelessWidget {
  static const double size = 24;

  const _TouchDot();

  @override
  build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.white60,
      ),
    );
  }
}

class _CropClipper extends CustomClipper<Rect> {
  const _CropClipper(this.left, this.top, this.right, this.bottom);

  @override
  getClip(Size size) => Rect.fromLTRB(left, top, right, bottom);

  @override
  shouldReclip(CustomClipper oldClipper) {
    if (oldClipper is! _CropClipper) {
      return true;
    }
    return left != oldClipper.left ||
        top != oldClipper.top ||
        right != oldClipper.right ||
        bottom != oldClipper.bottom;
  }

  final double left;
  final double top;
  final double right;
  final double bottom;
}

/// Store exceeding values and consume them if needed
class _Drain {
  void add(double v) {
    _drain += v;
  }

  void reset() {
    _drain = 0;
  }

  /// Consume by [v], and return whatever that remain in [v]
  double consume(double v) {
    if (_drain.sign == v.sign) {
      // add more to drain
      _drain += v;
      v = 0;
    } else {
      // consume from drain
      _drain += v;
      if (_drain.sign == v.sign) {
        // consumed all, dy = remaining
        v = _drain;
        _drain = 0;
      } else {
        v = 0;
      }
    }
    return v;
  }

  bool get isAvailable => _drain != 0;

  double _drain = 0;
}

class _CropArguments implements TransformArguments {
  const _CropArguments(this.top, this.left, this.bottom, this.right);

  @override
  toImageFilter() => TransformCropFilter(top, left, bottom, right);

  @override
  getToolType() => TransformToolType.crop;

  final double top;
  final double left;
  final double bottom;
  final double right;
}
