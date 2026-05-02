// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$FaceRecognitionFaceToString on FaceRecognitionFace {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "FaceRecognitionFace {id: $id, fileId: $fileId}";
  }
}

extension _$FaceRecognitionPersonToString on FaceRecognitionPerson {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "FaceRecognitionPerson {name: $name, thumbFaceId: $thumbFaceId, count: $count}";
  }
}

extension _$FavoriteToString on Favorite {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Favorite {href: $href, fileId: $fileId}";
  }
}

extension _$FileToString on File {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "File {href: $href, ${lastModified == null ? "" : "lastModified: $lastModified, "}${etag == null ? "" : "etag: $etag, "}${contentType == null ? "" : "contentType: $contentType, "}${isCollection == null ? "" : "isCollection: $isCollection, "}${contentLength == null ? "" : "contentLength: $contentLength, "}${fileId == null ? "" : "fileId: $fileId, "}${favorite == null ? "" : "favorite: $favorite, "}${ownerId == null ? "" : "ownerId: $ownerId, "}${ownerDisplayName == null ? "" : "ownerDisplayName: $ownerDisplayName, "}${hasPreview == null ? "" : "hasPreview: $hasPreview, "}${trashbinFilename == null ? "" : "trashbinFilename: $trashbinFilename, "}${trashbinOriginalLocation == null ? "" : "trashbinOriginalLocation: $trashbinOriginalLocation, "}${trashbinDeletionTime == null ? "" : "trashbinDeletionTime: $trashbinDeletionTime, "}${metadataPhotosIfd0 == null ? "" : "metadataPhotosIfd0: $metadataPhotosIfd0, "}${metadataPhotosExif == null ? "" : "metadataPhotosExif: $metadataPhotosExif, "}${metadataPhotosGps == null ? "" : "metadataPhotosGps: $metadataPhotosGps, "}${metadataPhotosSize == null ? "" : "metadataPhotosSize: $metadataPhotosSize, "}${customProperties == null ? "" : "customProperties: $customProperties"}}";
  }
}

extension _$NcAlbumToString on NcAlbum {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "NcAlbum {href: $href, lastPhoto: $lastPhoto, nbItems: $nbItems, location: $location, dateRange: $dateRange, collaborators: $collaborators}";
  }
}

extension _$NcAlbumCollaboratorToString on NcAlbumCollaborator {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "NcAlbumCollaborator {id: $id, label: $label, type: $type}";
  }
}

extension _$NcAlbumItemToString on NcAlbumItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "NcAlbumItem {href: $href, ${fileId == null ? "" : "fileId: $fileId, "}${contentLength == null ? "" : "contentLength: $contentLength, "}${contentType == null ? "" : "contentType: $contentType, "}${etag == null ? "" : "etag: $etag, "}${lastModified == null ? "" : "lastModified: $lastModified, "}${hasPreview == null ? "" : "hasPreview: $hasPreview, "}${favorite == null ? "" : "favorite: $favorite, "}${fileMetadataSize == null ? "" : "fileMetadataSize: $fileMetadataSize"}}";
  }
}

extension _$RecognizeApiKeyToString on RecognizeApiKey {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "RecognizeApiKey {apiKey: $apiKey}";
  }
}

extension _$RecognizeFaceToString on RecognizeFace {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "RecognizeFace {href: $href}";
  }
}

extension _$RecognizeFaceItemToString on RecognizeFaceItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "RecognizeFaceItem {href: $href, ${contentLength == null ? "" : "contentLength: $contentLength, "}${contentType == null ? "" : "contentType: $contentType, "}${etag == null ? "" : "etag: $etag, "}${lastModified == null ? "" : "lastModified: $lastModified, "}${faceDetections == null ? "" : "faceDetections: $faceDetections, "}${fileMetadataSize == null ? "" : "fileMetadataSize: $fileMetadataSize, "}${hasPreview == null ? "" : "hasPreview: $hasPreview, "}${realPath == null ? "" : "realPath: $realPath, "}${favorite == null ? "" : "favorite: $favorite, "}${fileId == null ? "" : "fileId: $fileId"}}";
  }
}

extension _$ShareToString on Share {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Share {id: $id, shareType: $shareType, stime: $stime, uidOwner: $uidOwner, displaynameOwner: $displaynameOwner, uidFileOwner: $uidFileOwner, path: $path, itemType: $itemType, mimeType: $mimeType, itemSource: $itemSource, shareWith: $shareWith, shareWithDisplayName: $shareWithDisplayName, url: $url}";
  }
}

extension _$ShareeToString on Sharee {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Sharee {type: $type, label: $label, shareType: $shareType, shareWith: $shareWith, shareWithDisplayNameUnique: $shareWithDisplayNameUnique}";
  }
}

extension _$StatusToString on Status {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Status {version: $version, versionString: $versionString, productName: $productName}";
  }
}

extension _$TagToString on Tag {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Tag {href: $href, id: $id, displayName: $displayName, userVisible: $userVisible, userAssignable: $userAssignable}";
  }
}

extension _$TaggedFileToString on TaggedFile {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "TaggedFile {href: $href, fileId: $fileId}";
  }
}
