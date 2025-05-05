import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_datetime/np_datetime.dart';

class LocalFileRepo {
  const LocalFileRepo(this.dataSrc);

  /// See [LocalFileDataSource.getFiles]
  Future<List<LocalFile>> getFiles({TimeRange? timeRange}) =>
      dataSrc.getFiles(timeRange: timeRange);

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

  /// See [LocalFileDataSource.getFilesSummary]
  Future<LocalFilesSummary> getFilesSummary() => dataSrc.getFilesSummary();

  final LocalFileDataSource dataSrc;
}

abstract class LocalFileDataSource {
  /// Query all local files
  ///
  /// Returned files are sorted by time in descending order
  Future<List<LocalFile>> getFiles({TimeRange? timeRange});

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

  Future<LocalFilesSummary> getFilesSummary();
}
