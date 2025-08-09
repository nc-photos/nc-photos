import 'package:flutter/material.dart';

/// Icon using an image in asset
class AssetIcon extends StatelessWidget {
  const AssetIcon(this.assetName, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return ImageIcon(AssetImage(assetName), size: size, color: color);
  }

  final String assetName;
  final double? size;
  final Color? color;
}
