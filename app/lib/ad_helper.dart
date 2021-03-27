import 'package:np_platform_util/np_platform_util.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (getRawPlatform() == NpPlatform.android) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (getRawPlatform() == NpPlatform.android) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
