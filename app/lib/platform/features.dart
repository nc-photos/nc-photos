import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:np_platform_util/np_platform_util.dart';

final isSupportMapView = [
  NpPlatform.android,
  NpPlatform.web,
].contains(getRawPlatform());
final isSupportSelfSignedCert = getRawPlatform() == NpPlatform.android;
final isSupportEnhancement = getRawPlatform() == NpPlatform.android;
final isSupportLocalFiles =
    getRawPlatform() == NpPlatform.android &&
    AndroidInfo().sdkInt >= AndroidVersion.TIRAMISU;

final isSupportAds = getRawPlatform() != NpPlatform.web;
final isSupportCrashlytics = getRawPlatform() != NpPlatform.web;
