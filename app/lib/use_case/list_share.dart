import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/use_case/find_file.dart';
import 'package:np_log/np_log.dart';

part 'list_share.g.dart';

/// List all shares from a given file
@npLog
class ListShare {
  const ListShare(this._c);

  Future<List<Share>> call(
    Account account,
    FileDescriptor file, {
    bool? isIncludeReshare,
  }) async {
    try {
      if (file_util.getUserDirNamePath(file.fdPath) != account.userId) {
        file = (await FindFile(_c)(account, [file.fdId])).first;
      }
    } catch (_) {
      // file not found
      _log.warning("[call] File not found in db: ${logFilename(file.fdPath)}");
    }
    return _c.shareRepo.list(
      account,
      file,
      isIncludeReshare: isIncludeReshare,
    );
  }

  final DiContainer _c;
}
