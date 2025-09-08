import 'package:logging/logging.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/entity/local_file/repo.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'find_local_file.g.dart';

@npLog
class FindLocalFile {
  const FindLocalFile({
    required this.localFileRepo,
    required this.prefController,
  });

  Future<List<LocalFile>> call(
    List<String> fileIds, {
    void Function(String fileId)? onFileNotFound,
  }) async {
    _log.info(
      "[call] fileIds: (length: ${fileIds.length}) ${fileIds.toReadableString(truncate: 10)}...",
    );
    final List<LocalFile> rawFiles;
    if (prefController.isEnableLocalFileValue) {
      rawFiles = await localFileRepo.getFiles(fileIds: fileIds);
    } else {
      rawFiles = const [];
    }
    final fileMap = <String, LocalFile>{};
    for (final f in rawFiles) {
      fileMap[f.id] = f;
    }

    final results = <LocalFile>[];
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

  final LocalFileRepo localFileRepo;
  final PrefController prefController;
}
