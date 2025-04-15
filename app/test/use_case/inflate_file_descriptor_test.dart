import 'package:clock/clock.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:test/test.dart';

import '../test_util.dart' as util;

void main() {
  group("InflateFileDescriptor", () {
    test("one", _one);
    test("multiple", _multiple);
    test("missing", _missing);
  });
}

/// Inflate one FileDescriptor
///
/// Expect: one file
Future<void> _one() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addJpeg("admin/test2.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  expect(
    await InflateFileDescriptor(c)(
      account,
      [util.fileToFileDescriptor(files[1])],
    ),
    [files[1]],
  );
}

/// Inflate 3 FileDescriptors
///
/// Expect: 3 files
Future<void> _multiple() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addJpeg("admin/test2.jpg")
        ..addJpeg("admin/test3.jpg")
        ..addJpeg("admin/test4.jpg")
        ..addJpeg("admin/test5.jpg")
        ..addJpeg("admin/test6.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  expect(
    await InflateFileDescriptor(c)(
      account,
      files.pySlice(1, 7, 2).map(util.fileToFileDescriptor).toList(),
    ),
    [files[1], files[3], files[5]],
  );
}

/// Inflate a FileDescriptor that doesn't exists in the DB
///
/// Expect: throw StateError
Future<void> _missing() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addJpeg("admin/test2.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  expect(
    () async => await InflateFileDescriptor(c)(
      account,
      [
        FileDescriptor(
          fdPath: "remote.php/dav/files/admin/test3.jpg",
          fdId: 4,
          fdMime: null,
          fdIsArchived: false,
          fdIsFavorite: false,
          fdDateTime: clock.now(),
        ),
      ],
    ),
    throwsA(const TypeMatcher<StateError>()),
  );
}
