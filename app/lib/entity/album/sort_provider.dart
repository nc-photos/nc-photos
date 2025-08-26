import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/collection_item/album_item_adapter.dart';
import 'package:nc_photos/entity/collection_item/sorter.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'sort_provider.g.dart';

@npLog
abstract class AlbumSortProvider with EquatableMixin {
  const AlbumSortProvider();

  factory AlbumSortProvider.fromJson(JsonObj json) {
    final type = json["type"];
    final content = json["content"];
    switch (type) {
      case AlbumNullSortProvider._type:
        return AlbumNullSortProvider.fromJson(content.cast<String, dynamic>());
      case AlbumTimeSortProvider._type:
        return AlbumTimeSortProvider.fromJson(content.cast<String, dynamic>());
      case AlbumFilenameSortProvider._type:
        return AlbumFilenameSortProvider.fromJson(
          content.cast<String, dynamic>(),
        );
      default:
        _log.shout("[fromJson] Unknown type: $type");
        throw ArgumentError.value(type, "type");
    }
  }

  factory AlbumSortProvider.fromCollectionItemSort(
    CollectionItemSort itemSort,
  ) {
    switch (itemSort) {
      case CollectionItemSort.manual:
        return const AlbumNullSortProvider();
      case CollectionItemSort.dateAscending:
        return const AlbumTimeSortProvider(isAscending: true);
      case CollectionItemSort.dateDescending:
        return const AlbumTimeSortProvider(isAscending: false);
      case CollectionItemSort.nameAscending:
        return const AlbumFilenameSortProvider(isAscending: true);
      case CollectionItemSort.nameDescending:
        return const AlbumFilenameSortProvider(isAscending: false);
    }
  }

  JsonObj toJson() {
    String getType() {
      if (this is AlbumNullSortProvider) {
        return AlbumNullSortProvider._type;
      } else if (this is AlbumTimeSortProvider) {
        return AlbumTimeSortProvider._type;
      } else if (this is AlbumFilenameSortProvider) {
        return AlbumFilenameSortProvider._type;
      } else {
        throw StateError("Unknwon subtype");
      }
    }

    return {"type": getType(), "content": _toContentJson()};
  }

  /// Return a sorted copy of [items]
  List<AlbumItem> sort(List<AlbumItem> items) {
    final type = toCollectionItemSort();
    final sorter = CollectionSorter.fromSortType(type);
    return sorter(
      items.map(AlbumAdaptedCollectionItem.fromItem).toList(),
    ).whereType<AlbumAdaptedCollectionItem>().map((e) => e.albumItem).toList();
  }

  CollectionItemSort toCollectionItemSort() {
    final that = this;
    if (that is AlbumNullSortProvider) {
      return CollectionItemSort.manual;
    } else if (that is AlbumTimeSortProvider) {
      return that.isAscending
          ? CollectionItemSort.dateAscending
          : CollectionItemSort.dateDescending;
    } else if (that is AlbumFilenameSortProvider) {
      return that.isAscending
          ? CollectionItemSort.nameAscending
          : CollectionItemSort.nameDescending;
    } else {
      throw StateError("Unknown type: ${sort.runtimeType}");
    }
  }

  JsonObj _toContentJson();

  static final _log = _$AlbumSortProviderNpLog.log;
}

/// Sort provider that does nothing
@toString
class AlbumNullSortProvider extends AlbumSortProvider {
  const AlbumNullSortProvider();

  factory AlbumNullSortProvider.fromJson(JsonObj json) {
    return const AlbumNullSortProvider();
  }

  @override
  String toString() => _$toString();

  @override
  get props => [];

  @override
  _toContentJson() {
    return {};
  }

  static const _type = "null";
}

abstract class AlbumReversibleSortProvider extends AlbumSortProvider {
  const AlbumReversibleSortProvider({required this.isAscending});

  @override
  get props => [isAscending];

  @override
  _toContentJson() {
    return {"isAscending": isAscending};
  }

  final bool isAscending;
}

/// Sort based on the time of the files
@toString
class AlbumTimeSortProvider extends AlbumReversibleSortProvider {
  const AlbumTimeSortProvider({required super.isAscending});

  factory AlbumTimeSortProvider.fromJson(JsonObj json) {
    return AlbumTimeSortProvider(isAscending: json["isAscending"] ?? true);
  }

  @override
  String toString() => _$toString();

  static const _type = "time";
}

/// Sort based on the name of the files
@toString
class AlbumFilenameSortProvider extends AlbumReversibleSortProvider {
  const AlbumFilenameSortProvider({required super.isAscending});

  factory AlbumFilenameSortProvider.fromJson(JsonObj json) {
    return AlbumFilenameSortProvider(isAscending: json["isAscending"] ?? true);
  }

  @override
  String toString() => _$toString();

  static const _type = "filename";
}
