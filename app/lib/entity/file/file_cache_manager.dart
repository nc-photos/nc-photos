import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'file_cache_manager.g.dart';

@npLog
class FileCacheLoader {
  FileCacheLoader(
    this._c, {
    required this.cacheSrc,
    required this.remoteSrc,
    this.shouldCheckCache = false,
  }) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.fileRepo);

  /// Return the cached results of listing a directory [dir]
  ///
  /// Should check [isGood] before using the cache returning by this method
  Future<List<File>?> call(Account account, File dir) async {
    List<File>? cache;
    try {
      cache = await cacheSrc.list(account, dir);
      // compare the cached root
      final cacheEtag =
          cache.firstWhere((f) => f.compareServerIdentity(dir)).etag!;
      // compare the etag to see if the content has been updated
      var remoteEtag = dir.etag;
      if (remoteEtag == null) {
        // if no etag supplied, we need to query it form remote
        _log.info(
            "[call] etag missing from input, querying remote: ${logFilename(dir.path)}");
        remoteEtag = (await remoteSrc.list(account, dir, depth: 0)).first.etag;
      }
      if (cacheEtag == remoteEtag) {
        if (shouldCheckCache) {
          await _checkTouchEtag(account, dir, cache);
        } else {
          _isGood = true;
        }
      } else {
        _log.info("[call] Remote content updated for ${dir.path}");
      }
    } on CacheNotFoundException catch (_) {
      // normal when there's no cache
    } catch (e, stackTrace) {
      _log.shout("[call] Cache failure", e, stackTrace);
    }
    return cache;
  }

  bool get isGood => _isGood;
  String? get remoteTouchEtag => _remoteEtag;

  Future<void> _checkTouchEtag(
      Account account, File f, List<File> cache) async {
    final result = await _c.touchManager.checkTouchEtag(account, f);
    if (result == null) {
      _isGood = true;
    } else {
      _remoteEtag = result;
    }
  }

  final DiContainer _c;
  final FileWebdavDataSource remoteSrc;
  final FileDataSource cacheSrc;
  final bool shouldCheckCache;

  var _isGood = false;
  String? _remoteEtag;
}

@npLog
class FileSqliteCacheUpdater {
  const FileSqliteCacheUpdater(this.db);

  Future<void> call(
    Account account,
    File dir, {
    required List<File> remote,
  }) async {
    final s = Stopwatch()..start();
    try {
      await db.syncDirFiles(
        account: account.toDb(),
        dirFile: dir.toDbKey(),
        files: remote.map((e) => e.toDb()).toList(),
      );
    } finally {
      _log.info("[call] Elapsed time: ${s.elapsedMilliseconds}ms");
    }
  }

  Future<void> updateSingle(Account account, File remoteFile) async {
    await db.syncFile(
      account: account.toDb(),
      file: remoteFile.toDb(),
    );
  }

  final NpDb db;
}

class FileSqliteCacheEmptier {
  const FileSqliteCacheEmptier(this._c);

  /// Empty a dir from cache
  Future<void> call(Account account, File dir) async {
    await _c.npDb.truncateDir(
      account: account.toDb(),
      dir: dir.toDbKey(),
    );
  }

  final DiContainer _c;
}
