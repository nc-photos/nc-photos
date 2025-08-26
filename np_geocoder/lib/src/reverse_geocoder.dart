import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:kdtree/kdtree.dart';
import 'package:logging/logging.dart';
import 'package:np_geocoder/src/native/db_util.dart'
    if (dart.library.html) 'package:np_geocoder/src/web/db_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_math/np_math.dart';
import 'package:sqlite3/common.dart';
import 'package:to_string/to_string.dart';

part 'reverse_geocoder.g.dart';

@toString
class ReverseGeocoderLocation {
  const ReverseGeocoderLocation(
    this.name,
    this.latitude,
    this.longitude,
    this.countryCode,
    this.admin1,
    this.admin2,
  );

  @override
  String toString() => _$toString();

  final String name;
  final double latitude;
  final double longitude;
  final String countryCode;
  final String? admin1;
  final String? admin2;
}

@npLog
class ReverseGeocoder {
  Future<void> init() async {
    final s = Stopwatch()..start();
    _db = await _openDatabase();
    _searchTree = _buildSearchTree(_db);
    _log.info("[init] Elapsed time: ${s.elapsedMilliseconds}ms");
  }

  /// Convert a geographic coordinate (in degree) into a location
  Future<ReverseGeocoderLocation?> call(
    double latitude,
    double longitude,
  ) async {
    _log.info(
      "[call] latitude: ${latitude.toStringAsFixed(3)}, longitude: ${longitude.toStringAsFixed(3)}",
    );
    final latitudeInt = (latitude * 10000).round();
    final longitudeInt = (longitude * 10000).round();
    final nearest =
        _searchTree.nearest({
          "t": latitudeInt,
          "g": longitudeInt,
        }, 1).firstOrNull;
    if (nearest == null) {
      _log.info("[call] Nearest point not found");
      return null;
    }
    final nearestLat = nearest[0]["t"];
    final nearestLatF = nearestLat / 10000;
    final nearestLng = nearest[0]["g"];
    final nearestLngF = nearestLng / 10000;
    _log.info("[call] Nearest point, (lat: $nearestLatF, lng: $nearestLngF)");
    try {
      final distance = _distanceInKm(
        degToRad(latitude),
        degToRad(longitude),
        degToRad(nearestLatF),
        degToRad(nearestLngF),
      );
      _log.info(
        "[call] (lat: ${latitude.toStringAsFixed(3)}, lng: ${longitude.toStringAsFixed(3)}) <-> (lat: $nearestLatF, lng: $nearestLngF) = ${distance.toStringAsFixed(3)}km",
      );
      // a completely arbitrary threshold :)
      if (distance > 10) {
        _log.info("[call] Nearest point is too far away");
        return null;
      }
    } catch (e, stackTrace) {
      _log.severe("[call] Uncaught exception", e, stackTrace);
    }

    final data = _queryPoint(nearestLat, nearestLng);
    if (data == null) {
      _log.severe(
        "[call] Row not found for point: latitude: $nearestLat, longitude: $nearestLng",
      );
      return null;
    }
    final result = ReverseGeocoderLocation(
      data.name,
      data.latitude / 10000,
      data.longitude / 10000,
      data.countryCode,
      data.admin1,
      data.admin2,
    );
    _log.info("[call] Found: $result");
    return result;
  }

  _DatabaseRow? _queryPoint(int latitudeInt, int longitudeInt) {
    final result = _db.select(
      "SELECT * FROM cities WHERE latitude = ? AND longitude = ? LIMIT 1;",
      [latitudeInt, longitudeInt],
    );
    if (result.isEmpty) {
      return null;
    } else {
      return _DatabaseRow(
        result.first.columnAt(1),
        result.first.columnAt(2),
        result.first.columnAt(3),
        result.first.columnAt(4),
        result.first.columnAt(5),
        result.first.columnAt(6),
      );
    }
  }

  late final CommonDatabase _db;
  late final KDTree _searchTree;
}

class _DatabaseRow {
  const _DatabaseRow(
    this.name,
    this.latitude,
    this.longitude,
    this.countryCode,
    this.admin1,
    this.admin2,
  );

  final String name;
  final int latitude;
  final int longitude;
  final String countryCode;
  final String? admin1;
  final String? admin2;
}

Future<CommonDatabase> _openDatabase() async {
  return openRawSqliteDbFromAsset("cities.sqlite", "cities.sqlite");
}

KDTree _buildSearchTree(CommonDatabase db) {
  final results = db.select("SELECT latitude, longitude FROM cities;");
  return KDTree(
    results.map((e) => {"t": e.columnAt(0), "g": e.columnAt(1)}).toList(),
    _kdTreeDistance,
    ["t", "g"],
  );
}

int _kdTreeDistance(Map a, Map b) {
  return (math.pow((a["t"] as int) - (b["t"] as int), 2) +
          math.pow((a["g"] as int) - (b["g"] as int), 2))
      as int;
}

/// Calculate the distance in KM between two point
///
/// Both latitude and longitude are expected to be in radian
double _distanceInKm(
  double latitude1,
  double longitude1,
  double latitude2,
  double longitude2,
) {
  final dLat = latitude2 - latitude1;
  final dLon = longitude2 - longitude1;
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(latitude1) *
          math.cos(latitude2) *
          math.pow(math.sin(dLon / 2), 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  // 6371 = earth radius
  return 6371 * c;
}
