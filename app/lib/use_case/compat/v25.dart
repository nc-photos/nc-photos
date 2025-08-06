import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/use_case/move.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;

part 'v25.g.dart';

/// Compatibility helper for v25
class CompatV25 {
  /// Return whether the album file need to be migrated to the new naming scheme
  static bool isAlbumFileNeedMigration(File albumFile) =>
      albumFile.path.endsWith(".nc_album.json") == false;

  /// Migrate an album file to the new naming scheme
  static Future<File> migrateAlbumFile(
    DiContainer c,
    Account account,
    File albumFile,
  ) => _MigrateAlbumFile(c)(account, albumFile);
}

@npLog
class _MigrateAlbumFile {
  _MigrateAlbumFile(this._c) : assert(require(_c)), assert(Move.require(_c));

  static bool require(DiContainer c) => true;

  Future<File> call(Account account, File albumFile) async {
    assert(CompatV25.isAlbumFileNeedMigration(albumFile));
    final newPath =
        path_lib.dirname(albumFile.path) +
        "/" +
        path_lib.basenameWithoutExtension(albumFile.path) +
        ".nc_album.json";
    _log.info(
      "[call] Migrate album file from '${albumFile.path}' to '$newPath'",
    );
    await Move(_c)(account, albumFile, newPath);
    return albumFile.copyWith(path: newPath);
  }

  final DiContainer _c;
}
