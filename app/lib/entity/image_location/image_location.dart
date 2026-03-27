import 'package:equatable/equatable.dart';
import 'package:np_common/type.dart';
import 'package:to_string/to_string.dart';

part 'image_location.g.dart';

@ToString(ignoreNull: true)
class ImageLocation with EquatableMixin {
  const ImageLocation({
    this.version = appVersion,
    required this.dataRevision,
    this.latitude,
    this.longitude,
    this.countryCode,
    this.names,
  });

  factory ImageLocation.empty() => const ImageLocation(dataRevision: 0);

  static ImageLocation fromJson(JsonObj json) {
    return ImageLocation(
      version: json["v"],
      dataRevision: json["drev"] ?? 0,
      latitude: json["lat"] == null ? null : json["lat"] / 10000,
      longitude: json["lng"] == null ? null : json["lng"] / 10000,
      countryCode: json["cc"],
      names:
          json["names"] == null
              ? null
              : (json["names"] as Map).cast<String, dynamic>().map(
                (key, value) =>
                    MapEntry(key, ImageLocationName.fromJson(value)),
              ),
    );
  }

  JsonObj toJson() => {
    "v": version,
    "drev": dataRevision,
    if (latitude != null) "lat": (latitude! * 10000).round(),
    if (longitude != null) "lng": (longitude! * 10000).round(),
    if (countryCode != null) "cc": countryCode,
    if (names != null)
      "names": names!.map((key, value) => MapEntry(key, value.toJson())),
  };

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    version,
    dataRevision,
    latitude,
    longitude,
    countryCode,
    names,
  ];

  // json revision
  final int version;
  // revision of the location data used for reverse geolocation
  final int dataRevision;
  final double? latitude;
  final double? longitude;
  final String? countryCode;
  // key: ISO-3166 alpha2 code
  final Map<String, ImageLocationName>? names;

  static const appVersion = 2;
}

@ToString(ignoreNull: true)
class ImageLocationName with EquatableMixin {
  const ImageLocationName({required this.name, this.admin1, this.admin2});

  factory ImageLocationName.fromJson(JsonObj json) {
    return ImageLocationName(
      name: json["name"],
      admin1: json["admin1"],
      admin2: json["admin2"],
    );
  }

  JsonObj toJson() => {
    if (name != null) "name": name,
    if (admin1 != null) "admin1": admin1,
    if (admin2 != null) "admin2": admin2,
  };

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [name, admin1, admin2];

  final String? name;
  final String? admin1;
  final String? admin2;
}
