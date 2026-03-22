import 'package:equatable/equatable.dart';
import 'package:np_common/type.dart';
import 'package:to_string/to_string.dart';

part 'image_location.g.dart';

@ToString(ignoreNull: true)
class ImageLocation with EquatableMixin {
  const ImageLocation({
    this.version = appVersion,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    this.admin1,
    this.admin2,
  });

  factory ImageLocation.empty() => const ImageLocation(
    name: null,
    latitude: null,
    longitude: null,
    countryCode: null,
  );

  static ImageLocation fromJson(JsonObj json) {
    return ImageLocation(
      version: json["v"],
      name: json["name"],
      latitude: json["lat"] == null ? null : json["lat"] / 10000,
      longitude: json["lng"] == null ? null : json["lng"] / 10000,
      countryCode: json["cc"],
      admin1: json["admin1"],
      admin2: json["admin2"],
    );
  }

  JsonObj toJson() => {
    "v": version,
    if (name != null) "name": name,
    if (latitude != null) "lat": (latitude! * 10000).round(),
    if (longitude != null) "lng": (longitude! * 10000).round(),
    if (countryCode != null) "cc": countryCode,
    if (admin1 != null) "admin1": admin1,
    if (admin2 != null) "admin2": admin2,
  };

  bool isEmpty() => name == null;

  @override
  String toString() => _$toString();

  @override
  get props => [
    version,
    name,
    latitude,
    longitude,
    countryCode,
    admin1,
    admin2,
  ];

  final int version;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? countryCode;
  final String? admin1;
  final String? admin2;

  static const appVersion = 1;
}
