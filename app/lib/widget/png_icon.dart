import 'package:flutter/material.dart';

class PngIcon extends StatelessWidget {
  const PngIcon(this.asset, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, width: size, height: size);
  }

  final String asset;
  final double size;
}
