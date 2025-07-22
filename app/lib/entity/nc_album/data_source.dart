import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/entity/nc_album/repo.dart';
import 'package:nc_photos/entity/nc_album_item.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class NcAlbumRemoteDataSource implements NcAlbumDataSource {
  const NcAlbumRemoteDataSource();

  @override
  Future<List<NcAlbum>> getAlbums(Account account) async {
    _log.info("[getAlbums] account: ${account.userId}");
    final results = await Future.wait([
      _getAlbums(account),
      _getSharedAlbums(account),
    ]);
    return results.flattened.toList();
  }

  @override
  Future<void> create(Account account, NcAlbum album) async {
    _log.info("[create] account: ${account.userId}, album: ${album.path}");
    final response = await ApiUtil.fromAccount(account)
        .photos(account.userId.toString())
        .album(album.strippedPath)
        .mkcol();
    if (!response.isGood) {
      _log.severe("[create] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  Future<void> remove(Account account, NcAlbum album) async {
    _log.info("[remove] account: ${account.userId}, album: ${album.path}");
    final response = await ApiUtil.fromAccount(account)
        .photos(account.userId.toString())
        .album(album.strippedPath)
        .delete();
    if (!response.isGood) {
      _log.severe("[remove] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  @override
  Future<List<NcAlbumItem>> getItems(Account account, NcAlbum album) async {
    _log.info(
        "[getItems] account: ${account.userId}, album: ${album.strippedPath}");
    final response = await ApiUtil.fromAccount(account).files().propfind(
      path: album.path,
      getlastmodified: 1,
      getetag: 1,
      getcontenttype: 1,
      getcontentlength: 1,
      hasPreview: 1,
      fileid: 1,
      favorite: 1,
      customProperties: [
        "nc:file-metadata-size",
        "nc:face-detections",
        "nc:realpath",
        "oc:permissions",
      ],
    );
    if (!response.isGood) {
      _log.severe("[getItems] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiFiles = await api.NcAlbumItemParser().parse(response.body);
    return apiFiles
        .where((f) => f.fileId != null)
        .map(ApiNcAlbumItemConverter.fromApi)
        .toList();
  }

  Future<List<NcAlbum>> _getAlbums(Account account) async {
    final response = await ApiUtil.fromAccount(account)
        .photos(account.userId.toString())
        .albums()
        .propfind(
          lastPhoto: 1,
          nbItems: 1,
          location: 1,
          dateRange: 1,
          collaborators: 1,
        );
    if (!response.isGood) {
      _log.severe("[_getAlbums] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiNcAlbums = await api.NcAlbumParser().parse(response.body);
    return apiNcAlbums
        .map(ApiNcAlbumConverter.fromApi)
        .where((a) => a.strippedPath != ".")
        .toList();
  }

  Future<List<NcAlbum>> _getSharedAlbums(Account account) async {
    final response = await ApiUtil.fromAccount(account)
        .photos(account.userId.toString())
        .sharedalbums()
        .propfind(
          lastPhoto: 1,
          nbItems: 1,
          location: 1,
          dateRange: 1,
          collaborators: 1,
        );
    if (!response.isGood) {
      _log.severe("[_getSharedAlbums] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiNcAlbums = await api.NcAlbumParser().parse(response.body);
    return apiNcAlbums
        .map(ApiNcAlbumConverter.fromApi)
        .where((a) => a.strippedPath != ".")
        .toList();
  }
}

@npLog
class NcAlbumSqliteDbDataSource implements NcAlbumCacheDataSource {
  const NcAlbumSqliteDbDataSource(this.npDb);

  @override
  Future<List<NcAlbum>> getAlbums(Account account) async {
    _log.info("[getAlbums] account: ${account.userId}");
    final results = await npDb.getNcAlbums(account: account.toDb());
    return results
        .map((e) {
          try {
            return DbNcAlbumConverter.fromDb(account.userId.toString(), e);
          } catch (e, stackTrace) {
            _log.severe(
                "[getAlbums] Failed while converting DB entry", e, stackTrace);
            return null;
          }
        })
        .nonNulls
        .toList();
  }

  @override
  Future<void> create(Account account, NcAlbum album) async {
    _log.info("[create] account: ${account.userId}, album: ${album.path}");
    await npDb.addNcAlbum(account: account.toDb(), album: album.toDb());
  }

  @override
  Future<void> remove(Account account, NcAlbum album) async {
    _log.info("[remove] account: ${account.userId}, album: ${album.path}");
    await npDb.deleteNcAlbum(account: account.toDb(), album: album.toDb());
  }

  @override
  Future<List<NcAlbumItem>> getItems(Account account, NcAlbum album) async {
    _log.info(
        "[getItems] account: ${account.userId}, album: ${album.strippedPath}");
    final results = await npDb.getNcAlbumItemsByParent(
      account: account.toDb(),
      parent: album.toDb(),
    );
    return results
        .map((e) {
          try {
            return DbNcAlbumItemConverter.fromDb(account.userId.toString(),
                album.strippedPath, album.isOwned, e);
          } catch (e, stackTrace) {
            _log.severe(
                "[getItems] Failed while converting DB entry", e, stackTrace);
            return null;
          }
        })
        .nonNulls
        .toList();
  }

  @override
  Future<void> updateAlbumsCache(Account account, List<NcAlbum> remote) async {
    _log.info(
        "[updateAlbumsCache] account: ${account.userId}, remote: ${remote.map((e) => e.strippedPath)}");
    await npDb.syncNcAlbums(
      account: account.toDb(),
      albums: remote.map(DbNcAlbumConverter.toDb).toList(),
    );
  }

  @override
  Future<void> updateItemsCache(
      Account account, NcAlbum album, List<NcAlbumItem> remote) async {
    _log.info(
        "[updateItemsCache] account: ${account.userId}, album: ${album.name}, remote: ${remote.map((e) => e.strippedPath)}");
    await npDb.syncNcAlbumItems(
      account: account.toDb(),
      album: album.toDb(),
      items: remote.map(DbNcAlbumItemConverter.toDb).toList(),
    );
  }

  final NpDb npDb;
}
