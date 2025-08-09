import 'package:bloc_test/bloc_test.dart';
import 'package:nc_photos/bloc/list_album_share_outlier.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:np_string/np_string.dart';
import 'package:test/test.dart';

import '../mock_type.dart';
import '../test_util.dart' as util;

void main() {
  group("ListAlbumShareOutlierBloc", () {
    test("intial state", _initialState);
    group("ListAlbumShareOutlierBlocQuery", () {
      group("unshared album", () {
        _testQueryUnsharedAlbumExtraShare("extra share");
        _testQueryUnsharedAlbumExtraJsonShare("extra json share");
      });
      group("shared album", () {
        group("owned", () {
          _testQuerySharedAlbumMissingShare("missing share");
          _testQuerySharedAlbumMissingManagedShareOtherAdded(
            "missing managed share added by others",
          );
          _testQuerySharedAlbumMissingUnmanagedShareOtherAdded(
            "missing unmanaged share added by others",
          );
          _testQuerySharedAlbumMissingManagedShareOtherReshared(
            "missing managed share reshared by others",
          );
          _testQuerySharedAlbumMissingJsonShare("missing json share");

          _testQuerySharedAlbumExtraShare("extra share");
          _testQuerySharedAlbumExtraShareOtherAdded(
            "extra share, file added by others",
          );
          _testQuerySharedAlbumExtraUnmanagedShare(
            "extra share for file managed by others",
          );
          _testQuerySharedAlbumExtraJsonShare("extra json share");
        });
        group("not owned", () {
          _testQuerySharedAlbumNotOwnedMissingShareToOwner("missing share");
          _testQuerySharedAlbumNotOwnedMissingManagedShare(
            "missing managed share",
          );
          _testQuerySharedAlbumNotOwnedMissingUnmanagedShare(
            "missing unmanaged share",
          );
          _testQuerySharedAlbumNotOwnedMissingJsonShare("missing json share");

          _testQuerySharedAlbumNotOwnedExtraManagedShare("extra managed share");
          _testQuerySharedAlbumNotOwnedExtraUnmanagedShare(
            "extra unmanaged share",
          );
          _testQuerySharedAlbumNotOwnedExtraJsonShare("extra json share");
        });
      });
    });
  });
}

void _initialState() {
  final c = DiContainer(
    shareRepo: MockShareRepo(),
    shareeRepo: MockShareeRepo(),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  final bloc = ListAlbumShareOutlierBloc(c);
  expect(bloc.state.account, null);
  expect(bloc.state.items, const []);
}

/// Query an album that is not shared, but with shared file (admin -> user1)
///
/// Expect: emit the file with extra share (admin -> user1)
void _testQueryUnsharedAlbumExtraShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album = (util.AlbumBuilder()..addFileItem(files[0])).build();
  final file1 = files[0];
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: file1, shareWith: "user1"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(file1, [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "0", file: file1, shareWith: "user1"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query an album that is not shared, but the album json is shared
/// (admin -> user1)
///
/// Expect: emit the json file with extra share (admin -> user1)
void _testQueryUnsharedAlbumExtraJsonShare(String description) {
  final account = util.buildAccount();
  final album = util.AlbumBuilder().build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(albumFile, [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (admin -> user1), with file not shared (admin -> user1)
///
/// Expect: emit the file with missing share (admin -> user1)
void _testQuerySharedAlbumMissingShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder()
            ..addFileItem(files[0])
            ..addShare("user1"))
          .build();
  final file1 = files[0];
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(file1, [
              ListAlbumShareOutlierMissingShareItem("user1".toCi(), "user1"),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (admin -> user1, user2), with file added by user1,
/// managed by admin, not shared (admin -> user2)
///
/// Expect: emit the file with missing share (admin -> user2)
void _testQuerySharedAlbumMissingManagedShareOtherAdded(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)
        ..addJpeg("user1/test1.jpg", ownerId: "user1")).build();
  final album =
      (util.AlbumBuilder()
            // added before album shared, thus managed by album owner
            ..addFileItem(files[0], addedBy: "user1")
            ..addShare("user1", sharedAt: DateTime.utc(2021, 1, 2, 3, 4, 5))
            ..addShare("user2", sharedAt: DateTime.utc(2021, 1, 2, 3, 4, 5)))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
          util.buildShare(
            id: "2",
            file: files[0],
            uidOwner: "user1",
            shareWith: "admin",
          ),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(files[0], [
              ListAlbumShareOutlierMissingShareItem("user2".toCi(), "user2"),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (admin -> user1, user2), with file managed by admin,
/// shared (admin -> user1) and reshared (user1 -> user2)
///
/// Expect: emit empty list
void _testQuerySharedAlbumMissingManagedShareOtherReshared(String description) {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final user1Files = [
    files[0].copyWith(path: "remote.php/dav/files/user1/dir/test1.jpg"),
  ];
  final album =
      (util.AlbumBuilder()
            ..addFileItem(files[0])
            ..addShare("user1")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
          util.buildShare(id: "2", file: files[0], shareWith: "user1"),
          util.buildShare(
            id: "3",
            file: user1Files[0],
            uidOwner: "user1",
            shareWith: "user2",
          ),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await c.sqliteDb.insertAccounts([user1Account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
        await util.insertFiles(c.sqliteDb, user1Account, user1Files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, []),
        ],
  );
}

/// Query a shared album (admin -> user1, user2), with file added by user1,
/// managed by user1, not shared (user1 -> user2)
///
/// Expect: emit empty list
void _testQuerySharedAlbumMissingUnmanagedShareOtherAdded(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)
        ..addJpeg("user1/test1.jpg", ownerId: "user1")).build();
  final album =
      (util.AlbumBuilder()
            // added after album shared, thus managed by adder
            ..addFileItem(
              files[0],
              addedBy: "user1",
              addedAt: DateTime.utc(2021, 1, 2, 3, 4, 5),
            )
            ..addShare("user1")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
          util.buildShare(
            id: "2",
            file: files[0],
            uidOwner: "user1",
            shareWith: "admin",
          ),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, []),
        ],
  );
}

/// Query a shared album (admin -> user1), with album json not shared
///
/// Expect: emit the file with missing share (admin -> user1)
void _testQuerySharedAlbumMissingJsonShare(String description) {
  final account = util.buildAccount();
  final album = (util.AlbumBuilder()..addShare("user1")).build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo(),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(albumFile, [
              ListAlbumShareOutlierMissingShareItem("user1".toCi(), "user1"),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (admin -> user1), with file shared
/// (admin -> user1, user2)
///
/// Expect: emit the file with extra share (admin -> user2)
void _testQuerySharedAlbumExtraShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder()
            ..addFileItem(files[0])
            ..addShare("user1"))
          .build();
  final file1 = files[0];
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: files[0], shareWith: "user1"),
          util.buildShare(id: "2", file: files[0], shareWith: "user2"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(file1, [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "2", file: files[0], shareWith: "user2"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (admin -> user1), with file added by user1, shared
/// (admin -> user1, user2)
///
/// Expect: emit the file with extra share (admin -> user2)
void _testQuerySharedAlbumExtraShareOtherAdded(String description) {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files =
      (util.FilesBuilder(initialFileId: 1)
        ..addJpeg("admin/test1.jpg", ownerId: "user1")).build();
  final user1Files = [
    files[0].copyWith(path: "remote.php/dav/files/user1/dir/test1.jpg"),
  ];
  final album =
      (util.AlbumBuilder()
            // added before album shared, thus managed by album owner
            ..addFileItem(files[0], addedBy: "user1")
            ..addShare("user1", sharedAt: DateTime.utc(2021, 1, 2, 3, 4, 5)))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(
            id: "1",
            file: files[0],
            uidOwner: "user1",
            shareWith: "admin",
          ),
          util.buildShare(id: "2", file: files[0], shareWith: "user2"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await c.sqliteDb.insertAccounts([user1Account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
        await util.insertFiles(c.sqliteDb, user1Account, user1Files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(files[0], [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "2", file: files[0], shareWith: "user2"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (admin -> user1, user2), with file managed by user1,
/// shared by user1 (user1 -> admin) and admin (admin -> user2)
///
/// Expect: emit empty list
void _testQuerySharedAlbumExtraUnmanagedShare(String description) {
  final account = util.buildAccount();
  final user1Account = util.buildAccount(userId: "user1");
  final files =
      (util.FilesBuilder(initialFileId: 1)
        ..addJpeg("admin/test1.jpg", ownerId: "user1")).build();
  final user1Files = [
    files[0].copyWith(path: "remote.php/dav/files/user1/dir/test1.jpg"),
  ];
  final album =
      (util.AlbumBuilder()
            // added after album shared, thus managed by adder
            ..addFileItem(
              files[0],
              addedBy: "user1",
              addedAt: DateTime.utc(2021, 1, 2, 3, 4, 5),
            )
            ..addShare("user1")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
          util.buildShare(
            id: "2",
            file: user1Files[0],
            uidOwner: "user1",
            shareWith: "admin",
          ),
          util.buildShare(id: "3", file: files[0], shareWith: "user2"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await c.sqliteDb.insertAccounts([user1Account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
        await util.insertFiles(c.sqliteDb, user1Account, user1Files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, []),
        ],
  );
}

/// Query a shared album (admin -> user1), with album json shared
/// (admin -> user1, user2)
///
/// Expect: emit the file with extra share (admin -> user2)
void _testQuerySharedAlbumExtraJsonShare(String description) {
  final account = util.buildAccount();
  final album = (util.AlbumBuilder()..addShare("user1")).build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(albumFile, [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (user1 -> admin), with file added by admin not shared
/// (admin -> user1)
///
/// Expect: emit the file with missing share (admin -> user1)
void _testQuerySharedAlbumNotOwnedMissingShareToOwner(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder(ownerId: "user1")
            ..addFileItem(files[0])
            ..addShare("admin"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(
            id: "0",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "admin",
          ),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(files[0], [
              ListAlbumShareOutlierMissingShareItem("user1".toCi(), "user1"),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (user1 -> admin, user2), with file added by admin,
/// managed by admin, not shared (admin -> user2)
///
/// Expect: emit the file with missing share (admin -> user2)
void _testQuerySharedAlbumNotOwnedMissingManagedShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder(ownerId: "user1")
            // added after album shared, thus managed by adder
            ..addFileItem(files[0], addedAt: DateTime.utc(2021, 1, 2, 3, 4, 5))
            ..addShare("admin")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(
            id: "0",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "admin",
          ),
          util.buildShare(
            id: "1",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "user2",
          ),
          util.buildShare(id: "2", file: files[0], shareWith: "user1"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(files[0], [
              ListAlbumShareOutlierMissingShareItem("user2".toCi(), "user2"),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (user1 -> admin, user2), with file added by admin,
/// managed by user1, not shared (user1 -> user2)
///
/// Expect: emit empty list
void _testQuerySharedAlbumNotOwnedMissingUnmanagedShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder(ownerId: "user1")
            // added before album shared, thus managed by album owner
            ..addFileItem(files[0], addedBy: "admin")
            ..addShare("admin", sharedAt: DateTime.utc(2021, 1, 2, 3, 4, 5))
            ..addShare("user2", sharedAt: DateTime.utc(2021, 1, 2, 3, 4, 5)))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
          util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
          util.buildShare(id: "2", file: files[0], shareWith: "user1"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, []),
        ],
  );
}

/// Query a shared album (user1 -> admin, user2), with missing album json share
/// (user1 -> user2)
///
/// Expect: emit empty list
void _testQuerySharedAlbumNotOwnedMissingJsonShare(String description) {
  final account = util.buildAccount();
  final album =
      (util.AlbumBuilder(ownerId: "user1")
            ..addShare("admin")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(
            id: "0",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "admin",
          ),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, []),
        ],
  );
}

/// Query a shared album (user1 -> admin), with file added by admin, managed by
/// admin, shared (admin -> user1, user2)
///
/// Expect: emit the file with missing share (admin -> user2)
void _testQuerySharedAlbumNotOwnedExtraManagedShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder(ownerId: "user1")
            // added after album shared, thus managed by adder
            ..addFileItem(files[0], addedAt: DateTime.utc(2021, 1, 2, 3, 4, 5))
            ..addShare("admin"))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(
            id: "0",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "admin",
          ),
          util.buildShare(id: "1", file: files[0], shareWith: "user1"),
          util.buildShare(id: "2", file: files[0], shareWith: "user2"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(files[0], [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "2", file: files[0], shareWith: "user2"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (user1 -> admin), with file added by admin, managed by
/// user1, shared (admin -> user1, user2)
///
/// Expect: emit the file with missing share (admin -> user2)
void _testQuerySharedAlbumNotOwnedExtraUnmanagedShare(String description) {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder(ownerId: "user1")
            // added before album shared, thus managed by album owner
            ..addFileItem(files[0], addedBy: "admin")
            ..addShare("admin", sharedAt: DateTime.utc(2021, 1, 2, 3, 4, 5)))
          .build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(
            id: "0",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "admin",
          ),
          util.buildShare(id: "1", file: files[0], shareWith: "user1"),
          util.buildShare(id: "2", file: files[0], shareWith: "user2"),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
      await c.sqliteDb.transaction(() async {
        await c.sqliteDb.insertAccounts([account.toDb()]);
        await util.insertFiles(c.sqliteDb, account, files);
      });
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, [
            ListAlbumShareOutlierItem(files[0], [
              ListAlbumShareOutlierExtraShareItem(
                util.buildShare(id: "2", file: files[0], shareWith: "user2"),
              ),
            ]),
          ]),
        ],
  );
}

/// Query a shared album (user1 -> admin), with album json share
/// (user1 -> admin, user2)
///
/// Expect: emit empty list
void _testQuerySharedAlbumNotOwnedExtraJsonShare(String description) {
  final account = util.buildAccount();
  final album =
      (util.AlbumBuilder(ownerId: "user1")..addShare("admin")).build();
  final albumFile = album.albumFile!;
  late final DiContainer c;

  blocTest<ListAlbumShareOutlierBloc, ListAlbumShareOutlierBlocState>(
    description,
    setUp: () async {
      c = DiContainer(
        shareRepo: MockShareMemoryRepo([
          util.buildShare(
            id: "0",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "admin",
          ),
          util.buildShare(
            id: "1",
            file: albumFile,
            uidOwner: "user1",
            shareWith: "user2",
          ),
        ]),
        shareeRepo: MockShareeMemoryRepo([
          util.buildSharee(shareWith: "user1".toCi()),
          util.buildSharee(shareWith: "user2".toCi()),
        ]),
        npDb: util.buildTestDb(),
      );
    },
    tearDown: () => c.sqliteDb.close(),
    build: () => ListAlbumShareOutlierBloc(c),
    act: (bloc) => bloc.add(ListAlbumShareOutlierBlocQuery(account, album)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          ListAlbumShareOutlierBlocLoading(account, []),
          ListAlbumShareOutlierBlocSuccess(account, []),
        ],
  );
}
