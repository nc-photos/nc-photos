import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/album/upgrader.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'album.g.dart';

/// Immutable object that represents an album
@npLog
class Album with EquatableMixin {
  /// Create a new album
  ///
  /// If [lastUpdated] is null, the current time will be used.
  ///
  /// [savedVersion] should be null when creating a new album, such that it'll
  /// be filled with the current version number automatically. You should only
  /// pass this argument when reading album from storage
  Album({
    DateTime? lastUpdated,
    required this.name,
    required this.provider,
    required this.coverProvider,
    required this.sortProvider,
    this.shares,
    this.albumFile,
    int? savedVersion,
  }) : lastUpdated = (lastUpdated ?? clock.now()).toUtc(),
       savedVersion = savedVersion ?? version;

  static Album? fromJson(
    JsonObj json, {
    required AlbumUpgraderFactory? upgraderFactory,
  }) {
    final jsonVersion = json["version"];
    JsonObj? result = json;
    if (jsonVersion < 2) {
      result = upgraderFactory?.buildV1()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 3) {
      result = upgraderFactory?.buildV2()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 4) {
      result = upgraderFactory?.buildV3()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 5) {
      result = upgraderFactory?.buildV4()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 6) {
      result = upgraderFactory?.buildV5()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 7) {
      result = upgraderFactory?.buildV6()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 8) {
      result = upgraderFactory?.buildV7()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 9) {
      result = upgraderFactory?.buildV8()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 10) {
      result = upgraderFactory?.buildV9()?.doJson(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion > version) {
      _log.warning(
        "[fromJson] Reading album with newer version: $jsonVersion > $version",
      );
    }
    return Album(
      lastUpdated:
          result["lastUpdated"] == null
              ? null
              : DateTime.parse(result["lastUpdated"]),
      name: result["name"],
      provider: AlbumProvider.fromJson(
        result["provider"].cast<String, dynamic>(),
      ),
      coverProvider: AlbumCoverProvider.fromJson(
        result["coverProvider"].cast<String, dynamic>(),
      ),
      sortProvider: AlbumSortProvider.fromJson(
        result["sortProvider"].cast<String, dynamic>(),
      ),
      shares:
          (result["shares"] as List?)
              ?.map((e) => AlbumShare.fromJson(e.cast<String, dynamic>()))
              .toList(),
      albumFile:
          result["albumFile"] == null
              ? null
              : File.fromJson(result["albumFile"].cast<String, dynamic>()),
      savedVersion: result["version"],
    );
  }

  @override
  toString({bool isDeep = false}) {
    return "$runtimeType {"
        "lastUpdated: $lastUpdated, "
        "name: $name, "
        "provider: ${provider.toString(isDeep: isDeep)}, "
        "coverProvider: $coverProvider, "
        "sortProvider: $sortProvider, "
        "shares: ${shares?.toReadableString()}, "
        "albumFile: $albumFile, "
        "}";
  }

  /// Return a copy with specified field modified
  ///
  /// [lastUpdated] is handled differently where if not set, the current time
  /// will be used. In order to keep [lastUpdated], you must explicitly assign
  /// it with value from this or a null value
  Album copyWith({
    OrNull<DateTime>? lastUpdated,
    String? name,
    AlbumProvider? provider,
    AlbumCoverProvider? coverProvider,
    AlbumSortProvider? sortProvider,
    OrNull<List<AlbumShare>>? shares,
    OrNull<File>? albumFile,
  }) {
    return Album(
      lastUpdated:
          lastUpdated == null ? null : (lastUpdated.obj ?? this.lastUpdated),
      name: name ?? this.name,
      provider: provider ?? this.provider,
      coverProvider: coverProvider ?? this.coverProvider,
      sortProvider: sortProvider ?? this.sortProvider,
      shares:
          shares == null ? this.shares?.run((obj) => List.of(obj)) : shares.obj,
      albumFile: albumFile == null ? this.albumFile : albumFile.obj,
      savedVersion: savedVersion,
    );
  }

  JsonObj toRemoteJson() {
    return {
      "version": version,
      "lastUpdated": lastUpdated.toIso8601String(),
      "name": name,
      "provider": provider.toJson(),
      "coverProvider": coverProvider.toJson(),
      "sortProvider": sortProvider.toJson(),
      if (shares != null) "shares": shares!.map((e) => e.toJson()).toList(),
      // ignore albumFile
    };
  }

  JsonObj toAppDbJson() {
    return {
      "version": version,
      "lastUpdated": lastUpdated.toIso8601String(),
      "name": name,
      "provider": provider.toJson(),
      "coverProvider": coverProvider.toJson(),
      "sortProvider": sortProvider.toJson(),
      if (shares != null) "shares": shares!.map((e) => e.toJson()).toList(),
      if (albumFile != null) "albumFile": albumFile!.toJson(),
    };
  }

  @override
  get props => [
    lastUpdated,
    name,
    provider,
    coverProvider,
    sortProvider,
    shares,
    albumFile,
    savedVersion,
  ];

  final DateTime lastUpdated;
  final String name;

  final AlbumProvider provider;
  final AlbumCoverProvider coverProvider;
  final AlbumSortProvider sortProvider;
  final List<AlbumShare>? shares;

  /// How is this album stored on server
  ///
  /// This field is typically only meaningful when returned by [AlbumRepo.get]
  final File? albumFile;

  /// The original version of this class when saved
  ///
  /// This field only exists in runtime and are not persisted
  final int savedVersion;

  /// versioning of this class, use to upgrade old persisted album
  static const version = 10;

  static final _log = _$AlbumNpLog.log;
}

@toString
class AlbumShare with EquatableMixin {
  AlbumShare({required this.userId, this.displayName, DateTime? sharedAt})
    : sharedAt = (sharedAt ?? clock.now()).toUtc();

  factory AlbumShare.fromJson(JsonObj json) {
    return AlbumShare(
      userId: CiString(json["userId"]),
      displayName: json["displayName"],
      sharedAt: DateTime.parse(json["sharedAt"]),
    );
  }

  JsonObj toJson() {
    return {
      "userId": userId.toString(),
      if (displayName != null) "displayName": displayName,
      "sharedAt": sharedAt.toIso8601String(),
    };
  }

  /// Return a copy with specified field modified
  ///
  /// [sharedAt] is handled differently where if not set, the current time will
  /// be used. In order to keep [sharedAt], you must explicitly assign it with
  /// value from this or a null value
  AlbumShare copyWith({
    CiString? userId,
    OrNull<String>? displayName,
    OrNull<DateTime>? sharedAt,
  }) {
    return AlbumShare(
      userId: userId ?? this.userId,
      displayName: displayName == null ? this.displayName : displayName.obj,
      sharedAt: sharedAt == null ? null : (sharedAt.obj ?? this.sharedAt),
    );
  }

  @override
  String toString() => _$toString();

  @override
  get props => [userId, sharedAt];

  /// User ID or username, case insensitive
  final CiString userId;
  final String? displayName;
  final DateTime sharedAt;
}

class AlbumRepo {
  AlbumRepo(this.dataSrc);

  /// See [AlbumDataSource.get]
  Future<Album> get(Account account, File albumFile) =>
      dataSrc.get(account, albumFile);

  /// See [AlbumDataSource.getAll]
  Stream<dynamic> getAll(Account account, List<File> albumFiles) =>
      dataSrc.getAll(account, albumFiles);

  /// See [AlbumDataSource.create]
  Future<Album> create(Account account, Album album) =>
      dataSrc.create(account, album);

  /// See [AlbumDataSource.update]
  Future<void> update(Account account, Album album) =>
      dataSrc.update(account, album);

  final AlbumDataSource dataSrc;
}

abstract class AlbumDataSource {
  /// Return the album defined by [albumFile]
  Future<Album> get(Account account, File albumFile);

  /// Emit albums defined by [albumFiles] or ExceptionEvent
  Stream<dynamic> getAll(Account account, List<File> albumFiles);

  // Create a new album
  Future<Album> create(Account account, Album album);

  /// Update an album
  Future<void> update(Account account, Album album);
}
