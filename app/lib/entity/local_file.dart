import 'package:equatable/equatable.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:np_common/size.dart';
import 'package:to_string/to_string.dart';

part 'local_file.g.dart';

abstract class LocalFile with EquatableMixin {
  const LocalFile();

  /// Compare the identity of two local files
  ///
  /// Return true if two Files point to the same local file on the device. Be
  /// careful that this does NOT mean that the two objects are identical
  bool compareIdentity(LocalFile other);

  /// hashCode to be used with [compareIdentity]
  int get identityHashCode;

  String get logTag;

  /// [platformIdentifier] should return the same value returned by the
  /// [LocalMedia] APIs
  String get platformIdentifier;

  String get id;
  String? get filename;
  DateTime get lastModified;
  String? get mime;
  DateTime? get dateTaken;
  SizeInt? get size;
  String? get path;
  int? get byteSize;
}

extension LocalFileExtension on LocalFile {
  DateTime get bestDateTime => dateTaken ?? lastModified;

  AnyFile toAnyFile() {
    return AnyFile(provider: AnyFileLocalProvider(file: this));
  }
}

/// A local file represented by its content uri on Android
@ToString(ignoreNull: true)
class LocalUriFile with EquatableMixin implements LocalFile {
  const LocalUriFile({
    required this.id,
    required this.uri,
    required this.displayName,
    required this.path,
    required this.lastModified,
    this.mime,
    this.dateTaken,
    this.size,
    required this.byteSize,
  });

  @override
  bool compareIdentity(LocalFile other) {
    if (other is! LocalUriFile) {
      return false;
    } else {
      return uri == other.uri;
    }
  }

  @override
  int get identityHashCode => uri.hashCode;

  @override
  String toString() => _$toString();

  @override
  String get logTag => path;

  @override
  String get platformIdentifier => uri;

  @override
  String get filename => displayName;

  @override
  List<Object?> get props => [
    id,
    uri,
    displayName,
    path,
    lastModified,
    mime,
    dateTaken,
    size,
    byteSize,
  ];

  @override
  final String id;
  final String uri;
  final String displayName;

  /// [path] could be a relative path or an absolute path
  @override
  final String path;
  @override
  final DateTime lastModified;
  @override
  final String? mime;
  @override
  final DateTime? dateTaken;
  @override
  final SizeInt? size;
  @override
  final int byteSize;
}

@ToString(ignoreNull: true)
class LocalMediaIosFile with EquatableMixin implements LocalFile {
  const LocalMediaIosFile({
    required this.id,
    required this.filename,
    required this.dateModified,
    required this.mime,
    required this.dateTaken,
    required this.size,
    required this.byteSize,
  });

  @override
  bool compareIdentity(LocalFile other) {
    if (other is! LocalMediaIosFile) {
      return false;
    } else {
      return id == other.id;
    }
  }

  @override
  int get identityHashCode => id.hashCode;

  @override
  String toString() => _$toString();

  @override
  String get logTag => filename ?? id;

  @override
  String get platformIdentifier => id;

  @override
  List<Object?> get props => [
    id,
    filename,
    lastModified,
    mime,
    dateTaken,
    size,
    byteSize,
  ];

  @override
  DateTime get lastModified =>
      dateModified ?? DateTime.fromMillisecondsSinceEpoch(0);

  @override
  String? get path => null;

  @override
  final String id;
  @override
  final String? filename;
  final DateTime? dateModified;
  @override
  final String? mime;
  @override
  final DateTime? dateTaken;
  @override
  final SizeInt size;
  @override
  final int? byteSize;
}

typedef LocalFileOnFailureListener =
    void Function(LocalFile file, Object? error, StackTrace? stackTrace);

int compareLocalFileDateTimeDescending(LocalFile x, LocalFile y) {
  final tmp = y.bestDateTime.compareTo(x.bestDateTime);
  if (tmp != 0) {
    return tmp;
  } else if (x.filename != null && y.filename != null) {
    // compare file name if files are modified at the same time
    return y.filename!.compareTo(x.filename!);
  } else {
    return y.id.compareTo(x.id);
  }
}
