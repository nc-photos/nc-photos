import 'package:android_intent_plus/android_intent.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_platform_util/np_platform_util.dart';

extension GpsMapProviderExtension on GpsMapProvider {
  String toUserString() {
    switch (this) {
      case GpsMapProvider.google:
        return "Google Maps";
      case GpsMapProvider.osm:
        return "OpenStreetMap";
    }
  }
}

void launchExternalMap(CameraPosition location) {
  if (getRawPlatform() == NpPlatform.android) {
    final intent = AndroidIntent(
      action: "action_view",
      data: Uri.encodeFull(
        "geo:${location.center.latitude},${location.center.longitude}?z=${location.zoom}",
      ),
    );
    intent.launch();
  }
}
