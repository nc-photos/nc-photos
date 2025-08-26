import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:to_string/to_string.dart';

part 'nc_album.g.dart';

/// Album provided by our app
@genCopyWith
@toString
class CollectionNcAlbumProvider
    with EquatableMixin
    implements CollectionContentProvider {
  const CollectionNcAlbumProvider({required this.account, required this.album});

  @override
  String toString() => _$toString();

  @override
  String get fourCc => "NC25";

  @override
  String get id => album.path;

  @override
  int? get count => album.count;

  @override
  DateTime get lastModified => album.dateEnd ?? clock.now().toUtc();

  @override
  List<CollectionCapability> get capabilities => [
    CollectionCapability.manualItem,
    CollectionCapability.rename,
    // CollectionCapability.share,
  ];

  /// Capabilities when this album is shared to this user by someone else
  List<CollectionCapability> get guestCapabilities => [
    CollectionCapability.manualItem,
  ];

  @override
  CollectionItemSort get itemSort => CollectionItemSort.dateDescending;

  @override
  List<CollectionShare> get shares =>
      album.collaborators
          .map((c) => CollectionShare(userId: c.id, username: c.label))
          .toList();

  @override
  CollectionCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  }) {
    if (album.lastPhoto == null) {
      return null;
    } else {
      return CollectionCoverResult(
        url: api_util.getPhotosApiFilePreviewUrlByFileId(
          account,
          album.lastPhoto!,
          width: width,
          height: height,
        ),
        mime: null,
      );
    }
  }

  @override
  bool get isDynamicCollection => false;

  @override
  bool get isPendingSharedAlbum => false;

  @override
  bool get isOwned => album.isOwned;

  @override
  List<Object?> get props => [account, album];

  final Account account;
  final NcAlbum album;
}
