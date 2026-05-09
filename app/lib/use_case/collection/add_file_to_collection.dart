import 'package:flutter/rendering.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_common/type.dart';

class AddFileToCollection {
  const AddFileToCollection(this._c);

  /// Add list of [files] to [collection] and return the added count
  Future<int> call(
    Account account,
    Collection collection,
    List<FileDescriptor> files, {
    ErrorWithValueHandler<FileDescriptor>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  }) {
    return CollectionWorkerFactory.addFiles(_c, account, collection).addFiles(
      files,
      onError: onError,
      onCollectionUpdated: onCollectionUpdated,
    );
  }

  final DiContainer _c;
}
