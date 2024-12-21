import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:np_common/type.dart';
import 'package:np_exiv2/np_exiv2.dart';
import 'package:np_log/np_log.dart';

part 'exif.g.dart';

@npLog
class Exif with EquatableMixin {
  Exif(this.data);

  dynamic operator [](String key) => data[key];

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => equals(other, isDeep: true);

  /// Compare two Exif objects
  ///
  /// If [isDeep] is false, two Exif objects are considered identical if they
  /// contain the same number of fields. This hack is to save time comparing a
  /// large amount of data that are mostly immutable
  bool equals(Object? other, {bool isDeep = false}) {
    if (isDeep) {
      return super == other;
    } else {
      return identical(this, other) ||
          other is Exif && data.keys.length == other.data.keys.length;
    }
  }

  bool containsKey(String key) => data.containsKey(key);

  JsonObj toJson() {
    return Map.fromEntries(
      // we are filtering out MakerNote here because it's generally very large
      // and could exceed the 1MB cursor size limit on Android. Second, the
      // content is proprietary and thus useless to us anyway
      // UserComment is now also ignored as its size could be very large
      data.entries
          .where((e) =>
              e.key != "MakerNote" &&
              e.key != "UserComment" &&
              e.key != "ImageDescription")
          .map((e) {
        dynamic jsonValue;
        if (e.value is Rational) {
          jsonValue = (e.value as Rational).toJson();
        } else if (e.value is List) {
          jsonValue = (e.value as List).map((e) {
            if (e is Rational) {
              return e.toJson();
            } else {
              return e;
            }
          }).toList();
        } else {
          jsonValue = e.value;
        }
        return MapEntry(e.key, jsonValue);
      }),
    );
  }

  factory Exif.fromJson(JsonObj json) {
    return Exif(Map.fromEntries(
      json.entries.map((e) {
        dynamic exifValue;
        if (e.value is Map) {
          exifValue =
              _rationalFromJson((e.value as Map).cast<String, dynamic>());
        } else if (e.value is List) {
          exifValue = (e.value as List).map((e) {
            if (e is Map) {
              return _rationalFromJson(e.cast<String, dynamic>());
            } else {
              return e;
            }
          }).toList();
        } else {
          exifValue = e.value;
        }
        return MapEntry(e.key, exifValue);
      }),
    ));
  }

  @override
  String toString() {
    final dataStr = data.entries.map((e) {
      return "${e.key}: '${e.value}'";
    }).join(", ");
    return "Exif {$dataStr}";
  }

  /// 0x010f Make
  String? get make => data["Make"];

  /// 0x0110 Model
  String? get model => data["Model"];

  /// 0x9003 DateTimeOriginal
  DateTime? get dateTimeOriginal {
    try {
      return data.containsKey("DateTimeOriginal") &&
              (data["DateTimeOriginal"] as String).isNotEmpty
          ? dateTimeFormat.parse(data["DateTimeOriginal"]).toUtc()
          : null;
    } catch (e, stackTrace) {
      _log.severe(
          "[dateTimeOriginal] Non standard valie: ${data["DateTimeOriginal"]}",
          e,
          stackTrace);
      return null;
    }
  }

  /// 0x829a ExposureTime
  Rational? get exposureTime => _readRationalValue("ExposureTime");

  /// 0x829d FNumber
  Rational? get fNumber => _readRationalValue("FNumber");

  /// 0x8827 ISO/ISOSpeedRatings/PhotographicSensitivity
  int? get isoSpeedRatings => _readIntValue("ISOSpeedRatings");

  /// 0x920a FocalLength
  Rational? get focalLength => _readRationalValue("FocalLength");

  /// 0x8825 GPS tags
  String? get gpsLatitudeRef => data["GPSLatitudeRef"];
  List<Rational>? get gpsLatitude => data["GPSLatitude"]?.cast<Rational>();
  String? get gpsLongitudeRef => data["GPSLongitudeRef"];
  List<Rational>? get gpsLongitude => data["GPSLongitude"]?.cast<Rational>();

  @override
  List<Object?> get props => [
        data,
      ];

  Rational? _readRationalValue(String key) {
    // values may be saved as typed (extracted by app) or untyped string
    // (extracted by server)
    return data[key] is String ? _tryParseRationalString(data[key]) : data[key];
  }

  int? _readIntValue(String key) {
    return data[key] is String ? _tryParseIntString(data[key]) : data[key];
  }

  static Rational? _tryParseRationalString(String str) {
    if (str.isEmpty) {
      return null;
    }
    try {
      final pos = str.indexOf("/");
      return Rational(
        int.parse(str.substring(0, pos)),
        int.parse(str.substring(pos + 1)),
      );
    } catch (e, stackTrace) {
      _$ExifNpLog.log.shout(
          "[_tryParseRationalString] Failed to parse rational string: $str",
          e,
          stackTrace);
      return null;
    }
  }

  static int? _tryParseIntString(String str) {
    if (str.isEmpty) {
      return null;
    }
    try {
      return int.parse(str);
    } catch (e, stackTrace) {
      _$ExifNpLog.log.shout(
          "[_tryParseIntString] Failed to parse int string: $str",
          e,
          stackTrace);
      return null;
    }
  }

  final Map<String, dynamic> data;

  static final dateTimeFormat = DateFormat("yyyy:MM:dd HH:mm:ss");
}

extension on Rational {
  Map<String, int> toJson() => {
        "n": numerator,
        "d": denominator,
      };
}

Rational _rationalFromJson(Map<String, dynamic> json) {
  return Rational(
      json["n"] ?? json["numerator"], json["d"] ?? json["denominator"]);
}
