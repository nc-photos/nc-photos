import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/use_case/update_album.dart';
import 'package:nc_photos/use_case/update_album_time.dart';
import 'package:nc_photos/use_case/update_auto_album_cover.dart';
import 'package:np_log/np_log.dart';

part 'update_album_with_actual_items.g.dart';

@npLog
class UpdateAlbumWithActualItems {
  UpdateAlbumWithActualItems(this.albumRepo);

  /// Update, if necessary, [album] after resynced/populated with actual items
  ///
  /// If [albumRepo] is null, the modified album will not be saved
  Future<Album> call(
      Account account, Album album, List<AlbumItem> items) async {
    final sortedItems =
        const AlbumTimeSortProvider(isAscending: false).sort(items);

    bool shouldUpdate = false;
    final albumUpdatedCover =
        UpdateAutoAlbumCover().updateWithSortedItems(album, sortedItems);
    if (!identical(albumUpdatedCover, album)) {
      _log.info("[call] Update album cover");
      shouldUpdate = true;
    }
    album = albumUpdatedCover;

    final albumUpdatedTime =
        UpdateAlbumTime().updateWithSortedItems(album, sortedItems);
    if (!identical(albumUpdatedTime, album)) {
      _log.info(
          "[call] Update album time: ${album.provider.latestItemTime} -> ${albumUpdatedTime.provider.latestItemTime}");
      shouldUpdate = true;
    }
    album = albumUpdatedTime;

    if (albumRepo != null && shouldUpdate) {
      _log.info("[call] Persist album");
      await UpdateAlbum(albumRepo!)(account, album);
    }
    return album;
  }

  final AlbumRepo? albumRepo;
}
