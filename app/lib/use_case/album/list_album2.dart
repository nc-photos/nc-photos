import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/compat/v15.dart';
import 'package:nc_photos/use_case/compat/v25.dart';
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'list_album2.g.dart';

@npLog
class ListAlbum2 {
  ListAlbum2(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.albumRepo) &&
      DiContainer.has(c, DiType.fileRepo);

  Stream<List<Album>> call(Account account, {ErrorHandler? onError}) async* {
    var hasAlbum = false;
    try {
      await for (final result in _call(account, onError: onError)) {
        hasAlbum = true;
        yield result;
      }
    } catch (e) {
      if (e is ApiException && e.response.statusCode == 404) {
        // no albums
        return;
      } else {
        rethrow;
      }
    }
    if (!hasAlbum) {
      if (await CompatV15.migrateAlbumFiles(account, _c.fileRepo)) {
        // migrated, try again
        yield* _call(account);
      }
    }
  }

  Stream<List<Album>> _call(Account account, {ErrorHandler? onError}) async* {
    List<File>? ls;
    var isRemoteGood = true;
    try {
      ls = await Ls(_c.fileRepo)(
        account,
        File(path: remote_storage_util.getRemoteAlbumsDir(account)),
      );
    } catch (e) {
      _log.warning("[_call] Failed while Ls", e);
    }
    if (ls == null) {
      isRemoteGood = false;
      ls = await Ls(_c.fileRepoLocal)(
        account,
        File(path: remote_storage_util.getRemoteAlbumsDir(account)),
      );
    }
    final List<File?> albumFiles =
        ls.where((element) => element.isCollection != true).toList();
    // migrate files
    for (var i = 0; i < albumFiles.length; ++i) {
      final f = albumFiles[i]!;
      try {
        if (CompatV25.isAlbumFileNeedMigration(f)) {
          albumFiles[i] = await CompatV25.migrateAlbumFile(_c, account, f);
        }
      } catch (e, stackTrace) {
        onError?.call(e, stackTrace);
        albumFiles[i] = null;
      }
    }
    if (isRemoteGood) {
      yield* _c.albumRepo2.getAlbums(account, albumFiles.nonNulls.toList());
    } else {
      yield* _c.albumRepo2Local.getAlbums(
        account,
        albumFiles.nonNulls.toList(),
      );
    }
  }

  final DiContainer _c;
}
