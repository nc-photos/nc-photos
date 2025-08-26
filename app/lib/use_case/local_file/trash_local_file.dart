import 'package:logging/logging.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_log/np_log.dart';

part 'trash_local_file.g.dart';

@npLog
class TrashLocalFile {
  TrashLocalFile(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.localFileRepo);

  Future<void> call(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) async {
    final trashed = List.of(files);
    await _c.localFileRepo.trashFiles(
      files,
      onFailure: (f, e, stackTrace) {
        trashed.removeWhere((d) => d.compareIdentity(f));
        onFailure?.call(f, e, stackTrace);
      },
    );
    if (trashed.isNotEmpty) {
      _log.info("[call] Trashed ${trashed.length} files successfully");
    }
  }

  final DiContainer _c;
}
