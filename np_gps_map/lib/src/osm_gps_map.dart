import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:np_gps_map/src/type.dart';

class OsmGpsMap extends StatelessWidget {
  const OsmGpsMap({super.key, required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    const double pinSize = 48;
    final center = LatLng(location.center.latitude, location.center.longitude);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      // IgnorePointer is needed to prevent FlutterMap absorbing all pointer
      // events
      child: IgnorePointer(
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: location.zoom,
            initialRotation: (360 - location.rotation) % 360,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.nkming.nc_photos",
            ),
            MarkerLayer(
              rotate: true,
              markers: [
                Marker(
                  width: pinSize,
                  height: pinSize,
                  point: center,
                  alignment: Alignment.topCenter,
                  child: const Image(
                    image: AssetImage(
                      "packages/np_gps_map/assets/gps_map_pin.png",
                    ),
                  ),
                ),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text("OpenStreetMap contributors"),
            ),
          ],
        ),
      ),
    );
  }

  final CameraPosition location;
  final void Function()? onTap;
}
