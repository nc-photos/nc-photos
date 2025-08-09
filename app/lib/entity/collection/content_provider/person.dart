import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:np_common/object_util.dart';

class CollectionPersonProvider
    with EquatableMixin
    implements CollectionContentProvider {
  const CollectionPersonProvider({required this.account, required this.person});

  @override
  String get fourCc => "PERS";

  @override
  String get id => person.id;

  @override
  int? get count => person.count;

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
  }) {
    final result = person.getCoverUrl(
      width,
      height,
      isKeepAspectRatio: isKeepAspectRatio,
    );
    return result?.let((e) => CollectionCoverResult(url: e.url, mime: e.mime));
  }

  @override
  bool get isDynamicCollection => true;

  @override
  bool get isPendingSharedAlbum => false;

  @override
  bool get isOwned => true;

  @override
  List<Object?> get props => [account, person];

  final Account account;
  final Person person;
}
