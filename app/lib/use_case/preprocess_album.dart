import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/use_case/populate_album.dart';
import 'package:nc_photos/use_case/resync_album.dart';

/// Pre-process an album such that it's ready to be displayed
///
/// Internally, it'll dispatch the work depending on the album:
/// - with AlbumStaticProvider: [ResyncAlbum]
/// - with AlbumDynamicProvider/AlbumSmartProvider: [PopulateAlbum]
class PreProcessAlbum {
  PreProcessAlbum(this._c)
    : assert(require(_c)),
      assert(PopulateAlbum.require(_c));

  static bool require(DiContainer c) => true;

  Future<List<AlbumItem>> call(Account account, Album album) {
    if (album.provider is AlbumStaticProvider) {
      return ResyncAlbum(_c)(account, album);
    } else if (album.provider is AlbumDynamicProvider) {
      return PopulateAlbum(_c)(account, album);
    } else {
      throw ArgumentError(
        "Unknown album provider: ${album.provider.runtimeType}",
      );
    }
  }

  final DiContainer _c;
}
