import 'package:flutter/foundation.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:np_string/np_string.dart';

class UnshareCollection {
  const UnshareCollection(this._c);

  /// Unshare the collection with a user
  Future<CollectionShareResult> call(
    Account account,
    Collection collection,
    CiString userId, {
    required ValueChanged<Collection> onCollectionUpdated,
  }) => CollectionAdapter.of(
    _c,
    account,
    collection,
  ).unshare(userId, onCollectionUpdated: onCollectionUpdated);

  final DiContainer _c;
}
