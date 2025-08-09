import 'package:drift/drift.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/database_extension.dart';
import 'package:np_geocoder/np_geocoder.dart';
import 'package:np_string/np_string.dart';

enum FilesQueryMode { file, completeFile, expression }

typedef FilesQueryRelativePathBuilder =
    Expression<bool> Function(GeneratedColumn<String> relativePath);

/// Build a Files table query
///
/// If you call more than one by* methods, the condition will be added up
/// instead of replaced. No validations will be made to make sure the resulting
/// conditions make sense
class FilesQueryBuilder {
  FilesQueryBuilder(this.db);

  /// Set the query mode
  ///
  /// If [mode] == FilesQueryMode.expression, [expressions] must be defined and
  /// not empty
  void setQueryMode(FilesQueryMode mode, {Iterable<Expression>? expressions}) {
    assert(
      (mode == FilesQueryMode.expression) != (expressions?.isEmpty != false),
    );
    _queryMode = mode;
    _selectExpressions = expressions;
  }

  void setExtraJoins(List<Join> joins) {
    _extraJoins = joins.toList();
  }

  void setAccount(ByAccount account) {
    if (account.sqlAccount != null) {
      assert(_dbAccount == null);
      _sqlAccount = account.sqlAccount;
    } else {
      assert(_sqlAccount == null);
      _dbAccount = account.dbAccount;
    }
  }

  void setAccountless() {
    assert(_sqlAccount == null && _dbAccount == null);
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

  void byOrDirRowId(int id) {
    (_byOrDirRowIds ??= []).add(id);
  }

  void byMimePattern(String pattern) {
    (_byMimePatterns ??= []).add(pattern);
  }

  void byFavorite(bool favorite) {
    _byFavorite = favorite;
  }

  void byArchived(bool archived) {
    _byArchived = archived;
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

  JoinedSelectStatement build() {
    if (_sqlAccount == null && _dbAccount == null && !_isAccountless) {
      throw StateError("Invalid query: missing account");
    }
    final dynamic select =
        _queryMode == FilesQueryMode.expression
            ? db.selectOnly(db.files)
            : db.select(db.files);
    final query =
        select.join([
              innerJoin(
                db.accountFiles,
                db.accountFiles.file.equalsExp(db.files.rowId),
                useColumns: _queryMode == FilesQueryMode.completeFile,
              ),
              if (_dbAccount != null) ...[
                innerJoin(
                  db.accounts,
                  db.accounts.rowId.equalsExp(db.accountFiles.account),
                  useColumns: false,
                ),
                innerJoin(
                  db.servers,
                  db.servers.rowId.equalsExp(db.accounts.server),
                  useColumns: false,
                ),
              ],
              if (_byDirRowId != null || _byOrDirRowIds?.isNotEmpty == true)
                innerJoin(
                  db.dirFiles,
                  db.dirFiles.child.equalsExp(db.files.rowId),
                  useColumns: false,
                ),
              if (_queryMode == FilesQueryMode.completeFile) ...[
                leftOuterJoin(
                  db.images,
                  db.images.accountFile.equalsExp(db.accountFiles.rowId),
                ),
                leftOuterJoin(
                  db.trashes,
                  db.trashes.file.equalsExp(db.files.rowId),
                ),
              ],
              if (_queryMode == FilesQueryMode.completeFile ||
                  _byLocation != null)
                leftOuterJoin(
                  db.imageLocations,
                  db.imageLocations.accountFile.equalsExp(
                    db.accountFiles.rowId,
                  ),
                ),
              if (_extraJoins != null) ..._extraJoins!,
            ])
            as JoinedSelectStatement;
    if (_queryMode == FilesQueryMode.expression) {
      query.addColumns(_selectExpressions!);
    }

    if (_sqlAccount != null) {
      query.where(db.accountFiles.account.equals(_sqlAccount!.rowId));
    } else if (_dbAccount != null) {
      query
        ..where(db.servers.address.equals(_dbAccount!.serverAddress))
        ..where(
          db.accounts.userId.equals(
            _dbAccount!.userId.toCaseInsensitiveString(),
          ),
        );
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
    if (_byOrRelativePathBuilders?.isNotEmpty == true ||
        _byOrDirRowIds?.isNotEmpty == true) {
      Expression<bool>? expression;
      if (_byOrRelativePathBuilders?.isNotEmpty == true) {
        expression = _byOrRelativePathBuilders!
            .sublist(1)
            .fold<Expression<bool>>(
              _byOrRelativePathBuilders![0](db.accountFiles.relativePath),
              (previousValue, builder) =>
                  previousValue | builder(db.accountFiles.relativePath),
            );
      }
      if (_byOrDirRowIds?.isNotEmpty == true) {
        final e = _byOrDirRowIds!
            .sublist(1)
            .fold<Expression<bool>>(
              db.dirFiles.dir.equals(_byOrDirRowIds![0]),
              (previousValue, id) => previousValue | db.dirFiles.dir.equals(id),
            );
        expression = (expression == null) ? e : (expression | e);
      }
      query.where(expression!);
    }
    if (_byMimePatterns?.isNotEmpty == true) {
      final expression = _byMimePatterns!
          .sublist(1)
          .fold<Expression<bool>>(
            db.files.contentType.like(_byMimePatterns![0]),
            (previousValue, element) =>
                previousValue | db.files.contentType.like(element),
          );
      query.where(expression);
    }
    if (_byFavorite != null) {
      if (_byFavorite!) {
        query.where(db.accountFiles.isFavorite.equals(true));
      } else {
        // null are treated as false
        query.where(
          db.accountFiles.isFavorite.equals(false) |
              db.accountFiles.isFavorite.isNull(),
        );
      }
    }
    if (_byArchived != null) {
      if (_byArchived!) {
        query.where(db.accountFiles.isArchived.equals(true));
      } else {
        // null are treated as false
        query.where(
          db.accountFiles.isArchived.equals(false) |
              db.accountFiles.isArchived.isNull(),
        );
      }
    }
    if (_byDirRowId != null) {
      query.where(db.dirFiles.dir.equals(_byDirRowId!));
    }
    if (_byServerRowId != null) {
      query.where(db.files.server.equals(_byServerRowId!));
    }
    if (_byLocation != null) {
      var clause =
          db.imageLocations.name.like(_byLocation!) |
          db.imageLocations.admin1.like(_byLocation!) |
          db.imageLocations.admin2.like(_byLocation!);
      final countryCode = nameToAlpha2Code(_byLocation!.toCi());
      if (countryCode != null) {
        clause = clause | db.imageLocations.countryCode.equals(countryCode);
      } else if (_byLocation!.length == 2 &&
          alpha2CodeToName(_byLocation!.toUpperCase()) != null) {
        clause =
            clause |
            db.imageLocations.countryCode.equals(_byLocation!.toUpperCase());
      }
      query.where(clause);
    }
    return query;
  }

  void _byOrRelativePathBuilder(FilesQueryRelativePathBuilder builder) {
    (_byOrRelativePathBuilders ??= []).add(builder);
  }

  final SqliteDb db;

  FilesQueryMode _queryMode = FilesQueryMode.file;
  Iterable<Expression>? _selectExpressions;
  List<Join>? _extraJoins;

  Account? _sqlAccount;
  DbAccount? _dbAccount;
  bool _isAccountless = false;

  int? _byRowId;
  int? _byFileId;
  Iterable<int>? _byFileIds;
  String? _byRelativePath;
  List<FilesQueryRelativePathBuilder>? _byOrRelativePathBuilders;
  List<int>? _byOrDirRowIds;
  List<String>? _byMimePatterns;
  bool? _byFavorite;
  bool? _byArchived;
  int? _byDirRowId;
  int? _byServerRowId;
  String? _byLocation;
}
