import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/tag.dart';

class CollectionTagProvider
    with EquatableMixin
    implements CollectionContentProvider {
  CollectionTagProvider({required this.account, required this.tags})
    : assert(tags.isNotEmpty);

  @override
  String get fourCc => "TAG-";

  @override
  String get id => tags.first.displayName;

  @override
  int? get count => null;

  @override
  DateTime get lastModified => clock.now().toUtc();

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
  }) => null;

  @override
  bool get isDynamicCollection => true;

  @override
  bool get isPendingSharedAlbum => false;

  @override
  bool get isOwned => true;

  @override
  List<Object?> get props => [account, tags];

  final Account account;
  final List<Tag> tags;
}
