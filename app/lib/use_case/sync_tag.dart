import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'sync_tag.g.dart';

@npLog
class SyncTag {
  const SyncTag(this._c);

  /// Sync tags in cache db with remote server
  ///
  /// Return tagIds of the affected tags
  Future<DbSyncIdResult> call(Account account) async {
    _log.info("[call] Sync tags with remote");
    final remote = await _c.tagRepoRemote.list(account);
    final result = await _c.npDb.syncTags(
      account: account.toDb(),
      tags: remote.map(DbTagConverter.toDb).toList(),
    );
    return result;
  }

  final DiContainer _c;
}
