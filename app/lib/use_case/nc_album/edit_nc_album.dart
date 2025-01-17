import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/use_case/move.dart';
import 'package:np_log/np_log.dart';

part 'edit_nc_album.g.dart';

@npLog
class EditNcAlbum {
  const EditNcAlbum(this._c);

  Future<NcAlbum> call(
    Account account,
    NcAlbum album, {
    String? name,
    List<FileDescriptor>? items,
    CollectionItemSort? itemSort,
  }) async {
    var newAlbum = album;
    if (items != null || itemSort != null) {
      _log.severe("[call] Editing items/itemSort is not supported");
    }
    if (name != null) {
      final newPath = album.getRenamedPath(name);
      await Move(_c)(account, File(path: album.path), newPath);
      newAlbum = newAlbum.copyWith(path: newPath);
    }
    return newAlbum;
  }

  final DiContainer _c;
}
