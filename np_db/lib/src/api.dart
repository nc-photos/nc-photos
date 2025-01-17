import 'dart:io' as io;

import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/src/entity.dart';
import 'package:np_db_sqlite/np_db_sqlite.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'api.g.dart';

typedef NpDbComputeCallback<T, U> = Future<U> Function(NpDb db, T message);

/// A data structure that identify a File in db
@ToString(ignoreNull: true)
class DbFileKey {
  const DbFileKey({
    this.fileId,
    this.relativePath,
  }) : assert(fileId != null || relativePath != null);

  const DbFileKey.byId(int fileId) : this(fileId: fileId);

  const DbFileKey.byPath(String relativePath)
      : this(relativePath: relativePath);

  @override
  String toString() => _$toString();

  bool compareIdentity(DbFileKey other) =>
      fileId == other.fileId || relativePath == other.relativePath;

  final int? fileId;
  final String? relativePath;
}

class DbSyncResult {
  const DbSyncResult({
    required this.insert,
    required this.delete,
    required this.update,
  });

  final int insert;
  final int delete;
  final int update;
}

/// Sync results with ids
///
/// The meaning of the ids returned depends on the specific call
@toString
class DbSyncIdResult {
  const DbSyncIdResult({
    required this.insert,
    required this.delete,
    required this.update,
  });

  factory DbSyncIdResult.fromJson(JsonObj json) => DbSyncIdResult(
        insert: (json["insert"] as List).cast<int>(),
        delete: (json["delete"] as List).cast<int>(),
        update: (json["update"] as List).cast<int>(),
      );

  JsonObj toJson() => {
        "insert": insert,
        "delete": delete,
        "update": update,
      };

  bool get isEmpty => insert.isEmpty && delete.isEmpty && update.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => _$toString();

  final List<int> insert;
  final List<int> delete;
  final List<int> update;
}

@toString
class DbLocationGroup with EquatableMixin {
  const DbLocationGroup({
    required this.place,
    required this.countryCode,
    required this.count,
    required this.latestFileId,
    required this.latestDateTime,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
        place,
        countryCode,
        count,
        latestFileId,
        latestDateTime,
      ];

  final String place;
  final String countryCode;
  final int count;
  final int latestFileId;
  final DateTime latestDateTime;
}

@toString
class DbLocationGroupResult {
  const DbLocationGroupResult({
    required this.name,
    required this.admin1,
    required this.admin2,
    required this.countryCode,
  });

  @override
  String toString() => _$toString();

  final List<DbLocationGroup> name;
  final List<DbLocationGroup> admin1;
  final List<DbLocationGroup> admin2;
  final List<DbLocationGroup> countryCode;
}

@toString
class DbImageLatLng with EquatableMixin {
  const DbImageLatLng({
    required this.lat,
    required this.lng,
    required this.fileId,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
        lat,
        lng,
        fileId,
      ];

  final double lat;
  final double lng;
  final int fileId;
}

@genCopyWith
@toString
class DbFilesSummaryItem with EquatableMixin {
  const DbFilesSummaryItem({
    required this.count,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
        count,
      ];

  final int count;
}

@genCopyWith
@toString
class DbFilesSummary {
  const DbFilesSummary({
    required this.items,
  });

  @override
  String toString() => _$toString();

  // sorted by date in descending order
  @Format(r"{length: ${$?.length}}")
  final Map<Date, DbFilesSummaryItem> items;
}

@genCopyWith
@toString
class DbFilesMemory {
  const DbFilesMemory({
    required this.memories,
  });

  @override
  String toString() => _$toString();

  /// Mapping year to files
  final Map<int, List<DbFileDescriptor>> memories;
}

@genCopyWith
@toString
class DbFileMissingMetadataResult {
  const DbFileMissingMetadataResult({
    required this.items,
  });

  @override
  String toString() => _$toString();

  final List<({int fileId, String relativePath})> items;
}

@npLog
abstract class NpDb {
  factory NpDb() => NpDbSqlite();

  /// Initialize the db for the main isolate
  ///
  /// If running on android, you must pass the current SDK int to [androidSdk].
  /// If running on other platforms, this value will be ignored, you can pass
  /// null in such case
  Future<void> initMainIsolate({
    required int? androidSdk,
  });

  /// Initialize the db for a background isolate
  ///
  /// If running on android, you must pass the current SDK int to [androidSdk].
  /// If running on other platforms, this value will be ignored, you can pass
  /// null in such case
  Future<void> initBackgroundIsolate({
    required int? androidSdk,
  });

  /// Dispose the db
  ///
  /// After disposing, you must not call any methods defined here anymore. This
  /// is typically used before stopping a background isolate
  Future<void> dispose();

  Future<io.File> export(io.Directory dir);

  /// Start an isolate with a [NpDb] instance provided to you
  Future<U> compute<T, U>(NpDbComputeCallback<T, U> callback, T args);

  /// Insert [accounts] to db
  Future<void> addAccounts(List<DbAccount> accounts);

  /// Clear all data in the database and insert [accounts]
  ///
  /// WARNING: ALL data will be dropped!
  Future<void> clearAndInitWithAccounts(List<DbAccount> accounts);

  Future<void> deleteAccount(DbAccount account);

  Future<List<DbAlbum>> getAlbumsByAlbumFileIds({
    required DbAccount account,
    required List<int> fileIds,
  });

  Future<void> syncAlbum({
    required DbAccount account,
    required DbFile albumFile,
    required DbAlbum album,
  });

  /// Return all faces provided by the Face Recognition app
  Future<List<DbFaceRecognitionPerson>> getFaceRecognitionPersons({
    required DbAccount account,
  });

  /// Return faces provided by the Face Recognition app with loosely matched
  /// [name]
  Future<List<DbFaceRecognitionPerson>> searchFaceRecognitionPersonsByName({
    required DbAccount account,
    required String name,
  });

  /// Replace all recognized people for [account]
  Future<DbSyncResult> syncFaceRecognitionPersons({
    required DbAccount account,
    required List<DbFaceRecognitionPerson> persons,
  });

  /// Return files located inside [dir]
  Future<List<DbFile>> getFilesByDirKey({
    required DbAccount account,
    required DbFileKey dir,
  });

  Future<List<DbFile>> getFilesByDirKeyAndLocation({
    required DbAccount account,
    required String dirRelativePath,
    required String? place,
    required String countryCode,
  });

  /// Return [DbFile]s by their corresponding file ids
  ///
  /// No error will be thrown even if a file in [fileIds] is not found, it is
  /// thus the responsibility of the caller to decide how to handle such case.
  /// Returned files are NOT guaranteed to be sorted as [fileIds]
  Future<List<DbFile>> getFilesByFileIds({
    required DbAccount account,
    required Iterable<int> fileIds,
  });

  /// Return [DbFile]s by their date time value
  Future<List<DbFile>> getFilesByTimeRange({
    required DbAccount account,
    required List<String> dirRoots,
    required TimeRange range,
  });

  /// Update one or more file properties of a single file
  Future<void> updateFileByFileId({
    required DbAccount account,
    required int fileId,
    String? relativePath,
    OrNull<bool>? isFavorite,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    DateTime? bestDateTime,
    OrNull<DbImageData>? imageData,
    OrNull<DbLocation>? location,
  });

  /// Batch update one or more file properties of multiple files
  ///
  /// Only a subset of properties can be updated in batch
  Future<void> updateFilesByFileIds({
    required DbAccount account,
    required List<int> fileIds,
    OrNull<bool>? isFavorite,
    OrNull<bool>? isArchived,
  });

  /// Add or replace files in db
  Future<void> syncDirFiles({
    required DbAccount account,
    required DbFileKey dirFile,
    required List<DbFile> files,
  });

  /// Replace a file in db
  Future<void> syncFile({
    required DbAccount account,
    required DbFile file,
  });

  /// Add or replace nc albums in db
  ///
  /// Return fileIds affected by this call
  Future<DbSyncIdResult> syncFavoriteFiles({
    required DbAccount account,
    required List<int> favoriteFileIds,
  });

  /// Return number of files without metadata
  Future<int> countFilesByMissingMetadata({
    required DbAccount account,
    required List<String> mimes,
    required String ownerId,
  });

  /// Return files without metadata
  Future<DbFileMissingMetadataResult> getFilesByMissingMetadata({
    required DbAccount account,
    required List<String> mimes,
    required String ownerId,
  });

  /// Delete a file or dir from db
  Future<void> deleteFile({
    required DbAccount account,
    required DbFileKey file,
  });

  /// Return a map of file id to etags for all dirs and sub dirs located under
  /// [relativePath], including the path itself
  Future<Map<int, String>> getDirFileIdToEtagByLikeRelativePath({
    required DbAccount account,
    required String relativePath,
  });

  /// Remove all children of a dir
  Future<void> truncateDir({
    required DbAccount account,
    required DbFileKey dir,
  });

  /// Return [DbFileDescriptor]s
  ///
  /// Limit results by their corresponding file ids if [fileIds] is not null. No
  /// error will be thrown even if a file in [fileIds] is not found, it is thus
  /// the responsibility of the caller to decide how to handle such case
  ///
  /// [includeRelativeRoots] define paths to be included; [excludeRelativeRoots]
  /// define paths to be excluded. Paths in both lists are matched as prefix
  ///
  /// Limit type of files to be returned by specifying [mimes]. The mime types
  /// are matched as is
  ///
  /// Returned files are sorted by [DbFileDescriptor.bestDateTime] in descending
  /// order
  Future<List<DbFileDescriptor>> getFileDescriptors({
    required DbAccount account,
    List<int>? fileIds,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    List<String>? relativePathKeywords,
    String? location,
    bool? isFavorite,
    bool? isArchived,
    List<String>? mimes,
    TimeRange? timeRange,
    int? offset,
    int? limit,
  });

  /// Summarize files matching some specific requirements
  ///
  /// See [getFileDescriptors]
  ///
  /// Returned data are sorted by [DbFileDescriptor.bestDateTime] in descending
  /// order
  Future<DbFilesSummary> getFilesSummary({
    required DbAccount account,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  });

  /// Return [DbFileDescriptor]s whose date is lying in a specific month and day
  /// range
  Future<DbFilesMemory> getFilesMemories({
    required DbAccount account,
    required Date at,
    required int radius,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  });

  Future<DbLocationGroupResult> groupLocations({
    required DbAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  });

  /// Return the location data of the first file (sorted by date time in
  /// descending order) in a group of files
  Future<DbLocation?> getFirstLocationOfFileIds({
    required DbAccount account,
    required List<int> fileIds,
  });

  /// Return the latitude, longitude and the file id of all files
  Future<List<DbImageLatLng>> getImageLatLngWithFileIds({
    required DbAccount account,
    TimeRange? timeRange,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  });

  Future<List<DbNcAlbum>> getNcAlbums({
    required DbAccount account,
  });

  Future<void> addNcAlbum({
    required DbAccount account,
    required DbNcAlbum album,
  });

  Future<void> deleteNcAlbum({
    required DbAccount account,
    required DbNcAlbum album,
  });

  /// Add or replace nc albums in db
  Future<DbSyncResult> syncNcAlbums({
    required DbAccount account,
    required List<DbNcAlbum> albums,
  });

  Future<List<DbNcAlbumItem>> getNcAlbumItemsByParent({
    required DbAccount account,
    required DbNcAlbum parent,
  });

  /// Add or replace nc album items in db
  Future<DbSyncResult> syncNcAlbumItems({
    required DbAccount account,
    required DbNcAlbum album,
    required List<DbNcAlbumItem> items,
  });

  /// Return all faces provided by the Recognize app
  Future<List<DbRecognizeFace>> getRecognizeFaces({
    required DbAccount account,
  });

  Future<List<DbRecognizeFaceItem>> getRecognizeFaceItemsByFaceLabel({
    required DbAccount account,
    required String label,
  });

  Future<Map<String, List<DbRecognizeFaceItem>>>
      getRecognizeFaceItemsByFaceLabels({
    required DbAccount account,
    required List<String> labels,
    ErrorWithValueHandler<String>? onError,
  });

  Future<Map<String, DbRecognizeFaceItem>>
      getLatestRecognizeFaceItemsByFaceLabels({
    required DbAccount account,
    required List<String> labels,
    ErrorWithValueHandler<String>? onError,
  });

  /// Replace all recognized faces for [account]
  ///
  /// Return true if any of the faces or items are changed
  Future<bool> syncRecognizeFacesAndItems({
    required DbAccount account,
    required Map<DbRecognizeFace, List<DbRecognizeFaceItem>> data,
  });

  /// Return all tags
  Future<List<DbTag>> getTags({
    required DbAccount account,
  });

  /// Return the tag matching [displayName]
  Future<DbTag?> getTagByDisplayName({
    required DbAccount account,
    required String displayName,
  });

  /// Replace all tags for [account]
  Future<DbSyncIdResult> syncTags({
    required DbAccount account,
    required List<DbTag> tags,
  });

  /// Migrate to app v55
  Future<void> migrateV55(void Function(int current, int count)? onProgress);

  /// Run vacuum statement on a database backed by sqlite
  ///
  /// This method is not necessarily supported by all implementations
  Future<void> sqlVacuum();
}
