import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_datetime/np_datetime.dart';

class LocalFileIdWithTimestamp {
  const LocalFileIdWithTimestamp({
    required this.fileId,
    required this.timestamp,
  });

  final String fileId;
  final int timestamp;
}

class LocalFileRepo {
  const LocalFileRepo(this.dataSrc);

  /// See [LocalFileDataSource.getFiles]
  Future<List<LocalFile>> getFiles({
    List<String>? fileIds,
    TimeRange? timeRange,
    bool? isAscending,
    int? offset,
    int? limit,
  }) => dataSrc.getFiles(
    fileIds: fileIds,
    timeRange: timeRange,
    isAscending: isAscending,
    offset: offset,
    limit: limit,
  );

  /// See [LocalFileDataSource.listDir]
  Future<List<LocalFile>> listDir(String path) => dataSrc.listDir(path);

  /// See [LocalFileDataSource.deleteFiles]
  Future<void> deleteFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) => dataSrc.deleteFiles(files, onFailure: onFailure);

  /// See [LocalFileDataSource.trashFiles]
  Future<void> trashFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) => dataSrc.trashFiles(files, onFailure: onFailure);

  /// See [LocalFileDataSource.shareFiles]
  Future<void> shareFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) => dataSrc.shareFiles(files, onFailure: onFailure);

  /// See [LocalFileDataSource.getFilesSummary]
  Future<LocalFilesSummary> getFilesSummary() => dataSrc.getFilesSummary();

  Future<List<LocalFileIdWithTimestamp>> getFileIdWithTimestamps() =>
      dataSrc.getFileIdWithTimestamps();

  final LocalFileDataSource dataSrc;
}

abstract class LocalFileDataSource {
  /// Query all local files
  ///
  /// Returned files are sorted by time in descending order
  Future<List<LocalFile>> getFiles({
    List<String>? fileIds,
    TimeRange? timeRange,
    bool? isAscending,
    int? offset,
    int? limit,
  });

  /// List all files under [path]
  Future<List<LocalFile>> listDir(String path);

  /// Delete files
  Future<void> deleteFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  });

  /// Trash files
  Future<void> trashFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  });

  /// Share files
  Future<void> shareFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  });

  Future<LocalFilesSummary> getFilesSummary();

  Future<List<LocalFileIdWithTimestamp>> getFileIdWithTimestamps();
}
