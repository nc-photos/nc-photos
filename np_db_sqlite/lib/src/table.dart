import 'package:drift/drift.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:np_db_sqlite/src/database.dart';

part 'table.g.dart';

class Servers extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get address => text().unique()();
}

class Accounts extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get server =>
      integer().references(Servers, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get userId => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {server, userId},
  ];
}

/// A file located on a server
class Files extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get server =>
      integer().references(Servers, #rowId, onDelete: KeyAction.cascade)();
  IntColumn get fileId => integer()();
  IntColumn get contentLength => integer().nullable()();
  TextColumn get contentType => text().nullable()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get lastModified =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();
  BoolColumn get isCollection => boolean().nullable()();
  IntColumn get usedBytes => integer().nullable()();
  BoolColumn get hasPreview => boolean().nullable()();
  TextColumn get ownerId => text().nullable()();
  TextColumn get ownerDisplayName => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {server, fileId},
  ];
}

/// Account specific properties associated with a file
///
/// A file on a Nextcloud server can have more than 1 path when it's shared
class AccountFiles extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(Accounts, #rowId, onDelete: KeyAction.cascade)();
  IntColumn get file =>
      integer().references(Files, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get relativePath => text()();
  BoolColumn get isFavorite => boolean().nullable()();
  BoolColumn get isArchived => boolean().nullable()();
  DateTimeColumn get overrideDateTime =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();
  DateTimeColumn get bestDateTime =>
      dateTime().map(const SqliteDateTimeConverter())();

  @override
  List<Set<Column>> get uniqueKeys => [
    {account, file},
  ];
}

/// An image file
class Images extends Table {
  // image data technically is identical between accounts, but the way it's
  // stored in the server is account specific so we follow the server here
  IntColumn get accountFile =>
      integer().references(AccountFiles, #rowId, onDelete: KeyAction.cascade)();
  DateTimeColumn get lastUpdated =>
      dateTime().map(const SqliteDateTimeConverter())();
  TextColumn get fileEtag => text().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  TextColumn get exifRaw => text().nullable()();
  TextColumn get xmpRaw => text().nullable()();
  IntColumn get src => integer().nullable()();

  // exif/xmp columns
  DateTimeColumn get dateTimeOriginal =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {accountFile};
}

/// Estimated locations for images
class ImageLocations extends Table {
  IntColumn get accountFile =>
      integer().references(AccountFiles, #rowId, onDelete: KeyAction.cascade)();
  IntColumn get version => integer()();
  TextColumn get name => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get countryCode => text().nullable()();
  TextColumn get admin1 => text().nullable()();
  TextColumn get admin2 => text().nullable()();

  @override
  Set<Column> get primaryKey => {accountFile};
}

/// A file inside trashbin
@DataClassName("Trash")
class Trashes extends Table {
  IntColumn get file =>
      integer().references(Files, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get filename => text()();
  TextColumn get originalLocation => text()();
  DateTimeColumn get deletionTime =>
      dateTime().map(const SqliteDateTimeConverter())();

  @override
  Set<Column> get primaryKey => {file};
}

/// A file located under another dir (dir is also a file)
class DirFiles extends Table {
  IntColumn get dir =>
      integer().references(Files, #rowId, onDelete: KeyAction.cascade)();
  @ReferenceName("child")
  IntColumn get child =>
      integer().references(Files, #rowId, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {dir, child};
}

class NcAlbums extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(Accounts, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get relativePath => text()();
  IntColumn get lastPhoto => integer().nullable()();
  IntColumn get nbItems => integer()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get dateStart =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();
  DateTimeColumn get dateEnd =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();
  TextColumn get collaborators => text()();
  BoolColumn get isOwned => boolean()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {account, relativePath},
  ];
}

class NcAlbumItems extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get parent =>
      integer().references(NcAlbums, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get relativePath => text()();
  IntColumn get fileId => integer()();
  IntColumn get contentLength => integer().nullable()();
  TextColumn get contentType => text().nullable()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get lastModified =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();
  BoolColumn get hasPreview => boolean().nullable()();
  BoolColumn get isFavorite => boolean().nullable()();
  IntColumn get fileMetadataWidth => integer().nullable()();
  IntColumn get fileMetadataHeight => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {parent, fileId},
  ];
}

class Albums extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get file =>
      integer()
          .references(Files, #rowId, onDelete: KeyAction.cascade)
          .unique()();
  // store the etag of the file when the album is cached in the db
  TextColumn get fileEtag => text().nullable()();
  IntColumn get version => integer()();
  DateTimeColumn get lastUpdated =>
      dateTime().map(const SqliteDateTimeConverter())();
  TextColumn get name => text()();

  // provider
  TextColumn get providerType => text()();
  TextColumn get providerContent => text()();

  // cover provider
  TextColumn get coverProviderType => text()();
  TextColumn get coverProviderContent => text()();

  // sort provider
  TextColumn get sortProviderType => text()();
  TextColumn get sortProviderContent => text()();
}

class AlbumShares extends Table {
  IntColumn get album =>
      integer().references(Albums, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get userId => text()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get sharedAt =>
      dateTime().map(const SqliteDateTimeConverter())();

  @override
  Set<Column> get primaryKey => {album, userId};
}

class Tags extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get server =>
      integer().references(Servers, #rowId, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer()();
  TextColumn get displayName => text()();
  BoolColumn get userVisible => boolean().nullable()();
  BoolColumn get userAssignable => boolean().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {server, tagId},
  ];
}

class FaceRecognitionPersons extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(Accounts, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get thumbFaceId => integer()();
  IntColumn get count => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {account, name},
  ];
}

class RecognizeFaces extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(Accounts, #rowId, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {account, label},
  ];
}

@DriftTableSort("SqliteDb")
class RecognizeFaceItems extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get parent =>
      integer().references(
        RecognizeFaces,
        #rowId,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get relativePath => text()();
  IntColumn get fileId => integer()();
  IntColumn get contentLength => integer().nullable()();
  TextColumn get contentType => text().nullable()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get lastModified =>
      dateTime().map(const SqliteDateTimeConverter()).nullable()();
  BoolColumn get hasPreview => boolean().nullable()();
  TextColumn get realPath => text().nullable()();
  BoolColumn get isFavorite => boolean().nullable()();
  IntColumn get fileMetadataWidth => integer().nullable()();
  IntColumn get fileMetadataHeight => integer().nullable()();
  TextColumn get faceDetections => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {parent, fileId},
  ];
}

class SqliteDateTimeConverter extends TypeConverter<DateTime, DateTime> {
  const SqliteDateTimeConverter();

  @override
  DateTime fromSql(DateTime fromDb) => fromDb.toUtc();

  @override
  DateTime toSql(DateTime value) => value.toUtc();
}
