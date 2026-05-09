import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection_item.dart';

class UpdateCollectionPostLoad {
  const UpdateCollectionPostLoad(this._c);

  /// Update the collection after its items are loaded if necessary
  ///
  /// Return a new collection if its updated, otherwise null
  Future<Collection?> call(
    Account account,
    Collection collection,
    List<CollectionItem> items,
  ) {
    return CollectionWorkerFactory.updatePostLoad(
      _c,
      account,
      collection,
    ).updatePostLoad(items);
  }

  final DiContainer _c;
}
