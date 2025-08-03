import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/use_case/album/unshare_file_from_album.dart';
import 'package:nc_photos/use_case/list_share.dart';
import 'package:nc_photos/use_case/remove.dart';
import 'package:nc_photos/use_case/remove_share.dart';
import 'package:nc_photos/use_case/update_album.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';

part 'remove_album.g.dart';

@npLog
class RemoveAlbum {
  RemoveAlbum(this._c)
      : assert(require(_c)),
        assert(UnshareFileFromAlbum.require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.albumRepo) &&
      DiContainer.has(c, DiType.shareRepo);

  /// Remove an album
  Future<void> call(Account account, Album album) async {
    _log.info("[call] Remove album: $album");
    if (album.shares?.isNotEmpty == true) {
      // remove shares from the album json. This should be the first so if this
      // fail the whole op can fail safely. This update may seems useless but is
      // needed to make sure the album is not shared after recovering from trash
      await UpdateAlbum(_c.albumRepo)(
        account,
        album.copyWith(
          shares: const OrNull(null),
        ),
      );
      // remove file shares
      await _unshareFiles(account, album);
      // remove shares for the album json itself
      await _unshareAlbumFile(account, album);
    }
    // you can't add an album to another album, so skipping clean up can save a
    // few queries
    await Remove(_c)(account, [album.albumFile!], shouldCleanUp: false);
  }

  Future<void> _unshareFiles(Account account, Album album) async {
    if (album.provider is! AlbumStaticProvider) {
      return;
    }
    final albumShares = (album.shares!.map((e) => e.userId).toList()
          ..add(album.albumFile!.ownerId ?? account.userId))
        .where((element) => element != account.userId)
        .toList();
    if (albumShares.isEmpty) {
      return;
    }
    final files = AlbumStaticProvider.of(album)
        .items
        .whereType<AlbumFileItem>()
        .map((e) => e.file)
        .toList();
    if (files.isEmpty) {
      return;
    }
    try {
      await UnshareFileFromAlbum(_c)(account, album, files, albumShares);
    } catch (e, stackTrace) {
      _log.shout(
          "[_unshareFiles] Failed while UnshareFileFromAlbum", e, stackTrace);
    }
  }

  Future<void> _unshareAlbumFile(Account account, Album album) async {
    final shares = (await ListShare(_c)(account, album.albumFile!))
        .where((s) => s.shareType == ShareType.user);
    for (final s in shares) {
      try {
        await RemoveShare(_c.shareRepo)(account, s);
      } catch (e, stackTrace) {
        _log.shout(
            "[_unshareAlbumFile] Failed while RemoveShare: $s", e, stackTrace);
      }
    }
  }

  final DiContainer _c;
}
