import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/nc_album_item.dart';
import 'package:to_string/to_string.dart';

part 'nc_album_item_adapter.g.dart';

@toString
class CollectionFileItemNcAlbumItemAdapter extends CollectionFileItem {
  const CollectionFileItemNcAlbumItemAdapter(this.item, [this.localFile]);

  @override
  CollectionFileItemNcAlbumItemAdapter copyWith({FileDescriptor? file}) {
    return CollectionFileItemNcAlbumItemAdapter(item, file ?? this.file);
  }

  @override
  String toString() => _$toString();

  @override
  FileDescriptor get file => localFile ?? item.toFile();

  final NcAlbumItem item;
  final FileDescriptor? localFile;
}
