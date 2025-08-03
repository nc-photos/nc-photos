import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:nc_photos/entity/exif_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/json_util.dart' as json_util;
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'file.g.dart';

int compareFileDateTimeDescending(File x, File y) =>
    compareFileDescriptorDateTimeDescending(x, y);

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
      name: null, latitude: null, longitude: null, countryCode: null);

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

enum MetadataSrc {
  // must not modify the order
  legacy,
  nextcloud,
  exiv2,
  ;

  factory MetadataSrc.fromValue(int value) => MetadataSrc.values[value];
}

/// Immutable object that hold metadata of a [File]
@npLog
@ToString(ignoreNull: true)
class Metadata with EquatableMixin {
  Metadata({
    DateTime? lastUpdated,
    this.fileEtag,
    this.imageWidth,
    this.imageHeight,
    this.exif,
    required this.src,
  }) : lastUpdated = (lastUpdated ?? clock.now()).toUtc();

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => equals(other, isDeep: true);

  bool equals(Object? other, {bool isDeep = false}) {
    if (other is Metadata) {
      return super == other &&
          (exif == null) == (other.exif == null) &&
          (exif?.equals(other.exif, isDeep: isDeep) ?? true);
    } else {
      return false;
    }
  }

  /// Parse Metadata from [json]
  ///
  /// If the version saved in json does not match the active one, the
  /// corresponding upgrader will be called one by one to upgrade the json,
  /// version by version until it reached the active version. If any upgrader
  /// in the chain is null, the upgrade process will fail
  static Metadata? fromJson(
    JsonObj json, {
    required MetadataUpgraderV1? upgraderV1,
    required MetadataUpgraderV2? upgraderV2,
    required MetadataUpgraderV3? upgraderV3,
    required MetadataUpgraderV4? upgraderV4,
  }) {
    final jsonVersion = json["version"];
    JsonObj? result = json;
    if (jsonVersion < 2) {
      result = upgraderV1?.call(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 3) {
      result = upgraderV2?.call(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 4) {
      result = upgraderV3?.call(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    if (jsonVersion < 5) {
      result = upgraderV4?.call(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    return Metadata(
      lastUpdated: result["lastUpdated"] == null
          ? null
          : DateTime.parse(result["lastUpdated"]),
      fileEtag: result["fileEtag"],
      imageWidth: result["imageWidth"],
      imageHeight: result["imageHeight"],
      exif: result["exif"] == null
          ? null
          : Exif.fromJson(result["exif"].cast<String, dynamic>()),
      src: MetadataSrc.fromValue(result["src"]),
    );
  }

  JsonObj toJson() {
    return {
      "version": version,
      "lastUpdated": lastUpdated.toIso8601String(),
      if (fileEtag != null) "fileEtag": fileEtag,
      if (imageWidth != null) "imageWidth": imageWidth,
      if (imageHeight != null) "imageHeight": imageHeight,
      if (exif != null) "exif": exif!.toJson(),
      "src": src.index,
    };
  }

  Metadata copyWith({
    OrNull<DateTime>? lastUpdated,
    String? fileEtag,
    int? imageWidth,
    int? imageHeight,
    Exif? exif,
  }) {
    return Metadata(
      lastUpdated:
          lastUpdated == null ? null : (lastUpdated.obj ?? this.lastUpdated),
      fileEtag: fileEtag ?? this.fileEtag,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      exif: exif ?? this.exif,
      src: src,
    );
  }

  static Metadata? fromApi({
    required String? etag,
    Map<String, String>? ifd0,
    Map<String, String>? exif,
    Map<String, String>? gps,
    required Map<String, String> size,
  }) {
    final lat = gps?["latitude"]?.let(double.tryParse);
    final lng = gps?["longitude"]?.let(double.tryParse);
    final alt = gps?["altitude"]?.let(double.tryParse);
    return Metadata(
      lastUpdated: clock.now().toUtc(),
      fileEtag: etag,
      imageWidth: int.parse(size["width"]!),
      imageHeight: int.parse(size["height"]!),
      exif: ifd0 != null || exif != null || gps != null
          ? Exif({
              if (ifd0 != null) ...ifd0,
              if (exif != null) ...exif,
              if (lat != null && lng != null) ...{
                "GPSLatitude": gpsDoubleToDms(lat),
                "GPSLatitudeRef": lat.isNegative ? "S" : "N",
                "GPSLongitude": gpsDoubleToDms(lng),
                "GPSLongitudeRef": lng.isNegative ? "W" : "E",
                if (alt != null) ...{
                  "GPSAltitude": doubleToRational(alt),
                  "GPSAltitudeRef": alt.isNegative ? 1 : 0,
                }
              }
            }..removeWhere((key, value) =>
              key == "MakerNote" ||
              key == "UserComment" ||
              key == "ImageDescription"))
          : null,
      src: MetadataSrc.nextcloud,
    );
  }

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
        lastUpdated,
        fileEtag,
        imageWidth,
        imageHeight,
        // exif is handled separately, see [equals]
        src,
      ];

  final DateTime lastUpdated;

  /// Etag of the parent file when the metadata is saved
  final String? fileEtag;
  final int? imageWidth;
  final int? imageHeight;
  final Exif? exif;
  final MetadataSrc src;

  /// versioning of this class, use to upgrade old persisted metadata
  static const version = 5;

  static final _log = _$MetadataNpLog.log;
}

abstract class MetadataUpgrader {
  JsonObj? call(JsonObj json);
}

/// Upgrade v1 Metadata to v2
@npLog
class MetadataUpgraderV1 implements MetadataUpgrader {
  MetadataUpgraderV1({
    required this.fileContentType,
    this.logFilePath,
  });

  @override
  JsonObj? call(JsonObj json) {
    if (fileContentType == "image/webp") {
      // Version 1 metadata for webp is bugged, drop it
      _log.fine("[call] Upgrade v1 metadata for file: $logFilePath");
      return null;
    } else {
      return json;
    }
  }

  final String? fileContentType;

  /// File path for logging only
  final String? logFilePath;
}

/// Upgrade v2 Metadata to v3
@npLog
class MetadataUpgraderV2 implements MetadataUpgrader {
  MetadataUpgraderV2({
    required this.fileContentType,
    this.logFilePath,
  });

  @override
  JsonObj? call(JsonObj json) {
    if (fileContentType == "image/jpeg") {
      // Version 2 metadata for jpeg doesn't consider orientation
      if (json["exif"] != null && json["exif"].containsKey("Orientation")) {
        // Check orientation
        final orientation = json["exif"]["Orientation"];
        if (orientation >= 5 && orientation <= 8) {
          _log.fine("[call] Upgrade v2 metadata for file: $logFilePath");
          final temp = json["imageWidth"];
          json["imageWidth"] = json["imageHeight"];
          json["imageHeight"] = temp;
        }
      }
    }
    return json;
  }

  final String? fileContentType;

  /// File path for logging only
  final String? logFilePath;
}

/// Upgrade v3 Metadata to v4
@npLog
class MetadataUpgraderV3 implements MetadataUpgrader {
  const MetadataUpgraderV3({
    required this.fileContentType,
    this.logFilePath,
  });

  @override
  JsonObj? call(JsonObj json) {
    if (fileContentType == "image/heic") {
      // Version 3 metadata for heic may incorrectly have exif as null due to a
      // bug in exifdart
      if (json["exif"] == null) {
        _log.fine("[call] Remove v3 metadata for file: $logFilePath");
        // return null to let the app parse the file again
        return null;
      }
    }
    return json;
  }

  final String? fileContentType;

  /// File path for logging only
  final String? logFilePath;
}

/// Upgrade v4 Metadata to v5
@npLog
class MetadataUpgraderV4 implements MetadataUpgrader {
  const MetadataUpgraderV4({
    required this.fileContentType,
    this.logFilePath,
  });

  @override
  JsonObj? call(JsonObj json) {
    if (!json.containsKey("src")) {
      _log.fine("[call] Upgrade v4 metadata for file: $logFilePath");
      json["src"] = MetadataSrc.legacy.index;
    }
    return json;
  }

  final String? fileContentType;

  /// File path for logging only
  final String? logFilePath;
}

@ToString(ignoreNull: true)
class File with EquatableMixin implements FileDescriptor {
  File({
    required String path,
    this.contentLength,
    this.contentType,
    this.etag,
    this.lastModified,
    this.isCollection,
    this.usedBytes,
    this.hasPreview,
    this.fileId,
    this.isFavorite,
    this.ownerId,
    this.ownerDisplayName,
    this.metadata,
    this.isArchived,
    this.overrideDateTime,
    this.trashbinFilename,
    this.trashbinOriginalLocation,
    this.trashbinDeletionTime,
    this.location,
  }) : path = path.trimAny("/");

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => equals(other, isDeep: true);

  bool equals(Object? other, {bool isDeep = false}) {
    if (other is File) {
      return super == other &&
          (metadata == null) == (other.metadata == null) &&
          (metadata?.equals(other.metadata, isDeep: isDeep) ?? true);
    } else {
      return false;
    }
  }

  factory File.fromJson(JsonObj json) {
    return File(
      path: json["path"],
      contentLength: json["contentLength"],
      contentType: json["contentType"],
      etag: json["etag"],
      lastModified: json["lastModified"] == null
          ? null
          : DateTime.parse(json["lastModified"]),
      isCollection: json["isCollection"],
      usedBytes: json["usedBytes"],
      hasPreview: json["hasPreview"],
      fileId: json["fileId"],
      isFavorite: json_util.boolFromJson(json["isFavorite"]),
      ownerId: json["ownerId"] == null ? null : CiString(json["ownerId"]),
      ownerDisplayName: json["ownerDisplayName"],
      trashbinFilename: json["trashbinFilename"],
      trashbinOriginalLocation: json["trashbinOriginalLocation"],
      trashbinDeletionTime: json["trashbinDeletionTime"] == null
          ? null
          : DateTime.parse(json["trashbinDeletionTime"]),
      metadata: json["metadata"] == null
          ? null
          : Metadata.fromJson(
              json["metadata"].cast<String, dynamic>(),
              upgraderV1: MetadataUpgraderV1(
                fileContentType: json["contentType"],
                logFilePath: json["path"],
              ),
              upgraderV2: MetadataUpgraderV2(
                fileContentType: json["contentType"],
                logFilePath: json["path"],
              ),
              upgraderV3: MetadataUpgraderV3(
                fileContentType: json["contentType"],
                logFilePath: json["path"],
              ),
              upgraderV4: MetadataUpgraderV4(
                fileContentType: json["contentType"],
                logFilePath: json["path"],
              ),
            ),
      isArchived: json["isArchived"],
      overrideDateTime: json["overrideDateTime"] == null
          ? null
          : DateTime.parse(json["overrideDateTime"]),
      location: json["location"] == null
          ? null
          : ImageLocation.fromJson(json["location"]),
    );
  }

  @override
  String toString() => _$toString();

  JsonObj toJson() {
    return {
      "path": path,
      if (contentLength != null) "contentLength": contentLength,
      if (contentType != null) "contentType": contentType,
      if (etag != null) "etag": etag,
      if (lastModified != null)
        "lastModified": lastModified!.toUtc().toIso8601String(),
      if (isCollection != null) "isCollection": isCollection,
      if (usedBytes != null) "usedBytes": usedBytes,
      if (hasPreview != null) "hasPreview": hasPreview,
      if (fileId != null) "fileId": fileId,
      if (isFavorite != null) "isFavorite": json_util.boolToJson(isFavorite),
      if (ownerId != null) "ownerId": ownerId.toString(),
      if (ownerDisplayName != null) "ownerDisplayName": ownerDisplayName,
      if (trashbinFilename != null) "trashbinFilename": trashbinFilename,
      if (trashbinOriginalLocation != null)
        "trashbinOriginalLocation": trashbinOriginalLocation,
      if (trashbinDeletionTime != null)
        "trashbinDeletionTime": trashbinDeletionTime!.toUtc().toIso8601String(),
      if (metadata != null) "metadata": metadata!.toJson(),
      if (isArchived != null) "isArchived": isArchived,
      if (overrideDateTime != null)
        "overrideDateTime": overrideDateTime!.toUtc().toIso8601String(),
      if (location != null) "location": location!.toJson(),
    };
  }

  @override
  JsonObj toFdJson() => FileDescriptor.toJson(this);

  File copyWith({
    String? path,
    int? contentLength,
    String? contentType,
    OrNull<String>? etag,
    DateTime? lastModified,
    bool? isCollection,
    int? usedBytes,
    bool? hasPreview,
    int? fileId,
    bool? isFavorite,
    CiString? ownerId,
    String? ownerDisplayName,
    String? trashbinFilename,
    String? trashbinOriginalLocation,
    DateTime? trashbinDeletionTime,
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    OrNull<ImageLocation>? location,
  }) {
    return File(
      path: path ?? this.path,
      contentLength: contentLength ?? this.contentLength,
      contentType: contentType ?? this.contentType,
      etag: etag == null ? this.etag : etag.obj,
      lastModified: lastModified ?? this.lastModified,
      isCollection: isCollection ?? this.isCollection,
      usedBytes: usedBytes ?? this.usedBytes,
      hasPreview: hasPreview ?? this.hasPreview,
      fileId: fileId ?? this.fileId,
      isFavorite: isFavorite ?? this.isFavorite,
      ownerId: ownerId ?? this.ownerId,
      ownerDisplayName: ownerDisplayName ?? this.ownerDisplayName,
      trashbinFilename: trashbinFilename ?? this.trashbinFilename,
      trashbinOriginalLocation:
          trashbinOriginalLocation ?? this.trashbinOriginalLocation,
      trashbinDeletionTime: trashbinDeletionTime ?? this.trashbinDeletionTime,
      metadata: metadata == null ? this.metadata : metadata.obj,
      isArchived: isArchived == null ? this.isArchived : isArchived.obj,
      overrideDateTime: overrideDateTime == null
          ? this.overrideDateTime
          : overrideDateTime.obj,
      location: location == null ? this.location : location.obj,
    );
  }

  @override
  get props => [
        path,
        contentLength,
        contentType,
        etag,
        lastModified,
        isCollection,
        usedBytes,
        hasPreview,
        fileId,
        isFavorite,
        ownerId,
        ownerDisplayName,
        trashbinFilename,
        trashbinOriginalLocation,
        trashbinDeletionTime,
        // metadata is handled separately, see [equals]
        isArchived,
        overrideDateTime,
        location,
      ];

  @override
  get fdPath => path;

  @override
  get fdId => fileId!;

  @override
  get fdMime => contentType;

  @override
  get fdIsArchived => isArchived ?? false;

  @override
  get fdIsFavorite => isFavorite ?? false;

  @override
  get fdDateTime => bestDateTime;

  final String path;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? isCollection;
  final int? usedBytes;
  final bool? hasPreview;
  final int? fileId;
  final bool? isFavorite;
  final CiString? ownerId;
  final String? ownerDisplayName;
  final String? trashbinFilename;
  final String? trashbinOriginalLocation;
  final DateTime? trashbinDeletionTime;
  // metadata
  final Metadata? metadata;
  final bool? isArchived;
  final DateTime? overrideDateTime;
  final ImageLocation? location;
}

extension FileExtension on File {
  DateTime get bestDateTime => file_util.getBestDateTime(
        overrideDateTime: overrideDateTime,
        dateTimeOriginal: metadata?.exif?.dateTimeOriginal,
        lastModified: lastModified,
      );

  bool isOwned(CiString userId) => ownerId == null || ownerId == userId;

  FileDescriptor toDescriptor() => FileDescriptor(
        fdPath: path,
        fdId: fileId!,
        fdMime: contentType,
        fdIsArchived: isArchived ?? false,
        fdIsFavorite: isFavorite ?? false,
        fdDateTime: bestDateTime,
      );
}

class FileServerIdentityComparator {
  const FileServerIdentityComparator(this.file);

  @override
  operator ==(Object other) {
    if (other is FileServerIdentityComparator) {
      return file.compareServerIdentity(other.file);
    } else if (other is File) {
      return file.compareServerIdentity(other);
    } else {
      return false;
    }
  }

  @override
  get hashCode => file.fileId?.hashCode ?? file.path.hashCode;

  final File file;
}

class FileRepo {
  const FileRepo(this.dataSrc);

  /// See [FileDataSource.list]
  Future<List<File>> list(Account account, File root) =>
      dataSrc.list(account, root);

  /// See [FileDataSource.listSingle]
  Future<File> listSingle(Account account, File root) =>
      dataSrc.listSingle(account, root);

  /// See [FileDataSource.listMinimal]
  Future<List<File>> listMinimal(Account account, File dir) =>
      dataSrc.listMinimal(account, dir);

  /// See [FileDataSource.remove]
  Future<void> remove(Account account, FileDescriptor file) =>
      dataSrc.remove(account, file);

  /// See [FileDataSource.getBinary]
  Future<Uint8List> getBinary(Account account, File file) =>
      dataSrc.getBinary(account, file);

  /// See [FileDataSource.putBinary]
  Future<void> putBinary(Account account, String path, Uint8List content) =>
      dataSrc.putBinary(account, path, content);

  /// See [FileDataSource.updateMetadata]
  Future<void> updateProperty(
    Account account,
    File file, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) =>
      dataSrc.updateProperty(
        account,
        file,
        metadata: metadata,
        isArchived: isArchived,
        overrideDateTime: overrideDateTime,
        favorite: favorite,
        location: location,
      );

  /// See [FileDataSource.copy]
  Future<void> copy(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  }) =>
      dataSrc.copy(
        account,
        f,
        destination,
        shouldOverwrite: shouldOverwrite,
      );

  /// See [FileDataSource.move]
  Future<void> move(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  }) =>
      dataSrc.move(
        account,
        f,
        destination,
        shouldOverwrite: shouldOverwrite,
      );

  /// See [FileDataSource.createDir]
  Future<void> createDir(Account account, String path) =>
      dataSrc.createDir(account, path);

  final FileDataSource dataSrc;
}

abstract class FileDataSource {
  /// List all files under [dir]
  Future<List<File>> list(Account account, File dir);

  /// List a single file [f]
  Future<File> listSingle(Account account, File f);

  /// List all files under [dir] with minimal data
  ///
  /// Only the following file data is guaranteed to be returned:
  /// - path
  /// - contentType
  /// - lastModified
  /// - isCollection
  /// - fileId
  Future<List<File>> listMinimal(Account account, File dir);

  /// Remove file
  Future<void> remove(Account account, FileDescriptor f);

  /// Read file as binary array
  Future<Uint8List> getBinary(Account account, File f);

  /// Upload content to [path]
  Future<void> putBinary(Account account, String path, Uint8List content);

  /// Update one or more properties of a file
  Future<void> updateProperty(
    Account account,
    File f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  });

  /// Copy [f] to [destination]
  ///
  /// [destination] should be a relative WebDAV path like
  /// remote.php/dav/files/admin/new/location
  Future<void> copy(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  });

  /// Move [f] to [destination]
  ///
  /// [destination] should be a relative WebDAV path like
  /// remote.php/dav/files/admin/new/location
  Future<void> move(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  });

  /// Create a directory at [path]
  ///
  /// [path] should be a relative WebDAV path like
  /// remote.php/dav/files/admin/new/dir
  Future<void> createDir(Account account, String path);
}
