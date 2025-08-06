import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_common/type.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'nc_album.g.dart';

/// Server-side album since Nextcloud 25
@toString
@genCopyWith
class NcAlbum with EquatableMixin {
  NcAlbum({
    required String path,
    required this.lastPhoto,
    required this.nbItems,
    required this.location,
    required this.dateStart,
    required this.dateEnd,
    required this.collaborators,
  }) : path = path.trimAny("/");

  static NcAlbum createNew({required Account account, required String name}) {
    return NcAlbum(
      path: "${api.ApiPhotos.path}/${account.userId}/albums/$name",
      lastPhoto: null,
      nbItems: 0,
      location: null,
      dateStart: null,
      dateEnd: null,
      collaborators: const [],
    );
  }

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [
    path,
    lastPhoto,
    nbItems,
    location,
    dateStart,
    dateEnd,
    collaborators,
  ];

  final String path;

  /// File ID of the last photo
  ///
  /// The API will return -1 if there's no photos in the album. It's mapped to
  /// null here instead
  final int? lastPhoto;

  /// Items count
  final int nbItems;
  final String? location;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final List<NcAlbumCollaborator> collaborators;
}

extension NcAlbumExtension on NcAlbum {
  /// Return if this album is owned by you, or shared with you by other users
  bool get isOwned {
    // [albums/sharedalbums]/{strippedPath}
    final p = _partialStrippedPath;
    return p.startsWith("albums/");
  }

  /// Return the owner of this shared album, or null if this album is owned by
  /// you
  String? get owner {
    if (isOwned) {
      return null;
    }
    final p = strippedPath;
    final found = p.lastIndexOf("(");
    if (found == -1) {
      // ?
      return null;
    } else {
      return p.slice(found + 1);
    }
  }

  /// Return the name of this album
  ///
  /// Normally this is identical to [strippedPath], except for those shared by
  /// others
  String get name {
    if (isOwned) {
      return strippedPath;
    }
    final p = strippedPath;
    final found = p.lastIndexOf(" (");
    if (found == -1) {
      // ?
      return p;
    } else {
      return p.slice(0, found);
    }
  }

  /// Return the path of this file with the DAV part stripped
  ///
  /// WebDAV file path: remote.php/dav/photos/{userId}/albums/{strippedPath}.
  /// If this path points to the user's root album path, return "."
  String get strippedPath {
    // [albums/sharedalbums]/{strippedPath}
    final p = _partialStrippedPath;
    var begin = 0;
    if (p.startsWith("albums")) {
      begin += 6;
    } else if (p.startsWith("sharedalbums")) {
      begin += 12;
    } else {
      throw ArgumentError("Unsupported path: $path");
    }
    // /{strippedPath}
    final stripped = p.slice(begin + 1);
    if (stripped.isEmpty) {
      return ".";
    } else {
      return stripped;
    }
  }

  String getRenamedPath(String newName) {
    final i = path.indexOf("albums/");
    if (i == -1) {
      throw StateError("Invalid path: $path");
    }
    return "${path.substring(0, i + "albums/".length)}$newName";
  }

  int get count => nbItems;

  bool compareIdentity(NcAlbum other) {
    return path == other.path;
  }

  int get identityHashCode => path.hashCode;

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

@toString
class NcAlbumCollaborator {
  const NcAlbumCollaborator({
    required this.id,
    required this.label,
    required this.type,
  });

  factory NcAlbumCollaborator.fromJson(JsonObj json) => NcAlbumCollaborator(
    id: CiString(json["id"]),
    label: json["label"],
    type: json["type"],
  );

  JsonObj toJson() => {"id": id.raw, "label": label, "type": type};

  @override
  String toString() => _$toString();

  final CiString id;
  final String label;
  // right now it's unclear what this variable represents
  final int type;
}
