import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_log/np_log.dart';

part 'scan_dir.g.dart';

@npLog
class ScanDir {
  ScanDir(this.fileRepo);

  /// List all files under a dir recursively
  Stream<dynamic> call(Account account, File root) async* {
    try {
      final items = await Ls(fileRepo)(account, root);
      yield items
          .where(
              (f) => f.isCollection != true && file_util.isSupportedFormat(f))
          .toList();
      for (final i in items.where((element) =>
          element.isCollection == true &&
          !element.path
              .endsWith(remote_storage_util.getRemoteStorageDir(account)))) {
        yield* this(account, i);
      }
    } on CacheNotFoundException catch (e, stackTrace) {
      _log.info("[call] Cache not found");
      yield ExceptionEvent(e, stackTrace);
    } catch (e, stackTrace) {
      _log.severe("[call] Failed while listing dir: ${logFilename(root.path)}",
          e, stackTrace);
      // for some reason exception thrown here can't be caught outside
      // rethrow;
      yield ExceptionEvent(e, stackTrace);
    }
  }

  final FileRepo fileRepo;
}
