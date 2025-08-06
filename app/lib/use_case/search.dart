import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/search.dart';

class Search {
  Search(this._c) : assert(require(_c));

  static bool require(DiContainer c) => DiContainer.has(c, DiType.searchRepo);

  Future<List<FileDescriptor>> call(
    Account account,
    SearchCriteria criteria,
  ) async {
    final files = await _c.searchRepo.list(account, criteria);
    return files.where((f) => file_util.isSupportedFormat(f)).toList();
  }

  final DiContainer _c;
}
