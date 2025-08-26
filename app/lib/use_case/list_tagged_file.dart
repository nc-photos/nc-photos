import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/tagged_file.dart';
import 'package:nc_photos/use_case/find_file.dart';
import 'package:np_log/np_log.dart';

part 'list_tagged_file.g.dart';

@npLog
class ListTaggedFile {
  ListTaggedFile(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.taggedFileRepo);

  /// List all files tagged with [tags] for [account]
  Future<List<File>> call(Account account, List<Tag> tags) async {
    final taggedFiles = <TaggedFile>[];
    for (final r in account.roots) {
      taggedFiles.addAll(
        await _c.taggedFileRepo.list(
          account,
          File(path: file_util.unstripPath(account, r)),
          tags,
        ),
      );
    }
    // server bug workaround, filter out repeated files
    final files = await FindFile(_c)(
      account,
      taggedFiles.map((f) => f.fileId).toSet(),
      onFileNotFound: (id) {
        // ignore missing file
        _log.warning("[call] Missing file: $id");
      },
    );
    return files.where((f) => file_util.isSupportedFormat(f)).toList();
  }

  final DiContainer _c;
}
