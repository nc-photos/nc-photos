import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:np_common/type.dart';
import 'package:np_string/np_string.dart';
import 'package:path/path.dart' as path_lib;
import 'package:to_string/to_string.dart';

part 'file_descriptor.g.dart';

int compareFileDescriptorDateTimeDescending(
  FileDescriptor x,
  FileDescriptor y,
) {
  final tmp = y.fdDateTime.compareTo(x.fdDateTime);
  if (tmp != 0) {
    return tmp;
  } else {
    // compare file name if files are modified at the same time
    return y.fdId.compareTo(x.fdId);
  }
}

@genCopyWith
@toString
class FileDescriptor with EquatableMixin {
  const FileDescriptor({
    required this.fdPath,
    required this.fdId,
    required this.fdMime,
    required this.fdIsArchived,
    required this.fdIsFavorite,
    required this.fdDateTime,
  });

  static FileDescriptor fromJson(JsonObj json) => FileDescriptor(
    fdPath: json["fdPath"],
    fdId: json["fdId"],
    fdMime: json["fdMime"],
    fdIsArchived: json["fdIsArchived"],
    fdIsFavorite: json["fdIsFavorite"],
    fdDateTime: DateTime.parse(json["fdDateTime"]),
  );

  static JsonObj toJson(FileDescriptor that) => {
    "fdPath": that.fdPath,
    "fdId": that.fdId,
    "fdMime": that.fdMime,
    "fdIsArchived": that.fdIsArchived,
    "fdIsFavorite": that.fdIsFavorite,
    "fdDateTime": that.fdDateTime.toUtc().toIso8601String(),
  };

  @override
  String toString() => _$toString();

  JsonObj toFdJson() => toJson(this);

  @override
  List<Object?> get props => [
    fdPath,
    fdId,
    fdMime,
    fdIsArchived,
    fdIsFavorite,
    fdDateTime,
  ];

  final String fdPath;
  final int fdId;
  final String? fdMime;
  final bool fdIsArchived;
  final bool fdIsFavorite;
  final DateTime fdDateTime;
}

extension FileDescriptorExtension on FileDescriptor {
  /// Return the path of this file with the DAV part stripped
  ///
  /// WebDAV file path: remote.php/dav/files/{username}/{strippedPath}. If this
  /// file points to the user's root dir, return "."
  ///
  /// See: [strippedPathWithEmpty]
  String get strippedPath {
    if (fdPath.startsWith("remote.php/dav/files")) {
      final position = fdPath.indexOf("/", "remote.php/dav/files/".length) + 1;
      if (position == 0) {
        // root dir path
        return ".";
      } else {
        return fdPath.substring(position);
      }
    } else if (fdPath.startsWith("remote.php/dav/photos/")) {
      // nextcloud albums
      var position = fdPath.indexOf("/", "remote.php/dav/photos/".length) + 1;
      position = fdPath.indexOf("/", position);
      return fdPath.slice(position + 1);
    } else {
      return fdPath;
    }
  }

  /// Return the path of this file with the DAV part stripped
  ///
  /// WebDAV file path: remote.php/dav/files/{username}/{strippedPath}. If this
  /// file points to the user's root dir, return an empty string
  ///
  /// See: [strippedPath]
  String get strippedPathWithEmpty {
    final path = strippedPath;
    return path == "." ? "" : path;
  }

  String get filename => path_lib.basename(fdPath);

  /// Compare the server identity of two Files
  ///
  /// Return true if two Files point to the same file on server. Be careful that
  /// this does NOT mean that the two Files are identical
  bool compareServerIdentity(FileDescriptor other) {
    try {
      return fdId == other.fdId;
    } catch (_) {
      return fdPath == other.fdPath;
    }
  }

  /// hashCode to be used with [compareServerIdentity]
  int get identityHashCode => fdId.hashCode;

  File toFile() {
    return File(
      path: fdPath,
      fileId: fdId,
      contentType: fdMime,
      isArchived: fdIsArchived,
      isFavorite: fdIsFavorite,
    );
  }

  FileDescriptor replacePath(String newPath) {
    if (this is File) {
      return (this as File).copyWith(path: newPath);
    } else {
      return copyWith(fdPath: newPath);
    }
  }
}

class FileDescriptorServerIdentityComparator {
  const FileDescriptorServerIdentityComparator(this.file);

  @override
  bool operator ==(Object other) {
    if (other is FileDescriptorServerIdentityComparator) {
      return file.compareServerIdentity(other.file);
    } else if (other is FileDescriptor) {
      return file.compareServerIdentity(other);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => file.fdId.hashCode;

  final FileDescriptor file;
}
