import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'list_location_group.g.dart';

@toString
class LocationGroup with EquatableMixin {
  const LocationGroup(
    this.place,
    this.countryCode,
    this.count,
    this.latestFileId,
    this.latestDateTime,
    this.latestFileMime,
    this.latestFileRelativePath,
  );

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
        place,
        countryCode,
        count,
        latestFileId,
        latestDateTime,
        latestFileMime,
        latestFileRelativePath,
      ];

  final String place;
  final String countryCode;
  final int count;
  final int latestFileId;
  final DateTime latestDateTime;
  final String? latestFileMime;
  final String latestFileRelativePath;
}

@toString
class LocationGroupResult with EquatableMixin {
  const LocationGroupResult(
      this.name, this.admin1, this.admin2, this.countryCode);

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
        name,
        admin1,
        admin2,
        countryCode,
      ];

  final List<LocationGroup> name;
  final List<LocationGroup> admin1;
  final List<LocationGroup> admin2;
  final List<LocationGroup> countryCode;
}

@npLog
class ListLocationGroup {
  const ListLocationGroup(this._c);

  /// List location groups based on the name of the places
  Future<LocationGroupResult> call(Account account) async {
    final s = Stopwatch()..start();
    try {
      final dbObj = await _c.npDb.groupLocations(
        account: account.toDb(),
        includeRelativeRoots: account.roots,
        excludeRelativeRoots: [
          remote_storage_util.remoteStorageDirRelativePath
        ],
      );
      return LocationGroupResult(
        dbObj.name.map(DbLocationGroupConverter.fromDb).toList(),
        dbObj.admin1.map(DbLocationGroupConverter.fromDb).toList(),
        dbObj.admin2.map(DbLocationGroupConverter.fromDb).toList(),
        dbObj.countryCode.map(DbLocationGroupConverter.fromDb).toList(),
      );
    } finally {
      _log.info("[call] Elapsed time: ${s.elapsedMilliseconds}ms");
    }
  }

  final DiContainer _c;
}
