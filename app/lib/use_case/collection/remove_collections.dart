import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'remove_collections.g.dart';

@npLog
class RemoveCollections {
  RemoveCollections(this._c) : assert(require(_c));

  static bool require(DiContainer c) => true;

  /// Remove [collections] and return the removed count
  ///
  /// If [onError] is not null, you'll get notified about the errors. The future
  /// will always complete normally
  Future<int> call(
    Account account,
    List<Collection> collections, {
    ErrorWithValueHandler<Collection>? onError,
  }) async {
    var failed = 0;
    final futures = Future.wait(
      collections.map((c) {
        return CollectionAdapter.of(_c, account, c).remove().catchError((
          e,
          stackTrace,
        ) {
          ++failed;
          onError?.call(c, e, stackTrace);
        });
      }),
    );
    await futures;
    if (failed > 0) {
      _log.warning("[call] Failed removing $failed collections");
    }
    return collections.length - failed;
  }

  final DiContainer _c;
}
