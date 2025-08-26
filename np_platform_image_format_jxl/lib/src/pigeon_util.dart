import 'package:np_common/size.dart';
import 'package:np_image_format_interface/np_image_format_interface.dart';
import 'package:np_platform_image_format_jxl/src/messages.g.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';

extension ImageExtension on Image {
  Rgba8Image toInterfaceType() {
    return Rgba8Image(pixel, width, height);
  }
}

extension Rgba8ImageExtension on Rgba8Image {
  Image toPigeonType() {
    return Image(pixel: pixel, width: width, height: height);
  }
}

extension MetadataExtension on Metadata {
  ImageFormatMetadata toInterfaceType() {
    return ImageFormatMetadata(size: SizeInt(w, h));
  }
}
