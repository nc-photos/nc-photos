import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;

class UpdateAutoAlbumCover {
  /// Update the AlbumAutoCoverProvider of an album with unsorted items
  ///
  /// If no updates are needed, return the same object
  Album call(Album album, List<AlbumItem> items) {
    if (album.coverProvider is! AlbumAutoCoverProvider) {
      return album;
    } else {
      final sortedItems = const AlbumTimeSortProvider(
        isAscending: false,
      ).sort(items);
      return _updateWithSortedItems(album, sortedItems);
    }
  }

  /// Update the AlbumAutoCoverProvider of an album with pre-sorted files
  ///
  /// The album items are expected to be sorted by [AlbumTimeSortProvider] with
  /// isAscending = false, otherwise please call the unsorted version. If no
  /// updates are needed, return the same object
  Album updateWithSortedItems(Album album, List<AlbumItem> sortedItems) {
    if (album.coverProvider is! AlbumAutoCoverProvider) {
      return album;
    } else {
      return _updateWithSortedItems(album, sortedItems);
    }
  }

  Album _updateWithSortedItems(Album album, List<AlbumItem> sortedItems) {
    if (sortedItems.isEmpty) {
      if (album.coverProvider != const AlbumAutoCoverProvider()) {
        return album.copyWith(coverProvider: const AlbumAutoCoverProvider());
      } else {
        return album;
      }
    }

    try {
      final coverFile =
          sortedItems
              .whereType<AlbumFileItem>()
              .map((e) => e.file)
              .where(file_util.isSupportedFormat)
              .first;
      // cache the result for later use
      if ((album.coverProvider as AlbumAutoCoverProvider).coverFile
              ?.compareServerIdentity(coverFile) !=
          true) {
        return album.copyWith(
          coverProvider: AlbumAutoCoverProvider(coverFile: coverFile),
        );
      }
    } on StateError catch (_) {
      // no files
    }
    return album;
  }
}
