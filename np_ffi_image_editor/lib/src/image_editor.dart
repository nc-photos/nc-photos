import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:np_common/type.dart';
import 'package:np_ffi_image_editor/src/image_util.dart';
import 'package:np_ffi_image_editor/src/np_ffi_image_editor_bindings_generated.dart'
    as ffi;
import 'package:np_platform_raw_image/np_platform_raw_image.dart';

sealed class Edit {
  JsonObj toJson();
}

class BlackPointEdit implements Edit {
  const BlackPointEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "blackPoint", "weight": weight};

  final double weight;
}

class BrightnessEdit implements Edit {
  const BrightnessEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "brightness", "weight": weight};

  final double weight;
}

class ContrastEdit implements Edit {
  const ContrastEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "contrast", "weight": weight};

  final double weight;
}

class CropEdit implements Edit {
  const CropEdit(this.top, this.left, this.bottom, this.right);

  @override
  JsonObj toJson() => {
    "type": "crop",
    "top": top,
    "left": left,
    "bottom": bottom,
    "right": right,
  };

  // normalized coords, [0, 1]
  final double top;
  final double left;
  final double bottom;
  final double right;
}

class OrientationEdit implements Edit {
  const OrientationEdit(this.degree);

  @override
  JsonObj toJson() => {"type": "orientation", "degree": degree};

  // rotation degree, [-180, -90, 0, 90, 180]
  final int degree;
}

class SaturationEdit implements Edit {
  const SaturationEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "saturation", "weight": weight};

  final double weight;
}

class TintEdit implements Edit {
  const TintEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "tint", "weight": weight};

  final double weight;
}

class WarmthEdit implements Edit {
  const WarmthEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "warmth", "weight": weight};

  final double weight;
}

class WhitePointEdit implements Edit {
  const WhitePointEdit(this.weight);

  @override
  JsonObj toJson() => {"type": "whitePoint", "weight": weight};

  final double weight;
}

Future<Rgba8Image> edit(Rgba8Image image, List<Edit> edits) {
  return Isolate.run(() async {
    final editJson = jsonEncode(edits.map((e) => e.toJson()).toList());
    final editJsonC = editJson.toNativeUtf8();
    try {
      return await image.useNative((imageC) {
        var result = Pointer<ffi.Rgba8Image>.fromAddress(0);
        try {
          result = _bindings.apply(imageC, editJsonC.cast());
          return result.ref.toDart();
        } finally {
          _bindings.rgba8ImageFree(result);
        }
      });
    } finally {
      malloc.free(editJsonC);
    }
  });
}

const String _libName = 'np_ffi_image_editor';

/// The dynamic library in which the symbols for [NpFfiImageEditorBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final ffi.NpFfiImageEditorBindings _bindings = ffi.NpFfiImageEditorBindings(
  _dylib,
);
