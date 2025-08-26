import 'package:equatable/equatable.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'recognize_face_item.g.dart';

@ToString(ignoreNull: true)
class RecognizeFaceItem with EquatableMixin {
  const RecognizeFaceItem({
    required this.path,
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
    path,
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

  final String path;
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
  final List<Map<String, dynamic>>? faceDetections;
}

extension RecognizeFaceItemExtension on RecognizeFaceItem {
  /// Return the path of this item with the DAV part stripped
  ///
  /// WebDAV file path: remote.php/dav/recognize/{userId}/faces/{face}/{strippedPath}.
  /// If this path points to the user's root album path, return "."
  String get strippedPath {
    if (!path.startsWith("${api.ApiRecognize.path}/")) {
      throw ArgumentError("Unsupported path: $path");
    }
    var begin = "${api.ApiRecognize.path}/".length;
    begin = path.indexOf("/", begin);
    if (begin == -1) {
      throw ArgumentError("Unsupported path: $path");
    }
    // /faces/{face}/{strippedPath}
    if (path.slice(begin, begin + 6) != "/faces") {
      throw ArgumentError("Unsupported path: $path");
    }
    begin += 7;
    // {face}/{strippedPath}
    begin = path.indexOf("/", begin);
    if (begin == -1) {
      return ".";
    }
    return path.slice(begin + 1);
  }

  bool compareIdentity(RecognizeFaceItem other) => fileId == other.fileId;

  int get identityHashCode => fileId.hashCode;

  static int identityComparator(RecognizeFaceItem a, RecognizeFaceItem b) =>
      a.fileId.compareTo(b.fileId);

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
      path: realPath ?? path,
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
}
