import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'sorter.g.dart';

abstract class CollectionSorter {
  const CollectionSorter();

  static CollectionSorter fromSortType(CollectionItemSort type) {
    switch (type) {
      case CollectionItemSort.dateDescending:
        return const CollectionTimeSorter(isAscending: false);
      case CollectionItemSort.dateAscending:
        return const CollectionTimeSorter(isAscending: true);
      case CollectionItemSort.nameAscending:
        return const CollectionFilenameSorter(isAscending: true);
      case CollectionItemSort.nameDescending:
        return const CollectionFilenameSorter(isAscending: false);
      case CollectionItemSort.manual:
        return const CollectionNullSorter();
    }
  }

  /// Return a sorted copy of [items]
  List<CollectionItem> call(List<CollectionItem> items);
}

/// Sort provider that does nothing
class CollectionNullSorter implements CollectionSorter {
  const CollectionNullSorter();

  @override
  List<CollectionItem> call(List<CollectionItem> items) {
    return List.of(items);
  }
}

/// Sort based on the time of the files
class CollectionTimeSorter implements CollectionSorter {
  const CollectionTimeSorter({
    required this.isAscending,
  });

  @override
  List<CollectionItem> call(List<CollectionItem> items) {
    DateTime? prevFileTime;
    return items
        .map((e) {
          if (e is CollectionFileItem) {
            // take the file time
            prevFileTime = e.file.fdDateTime;
          }
          // for non file items, use the sibling file's time
          return (dateTime: prevFileTime, item: e);
        })
        .stableSorted((x, y) {
          if (x.dateTime == null && y.dateTime == null) {
            return 0;
          } else if (x.dateTime == null) {
            return -1;
          } else if (y.dateTime == null) {
            return 1;
          } else {
            if (isAscending) {
              return x.dateTime!.compareTo(y.dateTime!);
            } else {
              return y.dateTime!.compareTo(x.dateTime!);
            }
          }
        })
        .map((e) => e.item)
        .toList();
  }

  final bool isAscending;
}

/// Sort based on the name of the files
class CollectionFilenameSorter implements CollectionSorter {
  const CollectionFilenameSorter({
    required this.isAscending,
  });

  @override
  List<CollectionItem> call(List<CollectionItem> items) {
    String? prevFilename;
    return items
        .map((e) {
          if (e is CollectionFileItem) {
            // take the file name
            prevFilename = e.file.filename;
          }
          // for non file items, use the sibling file's name
          return (dateTime: prevFilename, item: e);
        })
        .stableSorted((x, y) {
          if (x.dateTime == null && y.dateTime == null) {
            return 0;
          } else if (x.dateTime == null) {
            return -1;
          } else if (y.dateTime == null) {
            return 1;
          } else {
            if (isAscending) {
              return compareNatural(x.dateTime!, y.dateTime!);
            } else {
              return compareNatural(y.dateTime!, x.dateTime!);
            }
          }
        })
        .map((e) => e.item)
        .toList();
  }

  final bool isAscending;
}

@npLog
class CollectionAlbumSortAdapter implements CollectionSorter {
  const CollectionAlbumSortAdapter(this.sort);

  @override
  List<CollectionItem> call(List<CollectionItem> items) {
    final CollectionSorter sorter;
    if (sort is AlbumNullSortProvider) {
      sorter = const CollectionNullSorter();
    } else if (sort is AlbumTimeSortProvider) {
      sorter = CollectionTimeSorter(
          isAscending: (sort as AlbumTimeSortProvider).isAscending);
    } else if (sort is AlbumFilenameSortProvider) {
      sorter = CollectionFilenameSorter(
          isAscending: (sort as AlbumFilenameSortProvider).isAscending);
    } else {
      _log.shout("[call] Unknown type: ${sort.runtimeType}");
      throw UnsupportedError("Unknown type: ${sort.runtimeType}");
    }
    return sorter(items);
  }

  final AlbumSortProvider sort;
}
