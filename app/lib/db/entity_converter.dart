import 'dart:convert';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/image_location/repo.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/entity/nc_album_item.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/xmp.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_db/np_db.dart';
import 'package:np_string/np_string.dart';

abstract class DbAccountConverter {
  static DbAccount toDb(Account src) =>
      DbAccount(serverAddress: src.url, userId: src.userId);
}

extension AccountExtension on Account {
  DbAccount toDb() => DbAccountConverter.toDb(this);
}

extension AccountListExtension on List<Account> {
  List<DbAccount> toDb() => map(DbAccountConverter.toDb).toList();
}

abstract class DbAlbumConverter {
  static Album fromDb(File albumFile, DbAlbum src) {
    return Album(
      lastUpdated: src.lastUpdated,
      name: src.name,
      provider: AlbumProvider.fromJson({
        "type": src.providerType,
        "content": src.providerContent,
      }),
      coverProvider: AlbumCoverProvider.fromJson({
        "type": src.coverProviderType,
        "content": src.coverProviderContent,
      }),
      sortProvider: AlbumSortProvider.fromJson({
        "type": src.sortProviderType,
        "content": src.sortProviderContent,
      }),
      shares:
          src.shares.isEmpty
              ? null
              : src.shares
                  .map(
                    (e) => AlbumShare(
                      userId: e.userId.toCi(),
                      displayName: e.displayName,
                      sharedAt: e.sharedAt.toUtc(),
                    ),
                  )
                  .toList(),
      // replace with the original etag when this album was cached
      albumFile: albumFile.copyWith(etag: OrNull(src.fileEtag)),
      savedVersion: src.version,
    );
  }

  static DbAlbum toDb(Album src) {
    final providerJson = src.provider.toJson();
    final coverProviderJson = src.coverProvider.toJson();
    final sortProviderJson = src.sortProvider.toJson();
    return DbAlbum(
      fileId: src.albumFile!.fileId!,
      fileEtag: src.albumFile!.etag!,
      version: Album.version,
      lastUpdated: src.lastUpdated,
      name: src.name,
      providerType: providerJson["type"],
      providerContent: providerJson["content"],
      coverProviderType: coverProviderJson["type"],
      coverProviderContent: coverProviderJson["content"],
      sortProviderType: sortProviderJson["type"],
      sortProviderContent: sortProviderJson["content"],
      shares:
          src.shares
              ?.map(
                (e) => DbAlbumShare(
                  userId: e.userId.toCaseInsensitiveString(),
                  displayName: e.displayName,
                  sharedAt: e.sharedAt,
                ),
              )
              .toList() ??
          [],
    );
  }
}

abstract class DbFaceRecognitionPersonConverter {
  static FaceRecognitionPerson fromDb(DbFaceRecognitionPerson src) {
    return FaceRecognitionPerson(
      name: src.name,
      thumbFaceId: src.thumbFaceId,
      count: src.count,
    );
  }

  static DbFaceRecognitionPerson toDb(FaceRecognitionPerson src) {
    return DbFaceRecognitionPerson(
      name: src.name,
      thumbFaceId: src.thumbFaceId,
      count: src.count,
    );
  }
}

extension FaceRecognitionPersonExtension on FaceRecognitionPerson {
  DbFaceRecognitionPerson toDb() => DbFaceRecognitionPersonConverter.toDb(this);
}

abstract class DbFileConverter {
  static File fromDb(String userId, DbFile src) {
    return File(
      path: "remote.php/dav/files/$userId/${src.relativePath}",
      contentLength: src.contentLength,
      contentType: src.contentType,
      etag: src.etag,
      lastModified: src.lastModified,
      isCollection: src.isCollection,
      usedBytes: src.usedBytes,
      hasPreview: src.hasPreview,
      fileId: src.fileId,
      isFavorite: src.isFavorite,
      ownerId: src.ownerId,
      ownerDisplayName: src.ownerDisplayName,
      metadata: src.imageData?.let(DbMetadataConverter.fromDb),
      isArchived: src.isArchived,
      overrideDateTime: src.overrideDateTime,
      trashbinFilename: src.trashData?.filename,
      trashbinOriginalLocation: src.trashData?.originalLocation,
      trashbinDeletionTime: src.trashData?.deletionTime,
      location: src.location?.let(DbImageLocationConverter.fromDb),
    );
  }

  static DbFile toDb(File src) {
    return DbFile(
      fileId: src.fileId!,
      contentLength: src.contentLength,
      contentType: src.contentType,
      etag: src.etag,
      lastModified: src.lastModified,
      isCollection: src.isCollection,
      usedBytes: src.usedBytes,
      hasPreview: src.hasPreview,
      ownerId: src.ownerId,
      ownerDisplayName: src.ownerDisplayName,
      relativePath: src.strippedPathWithEmpty,
      isFavorite: src.isFavorite,
      isArchived: src.isArchived,
      overrideDateTime: src.overrideDateTime,
      bestDateTime: src.bestDateTime,
      imageData: src.metadata?.let(
        (s) => DbImageData(
          lastUpdated: s.lastUpdated,
          fileEtag: s.fileEtag,
          width: s.imageWidth,
          height: s.imageHeight,
          exif: s.exif?.toJson(),
          xmp: s.xmp?.toJson(),
          dateTime: s.dateTime,
          src: s.src.index,
        ),
      ),
      location: src.location?.let(
        (s) => DbLocation(
          version: s.version,
          name: s.name,
          latitude: s.latitude,
          longitude: s.longitude,
          countryCode: s.countryCode,
          admin1: s.admin1,
          admin2: s.admin2,
        ),
      ),
      trashData:
          src.trashbinDeletionTime == null
              ? null
              : DbTrashData(
                filename: src.trashbinFilename!,
                originalLocation: src.trashbinOriginalLocation!,
                deletionTime: src.trashbinDeletionTime!,
              ),
    );
  }
}

abstract class DbFileDescriptorConverter {
  static FileDescriptor fromDb(String userId, DbFileDescriptor src) {
    return FileDescriptor(
      fdPath: "remote.php/dav/files/$userId/${src.relativePath}",
      fdId: src.fileId,
      fdMime: src.contentType,
      fdIsArchived: src.isArchived ?? false,
      fdIsFavorite: src.isFavorite ?? false,
      fdDateTime: src.bestDateTime,
    );
  }
}

extension FileDescriptorExtension on FileDescriptor {
  DbFileKey toDbKey() => DbFileKey.byId(fdId);
}

abstract class DbMetadataConverter {
  static Metadata fromDb(DbImageData src) {
    return Metadata(
      lastUpdated: src.lastUpdated,
      fileEtag: src.fileEtag,
      imageWidth: src.width,
      imageHeight: src.height,
      exif: src.exif?.let(Exif.fromJson),
      xmp: src.xmp?.let(Xmp.fromJson),
      src: src.src?.let(MetadataSrc.fromValue) ?? MetadataSrc.legacy,
    );
  }

  static DbImageData toDb(Metadata src) {
    return DbImageData(
      lastUpdated: src.lastUpdated,
      fileEtag: src.fileEtag,
      width: src.imageWidth,
      height: src.imageHeight,
      exif: src.exif?.toJson(),
      xmp: src.xmp?.toJson(),
      dateTime: src.dateTime,
      src: src.src.index,
    );
  }
}

extension MetadataExtension on Metadata {
  DbImageData toDb() => DbMetadataConverter.toDb(this);
}

abstract class DbImageLocationConverter {
  static ImageLocation fromDb(DbLocation src) {
    return ImageLocation(
      version: src.version,
      name: src.name,
      latitude: src.latitude,
      longitude: src.longitude,
      countryCode: src.countryCode,
      admin1: src.admin1,
      admin2: src.admin2,
    );
  }

  static DbLocation toDb(ImageLocation src) {
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

extension ImageLocationExtension on ImageLocation {
  DbLocation toDb() => DbImageLocationConverter.toDb(this);
}

abstract class DbLocationGroupConverter {
  static LocationGroup fromDb(DbLocationGroup src) {
    return LocationGroup(
      src.place,
      src.countryCode,
      src.count,
      src.latestFileId,
      src.latestDateTime,
      src.latestFileMime,
      src.latestFileRelativePath,
    );
  }
}

abstract class DbImageLatLngConverter {
  static ImageLatLng fromDb(DbImageLatLng src) {
    return ImageLatLng(
      latitude: src.lat,
      longitude: src.lng,
      fileId: src.fileId,
      fileRelativePath: src.fileRelativePath,
      mime: src.mime,
    );
  }
}

extension FileExtension on File {
  DbFileKey toDbKey() {
    if (fileId != null) {
      return DbFileKey.byId(fileId!);
    } else {
      return DbFileKey.byPath(strippedPathWithEmpty);
    }
  }

  DbFile toDb() => DbFileConverter.toDb(this);
}

abstract class DbNcAlbumConverter {
  static NcAlbum fromDb(String userId, DbNcAlbum src) {
    return NcAlbum(
      path:
          "${api.ApiPhotos.path}/$userId/${src.isOwned ? "albums" : "sharedalbums"}/${src.relativePath}",
      lastPhoto: src.lastPhoto,
      nbItems: src.nbItems,
      location: src.location,
      dateStart: src.dateStart,
      dateEnd: src.dateEnd,
      collaborators:
          src.collaborators.map(NcAlbumCollaborator.fromJson).toList(),
    );
  }

  static DbNcAlbum toDb(NcAlbum src) {
    return DbNcAlbum(
      relativePath: src.strippedPath,
      lastPhoto: src.lastPhoto,
      nbItems: src.nbItems,
      location: src.location,
      dateStart: src.dateStart,
      dateEnd: src.dateEnd,
      collaborators: src.collaborators.map((e) => e.toJson()).toList(),
      isOwned: src.isOwned,
    );
  }
}

extension NcAlbumExtension on NcAlbum {
  DbNcAlbum toDb() => DbNcAlbumConverter.toDb(this);
}

abstract class DbNcAlbumItemConverter {
  static NcAlbumItem fromDb(
    String userId,
    String albumRelativePath,
    bool isAlbumOwned,
    DbNcAlbumItem src,
  ) {
    return NcAlbumItem(
      path:
          "${api.ApiPhotos.path}/$userId/${isAlbumOwned ? "albums" : "sharedalbums"}/$albumRelativePath/${src.relativePath}",
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

  static DbNcAlbumItem toDb(NcAlbumItem src) {
    return DbNcAlbumItem(
      relativePath: src.strippedPath,
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
}

abstract class DbRecognizeFaceConverter {
  static RecognizeFace fromDb(DbRecognizeFace src) {
    return RecognizeFace(label: src.label);
  }

  static DbRecognizeFace toDb(RecognizeFace src) {
    return DbRecognizeFace(label: src.label);
  }
}

extension RecognizeFaceExtension on RecognizeFace {
  DbRecognizeFace toDb() => DbRecognizeFaceConverter.toDb(this);
}

abstract class DbRecognizeFaceItemConverter {
  static RecognizeFaceItem fromDb(
    String userId,
    String faceLabel,
    DbRecognizeFaceItem src,
  ) {
    return RecognizeFaceItem(
      path:
          "${api.ApiRecognize.path}/$userId/faces/$faceLabel/${src.relativePath}",
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
      faceDetections: src.faceDetections?.let(
        (obj) => (jsonDecode(obj) as List).cast<JsonObj>(),
      ),
    );
  }

  static DbRecognizeFaceItem toDb(RecognizeFaceItem src) {
    return DbRecognizeFaceItem(
      relativePath: src.strippedPath,
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
      faceDetections: src.faceDetections?.let(jsonEncode),
    );
  }
}

abstract class DbTagConverter {
  static Tag fromDb(DbTag src) {
    return Tag(
      id: src.id,
      displayName: src.displayName,
      userVisible: src.userVisible,
      userAssignable: src.userAssignable,
    );
  }

  static DbTag toDb(Tag src) {
    return DbTag(
      id: src.id,
      displayName: src.displayName,
      userVisible: src.userVisible,
      userAssignable: src.userAssignable,
    );
  }
}

extension TagExtension on Tag {
  DbTag toDb() => DbTagConverter.toDb(this);
}
