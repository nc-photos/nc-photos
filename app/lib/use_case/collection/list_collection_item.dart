import 'dart:async';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection_item.dart';

class ListCollectionItem {
  const ListCollectionItem(this._c);

  Stream<List<CollectionItem>> call(
    Account account,
    Collection collection, {
    required bool shouldUseRecognizeApiKey,
  }) => CollectionWorkerFactory.listItem(
    _c,
    account,
    collection,
    shouldUseRecognizeApiKey: shouldUseRecognizeApiKey,
  ).listItem();

  final DiContainer _c;
}
