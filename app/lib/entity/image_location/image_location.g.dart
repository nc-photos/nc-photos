// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_location.dart';

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$ImageLocationToString on ImageLocation {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ImageLocation {version: $version, ${latitude == null ? "" : "latitude: ${latitude!.toStringAsFixed(3)}, "}${longitude == null ? "" : "longitude: ${longitude!.toStringAsFixed(3)}, "}${countryCode == null ? "" : "countryCode: $countryCode, "}${names == null ? "" : "names: {length: ${names!.length}}"}}";
  }
}

extension _$ImageLocalizedLocationToString on ImageLocationName {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ImageLocalizedLocation {name: $name, ${admin1 == null ? "" : "admin1: $admin1, "}${admin2 == null ? "" : "admin2: $admin2"}}";
  }
}
