// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $DbAccountCopyWithWorker {
  DbAccount call({String? serverAddress, CiString? userId});
}

class _$DbAccountCopyWithWorkerImpl implements $DbAccountCopyWithWorker {
  _$DbAccountCopyWithWorkerImpl(this.that);

  @override
  DbAccount call({dynamic serverAddress, dynamic userId}) {
    return DbAccount(
        serverAddress: serverAddress as String? ?? that.serverAddress,
        userId: userId as CiString? ?? that.userId);
  }

  final DbAccount that;
}

extension $DbAccountCopyWith on DbAccount {
  $DbAccountCopyWithWorker get copyWith => _$copyWith;
  $DbAccountCopyWithWorker get _$copyWith =>
      _$DbAccountCopyWithWorkerImpl(this);
}

abstract class $DbAlbumCopyWithWorker {
  DbAlbum call(
      {int? fileId,
      String? fileEtag,
      int? version,
      DateTime? lastUpdated,
      String? name,
      String? providerType,
      JsonObj? providerContent,
      String? coverProviderType,
      JsonObj? coverProviderContent,
      String? sortProviderType,
      JsonObj? sortProviderContent,
      List<DbAlbumShare>? shares});
}

class _$DbAlbumCopyWithWorkerImpl implements $DbAlbumCopyWithWorker {
  _$DbAlbumCopyWithWorkerImpl(this.that);

  @override
  DbAlbum call(
      {dynamic fileId,
      dynamic fileEtag = copyWithNull,
      dynamic version,
      dynamic lastUpdated,
      dynamic name,
      dynamic providerType,
      dynamic providerContent,
      dynamic coverProviderType,
      dynamic coverProviderContent,
      dynamic sortProviderType,
      dynamic sortProviderContent,
      dynamic shares}) {
    return DbAlbum(
        fileId: fileId as int? ?? that.fileId,
        fileEtag:
            fileEtag == copyWithNull ? that.fileEtag : fileEtag as String?,
        version: version as int? ?? that.version,
        lastUpdated: lastUpdated as DateTime? ?? that.lastUpdated,
        name: name as String? ?? that.name,
        providerType: providerType as String? ?? that.providerType,
        providerContent: providerContent as JsonObj? ?? that.providerContent,
        coverProviderType:
            coverProviderType as String? ?? that.coverProviderType,
        coverProviderContent:
            coverProviderContent as JsonObj? ?? that.coverProviderContent,
        sortProviderType: sortProviderType as String? ?? that.sortProviderType,
        sortProviderContent:
            sortProviderContent as JsonObj? ?? that.sortProviderContent,
        shares: shares as List<DbAlbumShare>? ?? that.shares);
  }

  final DbAlbum that;
}

extension $DbAlbumCopyWith on DbAlbum {
  $DbAlbumCopyWithWorker get copyWith => _$copyWith;
  $DbAlbumCopyWithWorker get _$copyWith => _$DbAlbumCopyWithWorkerImpl(this);
}

abstract class $DbAlbumShareCopyWithWorker {
  DbAlbumShare call({String? userId, String? displayName, DateTime? sharedAt});
}

class _$DbAlbumShareCopyWithWorkerImpl implements $DbAlbumShareCopyWithWorker {
  _$DbAlbumShareCopyWithWorkerImpl(this.that);

  @override
  DbAlbumShare call(
      {dynamic userId, dynamic displayName = copyWithNull, dynamic sharedAt}) {
    return DbAlbumShare(
        userId: userId as String? ?? that.userId,
        displayName: displayName == copyWithNull
            ? that.displayName
            : displayName as String?,
        sharedAt: sharedAt as DateTime? ?? that.sharedAt);
  }

  final DbAlbumShare that;
}

extension $DbAlbumShareCopyWith on DbAlbumShare {
  $DbAlbumShareCopyWithWorker get copyWith => _$copyWith;
  $DbAlbumShareCopyWithWorker get _$copyWith =>
      _$DbAlbumShareCopyWithWorkerImpl(this);
}

abstract class $DbFaceRecognitionPersonCopyWithWorker {
  DbFaceRecognitionPerson call({String? name, int? thumbFaceId, int? count});
}

class _$DbFaceRecognitionPersonCopyWithWorkerImpl
    implements $DbFaceRecognitionPersonCopyWithWorker {
  _$DbFaceRecognitionPersonCopyWithWorkerImpl(this.that);

  @override
  DbFaceRecognitionPerson call(
      {dynamic name, dynamic thumbFaceId, dynamic count}) {
    return DbFaceRecognitionPerson(
        name: name as String? ?? that.name,
        thumbFaceId: thumbFaceId as int? ?? that.thumbFaceId,
        count: count as int? ?? that.count);
  }

  final DbFaceRecognitionPerson that;
}

extension $DbFaceRecognitionPersonCopyWith on DbFaceRecognitionPerson {
  $DbFaceRecognitionPersonCopyWithWorker get copyWith => _$copyWith;
  $DbFaceRecognitionPersonCopyWithWorker get _$copyWith =>
      _$DbFaceRecognitionPersonCopyWithWorkerImpl(this);
}

abstract class $DbFileCopyWithWorker {
  DbFile call(
      {int? fileId,
      int? contentLength,
      String? contentType,
      String? etag,
      DateTime? lastModified,
      bool? isCollection,
      int? usedBytes,
      bool? hasPreview,
      CiString? ownerId,
      String? ownerDisplayName,
      String? relativePath,
      bool? isFavorite,
      bool? isArchived,
      DateTime? overrideDateTime,
      DateTime? bestDateTime,
      DbImageData? imageData,
      DbLocation? location,
      DbTrashData? trashData});
}

class _$DbFileCopyWithWorkerImpl implements $DbFileCopyWithWorker {
  _$DbFileCopyWithWorkerImpl(this.that);

  @override
  DbFile call(
      {dynamic fileId,
      dynamic contentLength = copyWithNull,
      dynamic contentType = copyWithNull,
      dynamic etag = copyWithNull,
      dynamic lastModified = copyWithNull,
      dynamic isCollection = copyWithNull,
      dynamic usedBytes = copyWithNull,
      dynamic hasPreview = copyWithNull,
      dynamic ownerId = copyWithNull,
      dynamic ownerDisplayName = copyWithNull,
      dynamic relativePath,
      dynamic isFavorite = copyWithNull,
      dynamic isArchived = copyWithNull,
      dynamic overrideDateTime = copyWithNull,
      dynamic bestDateTime,
      dynamic imageData = copyWithNull,
      dynamic location = copyWithNull,
      dynamic trashData = copyWithNull}) {
    return DbFile(
        fileId: fileId as int? ?? that.fileId,
        contentLength: contentLength == copyWithNull
            ? that.contentLength
            : contentLength as int?,
        contentType: contentType == copyWithNull
            ? that.contentType
            : contentType as String?,
        etag: etag == copyWithNull ? that.etag : etag as String?,
        lastModified: lastModified == copyWithNull
            ? that.lastModified
            : lastModified as DateTime?,
        isCollection: isCollection == copyWithNull
            ? that.isCollection
            : isCollection as bool?,
        usedBytes:
            usedBytes == copyWithNull ? that.usedBytes : usedBytes as int?,
        hasPreview:
            hasPreview == copyWithNull ? that.hasPreview : hasPreview as bool?,
        ownerId: ownerId == copyWithNull ? that.ownerId : ownerId as CiString?,
        ownerDisplayName: ownerDisplayName == copyWithNull
            ? that.ownerDisplayName
            : ownerDisplayName as String?,
        relativePath: relativePath as String? ?? that.relativePath,
        isFavorite:
            isFavorite == copyWithNull ? that.isFavorite : isFavorite as bool?,
        isArchived:
            isArchived == copyWithNull ? that.isArchived : isArchived as bool?,
        overrideDateTime: overrideDateTime == copyWithNull
            ? that.overrideDateTime
            : overrideDateTime as DateTime?,
        bestDateTime: bestDateTime as DateTime? ?? that.bestDateTime,
        imageData: imageData == copyWithNull
            ? that.imageData
            : imageData as DbImageData?,
        location:
            location == copyWithNull ? that.location : location as DbLocation?,
        trashData: trashData == copyWithNull
            ? that.trashData
            : trashData as DbTrashData?);
  }

  final DbFile that;
}

extension $DbFileCopyWith on DbFile {
  $DbFileCopyWithWorker get copyWith => _$copyWith;
  $DbFileCopyWithWorker get _$copyWith => _$DbFileCopyWithWorkerImpl(this);
}

abstract class $DbFileDescriptorCopyWithWorker {
  DbFileDescriptor call(
      {String? relativePath,
      int? fileId,
      String? contentType,
      bool? isArchived,
      bool? isFavorite,
      DateTime? bestDateTime});
}

class _$DbFileDescriptorCopyWithWorkerImpl
    implements $DbFileDescriptorCopyWithWorker {
  _$DbFileDescriptorCopyWithWorkerImpl(this.that);

  @override
  DbFileDescriptor call(
      {dynamic relativePath,
      dynamic fileId,
      dynamic contentType = copyWithNull,
      dynamic isArchived = copyWithNull,
      dynamic isFavorite = copyWithNull,
      dynamic bestDateTime}) {
    return DbFileDescriptor(
        relativePath: relativePath as String? ?? that.relativePath,
        fileId: fileId as int? ?? that.fileId,
        contentType: contentType == copyWithNull
            ? that.contentType
            : contentType as String?,
        isArchived:
            isArchived == copyWithNull ? that.isArchived : isArchived as bool?,
        isFavorite:
            isFavorite == copyWithNull ? that.isFavorite : isFavorite as bool?,
        bestDateTime: bestDateTime as DateTime? ?? that.bestDateTime);
  }

  final DbFileDescriptor that;
}

extension $DbFileDescriptorCopyWith on DbFileDescriptor {
  $DbFileDescriptorCopyWithWorker get copyWith => _$copyWith;
  $DbFileDescriptorCopyWithWorker get _$copyWith =>
      _$DbFileDescriptorCopyWithWorkerImpl(this);
}

abstract class $DbImageDataCopyWithWorker {
  DbImageData call(
      {DateTime? lastUpdated,
      String? fileEtag,
      int? width,
      int? height,
      JsonObj? exif,
      DateTime? exifDateTimeOriginal,
      int? src});
}

class _$DbImageDataCopyWithWorkerImpl implements $DbImageDataCopyWithWorker {
  _$DbImageDataCopyWithWorkerImpl(this.that);

  @override
  DbImageData call(
      {dynamic lastUpdated,
      dynamic fileEtag = copyWithNull,
      dynamic width = copyWithNull,
      dynamic height = copyWithNull,
      dynamic exif = copyWithNull,
      dynamic exifDateTimeOriginal = copyWithNull,
      dynamic src = copyWithNull}) {
    return DbImageData(
        lastUpdated: lastUpdated as DateTime? ?? that.lastUpdated,
        fileEtag:
            fileEtag == copyWithNull ? that.fileEtag : fileEtag as String?,
        width: width == copyWithNull ? that.width : width as int?,
        height: height == copyWithNull ? that.height : height as int?,
        exif: exif == copyWithNull ? that.exif : exif as JsonObj?,
        exifDateTimeOriginal: exifDateTimeOriginal == copyWithNull
            ? that.exifDateTimeOriginal
            : exifDateTimeOriginal as DateTime?,
        src: src == copyWithNull ? that.src : src as int?);
  }

  final DbImageData that;
}

extension $DbImageDataCopyWith on DbImageData {
  $DbImageDataCopyWithWorker get copyWith => _$copyWith;
  $DbImageDataCopyWithWorker get _$copyWith =>
      _$DbImageDataCopyWithWorkerImpl(this);
}

abstract class $DbLocationCopyWithWorker {
  DbLocation call(
      {int? version,
      String? name,
      double? latitude,
      double? longitude,
      String? countryCode,
      String? admin1,
      String? admin2});
}

class _$DbLocationCopyWithWorkerImpl implements $DbLocationCopyWithWorker {
  _$DbLocationCopyWithWorkerImpl(this.that);

  @override
  DbLocation call(
      {dynamic version,
      dynamic name = copyWithNull,
      dynamic latitude = copyWithNull,
      dynamic longitude = copyWithNull,
      dynamic countryCode = copyWithNull,
      dynamic admin1 = copyWithNull,
      dynamic admin2 = copyWithNull}) {
    return DbLocation(
        version: version as int? ?? that.version,
        name: name == copyWithNull ? that.name : name as String?,
        latitude:
            latitude == copyWithNull ? that.latitude : latitude as double?,
        longitude:
            longitude == copyWithNull ? that.longitude : longitude as double?,
        countryCode: countryCode == copyWithNull
            ? that.countryCode
            : countryCode as String?,
        admin1: admin1 == copyWithNull ? that.admin1 : admin1 as String?,
        admin2: admin2 == copyWithNull ? that.admin2 : admin2 as String?);
  }

  final DbLocation that;
}

extension $DbLocationCopyWith on DbLocation {
  $DbLocationCopyWithWorker get copyWith => _$copyWith;
  $DbLocationCopyWithWorker get _$copyWith =>
      _$DbLocationCopyWithWorkerImpl(this);
}

abstract class $DbNcAlbumCopyWithWorker {
  DbNcAlbum call(
      {String? relativePath,
      int? lastPhoto,
      int? nbItems,
      String? location,
      DateTime? dateStart,
      DateTime? dateEnd,
      List<JsonObj>? collaborators,
      bool? isOwned});
}

class _$DbNcAlbumCopyWithWorkerImpl implements $DbNcAlbumCopyWithWorker {
  _$DbNcAlbumCopyWithWorkerImpl(this.that);

  @override
  DbNcAlbum call(
      {dynamic relativePath,
      dynamic lastPhoto = copyWithNull,
      dynamic nbItems,
      dynamic location = copyWithNull,
      dynamic dateStart = copyWithNull,
      dynamic dateEnd = copyWithNull,
      dynamic collaborators,
      dynamic isOwned}) {
    return DbNcAlbum(
        relativePath: relativePath as String? ?? that.relativePath,
        lastPhoto:
            lastPhoto == copyWithNull ? that.lastPhoto : lastPhoto as int?,
        nbItems: nbItems as int? ?? that.nbItems,
        location:
            location == copyWithNull ? that.location : location as String?,
        dateStart:
            dateStart == copyWithNull ? that.dateStart : dateStart as DateTime?,
        dateEnd: dateEnd == copyWithNull ? that.dateEnd : dateEnd as DateTime?,
        collaborators: collaborators as List<JsonObj>? ?? that.collaborators,
        isOwned: isOwned as bool? ?? that.isOwned);
  }

  final DbNcAlbum that;
}

extension $DbNcAlbumCopyWith on DbNcAlbum {
  $DbNcAlbumCopyWithWorker get copyWith => _$copyWith;
  $DbNcAlbumCopyWithWorker get _$copyWith =>
      _$DbNcAlbumCopyWithWorkerImpl(this);
}

abstract class $DbNcAlbumItemCopyWithWorker {
  DbNcAlbumItem call(
      {String? relativePath,
      int? fileId,
      int? contentLength,
      String? contentType,
      String? etag,
      DateTime? lastModified,
      bool? hasPreview,
      bool? isFavorite,
      int? fileMetadataWidth,
      int? fileMetadataHeight});
}

class _$DbNcAlbumItemCopyWithWorkerImpl
    implements $DbNcAlbumItemCopyWithWorker {
  _$DbNcAlbumItemCopyWithWorkerImpl(this.that);

  @override
  DbNcAlbumItem call(
      {dynamic relativePath,
      dynamic fileId,
      dynamic contentLength = copyWithNull,
      dynamic contentType = copyWithNull,
      dynamic etag = copyWithNull,
      dynamic lastModified = copyWithNull,
      dynamic hasPreview = copyWithNull,
      dynamic isFavorite = copyWithNull,
      dynamic fileMetadataWidth = copyWithNull,
      dynamic fileMetadataHeight = copyWithNull}) {
    return DbNcAlbumItem(
        relativePath: relativePath as String? ?? that.relativePath,
        fileId: fileId as int? ?? that.fileId,
        contentLength: contentLength == copyWithNull
            ? that.contentLength
            : contentLength as int?,
        contentType: contentType == copyWithNull
            ? that.contentType
            : contentType as String?,
        etag: etag == copyWithNull ? that.etag : etag as String?,
        lastModified: lastModified == copyWithNull
            ? that.lastModified
            : lastModified as DateTime?,
        hasPreview:
            hasPreview == copyWithNull ? that.hasPreview : hasPreview as bool?,
        isFavorite:
            isFavorite == copyWithNull ? that.isFavorite : isFavorite as bool?,
        fileMetadataWidth: fileMetadataWidth == copyWithNull
            ? that.fileMetadataWidth
            : fileMetadataWidth as int?,
        fileMetadataHeight: fileMetadataHeight == copyWithNull
            ? that.fileMetadataHeight
            : fileMetadataHeight as int?);
  }

  final DbNcAlbumItem that;
}

extension $DbNcAlbumItemCopyWith on DbNcAlbumItem {
  $DbNcAlbumItemCopyWithWorker get copyWith => _$copyWith;
  $DbNcAlbumItemCopyWithWorker get _$copyWith =>
      _$DbNcAlbumItemCopyWithWorkerImpl(this);
}

abstract class $DbRecognizeFaceCopyWithWorker {
  DbRecognizeFace call({String? label});
}

class _$DbRecognizeFaceCopyWithWorkerImpl
    implements $DbRecognizeFaceCopyWithWorker {
  _$DbRecognizeFaceCopyWithWorkerImpl(this.that);

  @override
  DbRecognizeFace call({dynamic label}) {
    return DbRecognizeFace(label: label as String? ?? that.label);
  }

  final DbRecognizeFace that;
}

extension $DbRecognizeFaceCopyWith on DbRecognizeFace {
  $DbRecognizeFaceCopyWithWorker get copyWith => _$copyWith;
  $DbRecognizeFaceCopyWithWorker get _$copyWith =>
      _$DbRecognizeFaceCopyWithWorkerImpl(this);
}

abstract class $DbRecognizeFaceItemCopyWithWorker {
  DbRecognizeFaceItem call(
      {String? relativePath,
      int? fileId,
      int? contentLength,
      String? contentType,
      String? etag,
      DateTime? lastModified,
      bool? hasPreview,
      String? realPath,
      bool? isFavorite,
      int? fileMetadataWidth,
      int? fileMetadataHeight,
      String? faceDetections});
}

class _$DbRecognizeFaceItemCopyWithWorkerImpl
    implements $DbRecognizeFaceItemCopyWithWorker {
  _$DbRecognizeFaceItemCopyWithWorkerImpl(this.that);

  @override
  DbRecognizeFaceItem call(
      {dynamic relativePath,
      dynamic fileId,
      dynamic contentLength = copyWithNull,
      dynamic contentType = copyWithNull,
      dynamic etag = copyWithNull,
      dynamic lastModified = copyWithNull,
      dynamic hasPreview = copyWithNull,
      dynamic realPath = copyWithNull,
      dynamic isFavorite = copyWithNull,
      dynamic fileMetadataWidth = copyWithNull,
      dynamic fileMetadataHeight = copyWithNull,
      dynamic faceDetections = copyWithNull}) {
    return DbRecognizeFaceItem(
        relativePath: relativePath as String? ?? that.relativePath,
        fileId: fileId as int? ?? that.fileId,
        contentLength: contentLength == copyWithNull
            ? that.contentLength
            : contentLength as int?,
        contentType: contentType == copyWithNull
            ? that.contentType
            : contentType as String?,
        etag: etag == copyWithNull ? that.etag : etag as String?,
        lastModified: lastModified == copyWithNull
            ? that.lastModified
            : lastModified as DateTime?,
        hasPreview:
            hasPreview == copyWithNull ? that.hasPreview : hasPreview as bool?,
        realPath:
            realPath == copyWithNull ? that.realPath : realPath as String?,
        isFavorite:
            isFavorite == copyWithNull ? that.isFavorite : isFavorite as bool?,
        fileMetadataWidth: fileMetadataWidth == copyWithNull
            ? that.fileMetadataWidth
            : fileMetadataWidth as int?,
        fileMetadataHeight: fileMetadataHeight == copyWithNull
            ? that.fileMetadataHeight
            : fileMetadataHeight as int?,
        faceDetections: faceDetections == copyWithNull
            ? that.faceDetections
            : faceDetections as String?);
  }

  final DbRecognizeFaceItem that;
}

extension $DbRecognizeFaceItemCopyWith on DbRecognizeFaceItem {
  $DbRecognizeFaceItemCopyWithWorker get copyWith => _$copyWith;
  $DbRecognizeFaceItemCopyWithWorker get _$copyWith =>
      _$DbRecognizeFaceItemCopyWithWorkerImpl(this);
}

abstract class $DbTagCopyWithWorker {
  DbTag call(
      {int? id, String? displayName, bool? userVisible, bool? userAssignable});
}

class _$DbTagCopyWithWorkerImpl implements $DbTagCopyWithWorker {
  _$DbTagCopyWithWorkerImpl(this.that);

  @override
  DbTag call(
      {dynamic id,
      dynamic displayName,
      dynamic userVisible = copyWithNull,
      dynamic userAssignable = copyWithNull}) {
    return DbTag(
        id: id as int? ?? that.id,
        displayName: displayName as String? ?? that.displayName,
        userVisible: userVisible == copyWithNull
            ? that.userVisible
            : userVisible as bool?,
        userAssignable: userAssignable == copyWithNull
            ? that.userAssignable
            : userAssignable as bool?);
  }

  final DbTag that;
}

extension $DbTagCopyWith on DbTag {
  $DbTagCopyWithWorker get copyWith => _$copyWith;
  $DbTagCopyWithWorker get _$copyWith => _$DbTagCopyWithWorkerImpl(this);
}

abstract class $DbTrashDataCopyWithWorker {
  DbTrashData call(
      {String? filename, String? originalLocation, DateTime? deletionTime});
}

class _$DbTrashDataCopyWithWorkerImpl implements $DbTrashDataCopyWithWorker {
  _$DbTrashDataCopyWithWorkerImpl(this.that);

  @override
  DbTrashData call(
      {dynamic filename, dynamic originalLocation, dynamic deletionTime}) {
    return DbTrashData(
        filename: filename as String? ?? that.filename,
        originalLocation: originalLocation as String? ?? that.originalLocation,
        deletionTime: deletionTime as DateTime? ?? that.deletionTime);
  }

  final DbTrashData that;
}

extension $DbTrashDataCopyWith on DbTrashData {
  $DbTrashDataCopyWithWorker get copyWith => _$copyWith;
  $DbTrashDataCopyWithWorker get _$copyWith =>
      _$DbTrashDataCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$DbAccountToString on DbAccount {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbAccount {serverAddress: $serverAddress, userId: $userId}";
  }
}

extension _$DbAlbumToString on DbAlbum {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbAlbum {fileId: $fileId, fileEtag: $fileEtag, version: $version, lastUpdated: $lastUpdated, name: $name, providerType: $providerType, providerContent: $providerContent, coverProviderType: $coverProviderType, coverProviderContent: $coverProviderContent, sortProviderType: $sortProviderType, sortProviderContent: $sortProviderContent, shares: [length: ${shares.length}]}";
  }
}

extension _$DbAlbumShareToString on DbAlbumShare {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbAlbumShare {userId: $userId, displayName: $displayName, sharedAt: $sharedAt}";
  }
}

extension _$DbFaceRecognitionPersonToString on DbFaceRecognitionPerson {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbFaceRecognitionPerson {name: $name, thumbFaceId: $thumbFaceId, count: $count}";
  }
}

extension _$DbFileToString on DbFile {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbFile {fileId: $fileId, contentLength: $contentLength, contentType: $contentType, etag: $etag, lastModified: $lastModified, isCollection: $isCollection, usedBytes: $usedBytes, hasPreview: $hasPreview, ownerId: $ownerId, ownerDisplayName: $ownerDisplayName, relativePath: $relativePath, isFavorite: $isFavorite, isArchived: $isArchived, overrideDateTime: $overrideDateTime, bestDateTime: $bestDateTime, imageData: $imageData, location: $location, trashData: $trashData}";
  }
}

extension _$DbFileDescriptorToString on DbFileDescriptor {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbFileDescriptor {relativePath: $relativePath, fileId: $fileId, contentType: $contentType, isArchived: $isArchived, isFavorite: $isFavorite, bestDateTime: $bestDateTime}";
  }
}

extension _$DbImageDataToString on DbImageData {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbImageData {lastUpdated: $lastUpdated, fileEtag: $fileEtag, width: $width, height: $height, exif: $exif, exifDateTimeOriginal: $exifDateTimeOriginal, src: $src}";
  }
}

extension _$DbLocationToString on DbLocation {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbLocation {version: $version, name: $name, latitude: ${latitude == null ? null : "${latitude!.toStringAsFixed(3)}"}, longitude: ${longitude == null ? null : "${longitude!.toStringAsFixed(3)}"}, countryCode: $countryCode, admin1: $admin1, admin2: $admin2}";
  }
}

extension _$DbNcAlbumToString on DbNcAlbum {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbNcAlbum {relativePath: $relativePath, lastPhoto: $lastPhoto, nbItems: $nbItems, location: $location, dateStart: $dateStart, dateEnd: $dateEnd, collaborators: [length: ${collaborators.length}], isOwned: $isOwned}";
  }
}

extension _$DbNcAlbumItemToString on DbNcAlbumItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbNcAlbumItem {relativePath: $relativePath, fileId: $fileId, contentLength: $contentLength, contentType: $contentType, etag: $etag, lastModified: $lastModified, hasPreview: $hasPreview, isFavorite: $isFavorite, fileMetadataWidth: $fileMetadataWidth, fileMetadataHeight: $fileMetadataHeight}";
  }
}

extension _$DbRecognizeFaceToString on DbRecognizeFace {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbRecognizeFace {label: $label}";
  }
}

extension _$DbRecognizeFaceItemToString on DbRecognizeFaceItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbRecognizeFaceItem {relativePath: $relativePath, fileId: $fileId, contentLength: $contentLength, contentType: $contentType, etag: $etag, lastModified: $lastModified, hasPreview: $hasPreview, realPath: $realPath, isFavorite: $isFavorite, fileMetadataWidth: $fileMetadataWidth, fileMetadataHeight: $fileMetadataHeight, faceDetections: $faceDetections}";
  }
}

extension _$DbTagToString on DbTag {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbTag {id: $id, displayName: $displayName, userVisible: $userVisible, userAssignable: $userAssignable}";
  }
}

extension _$DbTrashDataToString on DbTrashData {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "DbTrashData {filename: $filename, originalLocation: $originalLocation, deletionTime: $deletionTime}";
  }
}
