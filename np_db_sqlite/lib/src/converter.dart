import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:np_async/np_async.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/type.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/database_extension.dart';
import 'package:np_string/np_string.dart';

abstract class AlbumConverter {
  static DbAlbum fromSql(CompleteAlbum src) {
    return DbAlbum(
      fileId: src.albumFileId,
      fileEtag: src.album.fileEtag,
      version: src.album.version,
      lastUpdated: src.album.lastUpdated,
      name: src.album.name,
      providerType: src.album.providerType,
      providerContent: (jsonDecode(src.album.providerContent) as Map).cast(),
      coverProviderType: src.album.coverProviderType,
      coverProviderContent:
          (jsonDecode(src.album.coverProviderContent) as Map).cast(),
      sortProviderType: src.album.sortProviderType,
      sortProviderContent:
          (jsonDecode(src.album.sortProviderContent) as Map).cast(),
      shares: src.shares.map(AlbumShareConverter.fromSql).toList(),
    );
  }

  static CompleteAlbumCompanion toSql(DbAlbum src) {
    final sqlAlbum = AlbumsCompanion(
      fileEtag: Value(src.fileEtag),
      version: Value(src.version),
      lastUpdated: Value(src.lastUpdated),
      name: Value(src.name),
      providerType: Value(src.providerType),
      providerContent: Value(jsonEncode(src.providerContent)),
      coverProviderType: Value(src.coverProviderType),
      coverProviderContent: Value(jsonEncode(src.coverProviderContent)),
      sortProviderType: Value(src.sortProviderType),
      sortProviderContent: Value(jsonEncode(src.sortProviderContent)),
    );
    final sqlShares = src.shares
        .map((e) => AlbumSharesCompanion(
              userId: Value(e.userId),
              displayName: Value(e.displayName),
              sharedAt: Value(e.sharedAt),
            ))
        .toList();
    return CompleteAlbumCompanion(sqlAlbum, src.fileId, sqlShares);
  }
}

abstract class AlbumShareConverter {
  static DbAlbumShare fromSql(AlbumShare src) {
    return DbAlbumShare(
      userId: src.userId,
      displayName: src.displayName,
      sharedAt: src.sharedAt,
    );
  }
}

extension CompleteAlbumListExtension on List<CompleteAlbum> {
  Future<List<DbAlbum>> toDbAlbums() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertAlbum);
  }
}

abstract class FaceRecognitionPersonConverter {
  static DbFaceRecognitionPerson fromSql(FaceRecognitionPerson src) {
    return DbFaceRecognitionPerson(
      name: src.name,
      thumbFaceId: src.thumbFaceId,
      count: src.count,
    );
  }

  static FaceRecognitionPersonsCompanion toSql(
      Account account, DbFaceRecognitionPerson person) {
    return FaceRecognitionPersonsCompanion(
      account: Value(account.rowId),
      name: Value(person.name),
      thumbFaceId: Value(person.thumbFaceId),
      count: Value(person.count),
    );
  }
}

extension FaceRecognitionPersonListExtension on List<FaceRecognitionPerson> {
  Future<List<DbFaceRecognitionPerson>> toDbFaceRecognitionPersons() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertFaceRecognitionPerson);
  }
}

abstract class FileConverter {
  static DbFile fromSql(CompleteFile f) {
    return DbFile(
      fileId: f.file.fileId,
      contentLength: f.file.contentLength,
      contentType: f.file.contentType,
      etag: f.file.etag,
      lastModified: f.file.lastModified,
      isCollection: f.file.isCollection,
      usedBytes: f.file.usedBytes,
      hasPreview: f.file.hasPreview,
      ownerId: f.file.ownerId?.toCi(),
      ownerDisplayName: f.file.ownerDisplayName,
      relativePath: f.accountFile.relativePath,
      isFavorite: f.accountFile.isFavorite,
      isArchived: f.accountFile.isArchived,
      overrideDateTime: f.accountFile.overrideDateTime,
      bestDateTime: f.accountFile.bestDateTime,
      imageData: f.image?.let(ImageConverter.fromSql),
      location: f.imageLocation?.let(ImageLocationConverter.fromSql),
      trashData: f.trash?.let(TrashConverter.fromSql),
    );
  }

  static CompleteFileCompanion toSql(DbFile file) {
    final sqlFile = FilesCompanion(
      fileId: Value(file.fileId),
      contentLength: Value(file.contentLength),
      contentType: Value(file.contentType),
      etag: Value(file.etag),
      lastModified: Value(file.lastModified),
      isCollection: Value(file.isCollection),
      usedBytes: Value(file.usedBytes),
      hasPreview: Value(file.hasPreview),
      ownerId: Value(file.ownerId!.toCaseInsensitiveString()),
      ownerDisplayName: Value(file.ownerDisplayName),
    );
    final sqlAccountFile = AccountFilesCompanion(
      relativePath: Value(file.relativePath),
      isFavorite: Value(file.isFavorite),
      isArchived: Value(file.isArchived),
      overrideDateTime: Value(file.overrideDateTime),
      bestDateTime: Value(file.bestDateTime),
    );
    final sqlImage = file.imageData?.let((m) => ImagesCompanion.insert(
          lastUpdated: m.lastUpdated,
          fileEtag: Value(m.fileEtag),
          width: Value(m.width),
          height: Value(m.height),
          exifRaw: Value(m.exif?.let((j) => jsonEncode(j))),
          dateTimeOriginal: Value(m.exifDateTimeOriginal),
          src: Value(m.src),
        ));
    final sqlImageLocation =
        file.location?.let((l) => ImageLocationsCompanion.insert(
              version: l.version,
              name: Value(l.name),
              latitude: Value(l.latitude),
              longitude: Value(l.longitude),
              countryCode: Value(l.countryCode),
              admin1: Value(l.admin1),
              admin2: Value(l.admin2),
            ));
    final sqlTrash = file.trashData == null
        ? null
        : TrashesCompanion.insert(
            filename: file.trashData!.filename,
            originalLocation: file.trashData!.originalLocation,
            deletionTime: file.trashData!.deletionTime,
          );
    return CompleteFileCompanion(
        sqlFile, sqlAccountFile, sqlImage, sqlImageLocation, sqlTrash);
  }
}

abstract class ImageConverter {
  static DbImageData fromSql(Image src) {
    return DbImageData(
      lastUpdated: src.lastUpdated,
      fileEtag: src.fileEtag,
      width: src.width,
      height: src.height,
      exif:
          src.exifRaw?.let((e) => jsonDecode(e) as Map).cast<String, dynamic>(),
      exifDateTimeOriginal: src.dateTimeOriginal,
      src: src.src,
    );
  }
}

abstract class ImageLocationConverter {
  static DbLocation fromSql(ImageLocation src) {
    return DbLocation(
      version: src.version,
      name: src.name,
      latitude: src.latitude,
      longitude: src.longitude,
      countryCode: src.countryCode,
      admin1: src.admin1,
      admin2: src.admin2,
    );
  }
}

abstract class ImageLocationGroupConverter {
  static DbLocationGroup fromSql(ImageLocationGroup src) {
    return DbLocationGroup(
      place: src.place,
      countryCode: src.countryCode,
      count: src.count,
      latestFileId: src.latestFileId,
      latestDateTime: src.latestDateTime,
      latestFileMime: src.latestFileMime,
      latestFileRelativePath: src.latestFileRelativePath,
    );
  }
}

extension ImageLocationGroupListExtension on List<ImageLocationGroup> {
  List<DbLocationGroup> toDbLocationGroups() {
    return map(ImageLocationGroupConverter.fromSql).toList();
  }
}

abstract class TrashConverter {
  static DbTrashData fromSql(Trash src) {
    return DbTrashData(
      filename: src.filename,
      originalLocation: src.originalLocation,
      deletionTime: src.deletionTime,
    );
  }
}

extension DbFileListExtension on List<DbFile> {
  Future<List<CompleteFileCompanion>> toSql() {
    return map((e) => {
          "dbObj": e,
        }).computeAll(_covertDbFile);
  }
}

extension CompleteFileListExtension on List<CompleteFile> {
  Future<List<DbFile>> toDbFiles() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertFile);
  }
}

abstract class FileDescriptorConverter {
  static DbFileDescriptor fromSql(FileDescriptor src) {
    return DbFileDescriptor(
      relativePath: src.relativePath,
      fileId: src.fileId,
      contentType: src.contentType,
      isArchived: src.isArchived,
      isFavorite: src.isFavorite,
      bestDateTime: src.bestDateTime,
    );
  }
}

extension FileDescriptorListExtension on List<FileDescriptor> {
  Future<List<DbFileDescriptor>> toDbFileDescriptors() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertFileDescriptor);
  }
}

abstract class NcAlbumConverter {
  static DbNcAlbum fromSql(NcAlbum src) {
    return DbNcAlbum(
      relativePath: src.relativePath,
      lastPhoto: src.lastPhoto,
      nbItems: src.nbItems,
      location: src.location,
      dateStart: src.dateStart,
      dateEnd: src.dateEnd,
      collaborators: (jsonDecode(src.collaborators) as List).cast<JsonObj>(),
      isOwned: src.isOwned,
    );
  }

  static NcAlbumsCompanion toSql(Account account, DbNcAlbum src) {
    return NcAlbumsCompanion(
      account: Value(account.rowId),
      relativePath: Value(src.relativePath),
      lastPhoto: Value(src.lastPhoto),
      nbItems: Value(src.nbItems),
      location: Value(src.location),
      dateStart: Value(src.dateEnd),
      dateEnd: Value(src.dateEnd),
      collaborators: Value(jsonEncode(src.collaborators)),
      isOwned: Value(src.isOwned),
    );
  }
}

extension NcAlbumListExtension on List<NcAlbum> {
  Future<List<DbNcAlbum>> toDbNcAlbums() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertNcAlbum);
  }
}

abstract class NcAlbumItemConverter {
  static DbNcAlbumItem fromSql(NcAlbumItem src) {
    return DbNcAlbumItem(
      relativePath: src.relativePath,
      fileId: src.fileId,
      contentLength: src.contentLength,
      contentType: src.contentType,
      etag: src.etag,
      lastModified: src.lastModified,
      hasPreview: src.hasPreview,
      isFavorite: src.isFavorite,
      fileMetadataWidth: src.fileMetadataWidth,
      fileMetadataHeight: src.fileMetadataHeight,
    );
  }

  static NcAlbumItemsCompanion toSql(int parentRowId, DbNcAlbumItem src) {
    return NcAlbumItemsCompanion(
      parent: Value(parentRowId),
      relativePath: Value(src.relativePath),
      fileId: Value(src.fileId),
      contentLength: Value(src.contentLength),
      contentType: Value(src.contentType),
      etag: Value(src.etag),
      lastModified: Value(src.lastModified),
      hasPreview: Value(src.hasPreview),
      isFavorite: Value(src.isFavorite),
      fileMetadataWidth: Value(src.fileMetadataWidth),
      fileMetadataHeight: Value(src.fileMetadataHeight),
    );
  }
}

extension NcAlbumItemListExtension on List<NcAlbumItem> {
  Future<List<DbNcAlbumItem>> toDbNcAlbumItems() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertNcAlbumItem);
  }
}

abstract class RecognizeFaceConverter {
  static DbRecognizeFace fromSql(RecognizeFace src) {
    return DbRecognizeFace(label: src.label);
  }

  static RecognizeFacesCompanion toSql(Account account, DbRecognizeFace src) {
    return RecognizeFacesCompanion(
      account: Value(account.rowId),
      label: Value(src.label),
    );
  }
}

extension RecognizeFaceListExtension on List<RecognizeFace> {
  Future<List<DbRecognizeFace>> toDbRecognizeFaces() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertRecognizeFace);
  }
}

abstract class RecognizeFaceItemConverter {
  static DbRecognizeFaceItem fromSql(RecognizeFaceItem src) {
    return DbRecognizeFaceItem(
      relativePath: src.relativePath,
      fileId: src.fileId,
      contentLength: src.contentLength,
      contentType: src.contentType,
      etag: src.etag,
      lastModified: src.lastModified,
      hasPreview: src.hasPreview,
      realPath: src.realPath,
      isFavorite: src.isFavorite,
      fileMetadataWidth: src.fileMetadataWidth,
      fileMetadataHeight: src.fileMetadataHeight,
      faceDetections: src.faceDetections,
    );
  }

  static RecognizeFaceItemsCompanion toSql(
      RecognizeFace parent, DbRecognizeFaceItem src) {
    return RecognizeFaceItemsCompanion(
      parent: Value(parent.rowId),
      relativePath: Value(src.relativePath),
      fileId: Value(src.fileId),
      contentLength: Value(src.contentLength),
      contentType: Value(src.contentType),
      etag: Value(src.etag),
      lastModified: Value(src.lastModified),
      hasPreview: Value(src.hasPreview),
      realPath: Value(src.realPath),
      isFavorite: Value(src.isFavorite),
      fileMetadataWidth: Value(src.fileMetadataWidth),
      fileMetadataHeight: Value(src.fileMetadataHeight),
      faceDetections: Value(src.faceDetections),
    );
  }
}

extension RecognizeFaceItemListExtension on List<RecognizeFaceItem> {
  Future<List<DbRecognizeFaceItem>> toDbRecognizeFaceItems() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertRecognizeFaceItem);
  }
}

abstract class TagConverter {
  static DbTag fromSql(Tag src) {
    return DbTag(
      id: src.tagId,
      displayName: src.displayName,
      userVisible: src.userVisible,
      userAssignable: src.userAssignable,
    );
  }

  static TagsCompanion toSql(Account account, DbTag tag) {
    return TagsCompanion(
      server: Value(account.server),
      tagId: Value(tag.id),
      displayName: Value(tag.displayName),
      userVisible: Value(tag.userVisible),
      userAssignable: Value(tag.userAssignable),
    );
  }
}

extension TagListExtension on List<Tag> {
  Future<List<DbTag>> toDbTags() {
    return map((e) => {
          "sqlObj": e,
        }).computeAll(_covertTag);
  }
}

DbAlbum _covertAlbum(Map map) {
  final sqlObj = map["sqlObj"] as CompleteAlbum;
  return AlbumConverter.fromSql(sqlObj);
}

DbFaceRecognitionPerson _covertFaceRecognitionPerson(Map map) {
  final sqlObj = map["sqlObj"] as FaceRecognitionPerson;
  return FaceRecognitionPersonConverter.fromSql(sqlObj);
}

DbFile _covertFile(Map map) {
  final sqlObj = map["sqlObj"] as CompleteFile;
  return FileConverter.fromSql(sqlObj);
}

CompleteFileCompanion _covertDbFile(Map map) {
  final dbObj = map["dbObj"] as DbFile;
  return FileConverter.toSql(dbObj);
}

DbFileDescriptor _covertFileDescriptor(Map map) {
  final sqlObj = map["sqlObj"] as FileDescriptor;
  return FileDescriptorConverter.fromSql(sqlObj);
}

DbNcAlbum _covertNcAlbum(Map map) {
  final sqlObj = map["sqlObj"] as NcAlbum;
  return NcAlbumConverter.fromSql(sqlObj);
}

DbNcAlbumItem _covertNcAlbumItem(Map map) {
  final sqlObj = map["sqlObj"] as NcAlbumItem;
  return NcAlbumItemConverter.fromSql(sqlObj);
}

DbRecognizeFace _covertRecognizeFace(Map map) {
  final sqlObj = map["sqlObj"] as RecognizeFace;
  return RecognizeFaceConverter.fromSql(sqlObj);
}

DbRecognizeFaceItem _covertRecognizeFaceItem(Map map) {
  final sqlObj = map["sqlObj"] as RecognizeFaceItem;
  return RecognizeFaceItemConverter.fromSql(sqlObj);
}

DbTag _covertTag(Map map) {
  final sqlObj = map["sqlObj"] as Tag;
  return TagConverter.fromSql(sqlObj);
}
