import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:np_common/or_null.dart';

class UpdateAlbumTime {
  /// Update the latest item time of an album with unsorted items
  ///
  /// If no updates are needed, return the same object
  Album call(Album album, List<AlbumItem> items) {
    if (album.provider is! AlbumProviderBase) {
      return album;
    } else {
      final sortedItems = const AlbumTimeSortProvider(
        isAscending: false,
      ).sort(items);
      return _updateWithSortedItems(album, sortedItems);
    }
  }

  /// Update the latest item time of an album with pre-sorted files
  ///
  /// The album items are expected to be sorted by [AlbumTimeSortProvider] with
  /// isAscending = false, otherwise please call the unsorted version. If no
  /// updates are needed, return the same object
  Album updateWithSortedItems(Album album, List<AlbumItem> sortedItems) {
    if (album.provider is! AlbumProviderBase) {
      return album;
    } else {
      return _updateWithSortedItems(album, sortedItems);
    }
  }

  Album _updateWithSortedItems(Album album, List<AlbumItem> sortedItems) {
    if (sortedItems.isEmpty) {
      return album.copyWith(
        provider: (album.provider as AlbumProviderBase).copyWith(
          latestItemTime: const OrNull(null),
        ),
      );
    }

    DateTime? latestItemTime;
    try {
      final latestFile =
          sortedItems
              .whereType<AlbumFileItem>()
              .map((e) => e.file)
              .where((element) => file_util.isSupportedFormat(element))
              .first;
      latestItemTime = latestFile.fdDateTime;
    } catch (_) {
      latestItemTime = null;
    }
    if (latestItemTime != album.provider.latestItemTime) {
      return album.copyWith(
        provider: (album.provider as AlbumProviderBase).copyWith(
          latestItemTime: OrNull(latestItemTime),
        ),
      );
    }
    return album;
  }
}
