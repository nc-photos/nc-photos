import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/use_case/create_dir.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;

part 'move.g.dart';

@npLog
class Move {
  Move(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.fileRepo);

  /// Move a file from its original location to [destination]
  Future<void> call(
    Account account,
    File file,
    String destination, {
    bool shouldCreateMissingDir = false,
    bool shouldOverwrite = false,
    bool shouldRenameOnOverwrite = false,
  }) => _doWork(
    account,
    file,
    destination,
    shouldCreateMissingDir: shouldCreateMissingDir,
    shouldOverwrite: shouldOverwrite,
    shouldRenameOnOverwrite: shouldRenameOnOverwrite,
  );

  Future<void> _doWork(
    Account account,
    File file,
    String destination, {
    required bool shouldCreateMissingDir,
    required bool shouldOverwrite,
    required bool shouldRenameOnOverwrite,
    int retryCount = 1,
  }) async {
    final to = _renameDestination(destination, retryCount);
    if (retryCount > 1) {
      _log.info("[call] Retry with: '$to'");
    }
    try {
      await _c.fileRepo.move(
        account,
        file,
        to,
        shouldOverwrite: shouldOverwrite,
      );
    } catch (e) {
      if (e is ApiException) {
        if (e.response.statusCode == 409 && shouldCreateMissingDir) {
          // no dir
          _log.info("[call] Auto creating parent dirs");
          await CreateDir(_c.fileRepo)(account, path_lib.dirname(to));
          await _c.fileRepo.move(
            account,
            file,
            to,
            shouldOverwrite: shouldOverwrite,
          );
        } else if (e.response.statusCode == 412 && shouldRenameOnOverwrite) {
          return _doWork(
            account,
            file,
            to,
            shouldCreateMissingDir: shouldCreateMissingDir,
            shouldOverwrite: shouldOverwrite,
            shouldRenameOnOverwrite: shouldRenameOnOverwrite,
            retryCount: retryCount + 1,
          );
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
    KiwiContainer().resolve<EventBus>().fire(
      FileMovedEvent(account, file, destination),
    );
  }

  String _renameDestination(String destination, int retryCount) {
    if (retryCount < 2) {
      return destination;
    }
    final newName = file_util.renameConflict(
      path_lib.basename(destination),
      retryCount,
    );
    return "${path_lib.dirname(destination)}/$newName";
  }

  final DiContainer _c;
}
