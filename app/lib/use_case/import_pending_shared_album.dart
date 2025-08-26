import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/use_case/move.dart';

/// Import a shared album from the pending dir to the library
class ImportPendingSharedAlbum {
  ImportPendingSharedAlbum(this._c)
    : assert(require(_c)),
      assert(LsSingleFile.require(_c)),
      assert(Move.require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.albumRepo);

  Future<Album> call(Account account, Album album) async {
    final destination =
        "${remote_storage_util.getRemoteAlbumsDir(account)}/${album.albumFile!.filename}";
    await Move(_c)(
      account,
      album.albumFile!,
      destination,
      shouldCreateMissingDir: true,
    );
    final newAlbumFile = await LsSingleFile(_c)(account, destination);
    final newAlbum = await _c.albumRepo.get(account, newAlbumFile);
    return newAlbum;
  }

  final DiContainer _c;
}
