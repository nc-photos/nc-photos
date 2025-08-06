import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:nc_photos/mobile/android/k.dart' as android;
import 'package:nc_photos/mobile/share.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/stream_extension.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class LocalFileMediaStoreDataSource implements LocalFileDataSource {
  const LocalFileMediaStoreDataSource();

  @override
  listDir(String path) async {
    _log.info("[listDir] $path");
    final results = await MediaStore.queryFiles(path);
    return results
        .where((r) => file_util.isSupportedMime(r.mimeType ?? ""))
        .map(_toLocalFile)
        .toList();
  }

  @override
  deleteFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) async {
    _log.info("[deleteFiles] ${files.map((f) => f.logTag).toReadableString()}");
    final uriFiles = _filterUriFiles(files, (f) {
      onFailure?.call(f, ArgumentError("File not supported"), null);
    });
    if (AndroidInfo().sdkInt >= AndroidVersion.R) {
      await _deleteFiles30(uriFiles, onFailure);
    } else {
      await _deleteFiles0(uriFiles, onFailure);
    }
  }

  @override
  shareFiles(
    List<LocalFile> files, {
    LocalFileOnFailureListener? onFailure,
  }) async {
    _log.info("[shareFiles] ${files.map((f) => f.logTag).toReadableString()}");
    final uriFiles = _filterUriFiles(files, (f) {
      onFailure?.call(f, ArgumentError("File not supported"), null);
    });

    final share = AndroidFileShare(
      uriFiles.map((e) => AndroidFileShareFile(e.uri, e.mime)).toList(),
    );
    try {
      await share.share();
    } catch (e, stackTrace) {
      for (final f in uriFiles) {
        onFailure?.call(f, e, stackTrace);
      }
    }
  }

  Future<void> _deleteFiles30(
    List<LocalUriFile> files,
    LocalFileOnFailureListener? onFailure,
  ) async {
    assert(AndroidInfo().sdkInt >= AndroidVersion.R);
    int? resultCode;
    final resultFuture = MediaStore.stream
        .whereType<MediaStoreDeleteRequestResultEvent>()
        .first
        .then((ev) => resultCode = ev.resultCode);
    await MediaStore.deleteFiles(files.map((f) => f.uri).toList());
    await resultFuture;
    if (resultCode != android.resultOk) {
      _log.warning("[_deleteFiles30] result != OK: $resultCode");
      for (final f in files) {
        onFailure?.call(f, null, null);
      }
    }
  }

  Future<void> _deleteFiles0(
    List<LocalUriFile> files,
    LocalFileOnFailureListener? onFailure,
  ) async {
    assert(AndroidInfo().sdkInt < AndroidVersion.R);
    final failedUris = await MediaStore.deleteFiles(
      files.map((f) => f.uri).toList(),
    );
    final failedFilesIt =
        failedUris!
            .map((uri) => files.firstWhereOrNull((f) => f.uri == uri))
            .nonNulls;
    for (final f in failedFilesIt) {
      onFailure?.call(f, null, null);
    }
  }

  List<LocalUriFile> _filterUriFiles(
    List<LocalFile> files, [
    void Function(LocalFile)? nonUriFileCallback,
  ]) {
    return files
        .where((f) {
          if (f is! LocalUriFile) {
            _log.warning(
              "[deleteFiles] Can't remove file not returned by this data source: $f",
            );
            nonUriFileCallback?.call(f);
            return false;
          } else {
            return true;
          }
        })
        .cast<LocalUriFile>()
        .toList();
  }

  static LocalFile _toLocalFile(MediaStoreQueryResult r) => LocalUriFile(
    uri: r.uri,
    displayName: r.displayName,
    path: r.path,
    lastModified: DateTime.fromMillisecondsSinceEpoch(r.dateModified),
    mime: r.mimeType,
    dateTaken: r.dateTaken?.run(DateTime.fromMillisecondsSinceEpoch),
  );
}
