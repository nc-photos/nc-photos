import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/foundation.dart';
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
    this.dataRevision,
    this.latitude,
    this.longitude,
    this.countryCode,
    this.names,
  );

  @override
  String toString() => _$toString();

  final int dataRevision;
  final double latitude;
  final double longitude;
  final String countryCode;
  final Map<String, ReverseGeocoderLocationName> names;
}

@genCopyWith
@toString
class ReverseGeocoderLocationName {
  const ReverseGeocoderLocationName({this.name, this.admin1, this.admin2});

  const ReverseGeocoderLocationName.empty()
    : this(name: null, admin1: null, admin2: null);

  @override
  String toString() => _$toString();

  final String? name;
  final String? admin1;
  final String? admin2;
}

@npLog
class ReverseGeocoder {
  Future<void> init({
    @visibleForTesting
    FutureOr<CommonDatabase> Function() dbBuilder = _openDatabase,
  }) async {
    final s = Stopwatch()..start();
    _db = await dbBuilder();
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
    _log.info("[call] Found: $data");
    return data;
  }

  ReverseGeocoderLocation? _queryPoint(int latitudeInt, int longitudeInt) {
    const citySql = """
      SELECT cities.latitude, cities.longitude, cities.countryCode, cities.cityId, cities.admin1Id, cities.admin2Id
      FROM cities
      WHERE latitude = ? AND longitude = ?;
      """;
    final cityResult =
        _db.select(citySql, [latitudeInt, longitudeInt]).singleOrNull;
    if (cityResult == null) {
      return null;
    }
    final ids = [
      cityResult.columnAt(3),
      if (cityResult.columnAt(4) != null) cityResult.columnAt(4),
      if (cityResult.columnAt(5) != null) cityResult.columnAt(5),
    ];
    final nameSql = """
      SELECT names.geonameId, names.lang, names.name
      FROM names
      WHERE geonameId IN (${ids.join(", ")});
      """;
    var nameMap = <int, Map<String, String>>{};
    for (final r in _db.select(nameSql)) {
      nameMap[r.columnAt(0)] ??= <String, String>{};
      nameMap[r.columnAt(0)]![r.columnAt(1)] = r.columnAt(2);
    }

    // lang: names
    final localizedNames = <String, ReverseGeocoderLocationName>{};
    for (final r in _db.select(nameSql)) {
      localizedNames[r.columnAt(1)] ??=
          const ReverseGeocoderLocationName.empty();
      if (r.columnAt(0) == ids[0]) {
        // city
        localizedNames[r.columnAt(1)] = localizedNames[r.columnAt(1)]!.copyWith(
          name: r.columnAt(2),
        );
      } else if (r.columnAt(0) == ids[1]) {
        // admin1
        localizedNames[r.columnAt(1)] = localizedNames[r.columnAt(1)]!.copyWith(
          admin1: r.columnAt(2),
        );
      } else if (r.columnAt(0) == ids[2]) {
        // admin2
        localizedNames[r.columnAt(1)] = localizedNames[r.columnAt(1)]!.copyWith(
          admin2: r.columnAt(2),
        );
      } else {
        _log.warning("[_queryPoint] Unknown geonameId: ${r.columnAt(0)}");
      }
    }
    localizedNames.removeWhere(
      (key, value) => value == const ReverseGeocoderLocationName.empty(),
    );
    if (localizedNames.isEmpty) {
      return null;
    }

    return ReverseGeocoderLocation(
      ReverseGeocoder.dataRevision,
      cityResult.columnAt(0) / 10000,
      cityResult.columnAt(1) / 10000,
      cityResult.columnAt(2),
      localizedNames,
    );
  }

  static const dataRevision = 202603;

  late final CommonDatabase _db;
  late final KDTree _searchTree;
}

Future<CommonDatabase> _openDatabase() async {
  return openRawSqliteDbFromAsset();
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
