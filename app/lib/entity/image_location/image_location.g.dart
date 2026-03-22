part of 'image_location.dart';

extension _$ImageLocationToString on ImageLocation {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ImageLocation {version: $version, ${name == null ? "" : "name: $name, "}${latitude == null ? "" : "latitude: ${latitude!.toStringAsFixed(3)}, "}${longitude == null ? "" : "longitude: ${longitude!.toStringAsFixed(3)}, "}${countryCode == null ? "" : "countryCode: $countryCode, "}${admin1 == null ? "" : "admin1: $admin1, "}${admin2 == null ? "" : "admin2: $admin2"}}";
  }
}
