import 'package:equatable/equatable.dart';
import 'package:np_common/localized_string.dart';
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
    this.city,
    this.admin1,
    this.admin2,
  });

  factory ImageLocation.empty() => const ImageLocation(dataRevision: 0);

  static ImageLocation? fromJson(JsonObj json) {
    final jsonVersion = json["v"];
    if (jsonVersion == 1) {
      // v1 and v2 is not compatible
      return null;
    }
    return ImageLocation(
      version: json["v"],
      dataRevision: json["drev"] ?? 0,
      latitude: json["lat"] == null ? null : json["lat"] / 10000,
      longitude: json["lng"] == null ? null : json["lng"] / 10000,
      countryCode: json["cc"],
      city: json["city"] == null
          ? null
          : ImageLocationName.fromJson(json["city"]),
      admin1: json["admin1"] == null
          ? null
          : ImageLocationName.fromJson(json["admin1"]),
      admin2: json["admin2"] == null
          ? null
          : ImageLocationName.fromJson(json["admin2"]),
    );
  }

  JsonObj toJson() => {
    "v": version,
    "drev": dataRevision,
    if (latitude != null) "lat": (latitude! * 10000).round(),
    if (longitude != null) "lng": (longitude! * 10000).round(),
    if (countryCode != null) "cc": countryCode,
    if (city != null) "city": city!.toJson(),
    if (admin1 != null) "admin1": admin1!.toJson(),
    if (admin2 != null) "admin2": admin2!.toJson(),
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
    city,
    admin1,
    admin2,
  ];

  // json revision
  final int version;
  // revision of the location data used for reverse geolocation
  final int dataRevision;
  final double? latitude;
  final double? longitude;
  final String? countryCode;
  final ImageLocationName? city;
  final ImageLocationName? admin1;
  final ImageLocationName? admin2;

  static const appVersion = 2;
}

@ToString(ignoreNull: true)
class ImageLocationName with EquatableMixin {
  const ImageLocationName({required this.geonameId, required this.name});

  factory ImageLocationName.fromJson(JsonObj json) {
    return ImageLocationName(
      geonameId: json["geonameId"],
      name: LocalizedString.fromJson(json["name"]),
    );
  }

  JsonObj toJson() => {"geonameId": geonameId, "name": name.toJson()};

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [geonameId, name];

  final int geonameId;
  final LocalizedString name;
}
