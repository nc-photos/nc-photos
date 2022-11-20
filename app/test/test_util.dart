import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as sql;
import 'package:drift/native.dart' as sql;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/ci_string.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/entity/sqlite_table.dart' as sql;
import 'package:nc_photos/entity/sqlite_table_converter.dart';
import 'package:nc_photos/entity/sqlite_table_extension.dart' as sql;
import 'package:nc_photos/iterable_extension.dart';
import 'package:nc_photos/or_null.dart';
import 'package:tuple/tuple.dart';

class FilesBuilder {
  FilesBuilder({
    int initialFileId = 0,
  }) : fileId = initialFileId;

  List<File> build() {
    return files.map((f) => f.copyWith()).toList();
  }

  void add(
    String relativePath, {
    int? contentLength,
    String? contentType,
    String? etag,
    DateTime? lastModified,
    bool isCollection = false,
    bool hasPreview = true,
    bool? isFavorite,
    String ownerId = "admin",
    String? ownerDisplayName,
    Metadata? metadata,
  }) {
    files.add(File(
      path: "remote.php/dav/files/$relativePath",
      contentLength: contentLength,
      contentType: contentType,
      etag: etag,
      lastModified:
          lastModified ?? DateTime.utc(2020, 1, 2, 3, 4, 5 + files.length),
      isCollection: isCollection,
      hasPreview: hasPreview,
      fileId: fileId++,
      isFavorite: isFavorite,
      ownerId: ownerId.toCi(),
      ownerDisplayName: ownerDisplayName ?? ownerId.toString(),
      metadata: metadata,
    ));
  }

  void addGenericFile(
    String relativePath,
    String contentType, {
    int contentLength = 1024,
    String? etag,
    DateTime? lastModified,
    bool hasPreview = true,
    bool? isFavorite,
    String ownerId = "admin",
    String? ownerDisplayName,
  }) =>
      add(
        relativePath,
        contentLength: contentLength,
        contentType: contentType,
        etag: etag,
        lastModified: lastModified,
        hasPreview: hasPreview,
        isFavorite: isFavorite,
        ownerId: ownerId,
        ownerDisplayName: ownerDisplayName,
      );

  void addJpeg(
    String relativePath, {
    int contentLength = 1024,
    String? etag,
    DateTime? lastModified,
    bool hasPreview = true,
    bool? isFavorite,
    String ownerId = "admin",
    String? ownerDisplayName,
    OrNull<Metadata>? metadata,
  }) =>
      add(
        relativePath,
        contentLength: contentLength,
        contentType: "image/jpeg",
        etag: etag,
        lastModified: lastModified,
        hasPreview: hasPreview,
        isFavorite: isFavorite,
        ownerId: ownerId,
        ownerDisplayName: ownerDisplayName,
        metadata: metadata?.obj ??
            Metadata(
              lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
              imageWidth: 640,
              imageHeight: 480,
            ),
      );

  void addDir(
    String relativePath, {
    int contentLength = 1024,
    String? etag,
    DateTime? lastModified,
    bool? isFavorite,
    String ownerId = "admin",
    String? ownerDisplayName,
  }) =>
      add(
        relativePath,
        etag: etag,
        lastModified: lastModified,
        isCollection: true,
        hasPreview: false,
        isFavorite: isFavorite,
        ownerId: ownerId,
        ownerDisplayName: ownerDisplayName,
      );

  void addAlbumJson(
    String homeDir,
    String filename, {
    int contentLength = 1024,
    String? etag,
    DateTime? lastModified,
    String ownerId = "admin",
    String? ownerDisplayName,
  }) =>
      add(
        "$homeDir/.com.nkming.nc_photos/albums/$filename.nc_album.json",
        contentLength: contentLength,
        contentType: "application/json",
        etag: etag,
        lastModified: lastModified,
        hasPreview: false,
        ownerId: ownerId,
        ownerDisplayName: ownerDisplayName,
      );

  final files = <File>[];
  int fileId;
}

/// Create an album for testing
class AlbumBuilder {
  AlbumBuilder({
    DateTime? lastUpdated,
    String? name,
    this.albumFilename = "test0.nc_album.json",
    this.fileId = 0,
    String? ownerId,
  })  : lastUpdated = lastUpdated ?? DateTime.utc(2020, 1, 2, 3, 4, 5),
        name = name ?? "test",
        ownerId = ownerId ?? "admin";

  factory AlbumBuilder.ofId({
    required int albumId,
    DateTime? lastUpdated,
    String? name,
    String? ownerId,
  }) =>
      AlbumBuilder(
        lastUpdated: lastUpdated,
        name: name,
        albumFilename: "test$albumId.nc_album.json",
        fileId: albumId,
        ownerId: ownerId,
      );

  Album build() {
    final latestFileItem = items
        .whereType<AlbumFileItem>()
        .stableSorted(
            (a, b) => a.file.lastModified!.compareTo(b.file.lastModified!))
        .reversed
        .firstOrNull;
    return Album(
      lastUpdated: lastUpdated,
      name: name,
      provider: AlbumStaticProvider(
        items: items,
        latestItemTime: latestFileItem?.file.lastModified,
      ),
      coverProvider: cover == null
          ? AlbumAutoCoverProvider(coverFile: latestFileItem?.file)
          : AlbumManualCoverProvider(coverFile: cover!),
      sortProvider: const AlbumNullSortProvider(),
      shares: shares.isEmpty ? null : shares,
      albumFile: buildAlbumFile(
        path: buildAlbumFilePath(albumFilename, user: ownerId),
        fileId: fileId,
        ownerId: ownerId,
      ),
    );
  }

  /// Add a file item
  ///
  /// By default, the item will be added by admin and added at the same time as
  /// the file's lastModified.
  ///
  /// If [isCover] is true, the coverProvider of the album will become
  /// [AlbumManualCoverProvider]
  void addFileItem(
    File file, {
    String addedBy = "admin",
    DateTime? addedAt,
    bool isCover = false,
  }) {
    final fileItem = AlbumFileItem(
      file: file,
      addedBy: addedBy.toCi(),
      addedAt: addedAt ?? file.lastModified!,
    );
    items.add(fileItem);
    if (isCover) {
      cover = file;
    }
  }

  /// Add an album share
  ///
  /// By default, the album will be shared at 2020-01-02 03:04:05
  void addShare(
    String userId, {
    DateTime? sharedAt,
  }) {
    shares.add(buildAlbumShare(
      userId: userId,
      sharedAt: sharedAt,
    ));
  }

  static List<AlbumFileItem> fileItemsOf(Album album) =>
      AlbumStaticProvider.of(album).items.whereType<AlbumFileItem>().toList();

  final DateTime lastUpdated;
  final String name;
  final String albumFilename;
  final int fileId;
  final String ownerId;

  final items = <AlbumItem>[];
  File? cover;
  final shares = <AlbumShare>[];
}

class SqlAccountWithServer with EquatableMixin {
  const SqlAccountWithServer(this.server, this.account);

  @override
  get props => [server, account];

  final sql.Server server;
  final sql.Account account;
}

void initLog() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    String msg =
        "[${record.loggerName}] ${record.level.name} ${record.time}: ${record.message}";
    if (record.error != null) {
      msg += " (throw: ${record.error.runtimeType} { ${record.error} })";
    }
    if (record.stackTrace != null) {
      msg += "\nStack Trace:\n${record.stackTrace}";
    }

    int color;
    if (record.level >= Level.SEVERE) {
      color = 91;
    } else if (record.level >= Level.WARNING) {
      color = 33;
    } else if (record.level >= Level.INFO) {
      color = 34;
    } else if (record.level >= Level.FINER) {
      color = 32;
    } else {
      color = 90;
    }
    msg = "\x1B[${color}m$msg\x1B[0m";

    debugPrint(msg);
  });
}

Account buildAccount({
  String id = "123456-000000",
  String scheme = "http",
  String address = "example.com",
  String userId = "admin",
  String username2 = "admin",
  String password = "pass",
  List<String> roots = const [""],
}) =>
    Account(id, scheme, address, userId.toCi(), username2, password, roots);

/// Build a mock [File] pointing to a album JSON file
///
/// Warning: not all fields are filled, but the most essential ones are
File buildAlbumFile({
  required String path,
  int contentLength = 1024,
  DateTime? lastModified,
  required int fileId,
  String ownerId = "admin",
  String? ownerDisplayName,
  String? etag,
}) =>
    File(
      path: path,
      contentLength: contentLength,
      contentType: "application/json",
      lastModified: lastModified ?? DateTime.utc(2020, 1, 2, 3, 4, 5),
      isCollection: false,
      hasPreview: false,
      fileId: fileId,
      ownerId: ownerId.toCi(),
      ownerDisplayName: ownerDisplayName ?? ownerId.toString(),
      etag: fileId.toString(),
    );

String buildAlbumFilePath(
  String filename, {
  String user = "admin",
}) =>
    "remote.php/dav/files/$user/.com.nkming.nc_photos/albums/$filename";

AlbumShare buildAlbumShare({
  required String userId,
  String? displayName,
  DateTime? sharedAt,
}) =>
    AlbumShare(
      userId: userId.toCi(),
      displayName: displayName ?? userId,
      sharedAt: sharedAt ?? DateTime.utc(2020, 1, 2, 3, 4, 5),
    );

/// Build a mock [File] pointing to a JPEG image file
///
/// Warning: not all fields are filled, but the most essential ones are
File buildJpegFile({
  required String path,
  int contentLength = 1024,
  DateTime? lastModified,
  bool hasPreview = true,
  required int fileId,
  String ownerId = "admin",
  String? ownerDisplayName,
}) =>
    File(
      path: path,
      contentLength: contentLength,
      contentType: "image/jpeg",
      lastModified: lastModified ?? DateTime.utc(2020, 1, 2, 3, 4, 5),
      isCollection: false,
      hasPreview: hasPreview,
      fileId: fileId,
      ownerId: ownerId.toCi(),
      ownerDisplayName: ownerDisplayName ?? ownerId.toString(),
    );

FileDescriptor fileToFileDescriptor(File f) => FileDescriptor(
      fdPath: f.path,
      fdId: f.fileId!,
      fdMime: f.contentType,
      fdIsArchived: f.isArchived ?? false,
      fdIsFavorite: f.isFavorite ?? false,
      fdDateTime: f.bestDateTime,
    );

Share buildShare({
  required String id,
  DateTime? stime,
  String uidOwner = "admin",
  String? displaynameOwner,
  required File file,
  required String shareWith,
}) =>
    Share(
      id: id,
      shareType: ShareType.user,
      stime: stime ?? DateTime.utc(2020, 1, 2, 3, 4, 5),
      uidOwner: uidOwner.toCi(),
      displaynameOwner: displaynameOwner ?? uidOwner,
      uidFileOwner: file.ownerId!,
      path: file.strippedPath,
      itemType: ShareItemType.file,
      mimeType: file.contentType ?? "",
      itemSource: file.fileId!,
      shareWith: shareWith.toCi(),
      shareWithDisplayName: shareWith,
    );

Sharee buildSharee({
  ShareeType type = ShareeType.user,
  String? label,
  int shareType = 0,
  required CiString shareWith,
  String? shareWithDisplayNameUnique,
}) =>
    Sharee(
      type: type,
      label: label ?? shareWith.toString(),
      shareType: shareType,
      shareWith: shareWith,
    );

sql.SqliteDb buildTestDb() {
  sql.driftRuntimeOptions.debugPrint = _debugPrintSql;
  return sql.SqliteDb(
    executor: sql.NativeDatabase.memory(
      logStatements: true,
    ),
  );
}

Future<void> insertFiles(
    sql.SqliteDb db, Account account, Iterable<File> files) async {
  final dbAccount = await db.accountOf(account);
  for (final f in files) {
    final sharedQuery = db.selectOnly(db.files).join([
      sql.innerJoin(
          db.accountFiles, db.accountFiles.file.equalsExp(db.files.rowId),
          useColumns: false),
    ])
      ..addColumns([db.files.rowId])
      ..where(db.accountFiles.account.equals(dbAccount.rowId).not())
      ..where(db.files.fileId.equals(f.fileId!));
    var rowId = (await sharedQuery.map((r) => r.read(db.files.rowId)).get())
        .firstOrNull;
    final insert = SqliteFileConverter.toSql(dbAccount, f);
    if (rowId == null) {
      final dbFile = await db.into(db.files).insertReturning(insert.file);
      rowId = dbFile.rowId;
    }
    final dbAccountFile = await db
        .into(db.accountFiles)
        .insertReturning(insert.accountFile.copyWith(file: sql.Value(rowId)));
    if (insert.image != null) {
      await db.into(db.images).insert(
          insert.image!.copyWith(accountFile: sql.Value(dbAccountFile.rowId)));
    }
    if (insert.imageLocation != null) {
      await db.into(db.imageLocations).insert(insert.imageLocation!
          .copyWith(accountFile: sql.Value(dbAccountFile.rowId)));
    }
    if (insert.trash != null) {
      await db
          .into(db.trashes)
          .insert(insert.trash!.copyWith(file: sql.Value(rowId)));
    }
  }
}

Future<void> insertDirRelation(
    sql.SqliteDb db, Account account, File dir, Iterable<File> children) async {
  final dbAccount = await db.accountOf(account);
  final dirRowIds = (await db
          .accountFileRowIdsByFileIds([dir.fileId!], sqlAccount: dbAccount))
      .first;
  final childRowIds = await db.accountFileRowIdsByFileIds(
      [dir, ...children].map((f) => f.fileId!),
      sqlAccount: dbAccount);
  await db.batch((batch) {
    batch.insertAll(
      db.dirFiles,
      childRowIds.map((c) => sql.DirFilesCompanion.insert(
            dir: dirRowIds.fileRowId,
            child: c.fileRowId,
          )),
    );
  });
}

Future<void> insertAlbums(
    sql.SqliteDb db, Account account, Iterable<Album> albums) async {
  final dbAccount = await db.accountOf(account);
  for (final a in albums) {
    final rowIds =
        await db.accountFileRowIdsOf(a.albumFile!, sqlAccount: dbAccount);
    final insert =
        SqliteAlbumConverter.toSql(a, rowIds.fileRowId, a.albumFile!.etag!);
    final dbAlbum = await db.into(db.albums).insertReturning(insert.album);
    for (final s in insert.albumShares) {
      await db
          .into(db.albumShares)
          .insert(s.copyWith(album: sql.Value(dbAlbum.rowId)));
    }
  }
}

Future<Set<File>> listSqliteDbFiles(sql.SqliteDb db) async {
  final query = db.select(db.files).join([
    sql.innerJoin(
        db.accountFiles, db.accountFiles.file.equalsExp(db.files.rowId)),
    sql.innerJoin(
        db.accounts, db.accounts.rowId.equalsExp(db.accountFiles.account)),
    sql.leftOuterJoin(
        db.images, db.images.accountFile.equalsExp(db.accountFiles.rowId)),
    sql.leftOuterJoin(db.imageLocations,
        db.imageLocations.accountFile.equalsExp(db.accountFiles.rowId)),
    sql.leftOuterJoin(db.trashes, db.trashes.file.equalsExp(db.files.rowId)),
  ]);
  return (await query
          .map((r) => SqliteFileConverter.fromSql(
                r.readTable(db.accounts).userId,
                sql.CompleteFile(
                  r.readTable(db.files),
                  r.readTable(db.accountFiles),
                  r.readTableOrNull(db.images),
                  r.readTableOrNull(db.imageLocations),
                  r.readTableOrNull(db.trashes),
                ),
              ))
          .get())
      .toSet();
}

Future<Map<File, Set<File>>> listSqliteDbDirs(sql.SqliteDb db) async {
  final query = db.select(db.files).join([
    sql.innerJoin(
        db.accountFiles, db.accountFiles.file.equalsExp(db.files.rowId)),
    sql.innerJoin(
        db.accounts, db.accounts.rowId.equalsExp(db.accountFiles.account)),
    sql.leftOuterJoin(
        db.images, db.images.accountFile.equalsExp(db.accountFiles.rowId)),
    sql.leftOuterJoin(db.imageLocations,
        db.imageLocations.accountFile.equalsExp(db.accountFiles.rowId)),
    sql.leftOuterJoin(db.trashes, db.trashes.file.equalsExp(db.files.rowId)),
  ]);
  final fileMap = Map.fromEntries(await query.map((r) {
    final f = sql.CompleteFile(
      r.readTable(db.files),
      r.readTable(db.accountFiles),
      r.readTableOrNull(db.images),
      r.readTableOrNull(db.imageLocations),
      r.readTableOrNull(db.trashes),
    );
    return MapEntry(
      f.file.rowId,
      SqliteFileConverter.fromSql(r.readTable(db.accounts).userId, f),
    );
  }).get());

  final dirQuery = db.select(db.dirFiles);
  final dirs = await dirQuery.map((r) => Tuple2(r.dir, r.child)).get();
  final result = <File, Set<File>>{};
  for (final d in dirs) {
    (result[fileMap[d.item1]!] ??= <File>{}).add(fileMap[d.item2]!);
  }
  return result;
}

Future<Set<Album>> listSqliteDbAlbums(sql.SqliteDb db) async {
  final albumQuery = db.select(db.albums).join([
    sql.innerJoin(db.files, db.files.rowId.equalsExp(db.albums.file)),
    sql.innerJoin(
        db.accountFiles, db.accountFiles.file.equalsExp(db.files.rowId)),
    sql.innerJoin(
        db.accounts, db.accounts.rowId.equalsExp(db.accountFiles.account)),
  ]);
  final albums = await albumQuery.map((r) {
    final albumFile = SqliteFileConverter.fromSql(
      r.readTable(db.accounts).userId,
      sql.CompleteFile(
        r.readTable(db.files),
        r.readTable(db.accountFiles),
        null,
        null,
        null,
      ),
    );
    return Tuple2(
      r.read(db.albums.rowId),
      SqliteAlbumConverter.fromSql(r.readTable(db.albums), albumFile, []),
    );
  }).get();

  final results = <Album>{};
  for (final a in albums) {
    final shareQuery = db.select(db.albumShares)
      ..where((t) => t.album.equals(a.item1));
    final dbShares = await shareQuery.get();
    results.add(a.item2.copyWith(
      lastUpdated: OrNull(null),
      shares: dbShares.isEmpty
          ? null
          : OrNull(dbShares
              .map((s) => AlbumShare(
                  userId: s.userId.toCi(),
                  displayName: s.displayName,
                  sharedAt: s.sharedAt))
              .toList()),
    ));
  }
  return results;
}

Future<Set<SqlAccountWithServer>> listSqliteDbServerAccounts(
    sql.SqliteDb db) async {
  final query = db.select(db.servers).join([
    sql.leftOuterJoin(
        db.accounts, db.accounts.server.equalsExp(db.servers.rowId)),
  ]);
  return (await query
          .map((r) => SqlAccountWithServer(
              r.readTable(db.servers), r.readTable(db.accounts)))
          .get())
      .toSet();
}

bool shouldPrintSql = false;

void _debugPrintSql(String log) {
  if (shouldPrintSql) {
    debugPrint(log, wrapWidth: 1024);
  }
}
