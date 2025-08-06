import 'package:flutter/foundation.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/sharee.dart';

class ShareCollection {
  const ShareCollection(this._c);

  /// Share the collection with [sharee]
  Future<CollectionShareResult> call(
    Account account,
    Collection collection,
    Sharee sharee, {
    required ValueChanged<Collection> onCollectionUpdated,
  }) => CollectionAdapter.of(
    _c,
    account,
    collection,
  ).share(sharee, onCollectionUpdated: onCollectionUpdated);

  final DiContainer _c;
}
