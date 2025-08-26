import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/use_case/remove.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'remove_from_nc_album.g.dart';

@npLog
class RemoveFromNcAlbum {
  RemoveFromNcAlbum(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.fileRepo);

  Future<int> call(
    Account account,
    NcAlbum album,
    List<CollectionItem> items, {
    ErrorWithValueIndexedHandler<CollectionItem>? onError,
  }) async {
    _log.info(
      "[call] Remove ${items.length} items from album '${album.strippedPath}'",
    );
    final fileItems =
        items
            .whereIndexed((i, e) {
              if (e is! CollectionFileItem) {
                onError?.call(
                  i,
                  e,
                  UnsupportedError("Item type not supported: ${e.runtimeType}"),
                  StackTrace.current,
                );
                return false;
              } else {
                return true;
              }
            })
            .cast<CollectionFileItem>()
            // since nextcloud album uses the DELETE method, we must make sure we
            // are "deleting" with an album path, not the actual file path
            .where((e) {
              if (file_util.isNcAlbumFile(account, e.file)) {
                return true;
              } else {
                _log.warning("[call] Wrong path for files in Nextcloud album");
                return false;
              }
            })
            .toList();
    var count = fileItems.length;
    await Remove(_c)(
      account,
      fileItems.map((e) => e.file).toList(),
      shouldCleanUp: false,
      onError: (i, f, e, stackTrace) {
        --count;
        try {
          onError?.call(i, fileItems[i], e, stackTrace);
        } catch (e, stackTrace) {
          _log.severe(
            "[call] Failed file not found: ${logFilename(f.strippedPath)}",
            e,
            stackTrace,
          );
        }
      },
    );
    return count;
  }

  final DiContainer _c;
}
