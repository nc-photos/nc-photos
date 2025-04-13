import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/entity/face_recognition_face.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/entity/favorite.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/entity/nc_album_item.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:nc_photos/entity/server_status.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/tagged_file.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'entity_converter.g.dart';

class ApiFaceRecognitionFaceConverter {
  static FaceRecognitionFace fromApi(api.FaceRecognitionFace face) {
    return FaceRecognitionFace(
      id: face.id,
      fileId: face.fileId,
    );
  }
}

class ApiFaceRecognitionPersonConverter {
  static FaceRecognitionPerson fromApi(api.FaceRecognitionPerson person) {
    return FaceRecognitionPerson(
      name: person.name,
      thumbFaceId: person.thumbFaceId,
      count: person.count,
    );
  }
}

class ApiFavoriteConverter {
  static Favorite fromApi(api.Favorite favorite) {
    return Favorite(
      fileId: favorite.fileId,
    );
  }
}

class ApiFileConverter {
  static Metadata? _metadataFromApi(api.File file) {
    if (file.metadataPhotosSize != null) {
      return Metadata.fromApi(
        etag: file.etag,
        ifd0: file.metadataPhotosIfd0,
        exif: file.metadataPhotosExif,
        gps: file.metadataPhotosGps,
        size: file.metadataPhotosSize!,
      );
    } else {
      return file.customProperties?["com.nkming.nc_photos:metadata"]
          ?.let((obj) => Metadata.fromJson(
                jsonDecode(obj),
                upgraderV1: MetadataUpgraderV1(
                  fileContentType: file.contentType,
                  logFilePath: file.href,
                ),
                upgraderV2: MetadataUpgraderV2(
                  fileContentType: file.contentType,
                  logFilePath: file.href,
                ),
                upgraderV3: MetadataUpgraderV3(
                  fileContentType: file.contentType,
                  logFilePath: file.href,
                ),
                upgraderV4: MetadataUpgraderV4(
                  fileContentType: file.contentType,
                  logFilePath: file.href,
                ),
              ));
    }
  }

  static File fromApi(api.File file) {
    final mime = file.contentType == "application/octet-stream" &&
            file.href.endsWith(".jxl")
        ? "image/jxl"
        : file.contentType;
    return File(
      path: _hrefToPath(file.href),
      contentLength: file.contentLength,
      contentType: mime,
      etag: file.etag,
      lastModified: file.lastModified,
      isCollection: file.isCollection,
      hasPreview: file.hasPreview,
      fileId: file.fileId,
      isFavorite: file.favorite,
      ownerId: file.ownerId?.toCi(),
      ownerDisplayName: file.ownerDisplayName,
      trashbinFilename: file.trashbinFilename,
      trashbinOriginalLocation: file.trashbinOriginalLocation,
      trashbinDeletionTime: file.trashbinDeletionTime,
      metadata: _metadataFromApi(file),
      isArchived: file.customProperties?["com.nkming.nc_photos:is-archived"]
          ?.run((obj) => obj == "true"),
      overrideDateTime: file
          .customProperties?["com.nkming.nc_photos:override-date-time"]
          ?.run((obj) => DateTime.parse(obj)),
      location: file.customProperties?["com.nkming.nc_photos:location"]
          ?.run((obj) => ImageLocation.fromJson(jsonDecode(obj))),
    );
  }
}

class ApiNcAlbumConverter {
  static NcAlbum fromApi(api.NcAlbum album) {
    return NcAlbum(
      path: _hrefToPath(album.href),
      lastPhoto: (album.lastPhoto ?? -1) < 0 ? null : album.lastPhoto,
      nbItems: album.nbItems ?? 0,
      location: album.location,
      dateStart: (album.dateRange?["start"] as int?)
          ?.run((d) => DateTime.fromMillisecondsSinceEpoch(d * 1000)),
      dateEnd: (album.dateRange?["end"] as int?)
          ?.run((d) => DateTime.fromMillisecondsSinceEpoch(d * 1000)),
      collaborators: album.collaborators
          .map((c) => NcAlbumCollaborator(
                id: c.id.toCi(),
                label: c.label,
                type: c.type,
              ))
          .toList(),
    );
  }
}

class ApiNcAlbumItemConverter {
  static NcAlbumItem fromApi(api.NcAlbumItem item) {
    return NcAlbumItem(
      path: _hrefToPath(item.href),
      fileId: item.fileId!,
      contentLength: item.contentLength,
      contentType: item.contentType,
      etag: item.etag,
      lastModified: item.lastModified,
      hasPreview: item.hasPreview,
      isFavorite: item.favorite,
      fileMetadataWidth: item.fileMetadataSize?["width"],
      fileMetadataHeight: item.fileMetadataSize?["height"],
    );
  }
}

class ApiRecognizeFaceConverter {
  static RecognizeFace fromApi(api.RecognizeFace item) {
    // remote.php/dav/recognize/admin/faces/john
    var path = _hrefToPath(item.href);
    if (!path.startsWith("remote.php/dav/recognize/")) {
      throw ArgumentError("Invalid face path: ${item.href}");
    }
    // admin/faces/john
    path = path.substring(25);
    final found = path.indexOf("/");
    if (found == -1) {
      throw ArgumentError("Invalid face path: ${item.href}");
    }
    // faces/john
    path = path.substring(found + 1);
    if (!path.startsWith("faces")) {
      throw ArgumentError("Invalid face path: ${item.href}");
    }
    // john
    path = path.slice(6);
    return RecognizeFace(label: path);
  }
}

class ApiRecognizeFaceItemConverter {
  static RecognizeFaceItem fromApi(api.RecognizeFaceItem item) {
    return RecognizeFaceItem(
      path: _hrefToPath(item.href),
      fileId: item.fileId!,
      contentLength: item.contentLength,
      contentType: item.contentType,
      etag: item.etag,
      lastModified: item.lastModified,
      hasPreview: item.hasPreview,
      realPath: item.realPath,
      isFavorite: item.favorite,
      fileMetadataWidth: item.fileMetadataSize?["width"],
      fileMetadataHeight: item.fileMetadataSize?["height"],
      faceDetections:
          item.faceDetections?.isEmpty == true ? null : item.faceDetections,
    );
  }
}

class ApiShareConverter {
  static Share fromApi(api.Share share) {
    final shareType = ShareTypeExtension.fromValue(share.shareType);
    final itemType = ShareItemTypeExtension.fromValue(share.itemType);
    return Share(
      id: share.id,
      shareType: shareType,
      stime: DateTime.fromMillisecondsSinceEpoch(share.stime * 1000),
      uidOwner: share.uidOwner.toCi(),
      displaynameOwner: share.displaynameOwner,
      uidFileOwner: share.uidFileOwner.toCi(),
      path: share.path,
      itemType: itemType,
      mimeType: share.mimeType,
      itemSource: share.itemSource,
      // when shared with a password protected link, shareWith somehow contains
      // the password, which doesn't make sense. We set it to null instead
      shareWith:
          shareType == ShareType.publicLink ? null : share.shareWith?.toCi(),
      shareWithDisplayName: share.shareWithDisplayName,
      url: share.url,
    );
  }
}

class ApiShareeConverter {
  static Sharee fromApi(api.Sharee sharee) {
    return Sharee(
      type: _keyTypes[sharee.type]!,
      label: sharee.label,
      shareType: sharee.shareType,
      shareWith: sharee.shareWith.toCi(),
      shareWithDisplayNameUnique: sharee.shareWithDisplayNameUnique,
    );
  }

  static const _keyTypes = {
    "users": ShareeType.user,
    "groups": ShareeType.group,
    "remotes": ShareeType.remote,
    "remote_groups": ShareeType.remoteGroup,
    "emails": ShareeType.email,
    "circles": ShareeType.circle,
    "rooms": ShareeType.room,
    "deck": ShareeType.deck,
    "lookup": ShareeType.lookup,
  };
}

class ApiStatusConverter {
  static ServerStatus fromApi(api.Status status) {
    return ServerStatus(
      versionRaw: status.version,
      versionName: status.versionString,
      productName: status.productName,
    );
  }
}

class ApiTagConverter {
  static Tag fromApi(api.Tag tag) {
    return Tag(
      id: tag.id,
      displayName: tag.displayName,
      userVisible: tag.userVisible,
      userAssignable: tag.userAssignable,
    );
  }
}

class ApiTaggedFileConverter {
  static TaggedFile fromApi(api.TaggedFile taggedFile) {
    return TaggedFile(
      fileId: taggedFile.fileId,
    );
  }
}

String _hrefToPath(String href) {
  final rawPath = href.trimAny("/");
  final pos = rawPath.indexOf("remote.php");
  if (pos == -1) {
    // what?
    _$_NpLog.log.warning("[_hrefToPath] Unknown href value: $rawPath");
    return rawPath;
  } else {
    return rawPath.substring(pos);
  }
}

@npLog
// ignore: camel_case_types
class _ {}
