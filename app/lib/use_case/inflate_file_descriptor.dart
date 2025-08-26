import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/use_case/find_file.dart';

class InflateFileDescriptor {
  InflateFileDescriptor(this._c) : assert(require(_c));

  static bool require(DiContainer c) => true;

  /// Turn a list of FileDescriptors to the corresponding Files
  ///
  /// The conversion is done by looking up the files in the database. No lookup
  /// will be done for File objects in [fds]
  Future<List<File>> call(Account account, List<FileDescriptor> fds) async {
    final found = await FindFile(_c)(
      account,
      fds.where((e) => e is! File).map((e) => e.fdId).toList(),
    );
    final foundMap = Map.fromEntries(found.map((e) => MapEntry(e.fileId!, e)));
    return fds.map((e) {
      if (e is File) {
        return e;
      } else {
        return foundMap[e.fdId]!;
      }
    }).toList();
  }

  final DiContainer _c;
}
