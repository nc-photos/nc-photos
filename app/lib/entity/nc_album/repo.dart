import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/entity/nc_album_item.dart';
import 'package:np_log/np_log.dart';

part 'repo.g.dart';

abstract class NcAlbumRepo {
  /// Query all [NcAlbum]s belonging to [account]
  ///
  /// Normally the stream should complete with only a single event, but some
  /// implementation might want to return multiple set of values, say one set of
  /// cached value and later another set of updated value from a remote source.
  /// In any case, each event is guaranteed to be one complete set of data
  Stream<List<NcAlbum>> getAlbums(Account account);

  /// Create a new [album]
  Future<void> create(Account account, NcAlbum album);

  /// Remove [album]
  Future<void> remove(Account account, NcAlbum album);

  /// Query all items belonging to [album]
  Stream<List<NcAlbumItem>> getItems(Account account, NcAlbum album);
}

/// A repo that simply relay the call to the backed [NcAlbumDataSource]
@npLog
class BasicNcAlbumRepo implements NcAlbumRepo {
  const BasicNcAlbumRepo(this.dataSrc);

  @override
  Stream<List<NcAlbum>> getAlbums(Account account) async* {
    yield await dataSrc.getAlbums(account);
  }

  @override
  Future<void> create(Account account, NcAlbum album) =>
      dataSrc.create(account, album);

  @override
  Future<void> remove(Account account, NcAlbum album) =>
      dataSrc.remove(account, album);

  @override
  Stream<List<NcAlbumItem>> getItems(Account account, NcAlbum album) async* {
    yield await dataSrc.getItems(account, album);
  }

  final NcAlbumDataSource dataSrc;
}

/// A repo that manage a remote data source and a cache data source
@npLog
class CachedNcAlbumRepo implements NcAlbumRepo {
  const CachedNcAlbumRepo(this.remoteDataSrc, this.cacheDataSrc);

  @override
  Stream<List<NcAlbum>> getAlbums(Account account) async* {
    // get cache
    try {
      yield await cacheDataSrc.getAlbums(account);
    } catch (e, stackTrace) {
      _log.shout("[getAlbums] Cache failure", e, stackTrace);
    }

    // query remote
    final remote = await remoteDataSrc.getAlbums(account);
    yield remote;

    // update cache
    unawaited(cacheDataSrc.updateAlbumsCache(account, remote));
  }

  @override
  Future<void> create(Account account, NcAlbum album) async {
    await remoteDataSrc.create(account, album);
    try {
      await cacheDataSrc.create(account, album);
    } catch (e, stackTrace) {
      _log.warning("[create] Failed to insert cache", e, stackTrace);
    }
  }

  @override
  Future<void> remove(Account account, NcAlbum album) async {
    await remoteDataSrc.remove(account, album);
    try {
      await cacheDataSrc.remove(account, album);
    } catch (e, stackTrace) {
      _log.warning("[remove] Failed to remove cache", e, stackTrace);
    }
  }

  @override
  Stream<List<NcAlbumItem>> getItems(Account account, NcAlbum album) async* {
    // get cache
    try {
      yield await cacheDataSrc.getItems(account, album);
    } catch (e, stackTrace) {
      _log.shout("[getItems] Cache failure", e, stackTrace);
    }

    // query remote
    final remote = await remoteDataSrc.getItems(account, album);
    yield remote;

    // update cache
    await cacheDataSrc.updateItemsCache(account, album, remote);
  }

  final NcAlbumDataSource remoteDataSrc;
  final NcAlbumCacheDataSource cacheDataSrc;
}

abstract class NcAlbumDataSource {
  /// Query all [NcAlbum]s belonging to [account]
  Future<List<NcAlbum>> getAlbums(Account account);

  /// Create a new [album]
  Future<void> create(Account account, NcAlbum album);

  /// Remove [album]
  Future<void> remove(Account account, NcAlbum album);

  /// Query all items belonging to [album]
  Future<List<NcAlbumItem>> getItems(Account account, NcAlbum album);
}

abstract class NcAlbumCacheDataSource extends NcAlbumDataSource {
  /// Update cache to match [remote]
  Future<void> updateAlbumsCache(Account account, List<NcAlbum> remote);

  /// Update cache to match [remote]
  Future<void> updateItemsCache(
    Account account,
    NcAlbum album,
    List<NcAlbumItem> remote,
  );
}
