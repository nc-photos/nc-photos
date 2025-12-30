import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:to_string/to_string.dart';

part 'album_item_adapter.g.dart';

mixin AlbumAdaptedCollectionItem on CollectionItem {
  static AlbumAdaptedCollectionItem fromItem(AlbumItem item) {
    if (item is AlbumFileItem) {
      return CollectionFileItemAlbumAdapter(item);
    } else if (item is AlbumLabelItem) {
      return CollectionLabelItemAlbumAdapter(item);
    } else if (item is AlbumMapItem) {
      return CollectionMapItemAlbumAdapter(item);
    } else {
      throw ArgumentError("Unknown type: ${item.runtimeType}");
    }
  }

  AlbumItem get albumItem;
}

@toString
class CollectionFileItemAlbumAdapter extends CollectionFileItem
    with AlbumAdaptedCollectionItem {
  const CollectionFileItemAlbumAdapter(this.item);

  @override
  CollectionFileItemAlbumAdapter copyWith({FileDescriptor? file}) {
    return CollectionFileItemAlbumAdapter(item.copyWith(file: file));
  }

  @override
  String toString() => _$toString();

  @override
  Object get id => file.fdId;

  @override
  FileDescriptor get file => item.file;

  @override
  AlbumItem get albumItem => item;

  final AlbumFileItem item;
}

@toString
class CollectionLabelItemAlbumAdapter extends CollectionLabelItem
    with AlbumAdaptedCollectionItem {
  const CollectionLabelItemAlbumAdapter(this.item);

  @override
  String toString() => _$toString();

  @override
  Object get id => item.addedAt;

  @override
  String get text => item.text;

  @override
  AlbumItem get albumItem => item;

  final AlbumLabelItem item;
}

@toString
class CollectionMapItemAlbumAdapter extends CollectionMapItem
    with AlbumAdaptedCollectionItem {
  const CollectionMapItemAlbumAdapter(this.item);

  @override
  String toString() => _$toString();

  @override
  Object get id => item.addedAt;

  @override
  CameraPosition get location => item.location;

  @override
  AlbumItem get albumItem => item;

  final AlbumMapItem item;
}
