part of '../database_extension.dart';

extension SqliteDbCompat75Extension on SqliteDb {
  Future<void> migrateV75() async {
    final updateFiles = <int>[];
    var i = 0;
    while (true) {
      final q = selectOnly(files).join([
        innerJoin(accountFiles, accountFiles.file.equalsExp(files.rowId),
            useColumns: false),
      ]);
      q
        ..addColumns([files.rowId])
        ..where(files.contentType.equals("application/octet-stream"))
        ..where(accountFiles.relativePath.like("%.jxl"))
        ..orderBy([
          OrderingTerm(
            expression: accountFiles.rowId,
            mode: OrderingMode.asc,
          ),
        ])
        ..limit(1000, offset: i);
      final fileRowIds = await q.map((r) => r.read(files.rowId)!).get();
      updateFiles.addAll(fileRowIds);
      if (fileRowIds.length < 1000) {
        break;
      }
    }

    _log.info("[migrateV75] ${updateFiles.length} rows require updating");
    await batch((batch) {
      for (final e in updateFiles) {
        batch.update(
          files,
          const FilesCompanion(
            contentType: Value("image/jxl"),
          ),
          where: (table) => table.rowId.equals(e),
        );
      }
    });
  }
}

extension SqliteDbCompat55Extension on SqliteDb {
  Future<void> migrateV55(
      void Function(int current, int count)? onProgress) async {
    final countExp = accountFiles.rowId.count();
    final countQ = selectOnly(accountFiles)..addColumns([countExp]);
    final count = await countQ.map((r) => r.read(countExp)!).getSingle();
    onProgress?.call(0, count);

    final dateTimeUpdates = <({int rowId, DateTime dateTime})>[];
    final imageRemoves = <int>[];
    for (var i = 0; i < count; i += 1000) {
      final q = select(files).join([
        innerJoin(accountFiles, accountFiles.file.equalsExp(files.rowId)),
        innerJoin(images, images.accountFile.equalsExp(accountFiles.rowId)),
      ]);
      q
        ..orderBy([
          OrderingTerm(
            expression: accountFiles.rowId,
            mode: OrderingMode.asc,
          ),
        ])
        ..limit(1000, offset: i);
      final dbFiles = await q
          .map((r) => CompleteFile(
                r.readTable(files),
                r.readTable(accountFiles),
                r.readTable(images),
                null,
                null,
              ))
          .get();
      for (final f in dbFiles) {
        final bestDateTime = _getBestDateTimeV55(
          overrideDateTime: f.accountFile.overrideDateTime,
          dateTimeOriginal: f.image?.dateTimeOriginal,
          lastModified: f.file.lastModified,
        );
        if (f.accountFile.bestDateTime != bestDateTime) {
          // need update
          dateTimeUpdates.add((
            rowId: f.accountFile.rowId,
            dateTime: bestDateTime,
          ));
        }

        if (f.file.contentType == "image/heic" &&
            f.image != null &&
            f.image!.exifRaw == null) {
          imageRemoves.add(f.accountFile.rowId);
        }
      }
      onProgress?.call(i, count);
    }

    _log.info(
        "[migrateV55] ${dateTimeUpdates.length} rows require updating, ${imageRemoves.length} rows require removing");
    if (isDevMode) {
      _log.fine(
          "[migrateV55] dateTimeUpdates: ${dateTimeUpdates.map((e) => e.rowId).toReadableString()}");
      _log.fine(
          "[migrateV55] imageRemoves: ${imageRemoves.map((e) => e).toReadableString()}");
    }
    await batch((batch) {
      for (final pair in dateTimeUpdates) {
        batch.update(
          accountFiles,
          AccountFilesCompanion(
            bestDateTime: Value(pair.dateTime),
          ),
          where: ($AccountFilesTable table) => table.rowId.equals(pair.rowId),
        );
      }
      for (final r in imageRemoves) {
        batch.deleteWhere(
          images,
          ($ImagesTable table) => table.accountFile.equals(r),
        );
      }
    });
  }

  static DateTime _getBestDateTimeV55({
    DateTime? overrideDateTime,
    DateTime? dateTimeOriginal,
    DateTime? lastModified,
  }) =>
      overrideDateTime ??
      dateTimeOriginal ??
      lastModified ??
      clock.now().toUtc();
}
