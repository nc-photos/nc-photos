import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'cache_favorite.g.dart';

@npLog
class CacheFavorite {
  const CacheFavorite(this._c);

  /// Cache favorites using results from remote
  ///
  /// Return the fileIds of the affected files
  Future<DbSyncIdResult> call(
    Account account,
    Iterable<int> remoteFileIds,
  ) async {
    _log.info("[call] Cache favorites");
    return _c.npDb.syncFavoriteFiles(
      account: account.toDb(),
      favoriteFileIds: remoteFileIds.toList(),
    );
  }

  final DiContainer _c;
}
