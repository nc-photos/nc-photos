import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/use_case/find_file_descriptor.dart';
import 'package:nc_photos/use_case/local_file/find_local_file.dart';
import 'package:np_log/np_log.dart';

part 'find_any_file.g.dart';

@npLog
class FindAnyFile {
  const FindAnyFile(this._c, {required this.prefController});

  Future<List<AnyFile>> call(
    Account account,
    List<String> afIds, {
    void Function(String fileId)? onFileNotFound,
  }) async {
    final (remote, local) = await handleAnyFileIdByType(
      afIds,
      nextcloudHandler:
          (ids) => FindFileDescriptor(_c)(
            account,
            ids.map((e) => e.fileId).toList(),
            onFileNotFound: (fileId) {
              onFileNotFound?.call(
                ids.firstWhere((e) => e.fileId == fileId).afId,
              );
            },
          ),
      localHandler:
          (ids) => FindLocalFile(
            localFileRepo: _c.localFileRepo,
            prefController: prefController,
          )(
            ids.map((e) => e.fileId).toList(),
            onFileNotFound: (fileId) {
              onFileNotFound?.call(
                ids.firstWhere((e) => e.fileId == fileId).afId,
              );
            },
          ),
    );
    final fileMap = <String, AnyFile>{};
    for (final f in remote.map((e) => e.toAnyFile())) {
      fileMap[f.id] = f;
    }
    for (final f in local.map((e) => e.toAnyFile())) {
      fileMap[f.id] = f;
    }

    final results = <AnyFile>[];
    for (final id in afIds) {
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
  final PrefController prefController;
}
