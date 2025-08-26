import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/use_case/cache_favorite.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'sync_favorite.g.dart';

@npLog
class SyncFavorite {
  SyncFavorite(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.favoriteRepo);

  /// Sync favorites in cache db with remote server
  ///
  /// Return number of files updated
  Future<DbSyncIdResult> call(Account account) async {
    _log.info("[call] Sync favorites with remote");
    final remote = await _getRemoteFavoriteFileIds(account);
    return await CacheFavorite(_c)(account, remote);
  }

  Future<List<int>> _getRemoteFavoriteFileIds(Account account) async {
    final settings = AccountPref.of(account);
    final shareDir = File(
      path: file_util.unstripPath(account, settings.getShareFolderOr()),
    );
    bool isShareDirIncluded = false;

    final fileIds = <int>[];
    for (final r in account.roots) {
      final dir = File(path: file_util.unstripPath(account, r));
      final favorites = await _c.favoriteRepo.list(account, dir);
      fileIds.addAll(favorites.map((f) => f.fileId));
      isShareDirIncluded |= file_util.isOrUnderDir(shareDir, dir);
    }

    if (!isShareDirIncluded) {
      _log.info("[_getRemoteFavoriteFileIds] Explicitly querying share folder");
      final favorites = await _c.favoriteRepo.list(account, shareDir);
      fileIds.addAll(favorites.map((f) => f.fileId));
    }
    return fileIds;
  }

  final DiContainer _c;
}
