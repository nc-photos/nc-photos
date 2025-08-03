import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_log/np_log.dart';

part 'list_potential_shared_album.g.dart';

/// List all shared files that are potentially albums
///
/// Beware that it's NOT guaranteed that they are actually albums
@npLog
class ListPotentialSharedAlbum {
  ListPotentialSharedAlbum(this.fileRepo);

  Future<List<File>> call(Account account, String shareFolder) async {
    final results = <File>[];
    final ls = await Ls(fileRepo)(
      account,
      File(
        path: file_util.unstripPath(account, shareFolder),
      ),
    );
    for (final f in ls) {
      // check owner
      if (_checkOwner(account, f) && _checkFileName(f)) {
        results.add(f);
      }
    }
    return results;
  }

  bool _checkOwner(Account account, File f) => !f.isOwned(account.userId);

  bool _checkFileName(File f) {
    try {
      final match = _regex.firstMatch(f.filename);
      if (match == null) {
        return false;
      }
      final timestamp = int.parse(match.group(1)!, radix: 16);
      final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
      _log.fine("[_checkFileName] Timestamp: $time");
      if (time.isAfter(clock.now())) {
        _log.warning("[_checkFileName] Invalid timestamp: ${f.path}");
        return false;
      }
      final random = int.parse(match.group(2)!, radix: 16);
      _log.fine("[_checkFileName] Random: $random");
      if (random > 0xFFFFFF) {
        _log.warning("[_checkFileName] Invalid random: ${f.path}");
        return false;
      }
      return true;
    } catch (e, stacktrace) {
      _log.warning("[_checkFileName] Exception: ${f.path}", e, stacktrace);
      return false;
    }
  }

  final FileRepo fileRepo;
  final _regex = RegExp(r"^([0-9a-fA-F]+)-([0-9a-fA-F]+)\.nc_album\.json$");
}
