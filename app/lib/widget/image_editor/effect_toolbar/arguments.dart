part of 'effect_toolbar.dart';

@genCopyWith
class _FaceReshapeArguments implements PixelFaceArguments {
  const _FaceReshapeArguments({required this.jawline, required this.eyeSize});

  @override
  image_editor.FaceEdit toEdit() =>
      image_editor.FaceReshapeEdit(jawline: jawline, eyeSize: eyeSize);

  @override
  PixelToolType getToolType() => PixelToolType.faceReshape;

  final double jawline;
  final double eyeSize;
}

class _HalftoneArguments implements PixelArguments {
  const _HalftoneArguments();

  @override
  image_editor.Edit toEdit() => const image_editor.HalftoneEdit();

  @override
  PixelToolType getToolType() => PixelToolType.halftone;
}

class _PixelationArguments implements PixelArguments {
  const _PixelationArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.PixelationEdit(value / 100 * .1);

  @override
  PixelToolType getToolType() => PixelToolType.pixelation;

  final double value;
}

class _PosterizationArguments implements PixelArguments {
  const _PosterizationArguments(this.value);

  @override
  image_editor.Edit toEdit() => image_editor.PosterizationEdit(value.round());

  @override
  PixelToolType getToolType() => PixelToolType.posterization;

  final double value;
}

@genCopyWith
class _SketchArguments implements PixelArguments {
  const _SketchArguments({required this.edge, required this.hatching});

  @override
  image_editor.Edit toEdit() {
    return image_editor.SketchEdit(
      edgeStrength: 1.1,
      edgeThreshold: .83 - edge * (.83 - .12),
      hatching: hatching,
    );
  }

  @override
  PixelToolType getToolType() => PixelToolType.sketch;

  final double edge;
  final double hatching;
}

@genCopyWith
class _ToonArguments implements PixelArguments {
  const _ToonArguments({required this.edge, required this.quantization});

  @override
  image_editor.Edit toEdit() {
    return image_editor.ToonEdit(
      edgeThreshold: .7 - edge * (.7 - .1),
      quantization: quantization * 8 + 2,
    );
  }

  @override
  PixelToolType getToolType() => PixelToolType.toon;

  final double edge;
  final double quantization;
}
