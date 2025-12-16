import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'xmp.g.dart';

@npLog
class Xmp with EquatableMixin {
  Xmp(this.data);

  factory Xmp.fromJson(JsonObj json) {
    return Xmp(Map.of(json));
  }

  JsonObj toJson() {
    // currently we only have String or List<String> for xmp data, so no
    // conversion is needed
    return Map.of(data);
  }

  int? get width {
    try {
      return data["Width"] == null ? null : int.parse(data["Width"]);
    } catch (e, stackTrace) {
      _log.warning(
        "[Xmp] Failed to parse Width: ${data["Width"]}",
        e,
        stackTrace,
      );
      return null;
    }
  }

  int? get height {
    try {
      return data["Height"] == null ? null : int.parse(data["Height"]);
    } catch (e, stackTrace) {
      _log.severe(
        "[Xmp] Failed to parse Height: ${data["Height"]}",
        e,
        stackTrace,
      );
      return null;
    }
  }

  DateTime? get dateUtc {
    final val = data["DateUTC"];
    try {
      final valInt = int.tryParse(val);
      if (valInt == null) {
        // not epoch, probably ISO format
        return DateTime.parse(val);
      }
      if (valInt < 2082844800) {
        // assume unix time
        return DateTime.fromMillisecondsSinceEpoch(valInt * 1000, isUtc: true);
      }
      // maybe unix/mac time
      final unixTime = DateTime.fromMillisecondsSinceEpoch(
        valInt * 1000,
        isUtc: true,
      );
      final macTime = DateTime.fromMillisecondsSinceEpoch(
        (valInt - 2082844800) * 1000,
        isUtc: true,
      );
      final unixDt = DateTime.now().difference(unixTime).abs();
      final macDt = DateTime.now().difference(macTime).abs();
      if (unixDt < macDt) {
        return unixTime;
      } else {
        return macTime;
      }
    } catch (e, stackTrace) {
      _log.severe(
        "[Xmp] Failed to parse DateUTC: ${data["DateUTC"]}",
        e,
        stackTrace,
      );
      return null;
    }
  }

  ({double lat, double lng})? get gpsCoordinates {
    final val =
        // for Android
        data["GPSCoordinates"] ??
        // for Apple
        data["np.meta.mdta.com.apple.quicktime.location.ISO6709"];
    if (val == null) {
      return null;
    }
    try {
      final regex = RegExp(r"([+-][0-9\.]+)([+-][0-9\.]+)");
      final match = regex.matchAsPrefix(val);
      if (match == null || match.groupCount != 2) {
        _log.warning("[Xmp] Failed to parse GPSCoordinates: $val");
        return null;
      }
      final latStr = match.group(1);
      final lngStr = match.group(2);
      return (lat: double.parse(latStr!), lng: double.parse(lngStr!));
    } catch (e, stackTrace) {
      _log.severe("[Xmp] Failed to parse GPSCoordinates: $val", e, stackTrace);
      return null;
    }
  }

  String? get make =>
      data["Make"] ??
      // for Android
      data["np.meta.mdta.com.android.manufacturer"] ??
      // for Apple
      data["np.meta.mdta.com.apple.quicktime.make"];

  String? get model =>
      data["Model"] ??
      // for Xiaomi
      data["np.meta.mdta.com.xiaomi.product.marketname"] ??
      // for other Android
      data["np.meta.mdta.com.android.model"] ??
      // for Apple
      data["np.meta.mdta.com.apple.quicktime.model"];

  @override
  List<Object?> get props => [data];

  final Map<String, dynamic> data;
}
