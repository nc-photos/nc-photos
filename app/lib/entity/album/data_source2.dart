import 'dart:convert';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/repo2.dart';
import 'package:nc_photos/entity/album/upgrader.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/get_file_binary.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/use_case/put_file_binary.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source2.g.dart';

@npLog
class AlbumRemoteDataSource2 implements AlbumDataSource2 {
  const AlbumRemoteDataSource2();

  @override
  Future<List<Album>> getAlbums(
    Account account,
    List<File> albumFiles, {
    ErrorWithValueHandler<File>? onError,
  }) async {
    final results = await Future.wait(
      albumFiles.map((f) async {
        try {
          return await _getSingle(account, f);
        } catch (e, stackTrace) {
          onError?.call(f, e, stackTrace);
          return null;
        }
      }),
    );
    return results.nonNulls.toList();
  }

  @override
  Future<Album> create(Account account, Album album) async {
    _log.info("[create] ${album.name}");
    final fileName = _makeAlbumFileName();
    final filePath =
        "${remote_storage_util.getRemoteAlbumsDir(account)}/$fileName";
    final c = KiwiContainer().resolve<DiContainer>();
    await PutFileBinary(c.fileRepo)(
      account,
      filePath,
      const Utf8Encoder().convert(jsonEncode(album.toRemoteJson())),
      shouldCreateMissingDir: true,
    );
    // query album file
    final newFile = await LsSingleFile(c)(account, filePath);
    return album.copyWith(albumFile: OrNull(newFile));
  }

  @override
  Future<void> update(Account account, Album album) async {
    _log.info("[update] ${album.albumFile!.path}");
    const fileRepo = FileRepo(FileWebdavDataSource());
    await const PutFileBinary(fileRepo)(
      account,
      album.albumFile!.path,
      const Utf8Encoder().convert(jsonEncode(album.toRemoteJson())),
    );
  }

  Future<Album> _getSingle(Account account, File albumFile) async {
    _log.info("[_getSingle] Getting ${albumFile.path}");
    const fileRepo = FileRepo(FileWebdavDataSource());
    final data = await GetFileBinary(fileRepo)(account, albumFile);
    try {
      final album = Album.fromJson(
        jsonDecode(utf8.decode(data)),
        upgraderFactory: DefaultAlbumUpgraderFactory(
          account: account,
          albumFile: albumFile,
          logFilePath: albumFile.path,
        ),
      );
      return album!.copyWith(
        lastUpdated: const OrNull(null),
        albumFile: OrNull(albumFile),
      );
    } catch (e, stacktrace) {
      dynamic d = data;
      try {
        d = utf8.decode(data);
      } catch (_) {}
      _log.severe("[_getSingle] Invalid json data: $d", e, stacktrace);
      throw const FormatException("Invalid album format");
    }
  }

  String _makeAlbumFileName() {
    // just make up something
    final timestamp = clock.now().millisecondsSinceEpoch;
    final random = Random().nextInt(0xFFFFFF);
    return "${timestamp.toRadixString(16)}-${random.toRadixString(16).padLeft(6, '0')}.nc_album.json";
  }
}

@npLog
class AlbumSqliteDbDataSource2 implements AlbumDataSource2 {
  const AlbumSqliteDbDataSource2(this.npDb);

  @override
  Future<List<Album>> getAlbums(
    Account account,
    List<File> albumFiles, {
    ErrorWithValueHandler<File>? onError,
  }) async {
    final albums = await npDb.getAlbumsByAlbumFileIds(
      account: account.toDb(),
      fileIds: albumFiles.map((e) => e.fileId!).toList(),
    );
    final files = await npDb.getFilesByFileIds(
      account: account.toDb(),
      fileIds: albums.map((e) => e.fileId).toList(),
    );
    final albumMap = albums.map((e) => MapEntry(e.fileId, e)).toMap();
    final fileMap = files.map((e) => MapEntry(e.fileId, e)).toMap();
    return albumFiles
        .map((f) {
          var dbAlbum = albumMap[f.fileId];
          final dbFile = fileMap[f.fileId];
          if (dbAlbum == null || dbFile == null) {
            // cache not found
            onError?.call(
              f,
              const CacheNotFoundException(),
              StackTrace.current,
            );
            return null;
          }
          try {
            final file = DbFileConverter.fromDb(
              account.userId.toString(),
              dbFile,
            );
            if (dbAlbum.version < 9) {
              dbAlbum = AlbumUpgraderV8(logFilePath: file.path).doDb(dbAlbum)!;
            }
            if (dbAlbum.version < 10) {
              dbAlbum =
                  AlbumUpgraderV9(
                    account: account,
                    logFilePath: file.path,
                  ).doDb(dbAlbum)!;
            }
            return DbAlbumConverter.fromDb(file, dbAlbum);
          } catch (e, stackTrace) {
            _log.severe(
              "[getAlbums] Failed while converting DB entry",
              e,
              stackTrace,
            );
            onError?.call(f, e, stackTrace);
            return null;
          }
        })
        .nonNulls
        .toList();
  }

  @override
  Future<Album> create(Account account, Album album) async {
    _log.info("[create] ${album.name}");
    throw UnimplementedError();
  }

  @override
  Future<void> update(Account account, Album album) async {
    _log.info("[update] ${album.albumFile!.path}");
    await npDb.syncAlbum(
      account: account.toDb(),
      albumFile: DbFileConverter.toDb(album.albumFile!),
      album: DbAlbumConverter.toDb(album),
    );
  }

  final NpDb npDb;
}
