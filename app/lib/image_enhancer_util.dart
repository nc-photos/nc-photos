import 'mobile/android/android_info.dart';

abstract class ImageEnhancerAndroidConstant {
  static const notificationChannelId = "ImageProcessorService";
  static const notificationChannelName = "Image processing";
  static const notificationChannelDescription =
      "Enhance images in the background";
  static const notificationChannelImportance = 2; // IMPORTANCE_LOW
  static const notificationId = 5000;

  // mediaProcessing only available on Android 15+
  static int get foregroundServiceType =>
      AndroidInfo().sdkInt == AndroidVersion.UPSIDE_DOWN_CAKE
      ? _FOREGROUND_SERVICE_TYPE_DATA_SYNC
      : _FOREGROUND_SERVICE_TYPE_MEDIA_PROCESSING;

  static const resultNotificationId = 5001;
  static const resultNotificationAction = "ACTION_SHOW_IMAGE_PROCESSOR_RESULT";
}

// from Android SDK
// ignore: constant_identifier_names
const _FOREGROUND_SERVICE_TYPE_DATA_SYNC = 1;
// ignore: constant_identifier_names
const _FOREGROUND_SERVICE_TYPE_MEDIA_PROCESSING = 8192;
