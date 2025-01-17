import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/create_dir.dart';
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_log/np_log.dart';

part 'v15.g.dart';

/// Compatibility helper for v15
class CompatV15 {
  /// Migrate album files from old location pre v15 to the new location in v15+
  ///
  /// Return true if album files are migrated successfully, false otherwise.
  /// Note that false does not necessarily mean that the migration has failed,
  /// it could simply mean that no migration is needed
  static Future<bool> migrateAlbumFiles(Account account, FileRepo fileRepo) {
    return _MigrateAlbumFiles(fileRepo)(account);
  }
}

@npLog
class _MigrateAlbumFiles {
  _MigrateAlbumFiles(this.fileRepo);

  Future<bool> call(Account account) async {
    try {
      // get files from the old location
      final ls = await Ls(fileRepo)(
          account,
          File(
            path: _getAlbumFileRootCompat14(account),
          ));
      final albumFiles =
          ls.where((element) => element.isCollection != true).toList();
      if (albumFiles.isEmpty) {
        return false;
      }
      // copy to an intermediate location
      final intermediateDir =
          "${remote_storage_util.getRemoteAlbumsDir(account)}.tmp";
      _log.info("[call] Copy album files to '$intermediateDir'");
      if (!ls.any((element) =>
          element.isCollection == true && element.path == intermediateDir)) {
        await CreateDir(fileRepo)(account, intermediateDir);
      }
      for (final f in albumFiles) {
        await fileRepo.copy(account, f, "$intermediateDir/${f.filename}",
            shouldOverwrite: true);
      }
      // rename intermediate
      await fileRepo.move(account, File(path: intermediateDir),
          remote_storage_util.getRemoteAlbumsDir(account));
      _log.info(
          "[call] Album files moved to '${remote_storage_util.getRemoteAlbumsDir(account)}' successfully");
      // remove old files
      for (final f in albumFiles) {
        try {
          await fileRepo.remove(account, f);
        } catch (_) {}
      }
      return true;
    } catch (e, stacktrace) {
      if (e is ApiException && e.response.statusCode == 404) {
        // no albums
        return false;
      }
      _log.shout("[call] Failed while migrating album files to new location", e,
          stacktrace);
      rethrow;
    }
  }

  // old album root location on v14-
  static String _getAlbumFileRootCompat14(Account account) =>
      "${api_util.getWebdavRootUrlRelative(account)}/.com.nkming.nc_photos";

  final FileRepo fileRepo;
}
