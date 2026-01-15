import 'dart:convert';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source2.dart';
import 'package:nc_photos/entity/file/file_cache_manager.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/use_case/compat/v32.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;

part 'data_source.g.dart';

@npLog
class FileWebdavDataSource implements FileDataSource {
  const FileWebdavDataSource();

  @override
  list(Account account, File dir, {int? depth}) async {
    _log.fine("[list] ${dir.path}");
    return _listWithArgs(
      account,
      dir,
      depth: depth,
      getlastmodified: 1,
      resourcetype: 1,
      getetag: 1,
      getcontenttype: 1,
      getcontentlength: 1,
      hasPreview: 1,
      fileid: 1,
      favorite: 1,
      ownerId: 1,
      ownerDisplayName: 1,
      trashbinFilename: 1,
      trashbinOriginalLocation: 1,
      trashbinDeletionTime: 1,
      metadataPhotosIfd0: 1,
      metadataPhotosExif: 1,
      metadataPhotosGps: 1,
      metadataPhotosSize: 1,
      customNamespaces: {"com.nkming.nc_photos": "app"},
      customProperties: [
        "app:metadata",
        "app:is-archived",
        "app:override-date-time",
        "app:location",
      ],
    );
  }

  @override
  listSingle(Account account, File f) async {
    _log.info("[listSingle] ${f.path}");
    return (await list(account, f, depth: 0)).first;
  }

  @override
  listMinimal(Account account, File dir, {int? depth}) {
    _log.fine("[listMinimal] ${dir.path}");
    return _listWithArgs(
      account,
      dir,
      depth: depth,
      getlastmodified: 1,
      resourcetype: 1,
      getcontenttype: 1,
      fileid: 1,
    );
  }

  @override
  remove(Account account, FileDescriptor f) async {
    _log.info("[remove] ${f.fdPath}");
    final response = await ApiUtil.fromAccount(
      account,
    ).files().delete(path: f.fdPath);
    if (!response.isGood) {
      _log.severe("[remove] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  getBinary(Account account, File f) async {
    _log.info("[getBinary] ${f.path}");
    final response = await ApiUtil.fromAccount(
      account,
    ).files().get(path: f.path);
    if (!response.isGood) {
      _log.severe("[getBinary] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
    return response.body;
  }

  @override
  putBinary(Account account, String path, Uint8List content) async {
    _log.info("[putBinary] $path");
    final response = await ApiUtil.fromAccount(
      account,
    ).files().put(path: path, content: content);
    if (!response.isGood) {
      _log.severe("[putBinary] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  updateProperty(
    Account account,
    File f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) async {
    _log.info("[updateProperty] ${f.path}");
    if (metadata?.obj != null && metadata!.obj!.fileEtag != f.etag) {
      _log.warning(
        "[updateProperty] Metadata etag mismatch (metadata: ${metadata.obj!.fileEtag}, file: ${f.etag})",
      );
    }
    final setProps = {
      if (metadata?.obj != null)
        "app:metadata": jsonEncode(metadata!.obj!.toJson()),
      if (isArchived?.obj != null) "app:is-archived": isArchived!.obj,
      if (overrideDateTime?.obj != null)
        "app:override-date-time":
            overrideDateTime!.obj!.toUtc().toIso8601String(),
      if (favorite != null) "oc:favorite": favorite ? 1 : 0,
      if (location?.obj != null)
        "app:location": jsonEncode(location!.obj!.toJson()),
    };
    final removeProps = [
      if (OrNull.isSetNull(metadata)) "app:metadata",
      if (OrNull.isSetNull(isArchived)) "app:is-archived",
      if (OrNull.isSetNull(overrideDateTime)) "app:override-date-time",
      if (OrNull.isSetNull(location)) "app:location",
    ];
    final response = await ApiUtil.fromAccount(account).files().proppatch(
      path: f.path,
      namespaces: {
        "com.nkming.nc_photos": "app",
        "http://owncloud.org/ns": "oc",
      },
      set: setProps.isNotEmpty ? setProps : null,
      remove: removeProps.isNotEmpty ? removeProps : null,
    );
    if (!response.isGood) {
      _log.severe("[updateProperty] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  Future<void> copy(
    Account account,
    FileDescriptor f,
    String destination, {
    bool? shouldOverwrite,
  }) async {
    _log.info("[copy] ${f.fdPath} to $destination");
    final response = await ApiUtil.fromAccount(account).files().copy(
      path: f.fdPath,
      destinationUrl: "${account.url}/$destination",
      overwrite: shouldOverwrite,
    );
    if (!response.isGood) {
      _log.severe("[copy] Failed requesting sever: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    } else if (response.statusCode == 204) {
      // conflict
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  move(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  }) async {
    _log.info("[move] ${f.path} to $destination");
    final response = await ApiUtil.fromAccount(account).files().move(
      path: f.path,
      destinationUrl: "${account.url}/$destination",
      overwrite: shouldOverwrite,
    );
    if (!response.isGood) {
      _log.severe("[move] Failed requesting sever: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  createDir(Account account, String path) async {
    _log.info("[createDir] $path");
    final response = await ApiUtil.fromAccount(
      account,
    ).files().mkcol(path: path);
    if (!response.isGood) {
      _log.severe("[createDir] Failed requesting sever: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  Future<List<File>> _listWithArgs(
    Account account,
    File dir, {
    int? depth,
    getlastmodified,
    getetag,
    getcontenttype,
    resourcetype,
    getcontentlength,
    id,
    fileid,
    favorite,
    commentsHref,
    commentsCount,
    commentsUnread,
    ownerId,
    ownerDisplayName,
    shareTypes,
    checksums,
    hasPreview,
    size,
    richWorkspace,
    trashbinFilename,
    trashbinOriginalLocation,
    trashbinDeletionTime,
    metadataPhotosIfd0,
    metadataPhotosExif,
    metadataPhotosGps,
    metadataPhotosSize,
    Map<String, String>? customNamespaces,
    List<String>? customProperties,
  }) async {
    final response = await ApiUtil.fromAccount(account).files().propfind(
      path: dir.path,
      depth: depth,
      getlastmodified: getlastmodified,
      getetag: getetag,
      getcontenttype: getcontenttype,
      resourcetype: resourcetype,
      getcontentlength: getcontentlength,
      id: id,
      fileid: fileid,
      favorite: favorite,
      commentsHref: commentsHref,
      commentsCount: commentsCount,
      commentsUnread: commentsUnread,
      ownerId: ownerId,
      ownerDisplayName: ownerDisplayName,
      shareTypes: shareTypes,
      checksums: checksums,
      hasPreview: hasPreview,
      size: size,
      richWorkspace: richWorkspace,
      trashbinFilename: trashbinFilename,
      trashbinOriginalLocation: trashbinOriginalLocation,
      trashbinDeletionTime: trashbinDeletionTime,
      metadataPhotosIfd0: metadataPhotosIfd0,
      metadataPhotosExif: metadataPhotosExif,
      metadataPhotosGps: metadataPhotosGps,
      metadataPhotosSize: metadataPhotosSize,
      customNamespaces: customNamespaces,
      customProperties: customProperties,
    );
    if (!response.isGood) {
      _log.severe("[list] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiFiles = await api.FileParser().parse(response.body);
    // _log.fine("[list] Parsed files: [$files]");
    bool hasNoMediaMarker = false;
    final files =
        apiFiles
            .map(ApiFileConverter.fromApi)
            .forEachLazy((f) {
              if (file_util.isNoMediaMarker(f)) {
                hasNoMediaMarker = true;
              }
            })
            .where((f) => _validateFile(f))
            .map((e) {
              if (e.metadata == null || e.metadata!.fileEtag == e.etag) {
                return e;
              } else {
                _log.info("[list] Ignore outdated metadata for ${e.path}");
                return e.copyWith(metadata: const OrNull(null));
              }
            })
            .toList();

    await _compatUpgrade(account, files);

    if (hasNoMediaMarker) {
      // return only the marker and the dir itself
      return files
          .where(
            (f) => dir.compareServerIdentity(f) || file_util.isNoMediaMarker(f),
          )
          .toList();
    } else {
      return files;
    }
  }

  Future<void> _compatUpgrade(Account account, List<File> files) async {
    for (final f in files.where((element) => element.metadata?.exif != null)) {
      if (CompatV32.isExifNeedMigration(f.metadata!.exif!)) {
        final newExif = CompatV32.migrateExif(f.metadata!.exif!, f.path);
        await updateProperty(
          account,
          f,
          metadata: OrNull(f.metadata!.copyWith(exif: newExif)),
        );
      }
    }
  }
}

@npLog
class FileSqliteDbDataSource implements FileDataSource {
  const FileSqliteDbDataSource(this._c);

  @override
  Future<List<File>> list(Account account, File dir) async {
    _log.info("[list] ${dir.path}");
    final List<DbFile> dbFiles;
    try {
      dbFiles = await _c.npDb.getFilesByDirKey(
        account: account.toDb(),
        dir: dir.toDbKey(),
      );
    } on DbNotFoundException catch (_) {
      throw CacheNotFoundException("No entry: ${dir.path}");
    }
    final results =
        dbFiles
            .map((f) => DbFileConverter.fromDb(account.userId.toString(), f))
            .where((f) => _validateFile(f))
            .toList();
    _log.fine("[list] Queried ${results.length} files");
    if (results.isEmpty) {
      // each dir will at least contain its own entry, so an empty list here
      // means that the dir has not been queried before
      throw CacheNotFoundException("No entry: ${dir.path}");
    }
    return results;
  }

  @override
  listSingle(Account account, File f) {
    _log.severe("[listSingle] ${f.path}");
    throw UnimplementedError();
  }

  @override
  listMinimal(Account account, File dir) => list(account, dir);

  /// List files with date between [fromEpochMs] (inclusive) and [toEpochMs]
  /// (exclusive)
  Future<List<File>> listByDate(
    Account account,
    int fromEpochMs,
    int toEpochMs,
  ) async {
    _log.info("[listByDate] [$fromEpochMs, $toEpochMs]");
    final results = await _c.npDb.getFilesByTimeRange(
      account: account.toDb(),
      dirRoots: account.roots,
      range: TimeRange(
        from: DateTime.fromMillisecondsSinceEpoch(fromEpochMs),
        to: DateTime.fromMillisecondsSinceEpoch(toEpochMs),
      ),
    );
    return results
        .map((e) => DbFileConverter.fromDb(account.userId.toString(), e))
        .toList();
  }

  @override
  Future<void> remove(Account account, FileDescriptor f) {
    _log.info("[remove] ${f.fdPath}");
    return BasicFileRepo(FileNpDbDataSource(_c.npDb)).remove(account, f);
  }

  @override
  getBinary(Account account, File f) {
    _log.severe("[getBinary] ${f.path}");
    throw UnimplementedError();
  }

  @override
  putBinary(Account account, String path, Uint8List content) async {
    _log.info("[putBinary] $path");
    // do nothing, we currently don't store file contents locally
  }

  @override
  Future<void> updateProperty(
    Account account,
    File f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) async {
    _log.info("[updateProperty] ${f.path}");
    await _c.npDb.updateFileByFileId(
      account: account.toDb(),
      fileId: f.fileId!,
      isFavorite: favorite?.let(OrNull.new),
      isArchived: isArchived,
      overrideDateTime: overrideDateTime,
      bestDateTime:
          overrideDateTime == null && metadata == null
              ? null
              : file_util.getBestDateTime(
                overrideDateTime:
                    overrideDateTime == null
                        ? f.overrideDateTime
                        : overrideDateTime.obj,
                metadataDateTime:
                    metadata == null
                        ? f.metadata?.dateTime
                        : metadata.obj?.dateTime,
                lastModified: f.lastModified,
              ),
      imageData: metadata?.let((e) => OrNull(e.obj?.toDb())),
      location: location?.let((e) => OrNull(e.obj?.toDb())),
    );
  }

  @override
  Future<void> copy(
    Account account,
    FileDescriptor f,
    String destination, {
    bool? shouldOverwrite,
  }) async {
    // do nothing
  }

  @override
  Future<void> move(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  }) {
    _log.info("[move] ${f.path} to $destination");
    return _c.npDb.updateFileByFileId(
      account: account.toDb(),
      fileId: f.fileId!,
      relativePath: File(path: destination).strippedPathWithEmpty,
    );
  }

  @override
  createDir(Account account, String path) async {
    // do nothing
  }

  /// Remove all children of [dir] but not [dir] itself
  Future<void> emptyDir(Account account, File dir) {
    _log.info("[emptyDir] ${dir.path}");
    return FileSqliteCacheEmptier(_c)(account, dir);
  }

  final DiContainer _c;
}

class IntermediateSyncState {
  const IntermediateSyncState({
    required this.account,
    required this.dir,
    required this.remoteTouchEtag,
    required this.files,
    required this.shouldCache,
  });

  final Account account;
  final File dir;
  final String? remoteTouchEtag;
  final List<File> files;
  final bool shouldCache;
}

@npLog
class FileCachedDataSource implements FileDataSource {
  FileCachedDataSource(this._c, {this.shouldCheckCache = false})
    : _sqliteDbSrc = FileSqliteDbDataSource(_c);

  @override
  Future<List<File>> list(Account account, File dir) async {
    final cacheLoader = FileCacheLoader(
      _c,
      cacheSrc: _sqliteDbSrc,
      remoteSrc: _remoteSrc,
      shouldCheckCache: shouldCheckCache,
    );
    final cache = await cacheLoader(account, dir);
    if (cacheLoader.isGood) {
      return cache!;
    }

    // no cache or outdated
    return await sync(
      account,
      dir,
      remoteTouchEtag: cacheLoader.remoteTouchEtag,
    );
  }

  /// Sync [dir] with remote content, and set the local touch etag as
  /// [remoteTouchEtag]
  Future<List<File>> sync(
    Account account,
    File dir, {
    required String? remoteTouchEtag,
  }) async {
    final state = await beginSync(
      account,
      dir,
      remoteTouchEtag: remoteTouchEtag,
    );
    return concludeSync(state);
  }

  Future<IntermediateSyncState> beginSync(
    Account account,
    File dir, {
    required String? remoteTouchEtag,
  }) async {
    try {
      final remote = await _remoteSrc.list(account, dir);
      return IntermediateSyncState(
        account: account,
        dir: dir,
        remoteTouchEtag: remoteTouchEtag,
        files: remote,
        shouldCache: true,
      );
    } on ApiException catch (e) {
      if (e.response.statusCode == 404) {
        _log.info("[list] File removed: $dir");
        try {
          await _sqliteDbSrc.remove(account, dir);
        } catch (e) {
          _log.warning(
            "[list] Failed while remove from db, file not cached?",
            e,
          );
        }
        return IntermediateSyncState(
          account: account,
          dir: dir,
          remoteTouchEtag: remoteTouchEtag,
          files: [],
          shouldCache: false,
        );
      } else if (e.response.statusCode == 403) {
        _log.info("[list] E2E encrypted dir: $dir");
        try {
          // we need to keep the dir itself as it'll be inserted again on next
          // listing of its parent
          await _sqliteDbSrc.emptyDir(account, dir);
        } catch (e) {
          _log.warning(
            "[list] Failed while emptying from db, file not cached?",
            e,
          );
        }
        return IntermediateSyncState(
          account: account,
          dir: dir,
          remoteTouchEtag: remoteTouchEtag,
          files: [],
          shouldCache: false,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<List<File>> concludeSync(IntermediateSyncState state) async {
    if (!state.shouldCache) {
      return state.files;
    }

    await FileSqliteCacheUpdater(_c.npDb)(
      state.account,
      state.dir,
      remote: state.files,
    );
    if (shouldCheckCache) {
      // update our local touch token to match the remote one
      try {
        _log.info("[list] Update outdated local etag: ${state.dir.path}");
        await _c.touchManager.setLocalEtag(
          state.account,
          state.dir,
          state.remoteTouchEtag,
        );
      } catch (e, stacktrace) {
        _log.shout("[list] Failed while setLocalToken", e, stacktrace);
        // ignore error
      }
    }
    return state.files;
  }

  @override
  listSingle(Account account, File f) async {
    final remote = await _remoteSrc.listSingle(account, f);
    if (remote.isCollection != true) {
      // only update regular files
      _log.info("[listSingle] Cache single file: ${logFilename(f.path)}");
      await FileSqliteCacheUpdater(_c.npDb).updateSingle(account, remote);
    }
    return remote;
  }

  @override
  listMinimal(Account account, File dir) {
    return _remoteSrc.listMinimal(account, dir);
  }

  @override
  remove(Account account, FileDescriptor f) async {
    await _remoteSrc.remove(account, f);
    try {
      await _sqliteDbSrc.remove(account, f);
    } catch (e, stackTrace) {
      // ignore cache failure
      _log.warning(
        "Failed while remove: ${logFilename(f.strippedPath)}",
        e,
        stackTrace,
      );
    }
  }

  @override
  getBinary(Account account, File f) {
    return _remoteSrc.getBinary(account, f);
  }

  @override
  putBinary(Account account, String path, Uint8List content) async {
    await _remoteSrc.putBinary(account, path, content);
  }

  @override
  updateProperty(
    Account account,
    File f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) async {
    await _remoteSrc.updateProperty(
      account,
      f,
      metadata: metadata,
      isArchived: isArchived,
      overrideDateTime: overrideDateTime,
      favorite: favorite,
      location: location,
    );
    await _sqliteDbSrc.updateProperty(
      account,
      f,
      metadata: metadata,
      isArchived: isArchived,
      overrideDateTime: overrideDateTime,
      favorite: favorite,
      location: location,
    );

    // generate a new random token
    final dir = File(path: path_lib.dirname(f.path));
    await _c.touchManager.touch(account, dir);
  }

  @override
  Future<void> copy(
    Account account,
    FileDescriptor f,
    String destination, {
    bool? shouldOverwrite,
  }) async {
    await _remoteSrc.copy(
      account,
      f,
      destination,
      shouldOverwrite: shouldOverwrite,
    );
  }

  @override
  Future<void> move(
    Account account,
    File f,
    String destination, {
    bool? shouldOverwrite,
  }) async {
    await _remoteSrc.move(
      account,
      f,
      destination,
      shouldOverwrite: shouldOverwrite,
    );
    try {
      await _sqliteDbSrc.move(account, f, destination);
    } catch (e, stackTrace) {
      // ignore cache failure
      _log.warning(
        "Failed while move: ${logFilename(f.strippedPath)}",
        e,
        stackTrace,
      );
    }
  }

  @override
  createDir(Account account, String path) async {
    await _remoteSrc.createDir(account, path);
  }

  Future<void> flushRemoteTouch() async {
    return _c.touchManager.flushRemote();
  }

  final DiContainer _c;
  final bool shouldCheckCache;

  final _remoteSrc = const FileWebdavDataSource();
  final FileSqliteDbDataSource _sqliteDbSrc;
}

bool _validateFile(File f) {
  // See: https://gitlab.com/nkming2/nc-photos/-/issues/9
  return f.lastModified != null;
}
