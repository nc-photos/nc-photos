part of '../database_extension.dart';

class CompleteFile {
  const CompleteFile(
      this.file, this.accountFile, this.image, this.imageLocation, this.trash);

  final File file;
  final AccountFile accountFile;
  final Image? image;
  final ImageLocation? imageLocation;
  final Trash? trash;
}

class CompleteFileCompanion {
  const CompleteFileCompanion(
      this.file, this.accountFile, this.image, this.imageLocation, this.trash);

  final FilesCompanion file;
  final AccountFilesCompanion accountFile;
  final ImagesCompanion? image;
  final ImageLocationsCompanion? imageLocation;
  final TrashesCompanion? trash;
}

class FileDescriptor {
  const FileDescriptor({
    required this.relativePath,
    required this.fileId,
    required this.contentType,
    required this.isArchived,
    required this.isFavorite,
    required this.bestDateTime,
  });

  final String relativePath;
  final int fileId;
  final String? contentType;
  final bool? isArchived;
  final bool? isFavorite;
  final DateTime bestDateTime;
}

class CountFileGroupsByDateResult {
  const CountFileGroupsByDateResult({
    required this.dateCount,
  });

  final Map<Date, int> dateCount;
}

extension SqliteDbFileExtension on SqliteDb {
  /// Return files located inside [dir]
  Future<List<CompleteFile>> queryFilesByDirKey({
    required ByAccount account,
    required DbFileKey dir,
  }) async {
    _log.info("[queryFilesByDirKey] dir: $dir");
    final sqlAccount = await accountOf(account);
    final AccountFileRowIds dirIds;
    try {
      dirIds = await _accountFileRowIdsOfSingle(ByAccount.sql(sqlAccount), dir)
          .notNull();
    } catch (_) {
      throw DbNotFoundException("No entry: $dir");
    }
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(FilesQueryMode.completeFile)
        ..setAccount(account);
      q.byDirRowId(dirIds.fileRowId);
      return q.build();
    });
    return _mapCompleteFile(query);
  }

  /// Return files located inside [dirRelativePath]
  Future<List<CompleteFile>> queryFilesByLocation({
    required ByAccount account,
    required String dirRelativePath,
    required String? place,
    required String countryCode,
  }) async {
    _log.info("[queryFilesByLocation] dirRelativePath: $dirRelativePath, "
        "place: $place, "
        "countryCode: $countryCode");
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(FilesQueryMode.completeFile)
        ..setAccount(account);
      if (dirRelativePath.isNotEmpty) {
        q.byOrRelativePathPattern("$dirRelativePath/%");
      }
      return q.build();
    });
    if (place == null || alpha2CodeToName(countryCode) == place) {
      // some places in the DB have the same name as the country, in such
      // cases, we return all photos from the country
      query.where(imageLocations.countryCode.equals(countryCode));
    } else {
      query
        ..where(imageLocations.name.equals(place) |
            imageLocations.admin1.equals(place) |
            imageLocations.admin2.equals(place))
        ..where(imageLocations.countryCode.equals(countryCode));
    }
    return _mapCompleteFile(query);
  }

  /// Query [CompleteFile]s by file id
  ///
  /// Returned files are NOT guaranteed to be sorted as [fileIds]
  Future<List<CompleteFile>> queryFilesByFileIds({
    required ByAccount account,
    required Iterable<int> fileIds,
  }) {
    _log.info(
        "[queryFilesByFileIds] fileIds: (length: ${fileIds.length}) ${fileIds.toReadableString(truncate: 10)}");
    return fileIds.withPartition((sublist) {
      final query = _queryFiles().let((q) {
        q
          ..setQueryMode(FilesQueryMode.completeFile)
          ..setAccount(account)
          ..byFileIds(sublist);
        return q.build();
      });
      return _mapCompleteFile(query);
    }, _maxByFileIdsSize);
  }

  Future<List<CompleteFile>> queryFilesByTimeRange({
    required ByAccount account,
    required List<String> dirRoots,
    required TimeRange range,
  }) {
    _log.info("[queryFilesByTimeRange] range: $range");
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(FilesQueryMode.completeFile)
        ..setAccount(account);
      for (final r in dirRoots) {
        if (r.isNotEmpty) {
          q.byOrRelativePathPattern("$r/%");
        }
      }
      return q.build();
    });
    accountFiles.bestDateTime
        .isBetweenTimeRange(range)
        ?.let((e) => query.where(e));
    query.orderBy([
      OrderingTerm.desc(accountFiles.bestDateTime),
      OrderingTerm.desc(files.fileId),
    ]);
    return _mapCompleteFile(query);
  }

  Future<List<int>> queryFileIds({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    bool? isFavorite,
    bool? isArchived,
    List<String>? mimes,
    int? limit,
  }) async {
    _log.info(
      "[queryFileIds] "
      "includeRelativeRoots: $includeRelativeRoots, "
      "includeRelativeDirs: $includeRelativeDirs, "
      "excludeRelativeRoots: $excludeRelativeRoots, "
      "isFavorite: $isFavorite, "
      "isArchived: $isArchived, "
      "mimes: $mimes, "
      "limit: $limit, ",
    );

    List<int>? dirIds;
    if (includeRelativeDirs?.isNotEmpty == true) {
      final sqlAccount = await accountOf(account);
      final result = await _accountFileRowIdsOf(ByAccount.sql(sqlAccount),
              includeRelativeDirs!.map((e) => DbFileKey.byPath(e)).toList())
          .notNull();
      dirIds = result.values.map((e) => e.fileRowId).toList();
      if (dirIds.length != includeRelativeDirs.length) {
        _log.warning(
            "[queryFileIds] Some dirs not found: $includeRelativeDirs");
      }
    }

    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [files.fileId],
        )
        ..setAccount(account);
      if (includeRelativeRoots != null) {
        if (includeRelativeRoots.none((p) => p.isEmpty)) {
          for (final r in includeRelativeRoots) {
            q.byOrRelativePathPattern("$r/%");
          }
          if (dirIds != null) {
            for (final i in dirIds) {
              q.byOrDirRowId(i);
            }
          }
        }
      } else {
        if (dirIds != null) {
          for (final i in dirIds) {
            q.byOrDirRowId(i);
          }
        }
      }
      if (isFavorite != null) {
        q.byFavorite(isFavorite);
      }
      if (isArchived != null) {
        q.byArchived(isArchived);
      }
      return q.build();
    });
    if (excludeRelativeRoots != null) {
      for (final r in excludeRelativeRoots) {
        query.where(accountFiles.relativePath.like("$r/%").not());
      }
    }
    if (mimes != null) {
      query.where(files.contentType.isIn(mimes));
    } else {
      query.where(files.isCollection.isNotValue(true));
    }
    query.orderBy([
      OrderingTerm.desc(accountFiles.bestDateTime),
      OrderingTerm.desc(files.fileId),
    ]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.map((r) => r.read(files.fileId)!).get();
  }

  Future<void> updateFileByFileId({
    required ByAccount account,
    required int fileId,
    String? relativePath,
    OrNull<bool>? isFavorite,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    DateTime? bestDateTime,
    OrNull<DbImageData>? imageData,
    OrNull<DbLocation>? location,
  }) async {
    // changing overrideDateTime/imageData requires changing bestDateTime
    // together
    assert((overrideDateTime == null && imageData == null) ==
        (bestDateTime == null));
    _log.info(
        "[updateFileByFileId] fileId: $fileId, relativePath: $relativePath");
    final rowId =
        await _accountFileRowIdsOfSingle(account, DbFileKey.byId(fileId))
            .notNull();
    final q = update(accountFiles)
      ..where((t) => t.rowId.equals(rowId.accountFileRowId));
    await q.write(AccountFilesCompanion(
      relativePath: relativePath?.let(Value.new) ?? const Value.absent(),
      isFavorite: isFavorite?.let((e) => Value(e.obj)) ?? const Value.absent(),
      isArchived: isArchived?.let((e) => Value(e.obj)) ?? const Value.absent(),
      overrideDateTime:
          overrideDateTime?.let((e) => Value(e.obj)) ?? const Value.absent(),
      bestDateTime: bestDateTime?.let(Value.new) ?? const Value.absent(),
    ));
    if (imageData != null) {
      if (imageData.obj == null) {
        await (delete(images)
              ..where((t) => t.accountFile.equals(rowId.accountFileRowId)))
            .go();
      } else {
        await into(images).insertOnConflictUpdate(ImagesCompanion.insert(
          accountFile: Value(rowId.accountFileRowId),
          lastUpdated: imageData.obj!.lastUpdated,
          fileEtag: Value(imageData.obj!.fileEtag),
          width: Value(imageData.obj!.width),
          height: Value(imageData.obj!.height),
          exifRaw: Value(imageData.obj!.exif?.let(jsonEncode)),
          dateTimeOriginal: Value(imageData.obj!.exifDateTimeOriginal),
        ));
      }
    }
    if (location != null) {
      if (location.obj == null) {
        await (delete(imageLocations)
              ..where((t) => t.accountFile.equals(rowId.accountFileRowId)))
            .go();
      } else {
        await into(imageLocations)
            .insertOnConflictUpdate(ImageLocationsCompanion.insert(
          accountFile: Value(rowId.accountFileRowId),
          version: location.obj!.version,
          name: Value(location.obj!.name),
          latitude: Value(location.obj!.latitude),
          longitude: Value(location.obj!.longitude),
          countryCode: Value(location.obj!.countryCode),
          admin1: Value(location.obj!.admin1),
          admin2: Value(location.obj!.admin2),
        ));
      }
    }
  }

  Future<void> updateFilesByFileIds({
    required ByAccount account,
    required List<int> fileIds,
    OrNull<bool>? isFavorite,
    OrNull<bool>? isArchived,
  }) async {
    // TODO: partition
    _log.info("[updateFilesByFileIds] fileIds: $fileIds, "
        "isFavorite: $isFavorite, "
        "isArchived: $isArchived");
    final rowIds = await _accountFileRowIdsOf(
        account, fileIds.map(DbFileKey.byId).toList());
    final q = update(accountFiles)
      ..where(
          (t) => t.rowId.isIn(rowIds.values.map((e) => e.accountFileRowId)));
    await q.write(AccountFilesCompanion(
      isFavorite: isFavorite?.let((e) => Value(e.obj)) ?? const Value.absent(),
      isArchived: isArchived?.let((e) => Value(e.obj)) ?? const Value.absent(),
    ));
  }

  Future<void> syncDirFiles({
    required ByAccount account,
    required DbFileKey dirFile,
    required List<CompleteFileCompanion> objs,
  }) async {
    _log.info("[syncDirFiles] files: [length: ${objs.length}]");
    final sqlAccount = await accountOf(account);
    // query list of rowIds for files
    final rowIds = await _accountFileRowIdsOf(ByAccount.sql(sqlAccount),
        objs.map((f) => DbFileKey.byId(f.file.fileId.value)).toList());

    final inserts = await _updateFiles(
      objs: objs,
      fileRowIds: rowIds,
    );
    _log.info("[syncDirFiles] Updated ${objs.length - inserts.length} files");
    // file id to row id
    final idMap = rowIds.map((key, value) => MapEntry(key, value.fileRowId));
    if (inserts.isNotEmpty) {
      final insertMap = await _insertFiles(
        account: sqlAccount,
        objs: inserts,
      );
      _log.info("[syncDirFiles] Inserted ${insertMap.length} files");
      idMap.addAll(insertMap);
    }

    final dirFileId = dirFile.fileId ??
        await _queryFileIdByRelativePath(
          account: ByAccount.sql(sqlAccount),
          relativePath: dirFile.relativePath!,
        ).notNull();
    final dirRowId = idMap[dirFileId];
    if (dirRowId == null) {
      _log.severe("[syncDirFiles] Dir not inserted");
      throw StateError("Row ID for dir is null");
    }
    await _replaceDirFiles(
      account: sqlAccount,
      dirRowId: dirRowId,
      childRowIds: idMap.values.toList(),
    );
  }

  Future<void> syncFile({
    required ByAccount account,
    required CompleteFileCompanion obj,
  }) async {
    _log.info("[syncFile] file: ${obj.accountFile.relativePath}");
    final sqlAccount = await accountOf(account);
    // query list of rowIds for files
    final rowId = await _accountFileRowIdsOfSingle(
        ByAccount.sql(sqlAccount), DbFileKey.byId(obj.file.fileId.value));

    if (rowId == null) {
      // insert
      await _insertFiles(
        account: sqlAccount,
        objs: [obj],
      );
      _log.info("[syncFile] Inserted file");
    } else {
      // update
      await _updateFiles(
        objs: [obj],
        fileRowIds: {obj.file.fileId.value: rowId},
      );
      _log.info("[syncFile] Updated file");
    }
  }

  Future<int> countFiles({
    required ByAccount account,
    bool? isMissingMetadata,
    List<String>? mimes,
    String? ownerId,
  }) async {
    _log.info(
        "[countFiles] isMissingMetadata: $isMissingMetadata, mimes: $mimes, ownerId: $ownerId");
    Expression<bool>? filter;
    if (isMissingMetadata != null) {
      if (isMissingMetadata) {
        filter = images.lastUpdated.isNull() | imageLocations.version.isNull();
      } else {
        filter =
            images.lastUpdated.isNotNull() & imageLocations.version.isNotNull();
      }
    }
    final count = countAll(filter: filter);
    final query = selectOnly(files).join([
      innerJoin(accountFiles, accountFiles.file.equalsExp(files.rowId),
          useColumns: false),
      if (account.dbAccount != null) ...[
        innerJoin(accounts, accounts.rowId.equalsExp(accountFiles.account),
            useColumns: false),
        innerJoin(servers, servers.rowId.equalsExp(accounts.server),
            useColumns: false),
      ],
      leftOuterJoin(images, images.accountFile.equalsExp(accountFiles.rowId),
          useColumns: false),
      leftOuterJoin(imageLocations,
          imageLocations.accountFile.equalsExp(accountFiles.rowId),
          useColumns: false),
    ]);
    query.addColumns([count]);
    if (account.sqlAccount != null) {
      query.where(accountFiles.account.equals(account.sqlAccount!.rowId));
    } else if (account.dbAccount != null) {
      query
        ..where(servers.address.equals(account.dbAccount!.serverAddress))
        ..where(accounts.userId
            .equals(account.dbAccount!.userId.toCaseInsensitiveString()));
    }
    if (mimes != null) {
      query.where(files.contentType.isIn(mimes));
    }
    if (ownerId != null) {
      query.where(files.ownerId.equals(ownerId));
    }
    return await query.map((r) => r.read(count)!).getSingle();
  }

  Future<List<({int fileId, String relativePath})>>
      queryFileIdPathsByMissingMetadata({
    required ByAccount account,
    bool? isMissingMetadata,
    List<String>? mimes,
    String? ownerId,
    int? offset,
    int? limit,
  }) async {
    _log.info(
        "[queryFileIdPathsByMissingMetadata] isMissingMetadata: $isMissingMetadata, mimes: $mimes, ownerId: $ownerId");
    final query = selectOnly(files).join([
      innerJoin(accountFiles, accountFiles.file.equalsExp(files.rowId),
          useColumns: false),
      if (account.dbAccount != null) ...[
        innerJoin(accounts, accounts.rowId.equalsExp(accountFiles.account),
            useColumns: false),
        innerJoin(servers, servers.rowId.equalsExp(accounts.server),
            useColumns: false),
      ],
      leftOuterJoin(images, images.accountFile.equalsExp(accountFiles.rowId),
          useColumns: false),
      leftOuterJoin(imageLocations,
          imageLocations.accountFile.equalsExp(accountFiles.rowId),
          useColumns: false),
    ]);
    query.addColumns([files.fileId, accountFiles.relativePath]);
    if (account.sqlAccount != null) {
      query.where(accountFiles.account.equals(account.sqlAccount!.rowId));
    } else if (account.dbAccount != null) {
      query
        ..where(servers.address.equals(account.dbAccount!.serverAddress))
        ..where(accounts.userId
            .equals(account.dbAccount!.userId.toCaseInsensitiveString()));
    }
    if (mimes != null) {
      query.where(files.contentType.isIn(mimes));
    }
    if (ownerId != null) {
      query.where(files.ownerId.equals(ownerId));
    }
    if (isMissingMetadata != null) {
      if (isMissingMetadata) {
        query.where(
            images.lastUpdated.isNull() | imageLocations.version.isNull());
      } else {
        query.where(images.lastUpdated.isNotNull() &
            imageLocations.version.isNotNull());
      }
    }

    query.orderBy([OrderingTerm.desc(files.fileId)]);
    if (limit != null) {
      query.limit(limit, offset: offset);
    }
    return await query
        .map((r) => (
              fileId: r.read(files.fileId)!,
              relativePath: r.read(accountFiles.relativePath)!,
            ))
        .get();
  }

  Future<List<FileDescriptor>> queryFileDescriptors({
    required ByAccount account,
    List<int>? fileIds,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    List<String>? relativePathKeywords,
    String? location,
    bool? isFavorite,
    bool? isArchived,
    List<String>? mimes,
    TimeRange? timeRange,
    bool? isAscending,
    int? offset,
    int? limit,
  }) async {
    _log.info(
      "[queryFileDescriptors] "
      "fileIds: ${fileIds?.toReadableString(truncate: 10)}, "
      "includeRelativeRoots: $includeRelativeRoots, "
      "includeRelativeDirs: $includeRelativeDirs, "
      "excludeRelativeRoots: $excludeRelativeRoots, "
      "relativePathKeywords: $relativePathKeywords, "
      "location: $location, "
      "isFavorite: $isFavorite, "
      "isArchived: $isArchived, "
      "mimes: $mimes, "
      "timeRange: $timeRange, "
      "offset: $offset, "
      "limit: $limit",
    );

    List<int>? dirIds;
    if (includeRelativeDirs?.isNotEmpty == true) {
      final sqlAccount = await accountOf(account);
      final result = await _accountFileRowIdsOf(ByAccount.sql(sqlAccount),
              includeRelativeDirs!.map((e) => DbFileKey.byPath(e)).toList())
          .notNull();
      dirIds = result.values.map((e) => e.fileRowId).toList();
      if (dirIds.length != includeRelativeDirs.length) {
        _log.warning("Some dirs not found: $includeRelativeDirs");
      }
    }

    Future<List<FileDescriptor>> query({
      List<int>? fileIds,
    }) {
      final query = _queryFiles().let((q) {
        q
          ..setQueryMode(
            FilesQueryMode.expression,
            expressions: [
              accountFiles.relativePath,
              files.fileId,
              files.contentType,
              accountFiles.isArchived,
              accountFiles.isFavorite,
              accountFiles.bestDateTime,
            ],
          )
          ..setAccount(account);
        if (fileIds != null) {
          q.byFileIds(fileIds);
        }
        if (includeRelativeRoots != null) {
          if (includeRelativeRoots.none((p) => p.isEmpty)) {
            for (final r in includeRelativeRoots) {
              q.byOrRelativePathPattern("$r/%");
            }
            if (dirIds != null) {
              for (final i in dirIds) {
                q.byOrDirRowId(i);
              }
            }
          }
        } else {
          if (dirIds != null) {
            for (final i in dirIds) {
              q.byOrDirRowId(i);
            }
          }
        }
        if (location != null) {
          q.byLocation(location);
        }
        if (isFavorite != null) {
          q.byFavorite(isFavorite);
        }
        if (isArchived != null) {
          q.byArchived(isArchived);
        }
        return q.build();
      });
      if (excludeRelativeRoots != null) {
        for (final r in excludeRelativeRoots) {
          query.where(accountFiles.relativePath.like("$r/%").not());
        }
      }
      if (mimes != null) {
        query.where(files.contentType.isIn(mimes));
      } else {
        query.where(files.isCollection.isNotValue(true));
      }
      for (final k in relativePathKeywords ?? const []) {
        query.where(accountFiles.relativePath.like("%$k%"));
      }
      if (isAscending ?? false) {
        query.orderBy([
          OrderingTerm.asc(accountFiles.bestDateTime),
          OrderingTerm.asc(files.fileId),
        ]);
      } else {
        query.orderBy([
          OrderingTerm.desc(accountFiles.bestDateTime),
          OrderingTerm.desc(files.fileId),
        ]);
      }
      if (limit != null) {
        query.limit(limit, offset: offset);
      }
      if (timeRange != null) {
        accountFiles.bestDateTime
            .isBetweenTimeRange(timeRange)
            ?.let((e) => query.where(e));
      }
      return query
          .map((r) => FileDescriptor(
                relativePath: r.read(accountFiles.relativePath)!,
                fileId: r.read(files.fileId)!,
                contentType: r.read(files.contentType),
                isArchived: r.read(accountFiles.isArchived),
                isFavorite: r.read(accountFiles.isFavorite),
                bestDateTime: r.read(accountFiles.bestDateTime)!.toUtc(),
              ))
          .get();
    }

    if (fileIds != null) {
      return fileIds.withPartition((sublist) {
        return query(
          fileIds: sublist.toList(),
        );
      }, _maxByFileIdsSize);
    } else {
      return query(
        fileIds: fileIds,
      );
    }
  }

  Future<void> deleteFile({
    required ByAccount account,
    required DbFileKey file,
  }) async {
    _log.info("[deleteFile] file: $file");
    final dbAccount = await accountOf(account);
    final rowId = await _accountFileRowIdsOfSingle(account, file);
    if (rowId == null) {
      _log.severe("[deleteFile] file not found: $file");
      throw StateError("File not found");
    }
    await _deleteFilesByRowIds(
      account: dbAccount,
      fileRowIds: [rowId.fileRowId],
    );
    await cleanUpDanglingFiles();
  }

  Future<Map<int, String>> getDirFileIdToEtagByLikeRelativePath({
    required ByAccount account,
    required String relativePath,
  }) async {
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [files.fileId, files.etag],
        )
        ..setAccount(account);
      if (relativePath.isNotEmpty) {
        q
          ..byOrRelativePath(relativePath)
          ..byOrRelativePathPattern("$relativePath/%");
      }
      return q.build();
    });
    query.where(files.isCollection.equals(true));
    return Map.fromEntries(await query
        .map((r) => MapEntry(r.read(files.fileId)!, r.read(files.etag)!))
        .get());
  }

  Future<void> truncateDir({
    required ByAccount account,
    required DbFileKey dir,
  }) async {
    _log.info("[truncateDir] dir: $dir");
    final rowId = await _accountFileRowIdsOfSingle(account, dir);
    if (rowId == null) {
      _log.severe("[truncateDir] dir not found: $dir");
      throw StateError("File not found");
    }

    // remove children
    final childIdsQuery = selectOnly(dirFiles)
      ..addColumns([dirFiles.child])
      ..where(dirFiles.dir.equals(rowId.fileRowId));
    final childRowIds =
        await childIdsQuery.map((r) => r.read(dirFiles.child)!).get();
    childRowIds.removeWhere((id) => id == rowId.fileRowId);
    if (childRowIds.isNotEmpty) {
      final dbAccount = await accountOf(account);
      await _deleteFilesByRowIds(account: dbAccount, fileRowIds: childRowIds);
      await cleanUpDanglingFiles();
    }

    // remove dir in DirFiles
    await (delete(dirFiles)..where((t) => t.dir.equals(rowId.fileRowId))).go();
  }

  Future<int?> _queryFileIdByRelativePath({
    required ByAccount account,
    required String relativePath,
  }) async {
    _log.info("[_queryFileIdByRelativePath] relativePath: $relativePath");
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [
            files.fileId,
          ],
        )
        ..setAccount(account)
        ..byRelativePath(relativePath);
      return q.build()..limit(1);
    });
    return query.map((r) => r.read(files.fileId)!).getSingleOrNull();
  }

  /// Count number of files per date
  Future<CountFileGroupsByDateResult> countFileGroupsByDate({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
    bool? isArchived,
  }) async {
    _log.info(
      "[countFileGroupsByDate] "
      "includeRelativeRoots: $includeRelativeRoots, "
      "includeRelativeDirs: $includeRelativeDirs, "
      "excludeRelativeRoots: $excludeRelativeRoots, "
      "mimes: $mimes",
    );

    List<int>? dirIds;
    if (includeRelativeDirs?.isNotEmpty == true) {
      final sqlAccount = await accountOf(account);
      final result = await _accountFileRowIdsOf(ByAccount.sql(sqlAccount),
              includeRelativeDirs!.map((e) => DbFileKey.byPath(e)).toList())
          .notNull();
      dirIds = result.values.map((e) => e.fileRowId).toList();
      if (dirIds.length != includeRelativeDirs.length) {
        _log.warning("Some dirs not found: $includeRelativeDirs");
      }
    }

    final count = countAll();
    final localDate = accountFiles.bestDateTime
        .modify(const DateTimeModifier.localTime())
        .date;
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [localDate, count],
        )
        ..setAccount(account);
      if (includeRelativeRoots != null) {
        if (includeRelativeRoots.none((p) => p.isEmpty)) {
          for (final r in includeRelativeRoots) {
            q.byOrRelativePathPattern("$r/%");
          }
          if (dirIds != null) {
            for (final i in dirIds) {
              q.byOrDirRowId(i);
            }
          }
        }
      } else {
        if (dirIds != null) {
          for (final i in dirIds) {
            q.byOrDirRowId(i);
          }
        }
      }
      return q.build();
    });
    if (excludeRelativeRoots != null) {
      for (final r in excludeRelativeRoots) {
        query.where(accountFiles.relativePath.like("$r/%").not());
      }
    }
    if (mimes != null) {
      query.where(files.contentType.isIn(mimes));
    } else {
      query.where(files.isCollection.isNotValue(true));
    }
    if (isArchived != null) {
      if (isArchived) {
        query.where(accountFiles.isArchived.equals(true));
      } else {
        query.where(accountFiles.isArchived.equals(false) |
            accountFiles.isArchived.isNull());
      }
    }
    query
      ..orderBy([OrderingTerm.desc(accountFiles.bestDateTime)])
      ..groupBy([localDate]);
    final results = await query
        .map((r) => MapEntry<Date, int>(
              DateTime.parse(r.read(localDate)!).toDate(),
              r.read(count)!,
            ))
        .get();
    return CountFileGroupsByDateResult(dateCount: results.toMap());
  }

  /// Query files descriptors whose date is lying in a specific month and day
  /// range
  Future<List<FileDescriptor>> queryFileDescriptorMemories({
    required ByAccount account,
    required Date at,
    required int radius,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  }) async {
    _log.info(
      "[queryFileDescriptorMemoryGroups] "
      "at: $at, "
      "radius: $radius, "
      "includeRelativeRoots: $includeRelativeRoots, "
      "excludeRelativeRoots: $excludeRelativeRoots, "
      "mimes: $mimes",
    );

    final dates =
        List.generate(radius * 2 + 1, (index) => at.add(day: -radius + index));
    final localTimeColumn =
        accountFiles.bestDateTime.modify(const DateTimeModifier.localTime());
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [
            accountFiles.relativePath,
            files.fileId,
            files.contentType,
            accountFiles.isArchived,
            accountFiles.isFavorite,
            accountFiles.bestDateTime,
          ],
        )
        ..setAccount(account)
        ..byArchived(false);
      if (includeRelativeRoots != null) {
        if (includeRelativeRoots.none((p) => p.isEmpty)) {
          for (final r in includeRelativeRoots) {
            q.byOrRelativePathPattern("$r/%");
          }
        }
      }
      return q.build();
    });
    if (excludeRelativeRoots != null) {
      for (final r in excludeRelativeRoots) {
        query.where(accountFiles.relativePath.like("$r/%").not());
      }
    }
    if (mimes != null) {
      query.where(files.contentType.isIn(mimes));
    } else {
      query.where(files.isCollection.isNotValue(true));
    }
    query.where(accountFiles.bestDateTime
        .isSmallerThanValue(at.add(month: -11).toLocalDateTime()));
    Expression<bool>? dateExp;
    for (final d in dates) {
      final thisExp = localTimeColumn.month.equals(d.month) &
          localTimeColumn.day.equals(d.day);
      if (dateExp == null) {
        dateExp = thisExp;
      } else {
        dateExp |= thisExp;
      }
    }
    query.where(dateExp!.isValue(true));
    final results = await query
        .map((r) => FileDescriptor(
              relativePath: r.read(accountFiles.relativePath)!,
              fileId: r.read(files.fileId)!,
              contentType: r.read(files.contentType),
              isArchived: r.read(accountFiles.isArchived),
              isFavorite: r.read(accountFiles.isFavorite),
              bestDateTime: r.read(accountFiles.bestDateTime)!.toUtc(),
            ))
        .get();
    return results;
  }

  /// Update Db files
  ///
  /// Return a list of files that are not yet inserted to the DB (thus not
  /// possible to update)
  Future<List<CompleteFileCompanion>> _updateFiles({
    required List<CompleteFileCompanion> objs,
    required Map<int, AccountFileRowIds> fileRowIds,
  }) async {
    final inserts = <CompleteFileCompanion>[];
    await batch((batch) {
      for (final f in objs) {
        final thisRowIds = fileRowIds[f.file.fileId.value];
        if (thisRowIds != null) {
          // updates
          batch.update(
            files,
            f.file,
            where: ($FilesTable t) => t.rowId.equals(thisRowIds.fileRowId),
          );
          batch.update(
            accountFiles,
            f.accountFile,
            where: ($AccountFilesTable t) =>
                t.rowId.equals(thisRowIds.accountFileRowId),
          );
          if (f.image != null) {
            batch.update(
              images,
              f.image!,
              where: ($ImagesTable t) =>
                  t.accountFile.equals(thisRowIds.accountFileRowId),
            );
          } else {
            batch.deleteWhere(
              images,
              ($ImagesTable t) =>
                  t.accountFile.equals(thisRowIds.accountFileRowId),
            );
          }
          if (f.imageLocation != null) {
            batch.update(
              imageLocations,
              f.imageLocation!,
              where: ($ImageLocationsTable t) =>
                  t.accountFile.equals(thisRowIds.accountFileRowId),
            );
          } else {
            batch.deleteWhere(
              imageLocations,
              ($ImageLocationsTable t) =>
                  t.accountFile.equals(thisRowIds.accountFileRowId),
            );
          }
          if (f.trash != null) {
            batch.update(
              trashes,
              f.trash!,
              where: ($TrashesTable t) => t.file.equals(thisRowIds.fileRowId),
            );
          } else {
            batch.deleteWhere(
              trashes,
              ($TrashesTable t) => t.file.equals(thisRowIds.fileRowId),
            );
          }
        } else {
          // inserts, do it later
          inserts.add(f);
        }
      }
    });
    return inserts;
  }

  /// Insert file [objs] to DB
  ///
  /// Return a map of file id to row id (of the Files table) for the inserted
  /// files
  Future<Map<int, int>> _insertFiles({
    required Account account,
    required List<CompleteFileCompanion> objs,
  }) async {
    _log.info("[_insertCache] Insert ${objs.length} files");
    // check if the files exist in the db in other accounts
    final entries =
        await objs.map((f) => f.file.fileId.value).withPartition((sublist) {
      final query = _queryFiles().let((q) {
        q
          ..setQueryMode(
            FilesQueryMode.expression,
            expressions: [files.rowId, files.fileId],
          )
          ..setAccountless()
          ..byServerRowId(account.server)
          ..byFileIds(sublist);
        return q.build();
      });
      return query
          .map((r) => MapEntry(r.read(files.fileId)!, r.read(files.rowId)!))
          .get();
    }, _maxByFileIdsSize);
    final fileRowIdMap = Map.fromEntries(entries);

    final results = <int, int>{};
    await Future.wait(objs.map((f) async {
      var rowId = fileRowIdMap[f.file.fileId.value];
      if (rowId != null) {
        // shared file that exists in other accounts
      } else {
        final dbFile = await into(files).insertReturning(
          f.file.copyWith(server: Value(account.server)),
        );
        rowId = dbFile.rowId;
      }
      final sqlAccountFile =
          await into(accountFiles).insertReturning(f.accountFile.copyWith(
        account: Value(account.rowId),
        file: Value(rowId),
      ));
      if (f.image != null) {
        await into(images).insert(
            f.image!.copyWith(accountFile: Value(sqlAccountFile.rowId)));
      }
      if (f.imageLocation != null) {
        await into(imageLocations).insert(f.imageLocation!
            .copyWith(accountFile: Value(sqlAccountFile.rowId)));
      }
      if (f.trash != null) {
        await into(trashes).insert(f.trash!.copyWith(file: Value(rowId)));
      }
      results[f.file.fileId.value] = rowId;
    }));
    return results;
  }

  Future<void> _replaceDirFiles({
    required Account account,
    required int dirRowId,
    required List<int> childRowIds,
  }) async {
    final dirFileQuery = select(dirFiles)
      ..where((t) => t.dir.equals(dirRowId))
      ..orderBy([(t) => OrderingTerm.asc(t.child)]);
    final dirFileObjs = await dirFileQuery.get();
    final diff = getDiff(dirFileObjs.map((e) => e.child),
        childRowIds.sorted(Comparable.compare));
    if (diff.onlyInB.isNotEmpty) {
      await batch((batch) {
        // insert new children
        batch.insertAll(dirFiles,
            diff.onlyInB.map((k) => DirFile(dir: dirRowId, child: k)));
      });
    }
    if (diff.onlyInA.isNotEmpty) {
      // remove entries from the DirFiles table first
      await diff.onlyInA.withPartitionNoReturn((sublist) async {
        final deleteQuery = delete(dirFiles)
          ..where((t) => t.child.isIn(sublist))
          ..where(
              (t) => t.dir.equals(dirRowId) | t.dir.equalsExp(dirFiles.child));
        await deleteQuery.go();
      }, _maxByFileIdsSize);

      // select files having another dir parent under this account (i.e.,
      // moved files)
      final moved = await diff.onlyInA.withPartition((sublist) async {
        final query = selectOnly(dirFiles).join([
          innerJoin(accountFiles, accountFiles.file.equalsExp(dirFiles.dir)),
        ]);
        query
          ..addColumns([dirFiles.child])
          ..where(accountFiles.account.equals(account.rowId))
          ..where(dirFiles.child.isIn(sublist));
        return query.map((r) => r.read(dirFiles.child)!).get();
      }, _maxByFileIdsSize);

      final removed = diff.onlyInA.where((e) => !moved.contains(e)).toList();
      if (removed.isNotEmpty) {
        // delete obsolete children
        await _deleteFilesByRowIds(account: account, fileRowIds: removed);
        await cleanUpDanglingFiles();
      }
    }
  }

  Future<void> _deleteFilesByRowIds({
    required Account account,
    required List<int> fileRowIds,
  }) async {
    // query list of children, in case some of the files are dirs
    final childRowIds = await fileRowIds.withPartition((sublist) {
      final childQuery = selectOnly(dirFiles)
        ..addColumns([dirFiles.child])
        ..where(dirFiles.dir.isIn(sublist));
      return childQuery.map((r) => r.read(dirFiles.child)!).get();
    }, _maxByFileIdsSize);
    childRowIds.removeWhere((id) => fileRowIds.contains(id));

    // remove the files in AccountFiles table. We are not removing in Files table
    // because a file could be associated with multiple accounts
    await fileRowIds.withPartitionNoReturn((sublist) async {
      await (delete(accountFiles)
            ..where(
                (t) => t.account.equals(account.rowId) & t.file.isIn(sublist)))
          .go();
    }, _maxByFileIdsSize);

    if (childRowIds.isNotEmpty) {
      // remove children recursively
      return _deleteFilesByRowIds(account: account, fileRowIds: childRowIds);
    } else {
      return;
    }
  }

  /// Delete Files without a corresponding entry in AccountFiles
  @visibleForTesting
  Future<void> cleanUpDanglingFiles() async {
    final query = selectOnly(files).join([
      leftOuterJoin(accountFiles, accountFiles.file.equalsExp(files.rowId),
          useColumns: false),
    ])
      ..addColumns([files.rowId])
      ..where(accountFiles.relativePath.isNull());
    final fileRowIds = await query.map((r) => r.read(files.rowId)!).get();
    if (fileRowIds.isNotEmpty) {
      _log.info("[_cleanUpDanglingFiles] Delete ${fileRowIds.length} files");
      await fileRowIds.withPartitionNoReturn((sublist) async {
        await (delete(files)..where((t) => t.rowId.isIn(sublist))).go();
      }, _maxByFileIdsSize);
    }
  }

  Future<List<CompleteFile>> _mapCompleteFile(JoinedSelectStatement query) {
    return query
        .map((r) => CompleteFile(
              r.readTable(files),
              r.readTable(accountFiles),
              r.readTableOrNull(images),
              r.readTableOrNull(imageLocations),
              r.readTableOrNull(trashes),
            ))
        .get();
  }
}
