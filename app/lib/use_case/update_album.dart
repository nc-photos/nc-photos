import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/exception.dart';

class UpdateAlbum {
  const UpdateAlbum(this.albumRepo);

  Future<void> call(Account account, Album album) async {
    if (album.savedVersion > Album.version) {
      // the album is created by a newer version of this app
      throw AlbumDowngradeException(
        "Not allowed to downgrade album '${album.name}'",
      );
    }
    await albumRepo.update(account, album);
  }

  final AlbumRepo albumRepo;
}
