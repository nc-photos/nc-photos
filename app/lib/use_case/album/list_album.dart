import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/compat/v15.dart';
import 'package:nc_photos/use_case/compat/v25.dart';
import 'package:nc_photos/use_case/ls.dart';

class ListAlbum {
  ListAlbum(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.albumRepo) &&
      DiContainer.has(c, DiType.fileRepo);

  /// List all albums associated with [account]
  ///
  /// The returned stream would emit either [Album] or [ExceptionEvent]
  Stream<dynamic> call(Account account) async* {
    bool hasAlbum = false;
    await for (final result in _call(account)) {
      hasAlbum = true;
      yield result;
    }
    if (!hasAlbum) {
      if (await CompatV15.migrateAlbumFiles(account, _c.fileRepo)) {
        // migrated, try again
        yield* _call(account);
      }
    }
  }

  Stream<dynamic> _call(Account account) async* {
    List<File> ls;
    try {
      ls = await Ls(_c.fileRepo)(
          account,
          File(
            path: remote_storage_util.getRemoteAlbumsDir(account),
          ));
    } catch (e, stackTrace) {
      if (e is ApiException && e.response.statusCode == 404) {
        // no albums
        return;
      }
      yield ExceptionEvent(e, stackTrace);
      return;
    }
    final List<File?> albumFiles =
        ls.where((element) => element.isCollection != true).toList();
    // migrate files
    for (var i = 0; i < albumFiles.length; ++i) {
      var f = albumFiles[i]!;
      try {
        if (CompatV25.isAlbumFileNeedMigration(f)) {
          albumFiles[i] = await CompatV25.migrateAlbumFile(_c, account, f);
        }
      } catch (e, stackTrace) {
        yield ExceptionEvent(e, stackTrace);
        albumFiles[i] = null;
      }
    }
    yield* _c.albumRepo.getAll(account, albumFiles.nonNulls.toList());
  }

  final DiContainer _c;
}
