import 'package:equatable/equatable.dart';
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

  String get filename;
  DateTime get lastModified;
  String? get mime;
  DateTime? get dateTaken;
}

extension LocalFileExtension on LocalFile {
  DateTime get bestDateTime => dateTaken ?? lastModified;
}

/// A local file represented by its content uri on Android
@ToString(ignoreNull: true)
class LocalUriFile with EquatableMixin implements LocalFile {
  const LocalUriFile({
    required this.uri,
    required this.displayName,
    required this.path,
    required this.lastModified,
    this.mime,
    this.dateTaken,
  });

  @override
  compareIdentity(LocalFile other) {
    if (other is! LocalUriFile) {
      return false;
    } else {
      return uri == other.uri;
    }
  }

  @override
  get identityHashCode => uri.hashCode;

  @override
  String toString() => _$toString();

  @override
  get logTag => path;

  @override
  get filename => displayName;

  @override
  get props => [uri, displayName, path, lastModified, mime, dateTaken];

  final String uri;
  final String displayName;

  /// [path] could be a relative path or an absolute path
  final String path;
  @override
  final DateTime lastModified;
  @override
  final String? mime;
  @override
  final DateTime? dateTaken;
}

typedef LocalFileOnFailureListener =
    void Function(LocalFile file, Object? error, StackTrace? stackTrace);

class LocalFileRepo {
  const LocalFileRepo(this.dataSrc);

  /// See [LocalFileDataSource.listDir]
  Future<List<LocalFile>> listDir(String path) => dataSrc.listDir(path);

  /// See [LocalFileDataSource.deleteFiles]
  Future<void> deleteFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) => dataSrc.deleteFiles(files, onFailure: onFailure);

  /// See [LocalFileDataSource.shareFiles]
  Future<void> shareFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) => dataSrc.shareFiles(files, onFailure: onFailure);

  final LocalFileDataSource dataSrc;
}

abstract class LocalFileDataSource {
  /// List all files under [path]
  Future<List<LocalFile>> listDir(String path);

  /// Delete files
  Future<void> deleteFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  });

  /// Share files
  Future<void> shareFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  });
}
