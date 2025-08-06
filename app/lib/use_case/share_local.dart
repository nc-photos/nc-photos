import 'package:logging/logging.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_log/np_log.dart';

part 'share_local.g.dart';

@npLog
class ShareLocal {
  ShareLocal(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.localFileRepo);

  Future<void> call(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) async {
    var count = files.length;
    await _c.localFileRepo.shareFiles(
      files,
      onFailure: (f, e, stackTrace) {
        --count;
        onFailure?.call(f, e, stackTrace);
      },
    );
    _log.info("[call] Shared $count files successfully");
  }

  final DiContainer _c;
}
