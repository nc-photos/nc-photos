import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;

enum TransformToolType { crop, orientation }

abstract class TransformArguments {
  image_editor.Edit? toEdit();

  TransformToolType getToolType();
}
