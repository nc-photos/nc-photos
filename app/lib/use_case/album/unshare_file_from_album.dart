import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/stream_extension.dart';
import 'package:nc_photos/use_case/album/list_album.dart';
import 'package:nc_photos/use_case/list_share.dart';
import 'package:nc_photos/use_case/remove_share.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'unshare_file_from_album.g.dart';

@npLog
class UnshareFileFromAlbum {
  UnshareFileFromAlbum(this._c)
      : assert(require(_c)),
        assert(ListAlbum.require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.shareRepo);

  /// Remove file shares created for an album
  ///
  /// Since a file may live in several albums, this will check across all albums
  /// and only remove shares exclusive to [album]
  Future<void> call(
    Account account,
    Album album,
    List<FileDescriptor> files,
    List<CiString> unshareWith, {
    ErrorWithValueHandler<Share>? onUnshareFileFailed,
  }) async {
    _log.info(
        "[call] Unshare ${files.length} files from album '${album.name}' with ${unshareWith.length} users");
    // list albums with shares identical to any element in [unshareWith]
    final otherAlbums = await ListAlbum(_c)(account)
        .whereType<Album>()
        .where((a) =>
            !a.albumFile!.compareServerIdentity(album.albumFile!) &&
            a.provider is AlbumStaticProvider &&
            a.shares?.any((s) => unshareWith.contains(s.userId)) == true)
        .toList();

    // look for shares that are exclusive to this album
    final exclusiveShares = <Share>[];
    for (final f in files) {
      try {
        final shares = await ListShare(_c)(account, f);
        exclusiveShares.addAll(
            shares.where((element) => unshareWith.contains(element.shareWith)));
      } catch (e, stackTrace) {
        _log.severe("[call] Failed while ListShare: '${logFilename(f.fdPath)}'",
            e, stackTrace);
      }
    }
    _log.fine("[call] Pre-filter shares: $exclusiveShares");
    for (final a in otherAlbums) {
      // check if the album is shared with the same users
      final sharesOfInterest =
          a.shares?.where((as) => unshareWith.contains(as.userId)).toList();
      if (sharesOfInterest == null || sharesOfInterest.isEmpty) {
        continue;
      }
      final albumFiles = AlbumStaticProvider.of(a)
          .items
          .whereType<AlbumFileItem>()
          .map((e) => e.file)
          .toList();
      // remove files shared as part of this other shared album
      exclusiveShares.removeWhere((s) =>
          sharesOfInterest.any((i) => i.userId == s.shareWith) &&
          albumFiles.any((f) => f.fdId == s.itemSource));
    }
    _log.fine("[call] Post-filter shares: $exclusiveShares");

    // unshare them
    await _unshare(account, exclusiveShares, onUnshareFileFailed);
  }

  Future<void> _unshare(Account account, List<Share> shares,
      ErrorWithValueHandler<Share>? onUnshareFileFailed) async {
    for (final s in shares) {
      try {
        await RemoveShare(_c.shareRepo)(account, s);
      } catch (e, stackTrace) {
        _log.severe(
            "[_unshare] Failed while RemoveShare: ${s.path}", e, stackTrace);
        onUnshareFileFailed?.call(s, e, stackTrace);
      }
    }
  }

  final DiContainer _c;
}
