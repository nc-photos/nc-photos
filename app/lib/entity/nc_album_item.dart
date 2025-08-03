import 'package:nc_photos/entity/file.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'nc_album_item.g.dart';

@ToString(ignoreNull: true)
class NcAlbumItem {
  const NcAlbumItem({
    required this.path,
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

  final String path;
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

extension NcAlbumItemExtension on NcAlbumItem {
  /// Return the path of this file with the DAV part stripped
  ///
  /// WebDAV file path: remote.php/dav/photos/{userId}/albums/{album}/{strippedPath}.
  /// If this path points to the user's root album path, return "."
  String get strippedPath {
    // [albums/sharedalbums]/{album}/{strippedPath}
    final p = _partialStrippedPath;
    var begin = 0;
    if (p.startsWith("albums")) {
      begin += 6;
    } else if (p.startsWith("sharedalbums")) {
      begin += 12;
    } else {
      throw ArgumentError("Unsupported path: $path");
    }
    begin += 1;
    // {album}/{strippedPath}
    begin = path.indexOf("/", begin);
    if (begin == -1) {
      return ".";
    }
    return path.slice(begin + 1);
  }

  bool compareIdentity(NcAlbumItem other) => fileId == other.fileId;

  int get identityHashCode => fileId.hashCode;

  File toFile() {
    Metadata? metadata;
    if (fileMetadataWidth != null && fileMetadataHeight != null) {
      metadata = Metadata(
        imageWidth: fileMetadataWidth,
        imageHeight: fileMetadataHeight,
        src: MetadataSrc.legacy,
      );
    }
    return File(
      path: path,
      fileId: fileId,
      contentLength: contentLength,
      contentType: contentType,
      etag: etag,
      lastModified: lastModified,
      hasPreview: hasPreview,
      isFavorite: isFavorite,
      metadata: metadata,
    );
  }

  /// Return a new path without the part before albums/sharedalbums
  String get _partialStrippedPath {
    if (!path.startsWith("${api.ApiPhotos.path}/")) {
      throw ArgumentError("Unsupported path: $path");
    }
    var begin = "${api.ApiPhotos.path}/".length;
    begin = path.indexOf("/", begin);
    if (begin == -1) {
      throw ArgumentError("Unsupported path: $path");
    }
    return path.slice(begin + 1);
  }
}
