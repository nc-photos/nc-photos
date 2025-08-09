import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/use_case/list_tagged_file.dart';
import 'package:nc_photos/use_case/scan_dir.dart';
import 'package:np_log/np_log.dart';

part 'populate_album.g.dart';

@npLog
class PopulateAlbum {
  PopulateAlbum(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.fileRepo);

  Future<List<AlbumItem>> call(Account account, Album album) async {
    if (album.provider is AlbumStaticProvider) {
      _log.warning(
        "[call] Populate only make sense for dynamic albums: ${album.name}",
      );
      return AlbumStaticProvider.of(album).items;
    } else if (album.provider is AlbumDirProvider) {
      return _populateDirAlbum(account, album);
    } else if (album.provider is AlbumTagProvider) {
      return _populateTagAlbum(account, album);
    } else {
      throw ArgumentError(
        "Unknown album provider: ${album.provider.runtimeType}",
      );
    }
  }

  Future<List<AlbumItem>> _populateDirAlbum(
    Account account,
    Album album,
  ) async {
    assert(album.provider is AlbumDirProvider);
    final provider = album.provider as AlbumDirProvider;
    final products = <AlbumItem>[];
    var hasGood = false;
    ExceptionEvent? firstException;
    for (final d in provider.dirs) {
      final stream = ScanDir(_c.fileRepo)(account, d);
      await for (final result in stream) {
        if (result is ExceptionEvent) {
          _log.severe(
            "[_populateDirAlbum] Failed while scanning dir: ${logFilename(d.path)}",
            result.error,
            result.stackTrace,
          );
          firstException = result;
          continue;
        }
        products.addAll(
          (result as List).cast<File>().map(
            (f) => AlbumFileItem(
              addedBy: account.userId,
              addedAt: clock.now(),
              file: f,
              ownerId: f.ownerId ?? account.userId,
            ),
          ),
        );
        hasGood = true;
      }
    }
    if (!hasGood && firstException != null) {
      firstException.throwMe();
    }
    return products;
  }

  Future<List<AlbumItem>> _populateTagAlbum(
    Account account,
    Album album,
  ) async {
    assert(album.provider is AlbumTagProvider);
    final provider = album.provider as AlbumTagProvider;
    final products = <AlbumItem>[];
    final files = await ListTaggedFile(_c)(account, provider.tags);
    products.addAll(
      files.map(
        (f) => AlbumFileItem(
          addedBy: account.userId,
          addedAt: clock.now(),
          file: f,
          ownerId: f.ownerId ?? account.userId,
        ),
      ),
    );
    return products;
  }

  final DiContainer _c;
}
