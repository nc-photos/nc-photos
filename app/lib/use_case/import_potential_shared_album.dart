import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/list_potential_shared_album.dart';
import 'package:nc_photos/use_case/move.dart';
import 'package:np_log/np_log.dart';

part 'import_potential_shared_album.g.dart';

/// Import new shared albums to the pending dir
@npLog
class ImportPotentialSharedAlbum {
  ImportPotentialSharedAlbum(this._c)
    : assert(require(_c)),
      assert(Move.require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.albumRepo) &&
      DiContainer.has(c, DiType.fileRepo);

  Future<List<Album>> call(Account account, String shareFolder) async {
    _log.info("[call] $account");
    final products = <Album>[];
    final files = await ListPotentialSharedAlbum(_c.fileRepo)(
      account,
      shareFolder,
    );
    for (final f in files) {
      // check if the file is actually an album
      try {
        final album = await _c.albumRepo.get(account, f);
        _log.info("[call] New shared album: ${album.name}, file: ${f.path}");
        // move this file to the pending dir
        await Move(_c)(
          account,
          f,
          "${remote_storage_util.getRemotePendingSharedAlbumsDir(account)}/${f.filename}",
          shouldCreateMissingDir: true,
        );
        products.add(album);
      } catch (e, stacktrace) {
        _log.severe("[call] Exception", e, stacktrace);
      }
    }
    return products;
  }

  final DiContainer _c;
}
