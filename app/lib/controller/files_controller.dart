import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/progress_util.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/rx_extension.dart';
import 'package:nc_photos/use_case/file/list_file.dart';
import 'package:nc_photos/use_case/find_file_descriptor.dart';
import 'package:nc_photos/use_case/list_archived_file.dart';
import 'package:nc_photos/use_case/remove.dart';
import 'package:nc_photos/use_case/sync_dir.dart';
import 'package:nc_photos/use_case/update_property.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/lazy.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_string/to_string.dart';

part 'files_controller.g.dart';

abstract class FilesStreamEvent {
  /// All files as a ordered list
  List<FileDescriptor> get data;

  /// All files as a map with the fileId as key
  Map<int, FileDescriptor> get dataMap;
  bool get hasNext;
}

@genCopyWith
class FilesSummaryStreamEvent {
  const FilesSummaryStreamEvent({
    required this.summary,
  });

  final DbFilesSummary summary;
}

@genCopyWith
class TimelineStreamEvent {
  const TimelineStreamEvent({
    required this.data,
    required this.isDummy,
  });

  final Map<int, FileDescriptor> data;
  final bool isDummy;
}

@npLog
class FilesController {
  FilesController(
    this._c, {
    required this.account,
    required this.accountPrefController,
  }) {
    _subscriptions.add(accountPrefController.shareFolderChange.listen((event) {
      // sync remote if share folder is modified
      syncRemote();
    }));
  }

  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _dataStreamController.close();
  }

  /// Return a stream of files associated with [account]
  ///
  /// The returned stream will emit new list of files whenever there are
  /// changes to the files (e.g., new file, removed file, etc)
  ///
  /// There's no guarantee that the returned list is always sorted in some ways,
  /// callers must sort it by themselves if the ordering is important
  ValueStream<FilesStreamEvent> get stream => _dataStreamController.stream;

  Stream<ExceptionEvent> get errorStream => _dataErrorStreamController.stream;

  /// Return a stream of file summaries associated with [account]
  ///
  /// File summary contains the number of files grouped by their dates
  ValueStream<FilesSummaryStreamEvent> get summaryStream {
    if (!_isSummaryStreamInited) {
      _isSummaryStreamInited = true;
      _reloadSummary();
    }
    return _summaryStreamController.stream;
  }

  /// Return a stream of timeline files associated with [account]
  ///
  /// This stream is typically used for the photo timeline
  ValueStream<TimelineStreamEvent> get timelineStream =>
      _timelineStreamController.stream;

  Stream<ExceptionEvent> get timelineErrorStream =>
      _timelineErrorStreamController.stream;

  Future<void> syncRemote({
    void Function(Progress progress)? onProgressUpdate,
  }) async {
    if (_isSyncing) {
      _log.fine("[syncRemote] Skipped as another sync running");
      return;
    }
    _isSyncing = true;
    try {
      final shareDir = File(
        path: file_util.unstripPath(
            account, accountPrefController.shareFolderValue),
      );
      var isShareDirIncluded = false;

      _c.touchManager.clearTouchCache();
      final progress = IntProgress(account.roots.length);
      var hasChange = false;
      for (final r in account.roots) {
        final dirPath = file_util.unstripPath(account, r);
        hasChange |= await SyncDir(_c)(
          account,
          dirPath,
          onProgressUpdate: (value) {
            final merged = progress.progress + progress.step * value.progress;
            onProgressUpdate?.call(Progress(merged, value.text));
          },
        );
        isShareDirIncluded |=
            file_util.isOrUnderDirPath(shareDir.path, dirPath);
        progress.next();
      }

      if (!isShareDirIncluded) {
        _log.info("[syncRemote] Explicitly scanning share folder");
        hasChange |=
            await SyncDir(_c)(account, shareDir.path, isRecursive: false);
      }
      if (hasChange) {
        // load the synced content to stream
        unawaited(_reload());
      } else {
        _dataStreamController.addWithValue((value) => value.copyWith(
              hasNext: false,
            ));
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Update files property and return number of files updated
  Future<void> updateProperty(
    List<FileDescriptor> files, {
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? isFavorite,
    OrNull<ImageLocation>? location,
    Exception? Function(List<FileDescriptor> files) errorBuilder =
        UpdatePropertyFailureError.new,
  }) async {
    final dataBackups = <int, FileDescriptor>{};
    // file ids that need to be queried again to get the correct
    // FileDescriptor.fdDateTime
    final dataOutdated = <int>[];
    final timelineBackups = <int, FileDescriptor>{};
    final timelineOutdated = <int>[];
    var isSummaryOutdated = false;
    await _mutex.protect(() async {
      _dataStreamController.addWithValue((value) {
        final result = _mockUpdateProperty(
          src: _dataStreamController.value.files,
          files: files,
          isArchived: isArchived,
          overrideDateTime: overrideDateTime,
          isFavorite: isFavorite,
          location: location,
        );
        dataBackups.addAll(result.backup);
        dataOutdated.addAll(result.outdated);
        return value.copyWith(files: result.result);
      });
      if (overrideDateTime != null || isArchived != null) {
        _summaryStreamController.addWithValue((value) {
          final next = Map.of(value.summary.items);
          for (final f in files) {
            final key = f.fdDateTime.toLocal().toDate();
            final dstKey =
                overrideDateTime == null ? key : overrideDateTime.obj?.toDate();
            final original = next[key];
            if (original == null) {
              continue;
            }
            if (!f.fdIsArchived) {
              final nextCount = original.count - 1;
              if (nextCount == 0) {
                next.remove(key);
              } else {
                next[key] = original.copyWith(count: nextCount);
              }
            }
            if (dstKey != null) {
              if (isArchived?.obj == false ||
                  (!f.fdIsArchived && isArchived == null)) {
                /// file not archived or to be set false
                if (next.containsKey(dstKey)) {
                  next[dstKey] = const DbFilesSummaryItem(count: 1);
                } else {
                  next[dstKey] = original.copyWith(count: original.count + 1);
                }
              }
            } else {
              // unset, need to query again
              isSummaryOutdated = true;
            }
          }
          return value.copyWith(summary: value.summary.copyWith(items: next));
        });
      }
      _timelineStreamController.addWithValue((value) {
        final result = _mockUpdateProperty(
          src: _timelineStreamController.value.data,
          files: files,
          isArchived: isArchived,
          overrideDateTime: overrideDateTime,
          isFavorite: isFavorite,
          location: location,
        );
        timelineBackups.addAll(result.backup);
        timelineOutdated.addAll(result.outdated);
        return value.copyWith(data: result.result);
      });
    });

    final failures = <FileDescriptor>[];
    for (final f in files) {
      try {
        await UpdateProperty(fileRepo: _c.fileRepo2)(
          account,
          f,
          isArchived: isArchived,
          overrideDateTime: overrideDateTime,
          favorite: isFavorite,
          location: location,
        );
      } catch (e, stackTrace) {
        _log.severe(
            "[updateProperty] Failed while UpdateProperty: ${logFilename(f.fdPath)}",
            e,
            stackTrace);
        failures.add(f);
        dataOutdated.remove(f.fdId);
        timelineOutdated.remove(f.fdId);
      }
    }

    if (failures.isNotEmpty) {
      // restore
      _dataStreamController.addWithValue((value) {
        final next = Map.of(_dataStreamController.value.files);
        for (final f in failures) {
          if (dataBackups.containsKey(f.fdId)) {
            next[f.fdId] = dataBackups[f.fdId]!;
          }
        }
        return value.copyWith(files: next);
      });
      _timelineStreamController.addWithValue((value) {
        final next = Map.of(_timelineStreamController.value.data);
        for (final f in failures) {
          if (timelineBackups.containsKey(f.fdId)) {
            next[f.fdId] = timelineBackups[f.fdId]!;
          }
        }
        return value.copyWith(data: next);
      });
      errorBuilder(failures)
          ?.let((e) => _dataErrorStreamController.add(ExceptionEvent(e)));
    }

    // TODO query outdated
    if (isSummaryOutdated) {
      unawaited(_reloadSummary());
    }
  }

  Future<void> remove(
    List<FileDescriptor> files, {
    Exception? Function(List<FileDescriptor> files) errorBuilder =
        RemoveFailureError.new,
  }) async {
    final dataBackups = <int, FileDescriptor>{};
    final timelineBackups = <int, FileDescriptor>{};
    await _mutex.protect(() async {
      _dataStreamController.addWithValue((value) {
        final result = _mockRemove(
          src: _dataStreamController.value.files,
          files: files,
        );
        dataBackups.addAll(result.backup);
        return value.copyWith(files: result.result);
      });
      _summaryStreamController.addWithValue((value) {
        final next = Map.of(value.summary.items);
        for (final f in files) {
          final key = f.fdDateTime.toLocal().toDate();
          final original = next[key];
          if (original == null) {
            continue;
          }
          final count = original.count - 1;
          if (count == 0) {
            next.remove(key);
          } else {
            next[key] = original.copyWith(count: count);
          }
        }
        return value.copyWith(summary: value.summary.copyWith(items: next));
      });
      _timelineStreamController.addWithValue((value) {
        final result = _mockRemove(
          src: _timelineStreamController.value.data,
          files: files,
        );
        timelineBackups.addAll(result.backup);
        return value.copyWith(data: result.result);
      });
    });

    final failures = <FileDescriptor>[];
    try {
      await Remove(_c)(
        account,
        files,
        onError: (index, value, error, stackTrace) {
          _log.severe(
              "[remove] Failed while Remove: ${logFilename(value.fdPath)}",
              error,
              stackTrace);
          failures.add(value);
        },
      );
    } catch (e, stackTrace) {
      _log.severe("[remove] Failed while Remove", e, stackTrace);
      failures.addAll(files);
    }

    if (failures.isNotEmpty) {
      // restore
      _dataStreamController.addWithValue((value) {
        final next = Map.of(_dataStreamController.value.files);
        for (final f in failures) {
          if (dataBackups.containsKey(f.fdId)) {
            next[f.fdId] = dataBackups[f.fdId]!;
          }
        }
        return value.copyWith(files: next);
      });
      _summaryStreamController.addWithValue((value) {
        final next = Map.of(value.summary.items);
        for (final f in files) {
          final key = f.fdDateTime.toDate();
          final original = next[key];
          if (original == null) {
            next[key] = const DbFilesSummaryItem(count: 1);
          } else {
            next[key] = original.copyWith(count: original.count + 1);
          }
        }
        return value.copyWith(summary: value.summary.copyWith(items: next));
      });
      _timelineStreamController.addWithValue((value) {
        final next = Map.of(_timelineStreamController.value.data);
        for (final f in failures) {
          if (timelineBackups.containsKey(f.fdId)) {
            next[f.fdId] = timelineBackups[f.fdId]!;
          }
        }
        return value.copyWith(data: next);
      });
      errorBuilder(failures)
          ?.let((e) => _dataErrorStreamController.add(ExceptionEvent(e)));
    }
  }

  Future<void> applySyncResult({
    DbSyncIdResult? favorites,
    List<int>? fileExifs,
  }) async {
    if (favorites?.isNotEmpty != true && fileExifs?.isNotEmpty != true) {
      return;
    }

    // do async ops first
    final fileExifFiles =
        await fileExifs?.letFuture((e) async => await FindFileDescriptor(_c)(
              account,
              e,
              onFileNotFound: (id) {
                _log.warning("[applySyncResult] File id not found: $id");
              },
            ));

    final dataNext = Map.of(_dataStreamController.value.files);
    final timelineNext = Map.of(_dataStreamController.value.files);
    if (favorites != null && favorites.isNotEmpty) {
      _applySyncFavoriteResult(dataNext, favorites);
      _applySyncFavoriteResult(timelineNext, favorites);
    }
    if (fileExifFiles != null && fileExifFiles.isNotEmpty) {
      _applySyncFileExifResult(dataNext, fileExifFiles);
      _applySyncFileExifResult(timelineNext, fileExifFiles);
      unawaited(_reloadSummary());
    }
    _dataStreamController.addWithValue((v) => v.copyWith(files: dataNext));
    _timelineStreamController
        .addWithValue((v) => v.copyWith(data: timelineNext));
  }

  Future<void> queryByFileId(List<int> fileIds) async {
    try {
      final interests = fileIds
          .where((e) => !_dataStreamController.value.files.containsKey(e))
          .toList();
      if (interests.isEmpty) {
        return;
      }
      final files = await FindFileDescriptor(_c)(
        account,
        interests,
        onFileNotFound: (fileId) {
          _log.warning("[queryByFileId] File missing: $fileId");
        },
      );
      final data = _toFileMap(files);
      _dataStreamController.addWithValue((v) => v.copyWith(
            files: v.files.addedAll(data),
          ));
    } catch (e, stackTrace) {
      _dataErrorStreamController.add(ExceptionEvent(e, stackTrace));
    }
  }

  Future<void> queryByArchived() async {
    try {
      final files = await ListArchivedFile(_c)(
        account,
        file_util.unstripPath(account, accountPrefController.shareFolderValue),
      );
      final data = _toFileMap(files);
      _dataStreamController.addWithValue((v) => v.copyWith(
            files: v.files.addedAll(data),
          ));
    } catch (e, stackTrace) {
      _dataErrorStreamController.add(ExceptionEvent(e, stackTrace));
    }
  }

  Future<void> queryTimelineByDateRange(DateRange dateRange) async {
    try {
      final files = await ListFile(_c)(
        account,
        file_util.unstripPath(account, accountPrefController.shareFolderValue),
        timeRange: dateRange.toLocalTimeRange(),
      );
      final data = _toFileMap(files);
      _timelineStreamController.addWithValue((v) => v.copyWith(
            data: v.data.addedAll(data),
            isDummy: false,
          ));
      _dataStreamController.addWithValue((v) => v.copyWith(
            files: v.files.addedAll(data),
          ));
      _addTimelineDateRange(dateRange);
    } catch (e, stackTrace) {
      _timelineErrorStreamController.add(ExceptionEvent(e, stackTrace));
    }
  }

  void _applySyncFavoriteResult(
      Map<int, FileDescriptor> next, DbSyncIdResult result) {
    for (final id in result.insert) {
      final f = next[id];
      if (f == null) {
        continue;
      }
      if (f is File) {
        next[id] = f.copyWith(isFavorite: true);
      } else {
        next[id] = f.copyWith(fdIsFavorite: true);
      }
    }
    for (final id in result.delete) {
      final f = next[id];
      if (f == null) {
        continue;
      }
      if (f is File) {
        next[id] = f.copyWith(isFavorite: false);
      } else {
        next[id] = f.copyWith(fdIsFavorite: false);
      }
    }
  }

  void _applySyncFileExifResult(
      Map<int, FileDescriptor> next, List<FileDescriptor> results) {
    for (final f in results) {
      next[f.fdId] = f;
    }
  }

  Future<void> _reload() async {
    // Take the ids of loaded files
    final ids = _dataStreamController.value.data.map((e) => e.fdId).toList();
    final newFiles = await FindFileDescriptor(_c)(
      account,
      ids,
      onFileNotFound: (_) {
        // file removed, can be ignored
      },
    );
    _dataStreamController.add(_FilesStreamEvent(
      files: _toFileMap(newFiles),
      hasNext: false,
    ));
    final diff = await _reloadSummary();
    final dropDates = [
      ...diff.onlyInThis.keys,
      ...diff.onlyInOther.keys,
      ...diff.updated.keys,
    ];
    if (dropDates.isNotEmpty) {
      _timelineStreamController.addWithValue((value) {
        final next = <int, FileDescriptor>{};
        for (final e in value.data.entries) {
          if (!dropDates.contains(e.value.fdDateTime.toLocal().toDate())) {
            next[e.key] = e.value;
          }
        }
        return value.copyWith(data: next);
      });
    }
  }

  Map<int, FileDescriptor> _toFileMap(List<FileDescriptor> results) {
    return {
      for (final f in results) f.fdId: f,
    };
  }

  Future<DbFilesSummaryDiff> _reloadSummary() async {
    final original = _summaryStreamController.valueOrNull?.summary ??
        const DbFilesSummary(items: {});
    final results = await _c.npDb.getFilesSummary(
      account: account.toDb(),
      includeRelativeRoots: account.roots
          .map((e) => File(path: file_util.unstripPath(account, e))
              .strippedPathWithEmpty)
          .toList(),
      includeRelativeDirs: [accountPrefController.shareFolderValue],
      excludeRelativeRoots: [remote_storage_util.remoteStorageDirRelativePath],
      mimes: file_util.supportedFormatMimes,
    );
    final diff = original.diff(results);
    _summaryStreamController.add(FilesSummaryStreamEvent(summary: results));
    return diff;
  }

  _MockResult _mockRemove({
    required Map<int, FileDescriptor> src,
    required List<FileDescriptor> files,
  }) {
    final backups = <int, FileDescriptor>{};
    final next = Map.of(src);
    for (final f in files) {
      final original = next.remove(f.fdId);
      if (original == null) {
        continue;
      }
      backups[f.fdId] = original;
    }
    return _MockResult(result: next, backup: backups);
  }

  _MockResult _mockUpdateProperty({
    required Map<int, FileDescriptor> src,
    required List<FileDescriptor> files,
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? isFavorite,
    OrNull<ImageLocation>? location,
  }) {
    final backups = <int, FileDescriptor>{};
    final outdated = <int>[];
    final next = Map.of(src);
    for (final f in files) {
      final original = next[f.fdId];
      if (original == null) {
        continue;
      }
      backups[f.fdId] = original;
      if (original is File) {
        next[f.fdId] = original.copyWith(
          metadata: metadata,
          isArchived: isArchived,
          overrideDateTime: overrideDateTime,
          isFavorite: isFavorite,
          location: location,
        );
      } else {
        next[f.fdId] = original.copyWith(
          fdIsArchived: isArchived == null ? null : (isArchived.obj ?? false),
          // in case of unsetting, we can't work out the new value here
          fdDateTime: overrideDateTime?.obj,
          fdIsFavorite: isFavorite,
        );
        if (OrNull.isSetNull(overrideDateTime)) {
          outdated.add(f.fdId);
        }
      }
    }
    return _MockResult(result: next, backup: backups, outdated: outdated);
  }

  void _addTimelineDateRange(DateRange dateRange) {
    // merge and sort the ranges
    final sorted = List.of(_timelineQueriedRanges)
      ..add(dateRange)
      ..sort((a, b) => b.to!.compareTo(a.to!));
    final results = <DateRange>[];
    for (final d in sorted) {
      if (results.isEmpty) {
        results.add(d);
        continue;
      }
      if (d.isOverlapped(results.last)) {
        results[results.length - 1] = results.last.union(d);
      } else {
        results.add(d);
      }
    }
    _timelineQueriedRanges = results;
  }

  final DiContainer _c;
  final Account account;
  final AccountPrefController accountPrefController;

  final _dataStreamController = BehaviorSubject.seeded(
    _FilesStreamEvent(
      files: const {},
      hasNext: true,
    ),
  );
  final _dataErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  var _isSummaryStreamInited = false;
  final _summaryStreamController = BehaviorSubject<FilesSummaryStreamEvent>();

  final _timelineStreamController = BehaviorSubject.seeded(
    const TimelineStreamEvent(data: {}, isDummy: true),
  );
  final _timelineErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();
  // sorted in descending order
  var _timelineQueriedRanges = <DateRange>[];

  final _mutex = Mutex();
  var _isSyncing = false;
  final _subscriptions = <StreamSubscription>[];
}

@toString
class UpdatePropertyFailureError implements Exception {
  const UpdatePropertyFailureError(this.files);

  @override
  String toString() => _$toString();

  final List<FileDescriptor> files;
}

@toString
class RemoveFailureError implements Exception {
  const RemoveFailureError(this.files);

  @override
  String toString() => _$toString();

  final List<FileDescriptor> files;
}

class _MockResult {
  const _MockResult({
    required this.result,
    required this.backup,
    this.outdated = const [],
  });

  final Map<int, FileDescriptor> result;
  final Map<int, FileDescriptor> backup;
  final List<int> outdated;
}

class _FilesStreamEvent implements FilesStreamEvent {
  _FilesStreamEvent({
    required this.files,
    Lazy<List<FileDescriptor>>? dataLazy,
    required this.hasNext,
  }) {
    this.dataLazy = dataLazy ?? (Lazy(() => files.values.toList()));
  }

  _FilesStreamEvent copyWith({
    Map<int, FileDescriptor>? files,
    bool? hasNext,
  }) {
    return _FilesStreamEvent(
      files: files ?? this.files,
      dataLazy: (files == null) ? dataLazy : null,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  List<FileDescriptor> get data => dataLazy();
  @override
  Map<int, FileDescriptor> get dataMap => files;

  final Map<int, FileDescriptor> files;
  late final Lazy<List<FileDescriptor>> dataLazy;

  /// If true, the results are intermediate values and may not represent the
  /// latest state
  @override
  final bool hasNext;
}
