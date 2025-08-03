import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:np_async/np_async.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source2.g.dart';

@npLog
class FileRemoteDataSource implements FileDataSource2 {
  const FileRemoteDataSource();

  @override
  Future<List<FileDescriptor>> getFileDescriptors(
    Account account,
    String shareDirPath, {
    TimeRange? timeRange,
    bool? isArchived,
    int? offset,
    int? limit,
  }) {
    throw UnsupportedError("getFileDescriptors not supported");
  }

  @override
  Future<List<int>> getFileIds(
    Account account,
    String shareDirPath, {
    bool? isArchived,
  }) {
    throw UnsupportedError("getFileIds not supported");
  }

  @override
  Future<void> updateProperty(
    Account account,
    FileDescriptor f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) async {
    _log.info("[updateProperty] ${f.fdPath}");
    if (f is File &&
        metadata?.obj != null &&
        metadata!.obj!.fileEtag != f.etag) {
      _log.warning(
          "[updateProperty] Metadata etag mismatch (metadata: ${metadata.obj!.fileEtag}, file: ${f.etag})");
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
          path: f.fdPath,
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
  Future<void> remove(Account account, FileDescriptor f) async {
    _log.info("[remove] ${f.fdPath}");
    final response =
        await ApiUtil.fromAccount(account).files().delete(path: f.fdPath);
    if (!response.isGood) {
      _log.severe("[remove] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }
}

@npLog
class FileNpDbDataSource implements FileDataSource2 {
  const FileNpDbDataSource(this.db);

  @override
  Future<List<FileDescriptor>> getFileDescriptors(
    Account account,
    String shareDirPath, {
    TimeRange? timeRange,
    bool? isArchived,
    int? offset,
    int? limit,
  }) {
    _log.info("[getFileDescriptors] $account");
    return _getFileDescriptors(
      account,
      shareDirPath,
      timeRange: timeRange,
      isArchived: isArchived,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<List<int>> getFileIds(
    Account account,
    String shareDirPath, {
    bool? isArchived,
  }) async {
    _log.info("[getFileIds] $account");
    return await db.getFileIds(
      account: account.toDb(),
      // need this because this arg expect empty string for root instead of "."
      includeRelativeRoots: account.roots
          .map((e) => File(path: file_util.unstripPath(account, e))
              .strippedPathWithEmpty)
          .toList(),
      includeRelativeDirs: [File(path: shareDirPath).strippedPathWithEmpty],
      excludeRelativeRoots: [remote_storage_util.remoteStorageDirRelativePath],
      mimes: file_util.supportedFormatMimes,
      isArchived: isArchived,
    );
  }

  @override
  Future<void> updateProperty(
    Account account,
    FileDescriptor f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) async {
    _log.info("[updateProperty] ${f.fdPath}");
    if (overrideDateTime != null || metadata != null) {
      f = DbFileConverter.fromDb(
        account.userId.toCaseInsensitiveString(),
        await db.getFilesByFileIds(
          account: account.toDb(),
          fileIds: [f.fdId],
        ).first,
      );
    }
    await db.updateFileByFileId(
      account: account.toDb(),
      fileId: f.fdId,
      isFavorite: favorite?.let(OrNull.new),
      isArchived: isArchived,
      overrideDateTime: overrideDateTime,
      bestDateTime: overrideDateTime == null && metadata == null
          ? null
          : file_util.getBestDateTime(
              overrideDateTime: overrideDateTime == null
                  ? (f as File).overrideDateTime
                  : overrideDateTime.obj,
              dateTimeOriginal: metadata == null
                  ? (f as File).metadata?.exif?.dateTimeOriginal
                  : metadata.obj?.exif?.dateTimeOriginal,
              lastModified: (f as File).lastModified,
            ),
      imageData: metadata?.let((e) => OrNull(e.obj?.toDb())),
      location: location?.let((e) => OrNull(e.obj?.toDb())),
    );
  }

  @override
  Future<void> remove(Account account, FileDescriptor f) async {
    _log.info("[remove] ${f.fdPath}");
    if (file_util.isNcAlbumFile(account, f)) {
      // removing from albums, not deleting the file
      return;
    }
    await db.deleteFile(
      account: account.toDb(),
      file: f.toDbKey(),
    );
  }

  Future<List<FileDescriptor>> _getFileDescriptors(
    Account account,
    String shareDirPath, {
    TimeRange? timeRange,
    bool? isArchived,
    int? offset,
    int? limit,
  }) async {
    _log.info(
        "[_getFileDescriptors] $account, timeRange: $timeRange, offset: $offset, limit: $limit");
    final results = await db.getFileDescriptors(
      account: account.toDb(),
      // need this because this arg expect empty string for root instead of "."
      includeRelativeRoots: account.roots
          .map((e) => File(path: file_util.unstripPath(account, e))
              .strippedPathWithEmpty)
          .toList(),
      includeRelativeDirs: [File(path: shareDirPath).strippedPathWithEmpty],
      excludeRelativeRoots: [remote_storage_util.remoteStorageDirRelativePath],
      mimes: file_util.supportedFormatMimes,
      timeRange: timeRange,
      isArchived: isArchived,
      offset: offset,
      limit: limit,
    );
    return results
        .map((e) =>
            DbFileDescriptorConverter.fromDb(account.userId.toString(), e))
        .toList();
  }

  final NpDb db;
}
