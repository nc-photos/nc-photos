import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:np_common/or_null.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/src/converter.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/database_extension.dart';
import 'package:np_string/np_string.dart';

class FilesBuilder {
  FilesBuilder({int initialFileId = 0}) : fileId = initialFileId;

  List<DbFile> build() {
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
    DbImageData? imageData,
    DbLocation? location,
  }) {
    files.add(
      DbFile(
        fileId: fileId++,
        contentLength: contentLength,
        contentType: contentType,
        etag: etag,
        lastModified:
            lastModified ?? DateTime.utc(2020, 1, 2, 3, 4, 5 + files.length),
        isCollection: isCollection,
        usedBytes: null,
        hasPreview: hasPreview,
        ownerId: ownerId.toCi(),
        ownerDisplayName: ownerDisplayName ?? ownerId.toString(),
        relativePath: relativePath,
        isFavorite: isFavorite,
        isArchived: null,
        overrideDateTime: null,
        bestDateTime: _getBestDateTime(
          overrideDateTime: null,
          dateTimeOriginal: imageData?.exifDateTimeOriginal,
          lastModified:
              lastModified ?? DateTime.utc(2020, 1, 2, 3, 4, 5 + files.length),
        ),
        imageData: imageData,
        location: location,
        trashData: null,
      ),
    );
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
  }) => add(
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
    OrNull<DbImageData>? imageData,
    DbLocation? location,
  }) => add(
    relativePath,
    contentLength: contentLength,
    contentType: "image/jpeg",
    etag: etag,
    lastModified: lastModified,
    hasPreview: hasPreview,
    isFavorite: isFavorite,
    ownerId: ownerId,
    ownerDisplayName: ownerDisplayName,
    imageData:
        imageData == null
            ? DbImageData(
              lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
              fileEtag: etag,
              width: 640,
              height: 480,
              exif: null,
              exifDateTimeOriginal: null,
              src: 0,
            )
            : imageData.obj,
    location: location,
  );

  void addDir(
    String relativePath, {
    int contentLength = 1024,
    String? etag,
    DateTime? lastModified,
    bool? isFavorite,
    String ownerId = "admin",
    String? ownerDisplayName,
  }) => add(
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
  }) => add(
    "$homeDir/.com.nkming.nc_photos/albums/$filename.nc_album.json",
    contentLength: contentLength,
    contentType: "application/json",
    etag: etag,
    lastModified: lastModified,
    hasPreview: false,
    ownerId: ownerId,
    ownerDisplayName: ownerDisplayName,
  );

  final files = <DbFile>[];
  int fileId;
}

DbAccount buildAccount({
  String serverAddress = "example.com",
  String userId = "admin",
}) => DbAccount(serverAddress: serverAddress, userId: userId.toCi());

SqliteDb buildTestDb() {
  driftRuntimeOptions.debugPrint = _debugPrintSql;
  return SqliteDb(executor: NativeDatabase.memory(logStatements: true));
}

Future<void> insertFiles(
  SqliteDb db,
  DbAccount account,
  Iterable<DbFile> files,
) async {
  final sqlAccount = await db.accountOf(ByAccount.db(account));
  for (final f in files) {
    final sharedQuery =
        db.selectOnly(db.files).join([
            innerJoin(
              db.accountFiles,
              db.accountFiles.file.equalsExp(db.files.rowId),
              useColumns: false,
            ),
          ])
          ..addColumns([db.files.rowId])
          ..where(db.accountFiles.account.equals(sqlAccount.rowId).not())
          ..where(db.files.fileId.equals(f.fileId));
    var rowId =
        (await sharedQuery.map((r) => r.read(db.files.rowId)).get())
            .firstOrNull;
    final insert = FileConverter.toSql(f);
    if (rowId == null) {
      final dbFile = await db
          .into(db.files)
          .insertReturning(
            insert.file.copyWith(server: Value(sqlAccount.server)),
          );
      rowId = dbFile.rowId;
    }
    final sqlAccountFile = await db
        .into(db.accountFiles)
        .insertReturning(
          insert.accountFile.copyWith(
            account: Value(sqlAccount.rowId),
            file: Value(rowId),
          ),
        );
    if (insert.image != null) {
      await db
          .into(db.images)
          .insert(
            insert.image!.copyWith(accountFile: Value(sqlAccountFile.rowId)),
          );
    }
    if (insert.imageLocation != null) {
      await db
          .into(db.imageLocations)
          .insert(
            insert.imageLocation!.copyWith(
              accountFile: Value(sqlAccountFile.rowId),
            ),
          );
    }
    if (insert.trash != null) {
      await db
          .into(db.trashes)
          .insert(insert.trash!.copyWith(file: Value(rowId)));
    }
  }
}

bool shouldPrintSql = false;

void _debugPrintSql(String log) {
  if (shouldPrintSql) {
    debugPrint(log, wrapWidth: 1024);
  }
}

DateTime _getBestDateTime({
  DateTime? overrideDateTime,
  DateTime? dateTimeOriginal,
  DateTime? lastModified,
}) =>
    overrideDateTime ?? dateTimeOriginal ?? lastModified ?? clock.now().toUtc();
