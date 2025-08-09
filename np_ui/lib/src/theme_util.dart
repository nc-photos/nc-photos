import 'package:flutter/material.dart';

extension ThemeDataExtension on ThemeData {
  /// Apply surface tint to [color] based on the [elevation] level
  ///
  /// This function is a temporary workaround for widgets not yet fully
  /// supported Material 3
  Color elevate(Color color, int elevation) {
    final double tintOpacity;
    switch (elevation) {
      case 1:
        tintOpacity = 0.05;
        break;
      case 2:
        tintOpacity = 0.08;
        break;
      case 3:
        tintOpacity = 0.11;
        break;
      case 4:
        tintOpacity = 0.12;
        break;
      case 5:
      default:
        tintOpacity = 0.14;
        break;
    }
    return Color.lerp(color, colorScheme.surfaceTint, tintOpacity)!;
  }

  TextStyle? textStyleColored(
    TextStyle? Function(TextTheme textTheme) textStyleBuilder,
    Color? Function(ColorScheme colorScheme) colorBuilder,
  ) {
    return textStyleBuilder(
      textTheme,
    )?.copyWith(color: colorBuilder(colorScheme));
  }
}
