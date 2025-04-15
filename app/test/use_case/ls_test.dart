import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_collection/np_collection.dart';
import 'package:test/test.dart';

import '../mock_type.dart';
import '../test_util.dart' as util;

void main() {
  group("Ls", () {
    test("root", _root);
    test("sub dir", _subDir);
  });
}

/// List the root dir
///
/// Expect: all files under root dir
Future<void> _root() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/dir")
        ..addJpeg("admin/dir/test2.jpg"))
      .build();
  final fileRepo = MockFileMemoryRepo(files);

  expect(
    await Ls(fileRepo)(
        account, File(path: file_util.unstripPath(account, "."))),
    files.pySlice(1, 3),
  );
}

/// List a sub dir
///
/// Expect: all files under the sub dir
Future<void> _subDir() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/dir")
        ..addJpeg("admin/dir/test2.jpg"))
      .build();
  final fileRepo = MockFileMemoryRepo(files);

  expect(
    await Ls(fileRepo)(
        account, File(path: file_util.unstripPath(account, "dir"))),
    [files[3]],
  );
}
