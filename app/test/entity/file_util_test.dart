import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:test/test.dart';

import '../test_util.dart' as util;

void main() {
  group("unstripPath", () {
    test("path", () {
      final account = util.buildAccount();
      expect(
        file_util.unstripPath(account, "test/test1.jpg"),
        "remote.php/dav/files/admin/test/test1.jpg",
      );
    });

    test("root", () {
      final account = util.buildAccount();
      expect(file_util.unstripPath(account, "."), "remote.php/dav/files/admin");
    });
  });

  group("renameConflict", () {
    test("w/ extension", () {
      expect(file_util.renameConflict("test.jpg", 2), "test (2).jpg");
    });

    test("w/o extension", () {
      expect(file_util.renameConflict("test", 2), "test (2)");
    });
  });
}
