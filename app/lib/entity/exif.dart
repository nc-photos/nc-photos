import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:np_common/type.dart';
import 'package:np_exiv2/np_exiv2.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

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
    dynamic convertValue(dynamic value) {
      if (value is List) {
        return value.map(convertValue).toList();
      } else if (value is Rational) {
        return value.toJson();
      } else if (value is Date) {
        return value.toJson();
      } else if (value is Time) {
        return value.toJson();
      } else {
        return value;
      }
    }

    return Map.fromEntries(
      // we are filtering out MakerNote here because it's generally very large
      // and could exceed the 1MB cursor size limit on Android. Second, the
      // content is proprietary and thus useless to us anyway
      // UserComment is now also ignored as its size could be very large
      data.entries
          .where(
            (e) =>
                e.key != "MakerNote" &&
                e.key != "UserComment" &&
                e.key != "ImageDescription",
          )
          .map((e) {
            final jsonValue = convertValue(e.value);
            return MapEntry(e.key, jsonValue);
          }),
    );
  }

  factory Exif.fromJson(JsonObj json) {
    return Exif(
      Map.fromEntries(
        json.entries.map((e) {
          dynamic exifValue;
          if (e.value is Map) {
            exifValue = _objectFromJson(
              (e.value as Map).cast<String, dynamic>(),
            );
          } else if (e.value is List) {
            exifValue =
                (e.value as List).map((e) {
                  if (e is Map) {
                    return _objectFromJson(e.cast<String, dynamic>());
                  } else {
                    return e;
                  }
                }).toList();
          } else {
            exifValue = e.value;
          }
          return MapEntry(e.key, exifValue);
        }),
      ),
    );
  }

  @override
  String toString() {
    final dataStr = data.entries
        .map((e) {
          return "${e.key}: '${e.value}'";
        })
        .join(", ");
    return "Exif {$dataStr}";
  }

  /// 0x010f Make
  String? get make => data["Make"];

  /// 0x0110 Model
  String? get model => data["Model"];

  /// 0x9003 DateTimeOriginal
  @visibleForTesting
  DateTime? get dateTimeOriginal {
    try {
      return data.containsKey("DateTimeOriginal") &&
              (data["DateTimeOriginal"] as String).isNotEmpty
          ? dateTimeFormat.parse(data["DateTimeOriginal"])
          : null;
    } catch (e, stackTrace) {
      _log.severe(
        "[dateTimeOriginal] Non standard value: ${data["DateTimeOriginal"]}",
        e,
        stackTrace,
      );
      return null;
    }
  }

  DateTime? get dateTimeOriginalWithOffset {
    final d = dateTimeOriginal;
    if (d == null) {
      return null;
    }
    try {
      final offset = offsetTimeOriginal;
      if (offset == null) {
        // no tz data, assume local
        return d.toUtc();
      }
      final result = d.copyWith(isUtc: true);
      // subtract the timezone offset to get the utc time manually
      return result.subtract(offset);
    } catch (e, stackTrace) {
      _log.severe(
        "[dateTimeOriginalWithTimezone] Non standard OffsetTimeOriginal value: ${data["OffsetTimeOriginal"]}",
        e,
        stackTrace,
      );
      return d.toUtc();
    }
  }

  Duration? get offsetTimeOriginal {
    var offsetStr =
        data.containsKey("OffsetTimeOriginal") &&
                (data["OffsetTimeOriginal"] as String).isNotEmpty
            ? data["OffsetTimeOriginal"] as String
            : null;
    // try the server hack
    offsetStr ??=
        data.containsKey("_OffsetTimeOriginal") &&
                (data["_OffsetTimeOriginal"] as String).isNotEmpty
            ? data["_OffsetTimeOriginal"] as String
            : null;
    if (offsetStr == null) {
      // no tz data
      return null;
    }
    final isPositive = offsetStr.startsWith("+");
    final hours = int.parse(offsetStr.slice(1, 3));
    final mins = int.parse(offsetStr.slice(4));
    return Duration(
      hours: isPositive ? hours : -hours,
      minutes: isPositive ? mins : -mins,
    );
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
  List<Object?> get props => [data];

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
        stackTrace,
      );
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
        stackTrace,
      );
      return null;
    }
  }

  final Map<String, dynamic> data;

  static final dateTimeFormat = DateFormat("yyyy:MM:dd HH:mm:ss");
}

extension on Rational {
  JsonObj toJson() => {"n": numerator, "d": denominator};
}

extension on Date {
  JsonObj toJson() => {"_": "Date", "y": year, "m": month, "d": day};
}

extension on Time {
  JsonObj toJson() => {
    "_": "Time",
    "h": hour,
    "m": minute,
    "s": second,
    "th": tzHour,
    "tm": tzMinute,
  };
}

Object _objectFromJson(JsonObj json) {
  switch (json["_"]) {
    case "Date":
      return Date(json["y"], json["m"], json["d"]);
    case "Time":
      return Time(json["h"], json["m"], json["s"], json["th"], json["tm"]);
    case null:
    default:
      return Rational(
        json["n"] ?? json["numerator"],
        json["d"] ?? json["denominator"],
      );
  }
}
