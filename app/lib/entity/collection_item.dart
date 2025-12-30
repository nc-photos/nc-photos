import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_gps_map/np_gps_map.dart';

/// An item in a [Collection]
abstract class CollectionItem {
  const CollectionItem();

  /// An object used to identify this instance
  ///
  /// [id] should be unique and stable
  Object get id;
}

abstract class CollectionFileItem implements CollectionItem {
  const CollectionFileItem();

  CollectionFileItem copyWith({FileDescriptor? file});

  FileDescriptor get file;
}

abstract class CollectionLabelItem implements CollectionItem {
  const CollectionLabelItem();

  String get text;
}

abstract class CollectionMapItem implements CollectionItem {
  const CollectionMapItem();

  CameraPosition get location;
}
