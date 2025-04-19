import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/size.dart';
import 'package:to_string/to_string.dart';

part 'memory.g.dart';

@toString
class CollectionMemoryProvider
    with EquatableMixin
    implements CollectionContentProvider {
  const CollectionMemoryProvider({
    required this.account,
    required this.year,
    required this.month,
    required this.day,
    this.cover,
  });

  @override
  String get fourCc => "MEMY";

  @override
  String get id => "$year-$month-$day";

  @override
  int? get count => null;

  @override
  DateTime get lastModified => DateTime(year, month, day);

  @override
  List<CollectionCapability> get capabilities => [
        CollectionCapability.deleteItem,
      ];

  @override
  CollectionItemSort get itemSort => CollectionItemSort.dateDescending;

  @override
  List<CollectionShare> get shares => [];

  @override
  CollectionCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  }) {
    return cover?.let((cover) => CollectionCoverResult(
          url: getStaticViewUrlForImageFile(
            account,
            cover,
            size: SizeInt(width, height),
            isKeepAspectRatio: isKeepAspectRatio ?? false,
          ),
          mime: cover.fdMime,
        ));
  }

  @override
  bool get isDynamicCollection => true;

  @override
  bool get isPendingSharedAlbum => false;

  @override
  bool get isOwned => true;

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [account, year, month, day, cover];

  final Account account;
  final int year;
  final int month;
  final int day;
  final FileDescriptor? cover;
}
