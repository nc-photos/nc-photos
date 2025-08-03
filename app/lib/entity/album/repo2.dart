import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'repo2.g.dart';

abstract class AlbumRepo2 {
  /// Query all [Album]s defined by [albumFiles]
  Stream<List<Album>> getAlbums(
    Account account,
    List<File> albumFiles, {
    ErrorWithValueHandler<File>? onError,
  });

  /// Create a new [album]
  Future<Album> create(Account account, Album album);

  /// Update an [album]
  Future<void> update(Account account, Album album);
}

class BasicAlbumRepo2 implements AlbumRepo2 {
  const BasicAlbumRepo2(this.dataSrc);

  @override
  Stream<List<Album>> getAlbums(
    Account account,
    List<File> albumFiles, {
    ErrorWithValueHandler<File>? onError,
  }) async* {
    yield await dataSrc.getAlbums(account, albumFiles, onError: onError);
  }

  @override
  Future<Album> create(Account account, Album album) =>
      dataSrc.create(account, album);

  @override
  Future<void> update(Account account, Album album) =>
      dataSrc.update(account, album);

  final AlbumDataSource2 dataSrc;
}

@npLog
class CachedAlbumRepo2 implements AlbumRepo2 {
  const CachedAlbumRepo2(this.remoteDataSrc, this.cacheDataSrc);

  @override
  Stream<List<Album>> getAlbums(
    Account account,
    List<File> albumFiles, {
    ErrorWithValueHandler<File>? onError,
  }) async* {
    // get cache
    final cached = <Album>[];
    final failed = <File>[];
    try {
      cached.addAll(await cacheDataSrc.getAlbums(
        account,
        albumFiles,
        onError: (f, e, stackTrace) {
          failed.add(f);
          if (e is CacheNotFoundException) {
            // not in cache, normal
          } else {
            _log.shout("[getAlbums] Cache failure", e, stackTrace);
          }
        },
      ));
      yield cached;
    } catch (e, stackTrace) {
      _log.shout("[getAlbums] Failed while getAlbums", e, stackTrace);
    }
    final cachedGroup = cached.groupListsBy((c) {
      try {
        return _validateCache(
            c, albumFiles.firstWhere(c.albumFile!.compareServerIdentity));
      } catch (_) {
        return false;
      }
    });

    // query remote
    final outdated = [
      ...failed,
      ...cachedGroup[false]?.map((e) =>
              albumFiles.firstWhere(e.albumFile!.compareServerIdentity)) ??
          const <File>[],
    ];
    final remote =
        await remoteDataSrc.getAlbums(account, outdated, onError: onError);
    yield (cachedGroup[true] ?? []) + remote;

    // update cache
    for (final a in remote) {
      unawaited(cacheDataSrc.update(account, a));
    }
  }

  @override
  Future<Album> create(Account account, Album album) =>
      remoteDataSrc.create(account, album);

  @override
  Future<void> update(Account account, Album album) async {
    await remoteDataSrc.update(account, album);
    try {
      await cacheDataSrc.update(account, album);
    } catch (e, stackTrace) {
      _log.warning("[update] Failed to update cache", e, stackTrace);
    }
  }

  /// Return true if the cached album is considered up to date
  bool _validateCache(Album cache, File albumFile) {
    if (cache.albumFile!.etag?.isNotEmpty == true &&
        cache.albumFile!.etag == albumFile.etag) {
      // cache is good
      _log.fine("[_validateCache] etag matched for ${albumFile.path}");
      return true;
    } else {
      _log.info(
          "[_validateCache] Remote content updated for ${albumFile.path}");
      return false;
    }
  }

  final AlbumDataSource2 remoteDataSrc;
  final AlbumDataSource2 cacheDataSrc;
}

abstract class AlbumDataSource2 {
  /// Query all [Album]s defined by [albumFiles]
  Future<List<Album>> getAlbums(
    Account account,
    List<File> albumFiles, {
    ErrorWithValueHandler<File>? onError,
  });

  Future<Album> create(Account account, Album album);

  Future<void> update(Account account, Album album);
}
