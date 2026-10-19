import 'package:flutter/material.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar_util.dart';
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:np_ui/np_ui.dart';

class OrientationArguments implements TransformArguments {
  const OrientationArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.OrientationEdit(value);

  @override
  TransformToolType getToolType() => TransformToolType.orientation;

  final int value;
}

class OrientationView extends StatelessWidget {
  const OrientationView({super.key, required this.image, required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: state?.turn ?? 0,
      duration: Durations.medium1,
      child: Image(
        image: PixelImage(image.pixel, image.width, image.height),
        fit: BoxFit.contain,
        gaplessPlayback: true,
      ),
    );
  }

  final Rgba8Image image;
  final OrientationArguments? state;
}

extension on OrientationArguments {
  double get turn => (-value ~/ 90) * .25;
}
