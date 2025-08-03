import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/file/file_cache_manager.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/or_null.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:np_math/np_math.dart';
import 'package:test/test.dart';

import '../../mock_type.dart';
import '../../test_util.dart' as util;

void main() {
  group("FileCacheLoader", () {
    group("default", () {
      test("no cache", _loaderNoCache);
      test("outdated", _loaderOutdatedCache);
      test("query remote etag", _loaderQueryRemoteSameEtag);
      test("query remote etag (updated)", _loaderQueryRemoteDiffEtag);
    });
  });
  group("FileSqliteCacheUpdater", () {
    test("identical", _updaterIdentical);
    test("new file", _updaterNewFile);
    test("delete file", _updaterDeleteFile);
    test("delete dir", _updaterDeleteDir);
    test("update file", _updaterUpdateFile);
    test("new shared file", _updaterNewSharedFile);
    test("new shared dir", _updaterNewSharedDir);
    test("delete shared file", _updaterDeleteSharedFile);
    test("delete shared dir", _updaterDeleteSharedDir);
    test("too many files", _updaterTooManyFiles,
        timeout: const Timeout(Duration(minutes: 2)),
        skip: "too slow on gitlab");
    test("moved file (to dir in front of the from dir)",
        _updaterMovedFileToFront);
    test("moved file (to dir behind the from dir)", _updaterMovedFileToBehind);
  });
  test("FileSqliteCacheEmptier", _emptier);
}

/// Load dir: no cache
///
/// Expect: null
Future<void> _loaderNoCache() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin", etag: "1")
        ..addJpeg("admin/test1.jpg", etag: "2")
        ..addDir("admin/test", etag: "3")
        ..addJpeg("admin/test/test2.jpg", etag: "4"))
      .build();
  final c = DiContainer(
    fileRepo: MockFileMemoryRepo(files),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
  });

  final cacheSrc = FileSqliteDbDataSource(c);
  final remoteSrc = MockFileWebdavDataSource(MockFileMemoryDataSource(files));
  final loader = FileCacheLoader(c, cacheSrc: cacheSrc, remoteSrc: remoteSrc);
  expect(await loader(account, files[0]), null);
}

/// Load dir: outdated cache
///
/// Expect: return cache;
/// isGood == false
Future<void> _loaderOutdatedCache() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin", etag: "1")
        ..addJpeg("admin/test1.jpg", etag: "2")
        ..addDir("admin/test", etag: "3")
        ..addJpeg("admin/test/test2.jpg", etag: "4"))
      .build();
  final c = DiContainer(
    fileRepo: MockFileMemoryRepo(files),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  final dbFiles = [
    files[0].copyWith(etag: const OrNull("a")),
    ...files.pySlice(1),
  ];
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, dbFiles);
    await util.insertDirRelation(
        c.sqliteDb, account, dbFiles[0], dbFiles.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, dbFiles[2], [dbFiles[3]]);
  });

  final cacheSrc = FileSqliteDbDataSource(c);
  final remoteSrc = MockFileWebdavDataSource(MockFileMemoryDataSource(files));
  final loader = FileCacheLoader(c, cacheSrc: cacheSrc, remoteSrc: remoteSrc);
  expect(
    (await loader(account, files[0]))?.toSet(),
    dbFiles.pySlice(0, 3).toSet(),
  );
  expect(loader.isGood, false);
}

/// Load dir: no etag, up-to-date cache
///
/// Expect: return cache;
/// isGood == true
Future<void> _loaderQueryRemoteSameEtag() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin", etag: "1")
        ..addJpeg("admin/test1.jpg", etag: "2")
        ..addDir("admin/test", etag: "3")
        ..addJpeg("admin/test/test2.jpg", etag: "4"))
      .build();
  final c = DiContainer(
    fileRepo: MockFileMemoryRepo(files),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final cacheSrc = FileSqliteDbDataSource(c);
  final remoteSrc = MockFileWebdavDataSource(MockFileMemoryDataSource(files));
  final loader = FileCacheLoader(c, cacheSrc: cacheSrc, remoteSrc: remoteSrc);
  expect(
    (await loader(account, files[0].copyWith(etag: const OrNull(null))))
        ?.toSet(),
    files.pySlice(0, 3).toSet(),
  );
  expect(loader.isGood, true);
}

/// Load dir: no etag, outdated cache
///
/// Expect: return cache;
/// isGood == false
Future<void> _loaderQueryRemoteDiffEtag() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin", etag: "1")
        ..addJpeg("admin/test1.jpg", etag: "2")
        ..addDir("admin/test", etag: "3")
        ..addJpeg("admin/test/test2.jpg", etag: "4"))
      .build();
  final c = DiContainer(
    fileRepo: MockFileMemoryRepo(files),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  final dbFiles = [
    files[0].copyWith(etag: const OrNull("a")),
    ...files.pySlice(1),
  ];
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, dbFiles);
    await util.insertDirRelation(
        c.sqliteDb, account, dbFiles[0], dbFiles.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, dbFiles[2], [dbFiles[3]]);
  });

  final cacheSrc = FileSqliteDbDataSource(c);
  final remoteSrc = MockFileWebdavDataSource(MockFileMemoryDataSource(files));
  final loader = FileCacheLoader(c, cacheSrc: cacheSrc, remoteSrc: remoteSrc);
  expect(
    (await loader(account, files[0].copyWith(etag: const OrNull(null))))
        ?.toSet(),
    dbFiles.pySlice(0, 3).toSet(),
  );
  expect(loader.isGood, false);
}

/// Update dir in cache: same set of files
///
/// Expect: nothing happens
Future<void> _updaterIdentical() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(account, files[0], remote: files.pySlice(0, 3));
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    files.toSet(),
  );
}

/// Update dir in cache: new file
///
/// Expect: new file added to Files table
Future<void> _updaterNewFile() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final newFile = (util.FilesBuilder(initialFileId: files.length)
        ..addJpeg("admin/test2.jpg"))
      .build()
      .first;
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(account, files[0], remote: [...files.pySlice(0, 3), newFile]);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files, newFile},
  );
}

/// Update dir in cache: file missing
///
/// Expect: missing file deleted from Files table
Future<void> _updaterDeleteFile() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(account, files[0], remote: [files[0], files[2]]);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {files[0], ...files.pySlice(2)},
  );
}

/// Update dir in cache: dir missing
///
/// Expect: missing dir deleted from Files table;
/// missing dir deleted from DirFiles table
/// files under dir deleted from Files table;
/// dirs under dir deleted from DirFiles table;
Future<void> _updaterDeleteDir() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(account, files[0], remote: files.pySlice(0, 2));
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    files.pySlice(0, 2).toSet(),
  );
  expect(
    await util.listSqliteDbDirs(c.sqliteDb),
    {
      files[0]: files.pySlice(0, 2).toSet(),
    },
  );
}

/// Update dir in cache: file updated
///
/// Expect: file updated in Files table
Future<void> _updaterUpdateFile() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg", contentLength: 321)
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final newFile = files[1].copyWith(contentLength: 654);
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(account, files[0],
      remote: [files[0], newFile, ...files.pySlice(2)]);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {files[0], newFile, ...files.pySlice(2)},
  );
}

/// Update dir in cache: new shared file
///
/// Expect: file added to AccountFiles table
Future<void> _updaterNewSharedFile() async {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final user1Files = (util.FilesBuilder(initialFileId: files.length)
        ..addDir("user1", ownerId: "user1"))
      .build();
  user1Files
      .add(files[1].copyWith(path: "remote.php/dav/files/user1/test1.jpg"));
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.insertAccounts([user1Account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(user1Account, user1Files[0], remote: user1Files);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files, ...user1Files},
  );
}

/// Update dir in cache: new shared dir
///
/// Expect: file added to AccountFiles table
Future<void> _updaterNewSharedDir() async {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg", ownerId: "user1")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final user1Files = <File>[];
  user1Files.add(files[2].copyWith(path: "remote.php/dav/files/user1/share"));
  user1Files.add(
      files[3].copyWith(path: "remote.php/dav/files/user1/share/test2.jpg"));
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.insertAccounts([user1Account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(user1Account, user1Files[0], remote: user1Files);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files, ...user1Files},
  );
}

/// Update dir in cache: shared file missing
///
/// Expect: file removed from AccountFiles table;
/// file remained in Files table
Future<void> _updaterDeleteSharedFile() async {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final user1Files =
      (util.FilesBuilder(initialFileId: files.length)..addDir("user1")).build();
  user1Files
      .add(files[1].copyWith(path: "remote.php/dav/files/user1/test1.jpg"));
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.insertAccounts([user1Account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);

    await util.insertFiles(c.sqliteDb, user1Account, user1Files);
    await util.insertDirRelation(
        c.sqliteDb, user1Account, user1Files[0], [user1Files[1]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(user1Account, user1Files[0], remote: [user1Files[0]]);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files, user1Files[0]},
  );
}

/// Update dir in cache: shared dir missing
///
/// Expect: file removed from AccountFiles table;
/// file remained in Files table
Future<void> _updaterDeleteSharedDir() async {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/test")
        ..addJpeg("admin/test/test2.jpg"))
      .build();
  final user1Files =
      (util.FilesBuilder(initialFileId: files.length)..addDir("user1")).build();
  user1Files.add(files[2].copyWith(path: "remote.php/dav/files/user1/share"));
  user1Files.add(
      files[3].copyWith(path: "remote.php/dav/files/user1/share/test2.jpg"));
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.insertAccounts([user1Account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);

    await util.insertFiles(c.sqliteDb, user1Account, user1Files);
    await util.insertDirRelation(
        c.sqliteDb, user1Account, user1Files[0], [user1Files[1]]);
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(user1Account, user1Files[0], remote: [user1Files[0]]);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files, user1Files[0]},
  );
}

/// Too many SQL variables
///
/// Expect: no error
Future<void> _updaterTooManyFiles() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg")
        ..addDir("admin/testMany")
        ..addJpeg("admin/testMany/testtest.jpg"))
      .build();
  final newFilesBuilder = util.FilesBuilder(initialFileId: files.length);
  // 250000 is the SQLITE_MAX_VARIABLE_NUMBER used in debian
  for (final i in 0.until(250000)) {
    newFilesBuilder.addJpeg("admin/testMany/test$i.jpg");
  }
  final newFiles = newFilesBuilder.build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[2], files.pySlice(3));
  });

  final updater = FileSqliteCacheUpdater(c.npDb);
  await updater(account, files[2], remote: [...files.pySlice(2), ...newFiles]);
  // we are testing to make sure the above function won't throw, so nothing to
  // expect here
}

/// Moved a file from test2 to test1, where test2 is sorted behind test1
///
/// Expect: file moved
Future<void> _updaterMovedFileToFront() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addDir("admin/test1")
        ..addDir("admin/test2")
        ..addJpeg("admin/test2/test1.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[1], []);
    await util.insertDirRelation(c.sqliteDb, account, files[2], [files[3]]);
  });

  final movedFile = files[3].copyWith(
    path: "remote.php/dav/files/admin/test1/test1.jpg",
  );
  await FileSqliteCacheUpdater(c.npDb)(
    account,
    files[1],
    remote: [files[1], movedFile],
  );
  await FileSqliteCacheUpdater(c.npDb)(
    account,
    files[2],
    remote: [files[2]],
  );
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files.pySlice(0, 3), movedFile},
  );
  final dirResult = await util.listSqliteDbDirs(c.sqliteDb);
  expect(dirResult[files[0]], {...files.pySlice(0, 3)});
  expect(dirResult[files[1]], {files[1], movedFile});
  expect(dirResult[files[2]], {files[2]});
}

/// Moved a file from test1 to test2, where test1 is sorted in front of test2
///
/// Expect: file moved
Future<void> _updaterMovedFileToBehind() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addDir("admin/test1")
        ..addDir("admin/test2")
        ..addJpeg("admin/test1/test1.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util.insertDirRelation(
        c.sqliteDb, account, files[0], files.pySlice(1, 3));
    await util.insertDirRelation(c.sqliteDb, account, files[1], [files[3]]);
    await util.insertDirRelation(c.sqliteDb, account, files[2], []);
  });

  final movedFile = files[3].copyWith(
    path: "remote.php/dav/files/admin/test2/test1.jpg",
  );
  await FileSqliteCacheUpdater(c.npDb)(
    account,
    files[1],
    remote: [files[1]],
  );
  await FileSqliteCacheUpdater(c.npDb)(
    account,
    files[2],
    remote: [files[2], movedFile],
  );
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {...files.pySlice(0, 3), movedFile},
  );
  final dirResult = await util.listSqliteDbDirs(c.sqliteDb);
  expect(dirResult[files[0]], {...files.pySlice(0, 3)});
  expect(dirResult[files[1]], {files[1]});
  expect(dirResult[files[2]], {files[2], movedFile});
}

/// Empty dir in cache
///
/// Expect: dir removed from DirFiles table;
/// dir remains in Files table
Future<void> _emptier() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addDir("admin/testA")
        ..addJpeg("admin/testA/test1.jpg")
        ..addDir("admin/testB")
        ..addJpeg("admin/testB/test2.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
    await util
        .insertDirRelation(c.sqliteDb, account, files[0], [files[1], files[3]]);
    await util.insertDirRelation(c.sqliteDb, account, files[1], [files[2]]);
    await util.insertDirRelation(c.sqliteDb, account, files[3], [files[4]]);
  });

  final emptier = FileSqliteCacheEmptier(c);
  await emptier(account, files[1]);
  expect(
    await util.listSqliteDbFiles(c.sqliteDb),
    {files[0], files[1], files[3], files[4]},
  );
  expect(
    await util.listSqliteDbDirs(c.sqliteDb),
    {
      files[0]: {files[0], files[1], files[3]},
      files[3]: {files[3], files[4]},
    },
  );
}
