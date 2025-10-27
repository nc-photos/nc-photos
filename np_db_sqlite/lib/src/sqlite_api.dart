import 'dart:io' as io;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_async/np_async.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/src/converter.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/database_extension.dart';
import 'package:np_db_sqlite/src/isolate_util.dart';
import 'package:np_db_sqlite/src/table.dart';
import 'package:np_db_sqlite/src/util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'sqlite_api.g.dart';

@npLog
class NpDbSqlite implements NpDb {
  NpDbSqlite();

  @override
  Future<void> initMainIsolate({required int? androidSdk}) async {
    initDrift();
    if (getRawPlatform() == NpPlatform.android && androidSdk! < 24) {
      _log.info("[initMainIsolate] Workaround Android 6- bug");
      // see: https://github.com/flutter/flutter/issues/73318 and
      // https://github.com/simolus3/drift/issues/895
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // use driftIsolate to prevent DB blocking the UI thread
    if (getRawPlatform() == NpPlatform.web) {
      // no isolate support on web
      _db = SqliteDb();
    } else {
      _db = await createDb();
    }
  }

  @override
  Future<void> initBackgroundIsolate({required int? androidSdk}) async {
    initDrift();
    // service already runs in an isolate
    _db = SqliteDb();
  }

  @visibleForTesting
  Future<void> initWithDb({required SqliteDb db}) async {
    initDrift();
    _db = db;
  }

  @override
  Future<void> dispose() {
    return _db.close();
  }

  @override
  Future<io.File> export(io.Directory dir) => exportSqliteDb(_db, dir);

  @override
  Future<U> compute<T, U>(NpDbComputeCallback<T, U> callback, T args) {
    return _db.isolate(args, (db, message) async {
      final that = NpDbSqlite();
      await that.initWithDb(db: db);
      return callback(that, message);
    });
  }

  @override
  Future<void> addAccounts(List<DbAccount> accounts) {
    return _db.use((db) async {
      await db.insertAccounts(accounts);
    });
  }

  @override
  Future<void> clearAndInitWithAccounts(List<DbAccount> accounts) {
    return _db.use((db) async {
      await db.truncate();
      await db.insertAccounts(accounts);
    });
  }

  @override
  Future<void> deleteAccount(DbAccount account) {
    return _db.use((db) async {
      await db.deleteAccount(account);
    });
  }

  @override
  Future<List<DbAlbum>> getAlbumsByAlbumFileIds({
    required DbAccount account,
    required List<int> fileIds,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryAlbumsByAlbumFileIds(
        account: ByAccount.db(account),
        fileIds: fileIds,
      );
    });
    return sqlObjs.toDbAlbums();
  }

  @override
  Future<void> syncAlbum({
    required DbAccount account,
    required DbFile albumFile,
    required DbAlbum album,
  }) async {
    final sqlAlbum = AlbumConverter.toSql(album);
    await _db.use((db) async {
      await db.syncAlbum(
        account: ByAccount.db(account),
        albumFileEtag: albumFile.etag,
        obj: sqlAlbum,
      );
    });
  }

  @override
  Future<List<DbFaceRecognitionPerson>> getFaceRecognitionPersons({
    required DbAccount account,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryFaceRecognitionPersons(
        account: ByAccount.db(account),
      );
    });
    return sqlObjs.toDbFaceRecognitionPersons();
  }

  @override
  Future<List<DbFaceRecognitionPerson>> searchFaceRecognitionPersonsByName({
    required DbAccount account,
    required String name,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.searchFaceRecognitionPersonByName(
        account: ByAccount.db(account),
        name: name,
      );
    });
    return sqlObjs.toDbFaceRecognitionPersons();
  }

  @override
  Future<DbSyncResult> syncFaceRecognitionPersons({
    required DbAccount account,
    required List<DbFaceRecognitionPerson> persons,
  }) async {
    int sorter(DbFaceRecognitionPerson a, DbFaceRecognitionPerson b) =>
        a.name.compareTo(b.name);
    final to = persons.sorted(sorter);
    return await _db.use((db) async {
      final sqlObjs = await db.queryFaceRecognitionPersons(
        account: ByAccount.db(account),
      );
      final from = sqlObjs
          .map(FaceRecognitionPersonConverter.fromSql)
          .sorted(sorter);
      final diff = getDiffWith(from, to, sorter);
      final inserts = diff.onlyInB;
      _log.info(
        "[replaceFaceRecognitionPersons] New persons: ${inserts.toReadableString()}",
      );
      final deletes = diff.onlyInA;
      _log.info(
        "[replaceFaceRecognitionPersons] Removed persons: ${deletes.toReadableString()}",
      );
      final updates =
          to.where((t) {
            final f = from.firstWhereOrNull((e) => e.name == t.name);
            return f != null && f != t;
          }).toList();
      _log.info(
        "[replaceFaceRecognitionPersons] Updated persons: ${updates.toReadableString()}",
      );
      if (inserts.isNotEmpty || deletes.isNotEmpty || updates.isNotEmpty) {
        await db.replaceFaceRecognitionPersons(
          account: ByAccount.db(account),
          inserts: inserts,
          deletes: deletes,
          updates: updates,
        );
      }
      return DbSyncResult(
        insert: inserts.length,
        delete: deletes.length,
        update: updates.length,
      );
    });
  }

  @override
  Future<List<DbFile>> getFilesByDirKey({
    required DbAccount account,
    required DbFileKey dir,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryFilesByDirKey(
        account: ByAccount.db(account),
        dir: dir,
      );
    });
    return sqlObjs.toDbFiles();
  }

  @override
  Future<List<DbFile>> getFilesByDirKeyAndLocation({
    required DbAccount account,
    required String dirRelativePath,
    required String? place,
    required String countryCode,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryFilesByLocation(
        account: ByAccount.db(account),
        dirRelativePath: dirRelativePath,
        place: place,
        countryCode: countryCode,
      );
    });
    return sqlObjs.toDbFiles();
  }

  @override
  Future<List<DbFile>> getFilesByFileIds({
    required DbAccount account,
    required Iterable<int> fileIds,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryFilesByFileIds(
        account: ByAccount.db(account),
        fileIds: fileIds,
      );
    });
    return sqlObjs.toDbFiles();
  }

  @override
  Future<List<DbFile>> getFilesByTimeRange({
    required DbAccount account,
    required List<String> dirRoots,
    required TimeRange range,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryFilesByTimeRange(
        account: ByAccount.db(account),
        dirRoots: dirRoots,
        range: range,
      );
    });
    return sqlObjs.toDbFiles();
  }

  @override
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
  }) async {
    await _db.use((db) async {
      await db.updateFileByFileId(
        account: ByAccount.db(account),
        fileId: fileId,
        relativePath: relativePath,
        isFavorite: isFavorite,
        isArchived: isArchived,
        overrideDateTime: overrideDateTime,
        bestDateTime: bestDateTime,
        imageData: imageData,
        location: location,
      );
    });
  }

  @override
  Future<void> updateFilesByFileIds({
    required DbAccount account,
    required List<int> fileIds,
    OrNull<bool>? isFavorite,
    OrNull<bool>? isArchived,
  }) async {
    await _db.use((db) async {
      await db.updateFilesByFileIds(
        account: ByAccount.db(account),
        fileIds: fileIds,
        isFavorite: isFavorite,
        isArchived: isArchived,
      );
    });
  }

  @override
  Future<void> syncDirFiles({
    required DbAccount account,
    required DbFileKey dirFile,
    required List<DbFile> files,
  }) async {
    final sqlFiles = await files.toSql();
    await _db.use((db) async {
      await db.syncDirFiles(
        account: ByAccount.db(account),
        dirFile: dirFile,
        objs: sqlFiles,
      );
    });
  }

  @override
  Future<void> syncFile({
    required DbAccount account,
    required DbFile file,
  }) async {
    final sqlFile = FileConverter.toSql(file);
    await _db.use((db) async {
      await db.syncFile(account: ByAccount.db(account), obj: sqlFile);
    });
  }

  @override
  Future<DbSyncIdResult> syncFavoriteFiles({
    required DbAccount account,
    required List<int> favoriteFileIds,
  }) async {
    int sorter(int a, int b) => a.compareTo(b);
    final to = favoriteFileIds.sorted(sorter);
    return await _db.use((db) async {
      final sqlObjs = await db.queryFileIds(
        account: ByAccount.db(account),
        isFavorite: true,
      );
      final from = sqlObjs.map((e) => e.fileId).sorted(sorter);
      final diff = getDiffWith(from, to, sorter);
      final inserts = diff.onlyInB;
      _log.info(
        "[syncFavoriteFiles] New favorites: ${inserts.toReadableString()}",
      );
      final deletes = diff.onlyInA;
      _log.info(
        "[syncFavoriteFiles] Removed favorites: ${deletes.toReadableString()}",
      );
      if (inserts.isNotEmpty) {
        await db.updateFilesByFileIds(
          account: ByAccount.db(account),
          fileIds: inserts,
          isFavorite: const OrNull(true),
        );
      }
      if (deletes.isNotEmpty) {
        await db.updateFilesByFileIds(
          account: ByAccount.db(account),
          fileIds: deletes,
          isFavorite: const OrNull(false),
        );
      }
      return DbSyncIdResult(insert: inserts, delete: deletes, update: const []);
    });
  }

  @override
  Future<int> countFilesByMissingMetadata({
    required DbAccount account,
    required List<String> mimes,
    required String ownerId,
  }) async {
    return _db.use((db) async {
      return await db.countFiles(
        account: ByAccount.db(account),
        isMissingMetadata: true,
        mimes: mimes,
        ownerId: ownerId,
      );
    });
  }

  @override
  Future<DbFileMissingMetadataResult> getFilesByMissingMetadata({
    required DbAccount account,
    required List<String> mimes,
    required String ownerId,
  }) async {
    return _db.use((db) async {
      final results = <({int fileId, String relativePath})>[];
      var i = 0;
      while (true) {
        final sqlObjs = await db.queryFileIdPathsByMissingMetadata(
          account: ByAccount.db(account),
          isMissingMetadata: true,
          mimes: mimes,
          ownerId: ownerId,
          limit: 10000,
          offset: i,
        );
        if (sqlObjs.isEmpty) {
          break;
        }
        results.addAll(sqlObjs);
        i += 10000;
      }
      return DbFileMissingMetadataResult(items: results);
    });
  }

  @override
  Future<void> deleteFile({
    required DbAccount account,
    required DbFileKey file,
  }) async {
    await _db.use((db) async {
      return await db.deleteFile(account: ByAccount.db(account), file: file);
    });
  }

  @override
  Future<Map<int, String>> getDirFileIdToEtagByLikeRelativePath({
    required DbAccount account,
    required String relativePath,
  }) async {
    return await _db.use((db) async {
      return await db.getDirFileIdToEtagByLikeRelativePath(
        account: ByAccount.db(account),
        relativePath: relativePath,
      );
    });
  }

  @override
  Future<void> truncateDir({
    required DbAccount account,
    required DbFileKey dir,
  }) async {
    await _db.use((db) async {
      return await db.truncateDir(account: ByAccount.db(account), dir: dir);
    });
  }

  @override
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
    bool? isAscending,
    int? offset,
    int? limit,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryFileDescriptors(
        account: ByAccount.db(account),
        fileIds: fileIds,
        includeRelativeRoots: includeRelativeRoots,
        includeRelativeDirs: includeRelativeDirs,
        excludeRelativeRoots: excludeRelativeRoots,
        relativePathKeywords: relativePathKeywords,
        location: location,
        isFavorite: isFavorite,
        isArchived: isArchived,
        mimes: mimes,
        timeRange: timeRange,
        isAscending: isAscending,
        offset: offset,
        limit: limit,
      );
    });
    return sqlObjs.toDbFileDescriptors();
  }

  @override
  Future<DbFilesSummary> getFilesSummary({
    required DbAccount account,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  }) async {
    final result = await _db.use((db) async {
      return await db.countFileGroupsByDate(
        account: ByAccount.db(account),
        includeRelativeRoots: includeRelativeRoots,
        includeRelativeDirs: includeRelativeDirs,
        excludeRelativeRoots: excludeRelativeRoots,
        mimes: mimes,
        isArchived: false,
      );
    });
    return DbFilesSummary(
      items: result.dateCount.map(
        (key, value) => MapEntry(key, DbFilesSummaryItem(count: value)),
      ),
    );
  }

  @override
  Future<DbFilesMemory> getFilesMemories({
    required DbAccount account,
    required Date at,
    required int radius,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  }) async {
    final result = await _db.use((db) async {
      return await db.queryFileDescriptorMemories(
        account: ByAccount.db(account),
        at: at,
        radius: radius,
        includeRelativeRoots: includeRelativeRoots,
        excludeRelativeRoots: excludeRelativeRoots,
        mimes: mimes,
      );
    });
    final memories = <int, List<DbFileDescriptor>>{};
    for (final r in result.map(FileDescriptorConverter.fromSql)) {
      (memories[r.bestDateTime.year] ??= <DbFileDescriptor>[]).add(r);
    }
    return DbFilesMemory(memories: memories);
  }

  @override
  Future<List<({int fileId, int timestamp, String filename})>>
  getFileIdWithTimestamps({
    required DbAccount account,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    bool? isArchived,
    List<String>? mimes,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final dbObj = await _db.use((db) async {
        return await db.queryFileIds(
          account: ByAccount.db(account),
          includeRelativeRoots: includeRelativeRoots,
          includeRelativeDirs: includeRelativeDirs,
          excludeRelativeRoots: excludeRelativeRoots,
          isArchived: isArchived,
          mimes: mimes,
          requestTimestamp: true,
          requestFilename: true,
        );
      });
      return dbObj
          .map(
            (e) => (
              fileId: e.fileId,
              timestamp: e.timestamp!,
              filename: e.filename!,
            ),
          )
          .toList();
    } finally {
      _log.fine(
        "[getFileIdWithTimestamps] Elapsed: ${stopwatch.elapsedMilliseconds}ms",
      );
    }
  }

  @override
  Future<DbLocationGroupResult> groupLocations({
    required DbAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) async {
    List<ImageLocationGroup>? nameResult, admin1Result, admin2Result, ccResult;
    await _db.use((db) async {
      try {
        nameResult = await db.groupImageLocationsByName(
          account: ByAccount.db(account),
          includeRelativeRoots: includeRelativeRoots,
          excludeRelativeRoots: excludeRelativeRoots,
        );
      } catch (e, stackTrace) {
        _log.shout(
          "[groupLocation] Failed while groupImageLocationsByName",
          e,
          stackTrace,
        );
      }
      try {
        admin1Result = await db.groupImageLocationsByAdmin1(
          account: ByAccount.db(account),
          includeRelativeRoots: includeRelativeRoots,
          excludeRelativeRoots: excludeRelativeRoots,
        );
      } catch (e, stackTrace) {
        _log.shout(
          "[groupLocation] Failed while groupImageLocationsByAdmin1",
          e,
          stackTrace,
        );
      }
      try {
        admin2Result = await db.groupImageLocationsByAdmin2(
          account: ByAccount.db(account),
          includeRelativeRoots: includeRelativeRoots,
          excludeRelativeRoots: excludeRelativeRoots,
        );
      } catch (e, stackTrace) {
        _log.shout(
          "[groupLocation] Failed while groupImageLocationsByAdmin2",
          e,
          stackTrace,
        );
      }
      try {
        ccResult = await db.groupImageLocationsByCountryCode(
          account: ByAccount.db(account),
          includeRelativeRoots: includeRelativeRoots,
          excludeRelativeRoots: excludeRelativeRoots,
        );
      } catch (e, stackTrace) {
        _log.shout(
          "[groupLocation] Failed while groupImageLocationsByCountryCode",
          e,
          stackTrace,
        );
      }
    });
    return DbLocationGroupResult(
      name: nameResult?.toDbLocationGroups() ?? [],
      admin1: admin1Result?.toDbLocationGroups() ?? [],
      admin2: admin2Result?.toDbLocationGroups() ?? [],
      countryCode: ccResult?.toDbLocationGroups() ?? [],
    );
  }

  @override
  Future<DbLocation?> getFirstLocationOfFileIds({
    required DbAccount account,
    required List<int> fileIds,
  }) async {
    final sqlObj = await _db.use((db) async {
      return await db.queryFirstImageLocationByFileIds(
        account: ByAccount.db(account),
        fileIds: fileIds,
      );
    });
    return sqlObj?.let(ImageLocationConverter.fromSql);
  }

  @override
  Future<List<DbImageLatLng>> getImageLatLngWithFileIds({
    required DbAccount account,
    TimeRange? timeRange,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryImageLatLngWithFileIds(
        account: ByAccount.db(account),
        timeRange: timeRange,
        includeRelativeRoots: includeRelativeRoots,
        excludeRelativeRoots: excludeRelativeRoots,
        mimes: mimes,
      );
    });
    return sqlObjs.computeAll(
      (e) => DbImageLatLng(
        lat: e.lat,
        lng: e.lng,
        fileId: e.fileId,
        fileRelativePath: e.fileRelativePath,
        mime: e.mime,
      ),
    );
  }

  @override
  Future<List<DbNcAlbum>> getNcAlbums({required DbAccount account}) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryNcAlbums(account: ByAccount.db(account));
    });
    return sqlObjs.toDbNcAlbums();
  }

  @override
  Future<void> addNcAlbum({
    required DbAccount account,
    required DbNcAlbum album,
  }) async {
    await _db.use((db) async {
      await db.insertNcAlbum(account: account, album: album);
    });
  }

  @override
  Future<void> deleteNcAlbum({
    required DbAccount account,
    required DbNcAlbum album,
  }) async {
    await _db.use((db) async {
      await db.deleteNcAlbum(account: account, album: album);
    });
  }

  @override
  Future<DbSyncResult> syncNcAlbums({
    required DbAccount account,
    required List<DbNcAlbum> albums,
  }) async {
    int sorter(DbNcAlbum a, DbNcAlbum b) =>
        a.relativePath.compareTo(b.relativePath);
    final to = albums.sorted(sorter);
    return await _db.use((db) async {
      final sqlObjs = await db.queryNcAlbums(account: ByAccount.db(account));
      final from = sqlObjs.map(NcAlbumConverter.fromSql).sorted(sorter);
      final diff = getDiffWith(from, to, sorter);
      final inserts = diff.onlyInB;
      _log.info("[syncNcAlbums] New nc albums: ${inserts.toReadableString()}");
      final deletes = diff.onlyInA;
      _log.info(
        "[syncNcAlbums] Removed nc albums: ${deletes.toReadableString()}",
      );
      final updates =
          to.where((t) {
            final f = from.firstWhereOrNull(
              (e) => e.relativePath == t.relativePath,
            );
            return f != null && f != t;
          }).toList();
      _log.info(
        "[syncNcAlbums] Updated nc albums: ${updates.toReadableString()}",
      );
      if (inserts.isNotEmpty || deletes.isNotEmpty || updates.isNotEmpty) {
        await db.replaceNcAlbums(
          account: ByAccount.db(account),
          inserts: inserts,
          deletes: deletes,
          updates: updates,
        );
      }
      return DbSyncResult(
        insert: inserts.length,
        delete: deletes.length,
        update: updates.length,
      );
    });
  }

  @override
  Future<List<DbNcAlbumItem>> getNcAlbumItemsByParent({
    required DbAccount account,
    required DbNcAlbum parent,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryNcAlbumItemsByParentRelativePath(
        account: ByAccount.db(account),
        parentRelativePath: parent.relativePath,
      );
    });
    return sqlObjs.toDbNcAlbumItems();
  }

  @override
  Future<DbSyncResult> syncNcAlbumItems({
    required DbAccount account,
    required DbNcAlbum album,
    required List<DbNcAlbumItem> items,
  }) async {
    int sorter(DbNcAlbumItem a, DbNcAlbumItem b) =>
        a.fileId.compareTo(b.fileId);
    final to = items.sorted(sorter);
    return await _db.use((db) async {
      final sqlObjs = await db.queryNcAlbumItemsByParentRelativePath(
        account: ByAccount.db(account),
        parentRelativePath: album.relativePath,
      );
      final int parentRowId;
      if (sqlObjs.isNotEmpty) {
        parentRowId = sqlObjs.first.parent;
      } else {
        final parent = await db.queryNcAlbumByRelativePath(
          account: ByAccount.db(account),
          relativePath: album.relativePath,
        );
        parentRowId = parent!.rowId;
      }

      final from = sqlObjs.map(NcAlbumItemConverter.fromSql).sorted(sorter);
      final diff = getDiffWith(from, to, sorter);
      final inserts = diff.onlyInB;
      _log.info(
        "[syncNcAlbumItems] New nc album items: ${inserts.toReadableString()}",
      );
      final deletes = diff.onlyInA;
      _log.info(
        "[syncNcAlbumItems] Removed nc album items: ${deletes.toReadableString()}",
      );
      final updates =
          to.where((t) {
            final f = from.firstWhereOrNull((e) => e.fileId == t.fileId);
            return f != null && f != t;
          }).toList();
      _log.info(
        "[syncNcAlbumItems] Updated nc album items: ${updates.toReadableString()}",
      );
      if (inserts.isNotEmpty || deletes.isNotEmpty || updates.isNotEmpty) {
        await db.replaceNcAlbumItems(
          parentRowId: parentRowId,
          inserts: inserts,
          deletes: deletes,
          updates: updates,
        );
      }
      return DbSyncResult(
        insert: inserts.length,
        delete: deletes.length,
        update: updates.length,
      );
    });
  }

  @override
  Future<List<DbRecognizeFace>> getRecognizeFaces({
    required DbAccount account,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryRecognizeFaces(account: ByAccount.db(account));
    });
    return sqlObjs.toDbRecognizeFaces();
  }

  @override
  Future<List<DbRecognizeFaceItem>> getRecognizeFaceItemsByFaceLabel({
    required DbAccount account,
    required String label,
  }) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryRecognizeFaceItemsByFaceLabel(
        account: ByAccount.db(account),
        label: label,
      );
    });
    return sqlObjs.toDbRecognizeFaceItems();
  }

  @override
  Future<Map<String, List<DbRecognizeFaceItem>>>
  getRecognizeFaceItemsByFaceLabels({
    required DbAccount account,
    required List<String> labels,
    ErrorWithValueHandler<String>? onError,
  }) async {
    final results = <String, List<RecognizeFaceItem>>{};
    await _db.use((db) async {
      for (final l in labels) {
        try {
          results[l] = await db.queryRecognizeFaceItemsByFaceLabel(
            account: ByAccount.db(account),
            label: l,
          );
        } catch (e, stackTrace) {
          onError?.call(l, e, stackTrace);
        }
      }
    });
    return results.asyncMap(
      (key, value) =>
          value.toDbRecognizeFaceItems().then((v) => MapEntry(key, v)),
    );
  }

  @override
  Future<Map<String, DbRecognizeFaceItem>>
  getLatestRecognizeFaceItemsByFaceLabels({
    required DbAccount account,
    required List<String> labels,
    ErrorWithValueHandler<String>? onError,
  }) async {
    final results = <String, List<RecognizeFaceItem>>{};
    await _db.use((db) async {
      for (final l in labels) {
        try {
          results[l] = await db.queryRecognizeFaceItemsByFaceLabel(
            account: ByAccount.db(account),
            label: l,
            orderBy: [RecognizeFaceItemSort.fileIdDesc],
            limit: 1,
          );
        } catch (e, stackTrace) {
          onError?.call(l, e, stackTrace);
        }
      }
    });
    return results.asyncMap(
      (key, value) =>
          value.toDbRecognizeFaceItems().then((v) => MapEntry(key, v.first)),
    );
  }

  @override
  Future<bool> syncRecognizeFacesAndItems({
    required DbAccount account,
    required Map<DbRecognizeFace, List<DbRecognizeFaceItem>> data,
  }) async {
    int sorter(DbRecognizeFace a, DbRecognizeFace b) =>
        a.label.compareTo(b.label);
    int itemSorter(DbRecognizeFaceItem a, DbRecognizeFaceItem b) =>
        a.fileId.compareTo(b.fileId);
    final faces = data.keys;
    final to = faces.sorted(sorter);
    final toItems = data.map(
      (key, value) => MapEntry(key, value.sorted(itemSorter)),
    );
    return await _db.use((db) async {
      var result = false;
      final sqlAccount = await db.accountOf(ByAccount.db(account));
      final sqlObjs = await db.queryRecognizeFaces(
        account: ByAccount.sql(sqlAccount),
      );
      final from = sqlObjs.map(RecognizeFaceConverter.fromSql).sorted(sorter);
      final diff = getDiffWith(from, to, sorter);
      final inserts = diff.onlyInB;
      _log.info(
        "[syncRecognizeFacesAndItems] New faces: ${inserts.toReadableString()}",
      );
      final deletes = diff.onlyInA;
      _log.info(
        "[syncRecognizeFacesAndItems] Removed faces: ${deletes.toReadableString()}",
      );
      final updates =
          to.where((t) {
            final f = from.firstWhereOrNull((e) => e.label == t.label);
            return f != null && f != t;
          }).toList();
      _log.info(
        "[syncRecognizeFacesAndItems] Updated faces: ${updates.toReadableString()}",
      );
      if (inserts.isNotEmpty || deletes.isNotEmpty || updates.isNotEmpty) {
        await db.replaceRecognizeFaces(
          account: ByAccount.sql(sqlAccount),
          inserts: inserts,
          deletes: deletes,
          updates: updates,
        );
        result = true;
      }
      sqlObjs.addAll(
        await db.queryRecognizeFaces(
          account: ByAccount.sql(sqlAccount),
          labels: inserts.map((e) => e.label).toList(),
        ),
      );

      for (final d in data.entries) {
        try {
          result |= await _replaceRecognizeFaceItems(
            db,
            sqlAccount: sqlAccount,
            face: sqlObjs.firstWhere((e) => e.label == d.key.label),
            items: toItems[d.key]!,
            sorter: itemSorter,
          );
        } catch (e, stackTrace) {
          _log.shout(
            "[syncRecognizeFacesAndItems] Failed to replace items for face: ${d.key}",
            e,
            stackTrace,
          );
        }
      }
      return result;
    });
  }

  @override
  Future<List<DbTag>> getTags({required DbAccount account}) async {
    final sqlObjs = await _db.use((db) async {
      return await db.queryTags(account: ByAccount.db(account));
    });
    return sqlObjs.toDbTags();
  }

  @override
  Future<DbTag?> getTagByDisplayName({
    required DbAccount account,
    required String displayName,
  }) async {
    final sqlObj = await _db.use((db) async {
      return await db.queryTagByDisplayName(
        account: ByAccount.db(account),
        displayName: displayName,
      );
    });
    return sqlObj?.let(TagConverter.fromSql);
  }

  @override
  Future<DbSyncIdResult> syncTags({
    required DbAccount account,
    required List<DbTag> tags,
  }) async {
    int sorter(DbTag a, DbTag b) => a.id.compareTo(b.id);
    final to = tags.sorted(sorter);
    return await _db.use((db) async {
      final sqlObjs = await db.queryTags(account: ByAccount.db(account));
      final from = sqlObjs.map(TagConverter.fromSql).sorted(sorter);
      final diff = getDiffWith(from, to, sorter);
      final inserts = diff.onlyInB;
      _log.info("[syncTags] New tags: ${inserts.toReadableString()}");
      final deletes = diff.onlyInA;
      _log.info("[syncTags] Removed tags: ${deletes.toReadableString()}");
      final updates =
          to.where((t) {
            final f = from.firstWhereOrNull((e) => e.id == t.id);
            return f != null && f != t;
          }).toList();
      _log.info("[syncTags] Updated tags: ${updates.toReadableString()}");
      if (inserts.isNotEmpty || deletes.isNotEmpty || updates.isNotEmpty) {
        await db.replaceTags(
          account: ByAccount.db(account),
          inserts: inserts,
          deletes: deletes,
          updates: updates,
        );
      }
      return DbSyncIdResult(
        insert: inserts.map((e) => e.id).toList(),
        delete: deletes.map((e) => e.id).toList(),
        update: updates.map((e) => e.id).toList(),
      );
    });
  }

  @override
  Future<void> migrateV55(
    void Function(int current, int count)? onProgress,
  ) async {
    await _db.use((db) async {
      await db.migrateV55(onProgress);
    });
  }

  @override
  Future<void> migrateV75() async {
    await _db.use((db) async {
      await db.migrateV75();
    });
  }

  @override
  Future<void> sqlVacuum() async {
    await _db.useNoTransaction((db) async {
      await db.customStatement("VACUUM;");
    });
  }

  Future<bool> _replaceRecognizeFaceItems(
    SqliteDb db, {
    required Account sqlAccount,
    required RecognizeFace face,
    required List<DbRecognizeFaceItem> items,
    required int Function(DbRecognizeFaceItem, DbRecognizeFaceItem) sorter,
  }) async {
    final to = items;
    final sqlObjs = await db.queryRecognizeFaceItemsByFaceLabel(
      account: ByAccount.sql(sqlAccount),
      label: face.label,
    );
    final from = sqlObjs.map(RecognizeFaceItemConverter.fromSql).sorted(sorter);
    final diff = getDiffWith(from, to, sorter);
    final inserts = diff.onlyInB;
    _log.info(
      "[_replaceRecognizeFaceItems] New faces: ${inserts.toReadableString()}",
    );
    final deletes = diff.onlyInA;
    _log.info(
      "[_replaceRecognizeFaceItems] Removed faces: ${deletes.toReadableString()}",
    );
    final updates =
        to.where((t) {
          final f = from.firstWhereOrNull((e) => e.fileId == t.fileId);
          return f != null && f != t;
        }).toList();
    _log.info(
      "[_replaceRecognizeFaceItems] Updated faces: ${updates.toReadableString()}",
    );
    if (inserts.isNotEmpty || deletes.isNotEmpty || updates.isNotEmpty) {
      await db.replaceRecognizeFaceItems(
        face: face,
        inserts: inserts,
        deletes: deletes,
        updates: updates,
      );
      return true;
    }
    return false;
  }

  @Deprecated("For compatibility only")
  SqliteDb get compatDb => _db;

  late final SqliteDb _db;
}
