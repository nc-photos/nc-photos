import 'package:flutter/material.dart';
import 'package:np_gps_map/src/interactive_map/google.dart';
import 'package:np_gps_map/src/interactive_map/osm.dart';
import 'package:np_gps_map/src/type.dart';
import 'package:np_gps_map/src/util.dart';
import 'package:np_platform_util/np_platform_util.dart';

// Client may extend this class to add custom data
class DataPoint {
  const DataPoint({required this.position});

  final MapCoord position;
}

abstract class InteractiveMapController {
  void setPosition(MapCoord position);
}

class InteractiveMap extends StatelessWidget {
  const InteractiveMap({
    super.key,
    required this.providerHint,
    this.initialPosition,
    this.initialZoom,
    this.dataPoints,
    this.onClusterTap,
    this.osmClusterBuilder,
    this.googleClusterBuilder,
    this.contentPadding,
    this.onMapCreated,
    this.onCameraMove,
  });

  @override
  Widget build(BuildContext context) {
    if (providerHint == GpsMapProvider.osm ||
        (getRawPlatform() == NpPlatform.android && !isNewGMapsRenderer())) {
      return OsmInteractiveMap(
        initialPosition: initialPosition,
        initialZoom: initialZoom,
        dataPoints: dataPoints,
        onClusterTap: onClusterTap,
        clusterBuilder: osmClusterBuilder,
        contentPadding: contentPadding,
        onMapCreated: onMapCreated,
        onCameraMove: onCameraMove,
      );
    } else {
      return GoogleInteractiveMap(
        initialPosition: initialPosition,
        initialZoom: initialZoom,
        dataPoints: dataPoints,
        onClusterTap: onClusterTap,
        clusterBuilder: googleClusterBuilder,
        contentPadding: contentPadding,
        onMapCreated: onMapCreated,
        onCameraMove: onCameraMove,
      );
    }
  }

  /// The backend to provide the actual map. This works as a hint only, the
  /// actual choice may be different depending on the runtime environment
  final GpsMapProvider providerHint;
  final MapCoord? initialPosition;
  final double? initialZoom;
  final List<DataPoint>? dataPoints;
  final void Function(List<DataPoint> dataPoints)? onClusterTap;
  final GoogleClusterBuilder? googleClusterBuilder;
  final OsmClusterBuilder? osmClusterBuilder;
  final EdgeInsets? contentPadding;
  final void Function(InteractiveMapController controller)? onMapCreated;
  final void Function(CameraPosition position)? onCameraMove;
}
