import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:latlong2/latlong.dart';
import 'package:np_common/type.dart';

enum GpsMapProvider { google, osm }

/// A pair of latitude and longitude coordinates, stored as degrees
class MapCoord {
  const MapCoord(this.latitude, this.longitude);

  MapCoord.fromJson(JsonObj json)
    : latitude = json["lat"],
      longitude = json["lng"];

  @override
  String toString() => "MapCoord {latitude: $latitude, longitude: $longitude}";

  JsonObj toJson() => {"lat": latitude, "lng": longitude};

  final double latitude;
  final double longitude;
}

extension GLatLngExtension on gmap.LatLng {
  MapCoord toMapCoord() => MapCoord(latitude, longitude);
}

extension LatLngExtension on LatLng {
  MapCoord toMapCoord() => MapCoord(latitude, longitude);
}

class CameraPosition with EquatableMixin {
  const CameraPosition({
    required this.center,
    required this.zoom,
    this.rotation = 0,
  });

  factory CameraPosition.fromJson(JsonObj json) {
    return CameraPosition(
      center: MapCoord.fromJson(json["center"]),
      zoom: json["zoom"],
      rotation: json["rotation"],
    );
  }

  @override
  String toString() =>
      "CameraPosition {"
      "center: $center, "
      "zoom: $zoom, "
      "rotation: $rotation, "
      "}";

  JsonObj toJson() {
    return {"center": center.toJson(), "zoom": zoom, "rotation": rotation};
  }

  @override
  List<Object?> get props => [center, zoom, rotation];

  final MapCoord center;
  final double zoom;
  // The camera's bearing in degrees, measured clockwise from north.
  //
  // A bearing of 0.0, the default, means the camera points north.
  // A bearing of 90.0 means the camera points east.
  final double rotation;
}
