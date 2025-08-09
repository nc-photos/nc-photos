import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/data_source.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/exception.dart';
import 'package:np_common/or_null.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:np_string/np_string.dart';
import 'package:test/test.dart';

import '../../test_util.dart' as util;

void main() {
  group("AlbumSqliteDbDataSource", () {
    group("get", () {
      test("normal", _dbGet);
      test("n/a", _dbGetNa);
    });
    group("getAll", () {
      test("normal", _dbGetAll);
      test("n/a", _dbGetAllNa);
    });
    group("update", () {
      test("existing album", _dbUpdateExisting);
      test("new album", _dbUpdateNew);
      test("shares", _dbUpdateShares);
      test("delete shares", _dbUpdateDeleteShares);
    });
  });
}

/// Get an album from DB
///
/// Expect: album
Future<void> _dbGet() async {
  final account = util.buildAccount();
  final albums = [
    (util.AlbumBuilder.ofId(albumId: 0)).build(),
    (util.AlbumBuilder.ofId(albumId: 1)).build(),
  ];
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(
      c.sqliteDb,
      account,
      albums.map((a) => a.albumFile!),
    );
    await util.insertAlbums(c.sqliteDb, account, albums);
  });

  final src = AlbumSqliteDbDataSource(c);
  expect(await src.get(account, albums[0].albumFile!), albums[0]);
}

/// Get an album that doesn't exist in DB
///
/// Expect: CacheNotFoundException
Future<void> _dbGetNa() async {
  final account = util.buildAccount();
  final albums = [(util.AlbumBuilder.ofId(albumId: 0)).build()];
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
  });

  final src = AlbumSqliteDbDataSource(c);
  expect(
    () async => await src.get(account, albums[0].albumFile!),
    throwsA(const TypeMatcher<CacheNotFoundException>()),
  );
}

/// Get multiple albums from DB
///
/// Expect: albums
Future<void> _dbGetAll() async {
  final account = util.buildAccount();
  final albums = [
    (util.AlbumBuilder.ofId(albumId: 0)).build(),
    (util.AlbumBuilder.ofId(albumId: 1)).build(),
    (util.AlbumBuilder.ofId(albumId: 2)).build(),
  ];
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(
      c.sqliteDb,
      account,
      albums.map((a) => a.albumFile!),
    );
    await util.insertAlbums(c.sqliteDb, account, albums);
  });

  final src = AlbumSqliteDbDataSource(c);
  expect(
    await src.getAll(account, [
      albums[0].albumFile!,
      albums[2].albumFile!,
    ]).toList(),
    [albums[0], albums[2]],
  );
}

/// Get multiple albums that doesn't exists in DB
///
/// Expect: ExceptionEvent with CacheNotFoundException
Future<void> _dbGetAllNa() async {
  final account = util.buildAccount();
  final albums = [
    (util.AlbumBuilder.ofId(albumId: 0)).build(),
    (util.AlbumBuilder.ofId(albumId: 1)).build(),
    (util.AlbumBuilder.ofId(albumId: 2)).build(),
  ];
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, [albums[0].albumFile!]);
    await util.insertAlbums(c.sqliteDb, account, [albums[0]]);
  });

  final src = AlbumSqliteDbDataSource(c);
  final results =
      await src.getAll(account, [
        albums[0].albumFile!,
        albums[2].albumFile!,
      ]).toList();
  expect(results.length, 2);
  expect(results[0], albums[0]);
  expect(
    () => throw results[1],
    throwsA(const TypeMatcher<CacheNotFoundException>()),
  );
}

/// Update an existing album in DB
///
/// Expect: album updated
Future<void> _dbUpdateExisting() async {
  final account = util.buildAccount();
  final albums = [
    (util.AlbumBuilder.ofId(albumId: 0)).build(),
    (util.AlbumBuilder.ofId(albumId: 1)).build(),
  ];
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(
      c.sqliteDb,
      account,
      albums.map((a) => a.albumFile!),
    );
    await util.insertAlbums(c.sqliteDb, account, albums);
  });

  final updateAlbum = albums[1].copyWith(
    name: "edit",
    lastUpdated: OrNull(DateTime.utc(2021, 2, 3, 4, 5, 6)),
    provider: AlbumStaticProvider(
      items: [
        AlbumLabelItem(
          addedBy: "admin".toCi(),
          addedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
          text: "test",
        ),
        AlbumFileItem(
          addedBy: "admin".toCi(),
          addedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
          file: files[1].toDescriptor(),
          ownerId: "admin".toCi(),
        ),
      ],
    ),
    coverProvider: AlbumManualCoverProvider(coverFile: files[1].toDescriptor()),
    sortProvider: const AlbumTimeSortProvider(isAscending: true),
  );
  final src = AlbumSqliteDbDataSource(c);
  await src.update(account, updateAlbum);
  expect(await util.listSqliteDbAlbums(c.sqliteDb), {albums[0], updateAlbum});
}

/// Update an album that doesn't exist in DB
///
/// Expect: album inserted
Future<void> _dbUpdateNew() async {
  final account = util.buildAccount();
  final albums = [(util.AlbumBuilder.ofId(albumId: 0)).build()];
  final newAlbum = (util.AlbumBuilder.ofId(albumId: 1)).build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, [
      ...albums.map((a) => a.albumFile!),
      newAlbum.albumFile!,
    ]);
    await util.insertAlbums(c.sqliteDb, account, albums);
  });

  final src = AlbumSqliteDbDataSource(c);
  await src.update(account, newAlbum);
  expect(await util.listSqliteDbAlbums(c.sqliteDb), {...albums, newAlbum});
}

/// Update shares of an album
///
/// Expect: album shares updated
Future<void> _dbUpdateShares() async {
  final account = util.buildAccount();
  final albums = [
    (util.AlbumBuilder.ofId(albumId: 0)).build(),
    (util.AlbumBuilder.ofId(albumId: 1)..addShare("user1")).build(),
  ];
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(
      c.sqliteDb,
      account,
      albums.map((a) => a.albumFile!),
    );
    await util.insertAlbums(c.sqliteDb, account, albums);
  });

  final updateAlbum = albums[1].copyWith(
    name: "edit",
    lastUpdated: OrNull(DateTime.utc(2021, 2, 3, 4, 5, 6)),
    provider: AlbumStaticProvider(
      items: [
        AlbumLabelItem(
          addedBy: "admin".toCi(),
          addedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
          text: "test",
        ),
        AlbumFileItem(
          addedBy: "admin".toCi(),
          addedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
          file: files[1].toDescriptor(),
          ownerId: "admin".toCi(),
        ),
      ],
    ),
    coverProvider: AlbumManualCoverProvider(coverFile: files[1].toDescriptor()),
    sortProvider: const AlbumTimeSortProvider(isAscending: true),
    shares: OrNull([
      AlbumShare(
        userId: "user1".toCi(),
        sharedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
      ),
      AlbumShare(
        userId: "user2".toCi(),
        sharedAt: DateTime.utc(2021, 2, 3, 4, 5, 7),
      ),
    ]),
  );
  final src = AlbumSqliteDbDataSource(c);
  await src.update(account, updateAlbum);
  expect(await util.listSqliteDbAlbums(c.sqliteDb), {albums[0], updateAlbum});
}

/// Delete shares of an album
///
/// Expect: album shares deleted
Future<void> _dbUpdateDeleteShares() async {
  final account = util.buildAccount();
  final albums = [
    (util.AlbumBuilder.ofId(albumId: 0)).build(),
    (util.AlbumBuilder.ofId(albumId: 1)..addShare("user1")).build(),
  ];
  final files =
      (util.FilesBuilder()
            ..addDir("admin")
            ..addJpeg("admin/test1.jpg"))
          .build();
  final c = DiContainer(npDb: util.buildTestDb());
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(
      c.sqliteDb,
      account,
      albums.map((a) => a.albumFile!),
    );
    await util.insertAlbums(c.sqliteDb, account, albums);
  });

  final updateAlbum = albums[1].copyWith(
    name: "edit",
    lastUpdated: OrNull(DateTime.utc(2021, 2, 3, 4, 5, 6)),
    provider: AlbumStaticProvider(
      items: [
        AlbumLabelItem(
          addedBy: "admin".toCi(),
          addedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
          text: "test",
        ),
        AlbumFileItem(
          addedBy: "admin".toCi(),
          addedAt: DateTime.utc(2021, 2, 3, 4, 5, 6),
          file: files[1].toDescriptor(),
          ownerId: "admin".toCi(),
        ),
      ],
    ),
    coverProvider: AlbumManualCoverProvider(coverFile: files[1].toDescriptor()),
    sortProvider: const AlbumTimeSortProvider(isAscending: true),
    shares: const OrNull(null),
  );
  final src = AlbumSqliteDbDataSource(c);
  await src.update(account, updateAlbum);
  expect(await util.listSqliteDbAlbums(c.sqliteDb), {albums[0], updateAlbum});
}
