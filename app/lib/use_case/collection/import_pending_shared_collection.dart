import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';

class ImportPendingSharedCollection {
  const ImportPendingSharedCollection(this._c);

  /// Import a pending shared collection to the app
  ///
  /// For some implementations, shared collection may live in a temporary
  /// state before being accepted by the user. This use case will accept the
  /// share and import the collection to the collections view
  Future<Collection> call(Account account, Collection collection) =>
      CollectionWorkerFactory.importPendingShared(
        _c,
        account,
        collection,
      ).importPendingShared();

  final DiContainer _c;
}
