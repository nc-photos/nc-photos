import 'package:flutter/material.dart';
import 'package:np_common/color.dart';

extension ColorIntExtension on ColorInt {
  Color toColor() => Color(value);
}

extension ColorExtension on Color {
  ColorInt toColorInt() => ColorInt(toARGB32());
}
