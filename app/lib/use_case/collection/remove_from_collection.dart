import 'package:flutter/foundation.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:np_common/type.dart';

class RemoveFromCollection {
  const RemoveFromCollection(this._c);

  Future<int> call(
    Account account,
    Collection collection,
    List<CollectionItem> items, {
    ErrorWithValueIndexedHandler<CollectionItem>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  }) {
    return CollectionWorkerFactory.removeItems(
      _c,
      account,
      collection,
    ).removeItems(
      items,
      onError: onError,
      onCollectionUpdated: onCollectionUpdated,
    );
  }

  final DiContainer _c;
}
