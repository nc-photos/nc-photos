import 'package:flutter/material.dart';
import 'package:np_gps_map/src/native/google_gps_map.dart'
    if (dart.library.html) 'package:np_gps_map/src/web/google_gps_map.dart';
import 'package:np_gps_map/src/osm_gps_map.dart';
import 'package:np_gps_map/src/type.dart';
import 'package:np_gps_map/src/util.dart';
import 'package:np_platform_util/np_platform_util.dart';

class StaticMap extends StatelessWidget {
  const StaticMap({
    super.key,
    required this.providerHint,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (providerHint == GpsMapProvider.osm ||
        (getRawPlatform() == NpPlatform.android && !isNewGMapsRenderer())) {
      return OsmGpsMap(location: location, onTap: onTap);
    } else {
      return GoogleGpsMap(location: location, onTap: onTap);
    }
  }

  /// The backend to provide the actual map. This works as a hint only, the
  /// actual choice may be different depending on the runtime environment
  final GpsMapProvider providerHint;

  final CameraPosition location;
  final void Function()? onTap;
}
