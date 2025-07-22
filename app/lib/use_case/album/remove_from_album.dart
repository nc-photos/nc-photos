import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/use_case/album/unshare_file_from_album.dart';
import 'package:nc_photos/use_case/preprocess_album.dart';
import 'package:nc_photos/use_case/update_album.dart';
import 'package:nc_photos/use_case/update_album_with_actual_items.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'remove_from_album.g.dart';

@npLog
class RemoveFromAlbum {
  RemoveFromAlbum(this._c)
      : assert(require(_c)),
        assert(UnshareFileFromAlbum.require(_c)),
        assert(PreProcessAlbum.require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.albumRepo);

  /// Remove a list of AlbumItems from [album]
  ///
  /// If [shouldUnshare] is false, files will not be unshared after removing
  /// from the album
  Future<Album> call(
    Account account,
    Album album,
    List<AlbumItem> items, {
    bool shouldUnshare = true,
    ErrorWithValueIndexedHandler<AlbumItem>? onError,
  }) async {
    _log.info("[call] Remove ${items.length} items from album '${album.name}'");
    assert(album.provider is AlbumStaticProvider);

    final filtered = items
        .mapIndexed((i, e) {
          if (album.albumFile!.isOwned(account.userId) ||
              e.addedBy == account.userId) {
            return e;
          } else {
            onError?.call(
              i,
              e,
              const AlbumItemPermissionException(
                  "No permission to remove item"),
              StackTrace.current,
            );
            return null;
          }
        })
        .nonNulls
        .toList();
    final provider = album.provider as AlbumStaticProvider;
    final newItems = provider.items
        .where((e) =>
            !filtered.containsIf(e, (a, b) => a.compareServerIdentity(b)))
        .toList();
    var newAlbum = album.copyWith(
      provider: AlbumStaticProvider.of(album).copyWith(
        items: newItems,
      ),
    );
    newAlbum = await _fixAlbumPostRemove(account, newAlbum, filtered);
    // TODO catch and use onError
    await UpdateAlbum(_c.albumRepo)(account, newAlbum);

    if (!shouldUnshare) {
      _log.info("[call] Skip unsharing files");
    } else {
      if (album.shares?.isNotEmpty == true) {
        final removeFiles =
            filtered.whereType<AlbumFileItem>().map((e) => e.file).toList();
        if (removeFiles.isNotEmpty) {
          await _unshareFiles(account, newAlbum, removeFiles);
        }
      }
    }

    return newAlbum;
  }

  /// Update the album accordingly if any of the removed items is interesting
  /// (e.g., cover, latest item, etc)
  Future<Album> _fixAlbumPostRemove(
      Account account, Album newAlbum, List<AlbumItem> items) async {
    bool isNeedUpdate = false;
    for (final fileItem in items.whereType<AlbumFileItem>()) {
      if (newAlbum.coverProvider
              .getCover(newAlbum)
              ?.compareServerIdentity(fileItem.file) ==
          true) {
        // revert to auto cover so [UpdateAutoAlbumCover] can do its work
        newAlbum = newAlbum.copyWith(
          coverProvider: const AlbumAutoCoverProvider(),
        );
        isNeedUpdate = true;
        break;
      }
      if (fileItem.file.fdDateTime == newAlbum.provider.latestItemTime) {
        isNeedUpdate = true;
        break;
      }
    }
    if (!isNeedUpdate) {
      return newAlbum;
    }

    _log.info(
        "[_fixAlbumPostRemove] Resync as interesting item is being removed");
    // need to update the album properties
    final newItemsSynced = await PreProcessAlbum(_c)(account, newAlbum);
    newAlbum = await UpdateAlbumWithActualItems(null)(
      account,
      newAlbum,
      newItemsSynced,
    );
    return newAlbum;
  }

  Future<void> _unshareFiles(
      Account account, Album album, List<FileDescriptor> files) async {
    final albumShares = (album.shares!.map((e) => e.userId).toList()
          ..add(album.albumFile!.ownerId ?? account.userId))
        .where((element) => element != account.userId)
        .toList();
    if (albumShares.isNotEmpty) {
      await UnshareFileFromAlbum(_c)(account, album, files, albumShares);
    }
  }

  final DiContainer _c;
}
