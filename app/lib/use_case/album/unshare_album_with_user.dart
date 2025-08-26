import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/use_case/album/unshare_file_from_album.dart';
import 'package:nc_photos/use_case/list_share.dart';
import 'package:nc_photos/use_case/remove_share.dart';
import 'package:nc_photos/use_case/update_album.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'unshare_album_with_user.g.dart';

@npLog
class UnshareAlbumWithUser {
  UnshareAlbumWithUser(this._c)
    : assert(require(_c)),
      assert(UnshareFileFromAlbum.require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.albumRepo) &&
      DiContainer.has(c, DiType.shareRepo);

  Future<Album> call(
    Account account,
    Album album,
    CiString shareWith, {
    ErrorWithValueHandler<Share>? onUnshareFileFailed,
  }) async {
    assert(album.provider is AlbumStaticProvider);
    // remove the share from album file
    final newShares =
        album.shares?.where((s) => s.userId != shareWith).toList() ?? [];
    final newAlbum = album.copyWith(
      shares: OrNull(newShares.isEmpty ? null : newShares),
    );
    await UpdateAlbum(_c.albumRepo)(account, newAlbum);

    try {
      await _deleteFileShares(
        account,
        newAlbum,
        shareWith,
        onUnshareFileFailed: onUnshareFileFailed,
      );
    } catch (e, stackTrace) {
      _log.shout("[call] Failed while _deleteFileShares", e, stackTrace);
    }
    return newAlbum;
  }

  Future<void> _deleteFileShares(
    Account account,
    Album album,
    CiString shareWith, {
    ErrorWithValueHandler<Share>? onUnshareFileFailed,
  }) async {
    // remove share from the album file
    final albumShares = await ListShare(_c)(account, album.albumFile!);
    for (final s in albumShares.where((s) => s.shareWith == shareWith)) {
      try {
        await RemoveShare(_c.shareRepo)(account, s);
      } catch (e, stackTrace) {
        _log.severe(
          "[_deleteFileShares] Failed unsharing album file '${logFilename(album.albumFile?.path)}' with '$shareWith'",
          e,
          stackTrace,
        );
        onUnshareFileFailed?.call(s, e, stackTrace);
      }
    }

    // then remove shares from all files in this album
    final files =
        AlbumStaticProvider.of(
          album,
        ).items.whereType<AlbumFileItem>().map((e) => e.file).toList();
    await UnshareFileFromAlbum(_c)(account, album, files, [
      shareWith,
    ], onUnshareFileFailed: onUnshareFileFailed);
  }

  final DiContainer _c;
}
