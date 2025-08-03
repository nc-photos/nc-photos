part of 'test_util.dart';

extension DiContainerExtension on DiContainer {
  // ignore: deprecated_member_use
  compat.SqliteDb get sqliteDb => (npDb as NpDbSqlite).compatDb;
}

class _ByAccount {
  const _ByAccount.sql(compat.Account account) : this._(sqlAccount: account);

  // const _ByAccount.app(Account account) : this._(appAccount: account);

  const _ByAccount._({
    this.sqlAccount,
    this.appAccount,
  }) : assert((sqlAccount != null) != (appAccount != null));

  final compat.Account? sqlAccount;
  final Account? appAccount;
}

class _AccountFileRowIds {
  const _AccountFileRowIds(
      this.accountFileRowId, this.accountRowId, this.fileRowId);

  final int accountFileRowId;
  final int accountRowId;
  final int fileRowId;
}

class _AccountFileRowIdsWithFileId {
  const _AccountFileRowIdsWithFileId(
      this.accountFileRowId, this.accountRowId, this.fileRowId, this.fileId);

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
      q.setQueryMode(_FilesQueryMode.expression, expressions: [
        accountFiles.rowId,
        accountFiles.account,
        accountFiles.file,
      ]);
      if (sqlAccount != null) {
        q.setSqlAccount(sqlAccount);
      } else {
        q.setAppAccount(appAccount!);
      }
      try {
        q.byFileId(file.fdId);
      } catch (_) {
        q.byRelativePath(file.strippedPathWithEmpty);
      }
      return q.build()..limit(1);
    });
    return query
        .map((r) => _AccountFileRowIds(
              r.read(accountFiles.rowId)!,
              r.read(accountFiles.account)!,
              r.read(accountFiles.file)!,
            ))
        .getSingleOrNull();
  }

  /// See [accountFileRowIdsOfOrNull]
  Future<_AccountFileRowIds> accountFileRowIdsOf(
    FileDescriptor file, {
    compat.Account? sqlAccount,
    Account? appAccount,
  }) =>
      accountFileRowIdsOfOrNull(file,
              sqlAccount: sqlAccount, appAccount: appAccount)
          .notNull();

  /// Query AccountFiles, Accounts and Files row ID by fileIds
  ///
  /// Returned files are NOT guaranteed to be sorted as [fileIds]
  Future<List<_AccountFileRowIdsWithFileId>> accountFileRowIdsByFileIds(
      _ByAccount account, Iterable<int> fileIds) {
    final query = queryFiles().let((q) {
      q.setQueryMode(_FilesQueryMode.expression, expressions: [
        accountFiles.rowId,
        accountFiles.account,
        accountFiles.file,
        files.fileId,
      ]);
      if (account.sqlAccount != null) {
        q.setSqlAccount(account.sqlAccount!);
      } else {
        q.setAppAccount(account.appAccount!);
      }
      q.byFileIds(fileIds);
      return q.build();
    });
    return query
        .map((r) => _AccountFileRowIdsWithFileId(
              r.read(accountFiles.rowId)!,
              r.read(accountFiles.account)!,
              r.read(accountFiles.file)!,
              r.read(files.fileId)!,
            ))
        .get();
  }

  _FilesQueryBuilder queryFiles() => _FilesQueryBuilder(this);
}

class _SqliteAlbumConverter {
  static Album fromSql(
      compat.Album album, File albumFile, List<compat.AlbumShare> shares) {
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
      shares: shares.isEmpty
          ? null
          : shares
              .map((e) => AlbumShare(
                    userId: e.userId.toCi(),
                    displayName: e.displayName,
                    sharedAt: e.sharedAt.toUtc(),
                  ))
              .toList(),
      // replace with the original etag when this album was cached
      albumFile: albumFile.copyWith(etag: OrNull(album.fileEtag)),
      savedVersion: album.version,
    );
  }

  static compat.CompleteAlbumCompanion toSql(
      Album album, int albumFileRowId, String albumFileEtag) {
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
    final dbAlbumShares = album.shares
        ?.map((s) => compat.AlbumSharesCompanion(
              userId: sql.Value(s.userId.toCaseInsensitiveString()),
              displayName: sql.Value(s.displayName),
              sharedAt: sql.Value(s.sharedAt),
            ))
        .toList();
    return compat.CompleteAlbumCompanion(dbAlbum, 1, dbAlbumShares ?? []);
  }
}

class _SqliteFileConverter {
  static File fromSql(String userId, compat.CompleteFile f) {
    final metadata = f.image?.let((obj) => Metadata(
          lastUpdated: obj.lastUpdated,
          fileEtag: obj.fileEtag,
          imageWidth: obj.width,
          imageHeight: obj.height,
          exif: obj.exifRaw?.let((e) => Exif.fromJson(jsonDecode(e))),
          src: obj.src?.let(MetadataSrc.fromValue) ?? MetadataSrc.legacy,
        ));
    final location = f.imageLocation?.let((obj) => ImageLocation(
          version: obj.version,
          name: obj.name,
          latitude: obj.latitude,
          longitude: obj.longitude,
          countryCode: obj.countryCode,
          admin1: obj.admin1,
          admin2: obj.admin2,
        ));
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
      compat.Account? account, File file) {
    final dbFile = compat.FilesCompanion(
      server: account == null
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
    final dbImage = file.metadata?.let((m) => compat.ImagesCompanion.insert(
          lastUpdated: m.lastUpdated,
          fileEtag: sql.Value(m.fileEtag),
          width: sql.Value(m.imageWidth),
          height: sql.Value(m.imageHeight),
          exifRaw: sql.Value(m.exif?.toJson().let((j) => jsonEncode(j))),
          dateTimeOriginal: sql.Value(m.exif?.dateTimeOriginal),
          src: sql.Value(m.src.index),
        ));
    final dbImageLocation =
        file.location?.let((l) => compat.ImageLocationsCompanion.insert(
              version: l.version,
              name: sql.Value(l.name),
              latitude: sql.Value(l.latitude),
              longitude: sql.Value(l.longitude),
              countryCode: sql.Value(l.countryCode),
              admin1: sql.Value(l.admin1),
              admin2: sql.Value(l.admin2),
            ));
    final dbTrash = file.trashbinDeletionTime == null
        ? null
        : compat.TrashesCompanion.insert(
            filename: file.trashbinFilename!,
            originalLocation: file.trashbinOriginalLocation!,
            deletionTime: file.trashbinDeletionTime!,
          );
    return compat.CompleteFileCompanion(
        dbFile, dbAccountFile, dbImage, dbImageLocation, dbTrash);
  }
}

enum _FilesQueryMode {
  file,
  completeFile,
  expression,
}

typedef _FilesQueryRelativePathBuilder = sql.Expression<bool> Function(
    sql.GeneratedColumn<String> relativePath);

/// Build a Files table query
///
/// If you call more than one by* methods, the condition will be added up
/// instead of replaced. No validations will be made to make sure the resulting
/// conditions make sense
class _FilesQueryBuilder {
  _FilesQueryBuilder(this.db);

  /// Set the query mode
  ///
  /// If [mode] == FilesQueryMode.expression, [expressions] must be defined and
  /// not empty
  void setQueryMode(
    _FilesQueryMode mode, {
    Iterable<sql.Expression>? expressions,
  }) {
    assert((mode == _FilesQueryMode.expression) !=
        (expressions?.isEmpty != false));
    _queryMode = mode;
    _selectExpressions = expressions;
  }

  void setSqlAccount(compat.Account account) {
    assert(_appAccount == null);
    _sqlAccount = account;
  }

  void setAppAccount(Account account) {
    assert(_sqlAccount == null);
    _appAccount = account;
  }

  void setAccountless() {
    assert(_sqlAccount == null && _appAccount == null);
    _isAccountless = true;
  }

  void byRowId(int rowId) {
    _byRowId = rowId;
  }

  void byFileId(int fileId) {
    _byFileId = fileId;
  }

  void byFileIds(Iterable<int> fileIds) {
    _byFileIds = fileIds;
  }

  void byRelativePath(String path) {
    _byRelativePath = path;
  }

  void byOrRelativePath(String path) {
    _byOrRelativePathBuilder((relativePath) => relativePath.equals(path));
  }

  void byOrRelativePathPattern(String pattern) {
    _byOrRelativePathBuilder((relativePath) => relativePath.like(pattern));
  }

  void byMimePattern(String pattern) {
    (_byMimePatterns ??= []).add(pattern);
  }

  void byFavorite(bool favorite) {
    _byFavorite = favorite;
  }

  void byDirRowId(int dirRowId) {
    _byDirRowId = dirRowId;
  }

  void byServerRowId(int serverRowId) {
    _byServerRowId = serverRowId;
  }

  void byLocation(String location) {
    _byLocation = location;
  }

  sql.JoinedSelectStatement build() {
    if (_sqlAccount == null && _appAccount == null && !_isAccountless) {
      throw StateError("Invalid query: missing account");
    }
    final dynamic select = _queryMode == _FilesQueryMode.expression
        ? db.selectOnly(db.files)
        : db.select(db.files);
    final query = select.join([
      sql.innerJoin(
          db.accountFiles, db.accountFiles.file.equalsExp(db.files.rowId),
          useColumns: _queryMode == _FilesQueryMode.completeFile),
      if (_appAccount != null) ...[
        sql.innerJoin(
            db.accounts, db.accounts.rowId.equalsExp(db.accountFiles.account),
            useColumns: false),
        sql.innerJoin(
            db.servers, db.servers.rowId.equalsExp(db.accounts.server),
            useColumns: false),
      ],
      if (_byDirRowId != null)
        sql.innerJoin(db.dirFiles, db.dirFiles.child.equalsExp(db.files.rowId),
            useColumns: false),
      if (_queryMode == _FilesQueryMode.completeFile) ...[
        sql.leftOuterJoin(
            db.images, db.images.accountFile.equalsExp(db.accountFiles.rowId)),
        sql.leftOuterJoin(db.imageLocations,
            db.imageLocations.accountFile.equalsExp(db.accountFiles.rowId)),
        sql.leftOuterJoin(
            db.trashes, db.trashes.file.equalsExp(db.files.rowId)),
      ],
    ]) as sql.JoinedSelectStatement;
    if (_queryMode == _FilesQueryMode.expression) {
      query.addColumns(_selectExpressions!);
    }

    if (_sqlAccount != null) {
      query.where(db.accountFiles.account.equals(_sqlAccount!.rowId));
    } else if (_appAccount != null) {
      query
        ..where(db.servers.address.equals(_appAccount!.url))
        ..where(db.accounts.userId
            .equals(_appAccount!.userId.toCaseInsensitiveString()));
    }

    if (_byRowId != null) {
      query.where(db.files.rowId.equals(_byRowId!));
    }
    if (_byFileId != null) {
      query.where(db.files.fileId.equals(_byFileId!));
    }
    if (_byFileIds != null) {
      query.where(db.files.fileId.isIn(_byFileIds!));
    }
    if (_byRelativePath != null) {
      query.where(db.accountFiles.relativePath.equals(_byRelativePath!));
    }
    if (_byOrRelativePathBuilders?.isNotEmpty == true) {
      final expression = _byOrRelativePathBuilders!
          .sublist(1)
          .fold<sql.Expression<bool>>(
              _byOrRelativePathBuilders![0](db.accountFiles.relativePath),
              (previousValue, builder) =>
                  previousValue | builder(db.accountFiles.relativePath));
      query.where(expression);
    }
    if (_byMimePatterns?.isNotEmpty == true) {
      final expression = _byMimePatterns!.sublist(1).fold<sql.Expression<bool>>(
          db.files.contentType.like(_byMimePatterns![0]),
          (previousValue, element) =>
              previousValue | db.files.contentType.like(element));
      query.where(expression);
    }
    if (_byFavorite != null) {
      if (_byFavorite!) {
        query.where(db.accountFiles.isFavorite.equals(true));
      } else {
        // null are treated as false
        query.where(db.accountFiles.isFavorite.equals(true).not());
      }
    }
    if (_byDirRowId != null) {
      query.where(db.dirFiles.dir.equals(_byDirRowId!));
    }
    if (_byServerRowId != null) {
      query.where(db.files.server.equals(_byServerRowId!));
    }
    if (_byLocation != null) {
      var clause = db.imageLocations.name.like(_byLocation!) |
          db.imageLocations.admin1.like(_byLocation!) |
          db.imageLocations.admin2.like(_byLocation!);
      final countryCode = nameToAlpha2Code(_byLocation!.toCi());
      if (countryCode != null) {
        clause = clause | db.imageLocations.countryCode.equals(countryCode);
      } else if (_byLocation!.length == 2 &&
          alpha2CodeToName(_byLocation!.toUpperCase()) != null) {
        clause = clause |
            db.imageLocations.countryCode.equals(_byLocation!.toUpperCase());
      }
      query.where(clause);
    }
    return query;
  }

  void _byOrRelativePathBuilder(_FilesQueryRelativePathBuilder builder) {
    (_byOrRelativePathBuilders ??= []).add(builder);
  }

  final compat.SqliteDb db;

  _FilesQueryMode _queryMode = _FilesQueryMode.file;
  Iterable<sql.Expression>? _selectExpressions;

  compat.Account? _sqlAccount;
  Account? _appAccount;
  bool _isAccountless = false;

  int? _byRowId;
  int? _byFileId;
  Iterable<int>? _byFileIds;
  String? _byRelativePath;
  List<_FilesQueryRelativePathBuilder>? _byOrRelativePathBuilders;
  List<String>? _byMimePatterns;
  bool? _byFavorite;
  int? _byDirRowId;
  int? _byServerRowId;
  String? _byLocation;
}
