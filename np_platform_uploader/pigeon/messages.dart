import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: "lib/src/messages.g.dart",
    kotlinOut:
        "android/src/main/kotlin/com/nkming/nc_photos/np_platform_uploader/pigeon/Messages.g.kt",
    kotlinOptions: KotlinOptions(
      package: "com.nkming.nc_photos.np_platform_uploader.pigeon",
    ),
    swiftOut: "ios/Classes/Messages.g.swift",
  ),
)
enum ConvertFormat { jpeg, jxl }

class Uploadable {
  late final String platformIdentifier;
  late final String endPoint;
  late final bool canConvert;
}

class ConvertConfig {
  late final ConvertFormat format;
  late final int quality;
  late final double? downsizeMp;
}

@HostApi()
abstract class MyHostApi {
  void asyncUpload({
    required String taskId,
    required List<Uploadable> uploadables,
    required Map<String, String> httpHeaders,
    ConvertConfig? convertConfig,
  });
}

@FlutterApi()
abstract class MyFlutterApi {
  void notifyUploadResult(String taskId, Uploadable uploadable, bool isSuccess);
  void notifyTaskComplete(String taskId);
}
