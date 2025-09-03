import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: "lib/src/messages.g.dart",
    kotlinOut:
        'android/src/main/kotlin/com/nkming/nc_photos/np_platform_image_format_jxl/Messages.g.kt',
    kotlinOptions: KotlinOptions(
      package: "com.nkming.nc_photos.np_platform_image_format_jxl",
    ),
  ),
)
class Image {
  late final Uint8List pixel;
  late final int width;
  late final int height;
}

class Metadata {
  late final int w;
  late final int h;
}

@HostApi()
abstract class MyHostApi {
  @async
  Image load(String filepath, int? w, int? h);

  @async
  Image loadBytes(Uint8List bytes, int? w, int? h);

  @async
  Metadata? loadMetadata(String filepath);

  @async
  bool save(Image img, String filepath);
}
