import 'dart:convert';

import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_string/np_string.dart';

part 'provider/local.dart';
part 'provider/merged.dart';
part 'provider/nextcloud.dart';

/// A File where its content is provided by an external provider
class AnyFile {
  const AnyFile({required this.provider});

  @override
  String toString() =>
      "AnyFile {"
      "id: $id, "
      "name: $name, "
      "mime: $mime, "
      "dateTime: $dateTime"
      "displayPath: $displayPath"
      "logTag: $logTag"
      "}";

  /// Compare the identity of two [AnyFile]s
  ///
  /// Return true if they both point to the same file. Beware that this does NOT
  /// imply that the two objects are identical
  bool compareIdentity(AnyFile other) => other.id == id;

  int get identityHashCode => id.hashCode;

  String get id => provider.id;
  String get name => provider.name;
  String? get mime => provider.mime;
  DateTime get dateTime => provider.bestDateTime;
  String? get displayPath => provider.displayPath;

  /// A string used to provide concrete details to identify this file easily in
  /// logs. This string is STRICTLY used for logging purpose ONLY, and must not
  /// be used in any other ways. Its content is 100% implementation details
  String get logTag => provider.logTag;

  final AnyFileProvider provider;
}

enum AnyFileCapability {
  favorite,
  archive,
  edit,
  download,
  delete,
  upload,
  remoteShare,
  collection,
}

mixin ArchivableAnyFile {
  bool get isArchived;
}

mixin FavoritableAnyFile {
  bool get isFavorite;
}

enum AnyFileProviderType {
  nextcloud,
  local,
  merged;

  static AnyFileProviderType fromId(String afId) {
    switch (afId.slice(0, 4)) {
      case AnyFileNextcloudProvider.kFourCc:
        return nextcloud;
      case AnyFileLocalProvider.kFourCc:
        return local;
      case AnyFileMergedProvider.kFourCc:
        return merged;
      default:
        throw ArgumentError("Unknwon id: $afId");
    }
  }
}

sealed class AnyFileProvider {
  const AnyFileProvider();

  /// Return the unique id of this file. This id must be formatted as
  /// XXXX-YYY...YYY, where XXXX is a unique FourCC for this provider, and Y is
  /// an implementation details
  String get id;

  /// Return the name of this file
  String get name;

  /// Return the mime type of this file
  String? get mime;

  /// Return the date time best representing this file
  DateTime get bestDateTime;

  /// Return a user facing path of this file, or null. The path returned could
  /// be anything that make sense as a "path", e.g., URL, dir path, etc. It's
  /// for displaying only and can be altered to improve understandability. It
  /// does not necessarily need to be openable either.
  String? get displayPath;

  String get logTag;
}

int anyFileDateTimeAscSorter(AnyFile a, AnyFile b) {
  var c = a.dateTime.compareTo(b.dateTime);
  if (c == 0) {
    c = a.name.compareTo(b.name);
  }
  if (c == 0) {
    c = a.id.compareTo(b.id);
  }
  return c;
}

int anyFileDateTimeDescSorter(AnyFile a, AnyFile b) =>
    anyFileDateTimeAscSorter(b, a);
