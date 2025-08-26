import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source2.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:np_collection/np_collection.dart';
import 'package:np_common/or_null.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:test/test.dart';

import '../../test_util.dart' as util;

void main() {
  group("FileNpDbDataSource", () {
    group("getFileDescriptors", () {
      test("normal", _getFileDescriptors);
      test("multiple account", _getFileDescriptorsMultipleAccount);
      test("share folder", _getFileDescriptorsShareFolder);
      test("extra share folder", _getFileDescriptorsExtraShareFolder);
    });
    group("remove", () {
      test("file", _removeFile);
      test("empty dir", _removeEmptyDir);
      test("dir w/ file", _removeDir);
      test("dir w/ sub dir", _removeDirWithSubDir);
    });
    group("updateProperty", () {
      test("file properties", _updateFileProperty);
      test("update metadata", _updateMetadata);
      test("add metadata", _updateAddMetadata);
      test("delete metadata", _updateDeleteMetadata);
    });
  });
}

/// Return files of an account
///
/// Files: admin/test1.jpg, admin/test/test2.jpg
/// Expect: admin/test1.jpg, admin/test/test2.jpg
Future<void> _getFileDescriptors() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg")
            ..addDir("admin/test")
            ..addJpeg("admin/test/test2.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
      c.sqliteDb,
      account,
      files[0],
      files.pySlice(1, 3),
    );
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  expect(
    await src.getFileDescriptors(account, file_util.unstripPath(account, "")),
    [files[3].toDescriptor(), files[1].toDescriptor()],
  );
}

/// Return files of an account
///
/// Files: admin/test1.jpg, admin/test/test2.jpg, user1/test3.jpg
/// Expect: admin/test1.jpg, admin/test/test2.jpg
Future<void> _getFileDescriptorsMultipleAccount() async {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg")
            ..addDir("admin/test")
            ..addJpeg("admin/test/test2.jpg"))
          .build();
  final user1Files =
      (util.FilesBuilder(initialFileId: files.length)
            ..addDir("user1", ownerId: "user1")
            ..addJpeg("user1/test3.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.insertAccounts([user1Account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
      c.sqliteDb,
      account,
      files[0],
      files.pySlice(1, 3),
    );
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
    await util.insertFiles(c.sqliteDb, user1Account, user1Files);
    await util.insertDirRelation(c.sqliteDb, user1Account, user1Files[0], [
      user1Files[1],
    ]);
  });

  final src = FileNpDbDataSource(c.npDb);
  expect(
    await src.getFileDescriptors(account, file_util.unstripPath(account, "")),
    [files[3].toDescriptor(), files[1].toDescriptor()],
  );
  expect(
    await src.getFileDescriptors(
      user1Account,
      file_util.unstripPath(user1Account, ""),
    ),
    [user1Files[1].toDescriptor()],
  );
}

/// Return files of an account
///
/// Files: admin/test1/test1.jpg, admin/test2/test2.jpg
/// Expect: admin/test1/test1.jpg
Future<void> _getFileDescriptorsShareFolder() async {
  final account = util.buildAccount(roots: ["test1"]);
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addDir("admin/test1")
            ..addJpeg("admin/test1/test1.jpg")
            ..addDir("admin/test2")
            ..addJpeg("admin/test2/test2.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [
      files[1],
      files[3],
    ]);
    await util.insertDirRelation(c.sqliteDb, account, files[1], [files[2]]);
    await util.insertDirRelation(c.sqliteDb, account, files[3], [files[4]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  expect(
    await src.getFileDescriptors(
      account,
      file_util.unstripPath(account, "test1"),
    ),
    [files[2].toDescriptor()],
  );
}

/// Return files of an account
///
/// Files: admin/test1/test1.jpg, admin/test2/test2.jpg
/// Expect: admin/test1/test1.jpg, admin/test2/test2.jpg
Future<void> _getFileDescriptorsExtraShareFolder() async {
  final account = util.buildAccount(roots: ["test1"]);
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addDir("admin/test1")
            ..addJpeg("admin/test1/test1.jpg")
            ..addDir("admin/test2")
            ..addJpeg("admin/test2/test2.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [
      files[1],
      files[3],
    ]);
    await util.insertDirRelation(c.sqliteDb, account, files[1], [files[2]]);
    await util.insertDirRelation(c.sqliteDb, account, files[3], [files[4]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  expect(
    await src.getFileDescriptors(
      account,
      file_util.unstripPath(account, "test2"),
    ),
    [files[4].toDescriptor(), files[2].toDescriptor()],
  );
}

/// Remove a file
///
/// Expect: entry removed from Files table
Future<void> _removeFile() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.remove(account, files[1]);
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0]});
}

/// Remove an empty dir
///
/// Expect: entry removed from DirFiles table
Future<void> _removeEmptyDir() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addDir("admin/test"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
    await util.insertDirRelation(c.sqliteDb, account, files[1], const []);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.remove(account, files[1]);
  // parent dir is not updated, parent dir is only updated when syncing with
  // remote
  expect(await util.listSqliteDbDirs(c.sqliteDb), {
    files[0]: {files[0]},
  });
}

/// Remove a dir with file
///
/// Expect: file entries under the dir removed from Files table
Future<void> _removeDir() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addDir("admin/test")
            ..addJpeg("admin/test/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
    await util.insertDirRelation(c.sqliteDb, account, files[1], [files[2]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.remove(account, files[1]);
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0]});
}

/// Remove a dir with file
///
/// Expect: file entries under the dir removed from Files table
Future<void> _removeDirWithSubDir() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addDir("admin/test")
            ..addDir("admin/test/test2")
            ..addJpeg("admin/test/test2/test3.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
    await util.insertDirRelation(c.sqliteDb, account, files[1], [files[2]]);
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.remove(account, files[1]);
  expect(await util.listSqliteDbDirs(c.sqliteDb), {
    files[0]: {files[0]},
  });
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0]});
}

/// Update the properties of a file
///
/// Expect: file's property updated in Files table
Future<void> _updateFileProperty() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.updateProperty(
    account,
    files[1],
    isArchived: const OrNull(true),
    overrideDateTime: OrNull(DateTime.utc(2020, 1, 2, 3, 4, 5)),
  );
  final expectFile = files[1].copyWith(
    isArchived: const OrNull(true),
    overrideDateTime: OrNull(DateTime.utc(2020, 1, 2, 3, 4, 5)),
  );
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0], expectFile});
}

/// Update metadata of a file
///
/// Expect: Metadata updated in Images table
Future<void> _updateMetadata() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  files[1] = files[1].copyWith(
    metadata: OrNull(
      Metadata(
        lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
        imageWidth: 123,
        src: MetadataSrc.legacy,
      ),
    ),
  );
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.updateProperty(
    account,
    files[1],
    metadata: OrNull(
      Metadata(
        lastUpdated: DateTime.utc(2021, 1, 2, 3, 4, 5),
        imageWidth: 321,
        imageHeight: 123,
        src: MetadataSrc.legacy,
      ),
    ),
  );
  final expectFile = files[1].copyWith(
    metadata: OrNull(
      Metadata(
        lastUpdated: DateTime.utc(2021, 1, 2, 3, 4, 5),
        imageWidth: 321,
        imageHeight: 123,
        src: MetadataSrc.legacy,
      ),
    ),
  );
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0], expectFile});
}

/// Add metadata to a file
///
/// Expect: Metadata added to Images table
Future<void> _updateAddMetadata() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.updateProperty(
    account,
    files[1],
    metadata: OrNull(
      Metadata(
        lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
        imageWidth: 123,
        src: MetadataSrc.legacy,
      ),
    ),
  );
  final expectFile = files[1].copyWith(
    metadata: OrNull(
      Metadata(
        lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
        imageWidth: 123,
        src: MetadataSrc.legacy,
      ),
    ),
  );
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0], expectFile});
}

/// Delete metadata of a file
///
/// Expect: Metadata deleted from Images table
Future<void> _updateDeleteMetadata() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  files[1] = files[1].copyWith(
    metadata: OrNull(
      Metadata(
        lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
        imageWidth: 123,
        src: MetadataSrc.legacy,
      ),
    ),
  );
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(c.sqliteDb, account, files[0], [files[1]]);
  });

  final src = FileNpDbDataSource(c.npDb);
  await src.updateProperty(account, files[1], metadata: const OrNull(null));
  final expectFile = files[1].copyWith(metadata: const OrNull(null));
  expect(await util.listSqliteDbFiles(c.sqliteDb), {files[0], expectFile});
}
