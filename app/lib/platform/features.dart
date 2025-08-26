import 'package:np_platform_util/np_platform_util.dart';

final isSupportMapView = [
  NpPlatform.android,
  NpPlatform.web,
].contains(getRawPlatform());
final isSupportSelfSignedCert = getRawPlatform() == NpPlatform.android;
final isSupportEnhancement = getRawPlatform() == NpPlatform.android;
