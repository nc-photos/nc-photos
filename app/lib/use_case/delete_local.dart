import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/event/event.dart';
import 'package:np_log/np_log.dart';

part 'delete_local.g.dart';

@npLog
class DeleteLocal {
  DeleteLocal(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.localFileRepo);

  Future<void> call(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) async {
    final deleted = List.of(files);
    await _c.localFileRepo.deleteFiles(
      files,
      onFailure: (f, e, stackTrace) {
        deleted.removeWhere((d) => d.compareIdentity(f));
        onFailure?.call(f, e, stackTrace);
      },
    );
    if (deleted.isNotEmpty) {
      _log.info("[call] Deleted ${deleted.length} files successfully");
      KiwiContainer().resolve<EventBus>().fire(LocalFileDeletedEvent(deleted));
    }
  }

  final DiContainer _c;
}
