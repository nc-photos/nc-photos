import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:np_common/type.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'entity.g.dart';

@genCopyWith
@toString
class DbAccount with EquatableMixin {
  const DbAccount({required this.serverAddress, required this.userId});

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [serverAddress, userId];

  final String serverAddress;
  final CiString userId;
}

@genCopyWith
@toString
class DbAlbum with EquatableMixin {
  const DbAlbum({
    required this.fileId,
    this.fileEtag,
    required this.version,
    required this.lastUpdated,
    required this.name,
    required this.providerType,
    required this.providerContent,
    required this.coverProviderType,
    required this.coverProviderContent,
    required this.sortProviderType,
    required this.sortProviderContent,
    required this.shares,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    fileId,
    fileEtag,
    version,
    lastUpdated,
    name,
    providerType,
    providerContent,
    coverProviderType,
    coverProviderContent,
    sortProviderType,
    sortProviderContent,
    shares,
  ];

  final int fileId;
  final String? fileEtag;
  final int version;
  final DateTime lastUpdated;
  final String name;
  final String providerType;
  final JsonObj providerContent;
  final String coverProviderType;
  final JsonObj coverProviderContent;
  final String sortProviderType;
  final JsonObj sortProviderContent;

  final List<DbAlbumShare> shares;
}

@genCopyWith
@toString
class DbAlbumShare with EquatableMixin {
  const DbAlbumShare({
    required this.userId,
    this.displayName,
    required this.sharedAt,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [userId, displayName, sharedAt];

  final String userId;
  final String? displayName;
  final DateTime sharedAt;
}

@genCopyWith
@toString
class DbFaceRecognitionPerson with EquatableMixin {
  const DbFaceRecognitionPerson({
    required this.name,
    required this.thumbFaceId,
    required this.count,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [name, thumbFaceId, count];

  final String name;
  final int thumbFaceId;
  final int count;
}

@genCopyWith
@toString
class DbFile with EquatableMixin {
  const DbFile({
    required this.fileId,
    required this.contentLength,
    required this.contentType,
    required this.etag,
    required this.lastModified,
    required this.isCollection,
    required this.usedBytes,
    required this.hasPreview,
    required this.ownerId,
    required this.ownerDisplayName,
    required this.relativePath,
    required this.isFavorite,
    required this.isArchived,
    required this.overrideDateTime,
    required this.bestDateTime,
    required this.imageData,
    required this.location,
    required this.trashData,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    isCollection,
    usedBytes,
    hasPreview,
    ownerId,
    ownerDisplayName,
    relativePath,
    isFavorite,
    isArchived,
    overrideDateTime,
    bestDateTime,
    imageData,
    location,
    trashData,
  ];

  final int fileId;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? isCollection;
  final int? usedBytes;
  final bool? hasPreview;
  final CiString? ownerId;
  final String? ownerDisplayName;
  final String relativePath;
  final bool? isFavorite;
  final bool? isArchived;
  final DateTime? overrideDateTime;
  final DateTime bestDateTime;
  final DbImageData? imageData;
  final DbLocation? location;
  final DbTrashData? trashData;
}

@genCopyWith
@toString
class DbFileDescriptor with EquatableMixin {
  const DbFileDescriptor({
    required this.relativePath,
    required this.fileId,
    required this.contentType,
    required this.isArchived,
    required this.isFavorite,
    required this.bestDateTime,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    relativePath,
    fileId,
    contentType,
    isArchived,
    isFavorite,
    bestDateTime,
  ];

  final String relativePath;
  final int fileId;
  final String? contentType;
  final bool? isArchived;
  final bool? isFavorite;
  final DateTime bestDateTime;
}

@genCopyWith
@toString
class DbImageData with EquatableMixin {
  const DbImageData({
    required this.lastUpdated,
    required this.fileEtag,
    required this.width,
    required this.height,
    required this.exif,
    required this.xmp,
    required this.exifDateTimeOriginal,
    required this.src,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    lastUpdated,
    fileEtag,
    width,
    height,
    exif,
    xmp,
    exifDateTimeOriginal,
    src,
  ];

  final DateTime lastUpdated;
  final String? fileEtag;
  final int? width;
  final int? height;
  final JsonObj? exif;
  final JsonObj? xmp;
  final DateTime? exifDateTimeOriginal;
  final int? src;
}

@genCopyWith
@toString
class DbLocation with EquatableMixin {
  const DbLocation({
    required this.version,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.admin1,
    required this.admin2,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    version,
    name,
    latitude,
    longitude,
    countryCode,
    admin1,
    admin2,
  ];

  final int version;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? countryCode;
  final String? admin1;
  final String? admin2;
}

@genCopyWith
@toString
class DbNcAlbum with EquatableMixin {
  const DbNcAlbum({
    required this.relativePath,
    this.lastPhoto,
    required this.nbItems,
    this.location,
    this.dateStart,
    this.dateEnd,
    required this.collaborators,
    required this.isOwned,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    relativePath,
    lastPhoto,
    nbItems,
    location,
    dateStart,
    dateEnd,
    collaborators,
    isOwned,
  ];

  final String relativePath;
  final int? lastPhoto;
  final int nbItems;
  final String? location;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final List<JsonObj> collaborators;
  final bool isOwned;
}

@genCopyWith
@toString
class DbNcAlbumItem with EquatableMixin {
  const DbNcAlbumItem({
    required this.relativePath,
    required this.fileId,
    this.contentLength,
    this.contentType,
    this.etag,
    this.lastModified,
    this.hasPreview,
    this.isFavorite,
    this.fileMetadataWidth,
    this.fileMetadataHeight,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    relativePath,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    hasPreview,
    isFavorite,
    fileMetadataWidth,
    fileMetadataHeight,
  ];

  final String relativePath;
  final int fileId;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? hasPreview;
  final bool? isFavorite;
  final int? fileMetadataWidth;
  final int? fileMetadataHeight;
}

@genCopyWith
@toString
class DbRecognizeFace with EquatableMixin {
  const DbRecognizeFace({required this.label});

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [label];

  final String label;
}

@genCopyWith
@toString
class DbRecognizeFaceItem with EquatableMixin {
  const DbRecognizeFaceItem({
    required this.relativePath,
    required this.fileId,
    this.contentLength,
    this.contentType,
    this.etag,
    this.lastModified,
    this.hasPreview,
    this.realPath,
    this.isFavorite,
    this.fileMetadataWidth,
    this.fileMetadataHeight,
    this.faceDetections,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    relativePath,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    hasPreview,
    realPath,
    isFavorite,
    fileMetadataWidth,
    fileMetadataHeight,
    faceDetections,
  ];

  final String relativePath;
  final int fileId;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? hasPreview;
  final String? realPath;
  final bool? isFavorite;
  final int? fileMetadataWidth;
  final int? fileMetadataHeight;
  final String? faceDetections;
}

@genCopyWith
@toString
class DbTag with EquatableMixin {
  const DbTag({
    required this.id,
    required this.displayName,
    required this.userVisible,
    required this.userAssignable,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [id, displayName, userVisible, userAssignable];

  final int id;
  final String displayName;
  final bool? userVisible;
  final bool? userAssignable;
}

@genCopyWith
@toString
class DbTrashData {
  const DbTrashData({
    required this.filename,
    required this.originalLocation,
    required this.deletionTime,
  });

  @override
  String toString() => _$toString();

  final String filename;
  final String originalLocation;
  final DateTime deletionTime;
}
