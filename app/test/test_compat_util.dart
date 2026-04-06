part of 'test_util.dart';

extension DiContainerExtension on DiContainer {
  // ignore: deprecated_member_use
  compat.SqliteDb get sqliteDb => (npDb as NpDbSqlite).compatDb;
}

class _ByAccount {
  const _ByAccount.sql(compat.Account account) : this._(sqlAccount: account);

  // const _ByAccount.app(Account account) : this._(appAccount: account);

  const _ByAccount._({this.sqlAccount, this.appAccount})
    : assert((sqlAccount != null) != (appAccount != null));

  final compat.Account? sqlAccount;
  final Account? appAccount;
}

class _AccountFileRowIds {
  const _AccountFileRowIds(
    this.accountFileRowId,
    this.accountRowId,
    this.fileRowId,
  );

  final int accountFileRowId;
  final int accountRowId;
  final int fileRowId;
}

class _AccountFileRowIdsWithFileId {
  const _AccountFileRowIdsWithFileId(
    this.accountFileRowId,
    this.accountRowId,
    this.fileRowId,
    this.fileId,
  );

  final int accountFileRowId;
  final int accountRowId;
  final int fileRowId;
  final int fileId;
}

extension on compat.SqliteDb {
  /// Query AccountFiles, Accounts and Files row ID by app File
  ///
  /// Only one of [sqlAccount] and [appAccount] must be passed
  Future<_AccountFileRowIds?> accountFileRowIdsOfOrNull(
    FileDescriptor file, {
    compat.Account? sqlAccount,
    Account? appAccount,
  }) {
    assert((sqlAccount != null) != (appAccount != null));
    final query = queryFiles().let((q) {
      q.setQueryMode(
        compat.FilesQueryMode.expression,
        expressions: [
          accountFiles.rowId,
          accountFiles.account,
          accountFiles.file,
        ],
      );
      if (sqlAccount != null) {
        q.setAccount(compat.ByAccount.sql(sqlAccount));
      } else {
        q.setAccount(compat.ByAccount.db(appAccount!.toDb()));
      }
      try {
        q.byFileId(file.fdId);
      } catch (_) {
        q.byRelativePath(file.strippedPathWithEmpty);
      }
      return q.build()..limit(1);
    });
    return query
        .map(
          (r) => _AccountFileRowIds(
            r.read(accountFiles.rowId)!,
            r.read(accountFiles.account)!,
            r.read(accountFiles.file)!,
          ),
        )
        .getSingleOrNull();
  }

  /// See [accountFileRowIdsOfOrNull]
  Future<_AccountFileRowIds> accountFileRowIdsOf(
    FileDescriptor file, {
    compat.Account? sqlAccount,
    Account? appAccount,
  }) =>
      accountFileRowIdsOfOrNull(
        file,
        sqlAccount: sqlAccount,
        appAccount: appAccount,
      ).notNull();

  /// Query AccountFiles, Accounts and Files row ID by fileIds
  ///
  /// Returned files are NOT guaranteed to be sorted as [fileIds]
  Future<List<_AccountFileRowIdsWithFileId>> accountFileRowIdsByFileIds(
    _ByAccount account,
    Iterable<int> fileIds,
  ) {
    final query = queryFiles().let((q) {
      q.setQueryMode(
        compat.FilesQueryMode.expression,
        expressions: [
          accountFiles.rowId,
          accountFiles.account,
          accountFiles.file,
          files.fileId,
        ],
      );
      if (account.sqlAccount != null) {
        q.setAccount(compat.ByAccount.sql(account.sqlAccount!));
      } else {
        q.setAccount(compat.ByAccount.db(account.appAccount!.toDb()));
      }
      q.byFileIds(fileIds);
      return q.build();
    });
    return query
        .map(
          (r) => _AccountFileRowIdsWithFileId(
            r.read(accountFiles.rowId)!,
            r.read(accountFiles.account)!,
            r.read(accountFiles.file)!,
            r.read(files.fileId)!,
          ),
        )
        .get();
  }

  compat.FilesQueryBuilder queryFiles() => compat.FilesQueryBuilder(this);
}

class _SqliteAlbumConverter {
  static Album fromSql(
    compat.Album album,
    File albumFile,
    List<compat.AlbumShare> shares,
  ) {
    return Album(
      lastUpdated: album.lastUpdated,
      name: album.name,
      provider: AlbumProvider.fromJson({
        "type": album.providerType,
        "content": jsonDecode(album.providerContent),
      }),
      coverProvider: AlbumCoverProvider.fromJson({
        "type": album.coverProviderType,
        "content": jsonDecode(album.coverProviderContent),
      }),
      sortProvider: AlbumSortProvider.fromJson({
        "type": album.sortProviderType,
        "content": jsonDecode(album.sortProviderContent),
      }),
      shares:
          shares.isEmpty
              ? null
              : shares
                  .map(
                    (e) => AlbumShare(
                      userId: e.userId.toCi(),
                      displayName: e.displayName,
                      sharedAt: e.sharedAt.toUtc(),
                    ),
                  )
                  .toList(),
      // replace with the original etag when this album was cached
      albumFile: albumFile.copyWith(etag: OrNull(album.fileEtag)),
      savedVersion: album.version,
    );
  }

  static compat.CompleteAlbumCompanion toSql(
    Album album,
    int albumFileRowId,
    String albumFileEtag,
  ) {
    final providerJson = album.provider.toJson();
    final coverProviderJson = album.coverProvider.toJson();
    final sortProviderJson = album.sortProvider.toJson();
    final dbAlbum = compat.AlbumsCompanion.insert(
      file: albumFileRowId,
      fileEtag: sql.Value(albumFileEtag),
      version: Album.version,
      lastUpdated: album.lastUpdated,
      name: album.name,
      providerType: providerJson["type"],
      providerContent: jsonEncode(providerJson["content"]),
      coverProviderType: coverProviderJson["type"],
      coverProviderContent: jsonEncode(coverProviderJson["content"]),
      sortProviderType: sortProviderJson["type"],
      sortProviderContent: jsonEncode(sortProviderJson["content"]),
    );
    final dbAlbumShares =
        album.shares
            ?.map(
              (s) => compat.AlbumSharesCompanion(
                userId: sql.Value(s.userId.toCaseInsensitiveString()),
                displayName: sql.Value(s.displayName),
                sharedAt: sql.Value(s.sharedAt),
              ),
            )
            .toList();
    return compat.CompleteAlbumCompanion(dbAlbum, 1, dbAlbumShares ?? []);
  }
}

class _SqliteFileConverter {
  static File fromSql(String userId, compat.CompleteFile f) {
    final metadata = f.image?.let(
      (obj) => Metadata(
        lastUpdated: obj.lastUpdated,
        fileEtag: obj.fileEtag,
        imageWidth: obj.width,
        imageHeight: obj.height,
        exif: obj.exifRaw?.let((e) => Exif.fromJson(jsonDecode(e))),
        xmp: obj.xmpRaw?.let((e) => Xmp.fromJson(jsonDecode(e))),
        src: obj.src?.let(MetadataSrc.fromValue) ?? MetadataSrc.legacy,
      ),
    );
    final location = f.imageLocation?.let(
      (e) => _ImageLocationConverter.fromSql(
        e,
        f.imageLocationIds,
        f.imageLocationNames,
      ),
    );
    return File(
      path: "remote.php/dav/files/$userId/${f.accountFile.relativePath}",
      contentLength: f.file.contentLength,
      contentType: f.file.contentType,
      etag: f.file.etag,
      lastModified: f.file.lastModified,
      isCollection: f.file.isCollection,
      usedBytes: f.file.usedBytes,
      hasPreview: f.file.hasPreview,
      fileId: f.file.fileId,
      isFavorite: f.accountFile.isFavorite,
      ownerId: f.file.ownerId?.toCi(),
      ownerDisplayName: f.file.ownerDisplayName,
      trashbinFilename: f.trash?.filename,
      trashbinOriginalLocation: f.trash?.originalLocation,
      trashbinDeletionTime: f.trash?.deletionTime,
      metadata: metadata,
      isArchived: f.accountFile.isArchived,
      overrideDateTime: f.accountFile.overrideDateTime,
      location: location,
    );
  }

  static compat.CompleteFileCompanion toSql(
    compat.Account? account,
    File file,
  ) {
    final dbFile = compat.FilesCompanion(
      server:
          account == null
              ? const sql.Value.absent()
              : sql.Value(account.server),
      fileId: sql.Value(file.fileId!),
      contentLength: sql.Value(file.contentLength),
      contentType: sql.Value(file.contentType),
      etag: sql.Value(file.etag),
      lastModified: sql.Value(file.lastModified),
      isCollection: sql.Value(file.isCollection),
      usedBytes: sql.Value(file.usedBytes),
      hasPreview: sql.Value(file.hasPreview),
      ownerId: sql.Value(file.ownerId!.toCaseInsensitiveString()),
      ownerDisplayName: sql.Value(file.ownerDisplayName),
    );
    final dbAccountFile = compat.AccountFilesCompanion(
      account:
          account == null ? const sql.Value.absent() : sql.Value(account.rowId),
      relativePath: sql.Value(file.strippedPathWithEmpty),
      isFavorite: sql.Value(file.isFavorite),
      isArchived: sql.Value(file.isArchived),
      overrideDateTime: sql.Value(file.overrideDateTime),
      bestDateTime: sql.Value(file.bestDateTime),
    );
    final dbImage = file.metadata?.let(
      (m) => compat.ImagesCompanion.insert(
        lastUpdated: m.lastUpdated,
        fileEtag: sql.Value(m.fileEtag),
        width: sql.Value(m.imageWidth),
        height: sql.Value(m.imageHeight),
        exifRaw: sql.Value(m.exif?.toJson().let((j) => jsonEncode(j))),
        xmpRaw: sql.Value(m.xmp?.toJson().let((j) => jsonEncode(j))),
        dateTimeOriginal: sql.Value(m.dateTime),
        src: sql.Value(m.src.index),
      ),
    );
    final dbImageLocation = file.location?.let(
      (l) => compat.ImageLocationsCompanion.insert(
        dataRevision: l.dataRevision,
        latitude: sql.Value(l.latitude),
        longitude: sql.Value(l.longitude),
        countryCode: sql.Value(l.countryCode),
      ),
    );
    final dbImageLocationIds =
        [
          file.location?.city?.let(
            (e) => compat.ImageLocationIdsCompanion(
              geonameId: sql.Value(e.geonameId),
              type: const sql.Value(compat.ImageLocationType.city),
            ),
          ),
          file.location?.admin1?.let(
            (e) => compat.ImageLocationIdsCompanion(
              geonameId: sql.Value(e.geonameId),
              type: const sql.Value(compat.ImageLocationType.admin1),
            ),
          ),
          file.location?.admin2?.let(
            (e) => compat.ImageLocationIdsCompanion(
              geonameId: sql.Value(e.geonameId),
              type: const sql.Value(compat.ImageLocationType.admin2),
            ),
          ),
        ].nonNulls.toList();
    final dbImageLocationNames = [
      ...?file.location?.city?.let(
        (e) => e.name.value.entries.map(
          (ee) => compat.ImageLocationNamesCompanion.insert(
            dataRevision: file.location!.dataRevision,
            geonameId: e.geonameId,
            lang: ee.key,
            name: ee.value,
          ),
        ),
      ),
      ...?file.location?.admin1?.let(
        (e) => e.name.value.entries.map(
          (ee) => compat.ImageLocationNamesCompanion.insert(
            dataRevision: file.location!.dataRevision,
            geonameId: e.geonameId,
            lang: ee.key,
            name: ee.value,
          ),
        ),
      ),
      ...?file.location?.admin2?.let(
        (e) => e.name.value.entries.map(
          (ee) => compat.ImageLocationNamesCompanion.insert(
            dataRevision: file.location!.dataRevision,
            geonameId: e.geonameId,
            lang: ee.key,
            name: ee.value,
          ),
        ),
      ),
    ];
    final dbTrash =
        file.trashbinDeletionTime == null
            ? null
            : compat.TrashesCompanion.insert(
              filename: file.trashbinFilename!,
              originalLocation: file.trashbinOriginalLocation!,
              deletionTime: file.trashbinDeletionTime!,
            );
    return compat.CompleteFileCompanion(
      dbFile,
      dbAccountFile,
      dbImage,
      dbImageLocation,
      dbImageLocationIds.isNotEmpty ? dbImageLocationIds : null,
      dbImageLocationNames.isNotEmpty ? dbImageLocationNames : null,
      dbTrash,
    );
  }
}

abstract class _ImageLocationConverter {
  static ImageLocation fromSql(
    compat.ImageLocation location,
    List<compat.ImageLocationId>? ids,
    List<compat.ImageLocationName>? names,
  ) {
    final cityId =
        ids
            ?.firstWhereOrNull((e) => e.type == compat.ImageLocationType.city)
            ?.geonameId;
    final cityNames =
        names
            ?.where((e) => e.geonameId == cityId)
            .map((e) => MapEntry(e.lang, e.name))
            .toMap();
    final admin1Id =
        ids
            ?.firstWhereOrNull((e) => e.type == compat.ImageLocationType.admin1)
            ?.geonameId;
    final admin1Names =
        names
            ?.where((e) => e.geonameId == admin1Id)
            .map((e) => MapEntry(e.lang, e.name))
            .toMap();
    final admin2Id =
        ids
            ?.firstWhereOrNull((e) => e.type == compat.ImageLocationType.admin2)
            ?.geonameId;
    final admin2Names =
        names
            ?.where((e) => e.geonameId == admin2Id)
            .map((e) => MapEntry(e.lang, e.name))
            .toMap();

    return ImageLocation(
      dataRevision: location.dataRevision,
      latitude: location.latitude,
      longitude: location.longitude,
      countryCode: location.countryCode,
      city:
          cityNames?.isNotEmpty == true
              ? ImageLocationName(
                geonameId: cityId!,
                name: LocalizedString(cityNames!),
              )
              : null,
      admin1:
          admin1Names?.isNotEmpty == true
              ? ImageLocationName(
                geonameId: admin1Id!,
                name: LocalizedString(admin1Names!),
              )
              : null,
      admin2:
          admin2Names?.isNotEmpty == true
              ? ImageLocationName(
                geonameId: admin2Id!,
                name: LocalizedString(admin2Names!),
              )
              : null,
    );
  }
}
