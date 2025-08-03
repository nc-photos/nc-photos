import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/data_source2.dart';
import 'package:nc_photos/entity/album/repo2.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

/// Backward compatibility only, use [AlbumRemoteDataSource2] instead
@npLog
class AlbumRemoteDataSource implements AlbumDataSource {
  @override
  get(Account account, File albumFile) async {
    _log.info("[get] ${albumFile.path}");
    final albums = await const AlbumRemoteDataSource2().getAlbums(
      account,
      [albumFile],
      onError: (_, error, stackTrace) {
        Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
      },
    );
    return albums.first;
  }

  @override
  getAll(Account account, List<File> albumFiles) async* {
    _log.info(
        "[getAll] ${albumFiles.map((f) => f.filename).toReadableString()}");
    final failed = <String, Map>{};
    final albums = await const AlbumRemoteDataSource2().getAlbums(
      account,
      albumFiles,
      onError: (v, error, stackTrace) {
        failed[v.path] = {
          "file": v,
          "error": error,
          "stackTrace": stackTrace,
        };
      },
    );
    var i = 0;
    for (final af in albumFiles) {
      final v = failed[af.path];
      if (v != null) {
        yield ExceptionEvent(v["error"], v["stackTrace"]);
      } else {
        yield albums[i++];
      }
    }
  }

  @override
  create(Account account, Album album) async {
    _log.info("[create]");
    return const AlbumRemoteDataSource2().create(account, album);
  }

  @override
  update(Account account, Album album) async {
    _log.info("[update] ${album.albumFile!.path}");
    return const AlbumRemoteDataSource2().update(account, album);
  }
}

/// Backward compatibility only, use [AlbumSqliteDbDataSource2] instead
@npLog
class AlbumSqliteDbDataSource implements AlbumDataSource {
  AlbumSqliteDbDataSource(this._c);

  @override
  get(Account account, File albumFile) async {
    final results = await getAll(account, [albumFile]).toList();
    if (results.first is! Album) {
      throw results.first;
    } else {
      return results.first;
    }
  }

  @override
  getAll(Account account, List<File> albumFiles) async* {
    _log.info(
        "[getAll] ${albumFiles.map((f) => f.filename).toReadableString()}");
    final failed = <String, Map>{};
    final albums = await AlbumSqliteDbDataSource2(_c.npDb).getAlbums(
      account,
      albumFiles,
      onError: (v, error, stackTrace) {
        failed[v.path] = {
          "file": v,
          "error": error,
          "stackTrace": stackTrace,
        };
      },
    );
    var i = 0;
    for (final af in albumFiles) {
      final v = failed[af.path];
      if (v != null) {
        if (v["error"] is CacheNotFoundException) {
          yield const CacheNotFoundException();
        } else {
          yield ExceptionEvent(v["error"], v["stackTrace"]);
        }
      } else {
        yield albums[i++];
      }
    }
  }

  @override
  create(Account account, Album album) async {
    _log.info("[create]");
    return AlbumSqliteDbDataSource2(_c.npDb).create(account, album);
  }

  @override
  update(Account account, Album album) async {
    _log.info("[update] ${album.albumFile!.path}");
    return AlbumSqliteDbDataSource2(_c.npDb).update(account, album);
  }

  final DiContainer _c;
}

/// Backward compatibility only, use [CachedAlbumRepo2] instead
@npLog
class AlbumCachedDataSource implements AlbumDataSource {
  AlbumCachedDataSource(DiContainer c) : npDb = c.npDb;

  @override
  get(Account account, File albumFile) async {
    final result = await getAll(account, [albumFile]).first;
    return result as Album;
  }

  @override
  getAll(Account account, List<File> albumFiles) async* {
    final repo = CachedAlbumRepo2(
      const AlbumRemoteDataSource2(),
      AlbumSqliteDbDataSource2(npDb),
    );
    final albums = await repo.getAlbums(account, albumFiles).last;
    for (final a in albums) {
      yield a;
    }
  }

  @override
  update(Account account, Album album) {
    return CachedAlbumRepo2(
      const AlbumRemoteDataSource2(),
      AlbumSqliteDbDataSource2(npDb),
    ).update(account, album);
  }

  @override
  create(Account account, Album album) {
    return CachedAlbumRepo2(
      const AlbumRemoteDataSource2(),
      AlbumSqliteDbDataSource2(npDb),
    ).create(account, album);
  }

  final NpDb npDb;
}
