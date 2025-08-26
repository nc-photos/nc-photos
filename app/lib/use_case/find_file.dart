import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'find_file.g.dart';

@npLog
class FindFile {
  const FindFile(this._c);

  /// Find list of files in the DB by [fileIds]
  ///
  /// If an id is not found, [onFileNotFound] will be called. If
  /// [onFileNotFound] is null, a [StateError] will be thrown
  Future<List<File>> call(
    Account account,
    Iterable<int> fileIds, {
    void Function(int fileId)? onFileNotFound,
  }) async {
    _log.info("[call] fileIds: ${fileIds.toReadableString()}");
    final results = await _c.npDb.getFilesByFileIds(
      account: account.toDb(),
      fileIds: fileIds,
    );
    final files =
        results
            .map((e) => DbFileConverter.fromDb(account.userId.toString(), e))
            .toList();
    final fileMap = <int, File>{};
    for (final f in files) {
      fileMap[f.fileId!] = f;
    }

    return () sync* {
      for (final id in fileIds) {
        final f = fileMap[id];
        if (f == null) {
          if (onFileNotFound == null) {
            throw StateError("File ID not found: $id");
          } else {
            onFileNotFound(id);
          }
        } else {
          yield fileMap[id]!;
        }
      }
    }().toList();
  }

  final DiContainer _c;
}
