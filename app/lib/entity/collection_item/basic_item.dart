import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:to_string/to_string.dart';

part 'basic_item.g.dart';

/// The basic form of [CollectionFileItem]
@toString
class BasicCollectionFileItem implements CollectionFileItem {
  const BasicCollectionFileItem(this.file);

  @override
  BasicCollectionFileItem copyWith({FileDescriptor? file}) {
    return BasicCollectionFileItem(file ?? this.file);
  }

  @override
  String toString() => _$toString();

  @override
  final FileDescriptor file;
}
