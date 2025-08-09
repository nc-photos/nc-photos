import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'util.g.dart';

enum CollectionSort {
  dateDescending,
  dateAscending,
  nameAscending,
  nameDescending;

  bool isAscending() {
    return this == CollectionSort.dateAscending ||
        this == CollectionSort.nameAscending;
  }
}

@toString
class CollectionShare with EquatableMixin {
  const CollectionShare({required this.userId, required this.username});

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [userId, username];

  final CiString userId;
  final String username;
}

enum CollectionShareResult { ok, partial }

extension CollectionListExtension on Iterable<Collection> {
  List<Collection> sortedBy(CollectionSort by) {
    return map<({Comparable comparable, Collection collection})>((e) {
          switch (by) {
            case CollectionSort.nameAscending:
            case CollectionSort.nameDescending:
              return (comparable: e.name.toLowerCase(), collection: e);

            case CollectionSort.dateAscending:
            case CollectionSort.dateDescending:
              return (
                comparable: e.contentProvider.lastModified,
                collection: e,
              );
          }
        })
        .sorted((a, b) {
          final x = by.isAscending() ? a : b;
          final y = by.isAscending() ? b : a;
          final tmp = x.comparable.compareTo(y.comparable);
          if (tmp != 0) {
            return tmp;
          } else {
            return x.collection.name.compareTo(y.collection.name);
          }
        })
        .map((e) => e.collection)
        .toList();
  }
}
