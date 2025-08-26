import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:np_gps_map/src/type.dart' as type;

class GoogleGpsMap extends StatelessWidget {
  const GoogleGpsMap({super.key, required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    final center = LatLng(location.center.latitude, location.center.longitude);
    return GoogleMap(
      compassEnabled: false,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      buildingsEnabled: false,
      // liteModeEnabled: true,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: location.zoom,
        bearing: location.rotation,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("at"),
          position: center,
          // for some reason, GoogleMap's onTap is not triggered if
          // tapped on top of the marker
          onTap: onTap,
        ),
      },
      onTap: (_) => onTap?.call(),
      onMapCreated: (controller) {
        if (Theme.of(context).brightness == Brightness.dark) {
          controller.setMapStyle(_mapStyleNight);
        }
      },
    );
  }

  final type.CameraPosition location;
  final VoidCallback? onTap;
}

// Generated in https://mapstyle.withgoogle.com/
const _mapStyleNight =
    '[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]';
