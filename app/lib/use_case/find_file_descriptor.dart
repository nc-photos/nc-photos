import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'find_file_descriptor.g.dart';

@npLog
class FindFileDescriptor {
  const FindFileDescriptor(this._c);

  /// Find list of files in the DB by [fileIds]
  ///
  /// If an id is not found, [onFileNotFound] will be called. If
  /// [onFileNotFound] is null, a [StateError] will be thrown
  Future<List<FileDescriptor>> call(
    Account account,
    List<int> fileIds, {
    void Function(int fileId)? onFileNotFound,
  }) async {
    _log.info("[call] fileIds: ${fileIds.toReadableString()}");
    final dbResults = await _c.npDb.getFileDescriptors(
      account: account.toDb(),
      fileIds: fileIds,
    );
    final files = dbResults
        .map((e) =>
            DbFileDescriptorConverter.fromDb(account.userId.toString(), e))
        .toList();
    final fileMap = <int, FileDescriptor>{};
    for (final f in files) {
      fileMap[f.fdId] = f;
    }

    final results = <FileDescriptor>[];
    for (final id in fileIds) {
      final f = fileMap[id];
      if (f == null) {
        if (onFileNotFound == null) {
          throw StateError("File ID not found: $id");
        } else {
          onFileNotFound(id);
        }
      } else {
        results.add(f);
      }
    }
    return results;
  }

  final DiContainer _c;
}
