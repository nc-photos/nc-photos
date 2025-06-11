import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/tag.dart';

class ListFileTag {
  ListFileTag(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.tagRepo);

  /// Return list of tags associated with [file]
  Future<List<Tag>> call(Account account, FileDescriptor file) =>
      _c.tagRepo.listByFile(account, file);

  final DiContainer _c;
}
