import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/use_case/move.dart';

class RestoreTrashbin {
  RestoreTrashbin(this._c) : assert(require(_c)), assert(Move.require(_c));

  static bool require(DiContainer c) => true;

  Future<void> call(Account account, File file) async {
    // we don't cache the trashbin
    await Move(_c.withRemoteRepo())(
      account,
      file,
      "remote.php/dav/trashbin/${account.userId}/restore/${file.filename}",
      shouldOverwrite: true,
    );
    KiwiContainer().resolve<EventBus>().fire(
      FileTrashbinRestoredEvent(account, file),
    );
  }

  final DiContainer _c;
}
