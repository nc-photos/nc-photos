import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChanged = void Function(Size size);

/// See: https://stackoverflow.com/a/60868972
class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChanged onChange;

  const MeasureSize({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }
}

class _MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChanged onChange;

  _MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    var newSize = child?.size;
    if (newSize == null || oldSize == newSize) {
      return;
    }

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class SliverMeasureExtent extends SingleChildRenderObjectWidget {
  const SliverMeasureExtent({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SliverMeasureExtentRenderObject(onChange);
  }

  final void Function(double) onChange;
}

class _SliverMeasureExtentRenderObject extends RenderProxySliver {
  _SliverMeasureExtentRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    var newExent = child?.geometry?.scrollExtent;
    if (newExent == null || _oldExtent == newExent) {
      return;
    }

    _oldExtent = newExent;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newExent));
  }

  final void Function(double) onChange;

  double? _oldExtent;
}
