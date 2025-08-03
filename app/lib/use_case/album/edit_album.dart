import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/use_case/update_album.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';

part 'edit_album.g.dart';

@npLog
class EditAlbum {
  const EditAlbum(this._c);

  /// Modify an [album]
  Future<Album> call(
    Account account,
    Album album, {
    String? name,
    List<AlbumItem>? items,
    CollectionItemSort? itemSort,
    OrNull<FileDescriptor>? cover,
    List<AlbumItem>? knownItems,
  }) async {
    _log.info(
        "[call] Edit album ${album.name}, name: $name, items: $items, itemSort: $itemSort, cover: $cover");
    var newAlbum = album;
    if (name != null) {
      newAlbum = newAlbum.copyWith(name: name);
    }
    if (items != null) {
      if (album.provider is AlbumStaticProvider) {
        newAlbum = newAlbum.copyWith(
          provider: (album.provider as AlbumStaticProvider).copyWith(
            items: items,
          ),
        );
      }
    }
    if (itemSort != null) {
      newAlbum = newAlbum.copyWith(
        sortProvider: AlbumSortProvider.fromCollectionItemSort(itemSort),
      );
    }
    if (cover != null) {
      if (cover.obj == null) {
        final coverFile = _getCoverFile(knownItems);
        newAlbum = newAlbum.copyWith(
          coverProvider: AlbumAutoCoverProvider(coverFile: coverFile),
        );
      } else {
        newAlbum = newAlbum.copyWith(
          coverProvider: AlbumManualCoverProvider(coverFile: cover.obj!),
        );
      }
    }
    if (identical(newAlbum, album)) {
      return album;
    }
    await UpdateAlbum(_c.albumRepo)(account, newAlbum);
    return newAlbum;
  }

  FileDescriptor? _getCoverFile(List<AlbumItem>? items) {
    if (items?.isEmpty ?? true) {
      return null;
    } else {
      return AlbumAutoCoverProvider.getCoverByItems(items!);
    }
  }

  final DiContainer _c;
}
