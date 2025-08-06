import 'dart:ui';

import 'package:flutter/material.dart';

class AppDimension extends ThemeExtension<AppDimension> {
  const AppDimension({
    required this.homeBottomAppBarHeight,
    required this.timelineDateItemHeight,
    required this.timelineDraggableThumbSize,
  });

  static AppDimension of(BuildContext context) =>
      Theme.of(context).extension<AppDimension>()!;

  @override
  AppDimension copyWith({
    double? homeBottomAppBarHeight,
    double? timelineDateItemHeight,
    double? timelineDraggableThumbSize,
  }) => AppDimension(
    homeBottomAppBarHeight:
        homeBottomAppBarHeight ?? this.homeBottomAppBarHeight,
    timelineDateItemHeight:
        timelineDateItemHeight ?? this.timelineDateItemHeight,
    timelineDraggableThumbSize:
        timelineDraggableThumbSize ?? this.timelineDraggableThumbSize,
  );

  @override
  AppDimension lerp(ThemeExtension<AppDimension>? other, double t) {
    if (other is! AppDimension) {
      return this;
    }
    return AppDimension(
      homeBottomAppBarHeight:
          lerpDouble(homeBottomAppBarHeight, other.homeBottomAppBarHeight, t)!,
      timelineDateItemHeight:
          lerpDouble(timelineDateItemHeight, other.timelineDateItemHeight, t)!,
      timelineDraggableThumbSize:
          lerpDouble(
            timelineDraggableThumbSize,
            other.timelineDraggableThumbSize,
            t,
          )!,
    );
  }

  final double homeBottomAppBarHeight;
  final double timelineDateItemHeight;
  final double timelineDraggableThumbSize;
}
