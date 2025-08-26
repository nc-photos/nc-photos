import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:np_common/size.dart';
import 'package:to_string/to_string.dart';

part 'album.g.dart';

/// Album provided by our app
@genCopyWith
@toString
class CollectionAlbumProvider
    with EquatableMixin
    implements CollectionContentProvider {
  const CollectionAlbumProvider({required this.account, required this.album});

  @override
  String toString() => _$toString();

  @override
  String get fourCc => "ALBM";

  @override
  String get id => album.albumFile!.fileId!.toString();

  @override
  int? get count {
    if (album.provider is AlbumStaticProvider) {
      return (album.provider as AlbumStaticProvider).items.length;
    } else {
      return null;
    }
  }

  @override
  DateTime get lastModified =>
      album.provider.latestItemTime ?? album.lastUpdated;

  @override
  List<CollectionCapability> get capabilities => [
    CollectionCapability.sort,
    CollectionCapability.rename,
    CollectionCapability.manualCover,
    CollectionCapability.deleteItem,
    if (album.provider is AlbumStaticProvider) ...[
      CollectionCapability.manualItem,
      CollectionCapability.manualSort,
      CollectionCapability.labelItem,
      CollectionCapability.mapItem,
      CollectionCapability.share,
    ],
  ];

  /// Capabilities when this album is shared to this user by someone else
  List<CollectionCapability> get guestCapabilities => [
    CollectionCapability.deleteItem,
    if (album.provider is AlbumStaticProvider) ...[
      CollectionCapability.manualItem,
      CollectionCapability.labelItem,
      CollectionCapability.mapItem,
    ],
  ];

  @override
  CollectionItemSort get itemSort => album.sortProvider.toCollectionItemSort();

  @override
  List<CollectionShare> get shares =>
      album.shares
          ?.where((s) => s.userId != account.userId)
          .map(
            (s) => CollectionShare(
              userId: s.userId,
              username: s.displayName ?? s.userId.raw,
            ),
          )
          .toList() ??
      const [];

  @override
  CollectionCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  }) {
    final fd = album.coverProvider.getCover(album);
    if (fd == null) {
      return null;
    } else {
      return CollectionCoverResult(
        url: getStaticViewUrlForImageFile(
          account,
          fd,
          size: SizeInt(width, height),
          isKeepAspectRatio: isKeepAspectRatio ?? false,
        ),
        mime: fd.fdMime,
      );
    }
  }

  @override
  bool get isDynamicCollection => album.provider is! AlbumStaticProvider;

  @override
  bool get isPendingSharedAlbum =>
      album.albumFile?.path.startsWith(
        remote_storage_util.getRemotePendingSharedAlbumsDir(account),
      ) ==
      true;

  @override
  bool get isOwned => album.albumFile?.isOwned(account.userId) ?? true;

  @override
  List<Object?> get props => [account, album];

  final Account account;
  final Album album;
}
