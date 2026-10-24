import 'package:flutter/material.dart';
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;
import 'package:np_string/np_string.dart';
import 'package:np_ui/np_ui.dart';

enum PixelToolType {
  // color
  brightness,
  contrast,
  whitePoint,
  blackPoint,
  saturation,
  warmth,
  tint,
  // effect
  halftone,
  pixelation,
  posterization,
  sketch,
  toon,
  // face
  faceReshape,
}

abstract class PixelArguments {
  image_editor.Edit toEdit();

  PixelToolType getToolType();
}

abstract class PixelFaceArguments implements PixelArguments {
  @override
  image_editor.FaceEdit toEdit();
}

class PixelToolSlider extends StatelessWidget {
  const PixelToolSlider({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    this.onChanged,
    this.onChangeEnd,
    this.isShowMinMax = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                if (isShowMinMax)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(min.toStringAsFixedTruncated(1)),
                  ),
                if (isShowMinMax && min < 0 && max > 0)
                  const Align(
                    alignment: AlignmentDirectional.center,
                    child: Text("0"),
                  ),
                if (isShowMinMax)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(max.toStringAsFixedTruncated(1)),
                  ),
              ],
            ),
          ),
          StatefulSlider(
            initialValue: initialValue.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }

  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final bool isShowMinMax;
}
