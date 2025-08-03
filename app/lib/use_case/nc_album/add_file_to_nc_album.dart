import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/use_case/copy.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'add_file_to_nc_album.g.dart';

@npLog
class AddFileToNcAlbum {
  AddFileToNcAlbum(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.fileRepo);

  /// Add list of [files] to [album] and return the added count
  Future<int> call(
    Account account,
    NcAlbum album,
    List<FileDescriptor> files, {
    ErrorWithValueHandler<FileDescriptor>? onError,
  }) async {
    _log.info(
        "[call] Add ${files.length} items to album '${album.strippedPath}'");
    var count = 0;
    for (final f in files) {
      try {
        await Copy(_c.fileRepo)(
          account,
          f.toFile(),
          "${album.path}/${f.fdPath.split("/").last}",
        );
        ++count;
      } catch (e, stackTrace) {
        onError?.call(f, e, stackTrace);
      }
    }
    return count;
  }

  final DiContainer _c;
}
