import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/move.dart';

/// Unimport a shared album from the library
class UnimportSharedAlbum {
  UnimportSharedAlbum(this._c) : assert(require(_c)), assert(Move.require(_c));

  static bool require(DiContainer c) => true;

  Future<void> call(Account account, Album album) async {
    final destination =
        "${remote_storage_util.getRemotePendingSharedAlbumsDir(account)}/${album.albumFile!.filename}";
    await Move(_c)(
      account,
      album.albumFile!,
      destination,
      shouldCreateMissingDir: true,
    );
  }

  final DiContainer _c;
}
