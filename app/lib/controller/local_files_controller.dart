import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/rx_extension.dart';
import 'package:nc_photos/use_case/local_file/find_local_file.dart';
import 'package:nc_photos/use_case/local_file/list_local_file.dart';
import 'package:nc_photos/use_case/local_file/trash_local_file.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/lazy.dart';
import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_string/to_string.dart';

part 'local_files_controller.g.dart';
part 'local_files_controller/util.dart';

abstract class LocalFilesStreamEvent {
  /// All files as a ordered list
  List<LocalFile> get data;

  /// All files as a map with the id as key
  Map<String, LocalFile> get dataMap;
}

@genCopyWith
class LocalTimelineStreamEvent {
  const LocalTimelineStreamEvent({required this.data});

  /// All files as a map with the id as key
  final Map<String, LocalFile> data;
}

class LocalFilesSummary {
  const LocalFilesSummary({required this.items});

  final Map<Date, int> items;
}

@genCopyWith
class LocalFilesSummaryStreamEvent {
  const LocalFilesSummaryStreamEvent({required this.summary});

  final LocalFilesSummary summary;
}

@toString
class TrashLocalFileFailureError implements Exception {
  const TrashLocalFileFailureError(this.files);

  @override
  String toString() => _$toString();

  final List<LocalFile> files;
}

abstract interface class LocalFilesController {
  void dispose() {}

  /// Return a stream of local files
  ValueStream<LocalFilesStreamEvent> get stream;

  Stream<ExceptionEvent> get errorStream;

  /// Return a stream of local files for timeline
  ///
  /// This stream is typically used for the photo timeline
  ValueStream<LocalTimelineStreamEvent> get timelineStream;

  Stream<ExceptionEvent> get timelineErrorStream;

  /// Return a stream of local file summaries
  ///
  /// File summary contains the number of local files grouped by their dates
  ValueStream<LocalFilesSummaryStreamEvent> get summaryStream2;

  Stream<ExceptionEvent> get summaryErrorStream;

  Future<void> queryByFileId(List<String> fileIds);

  Future<void> queryTimelineByDateRange(DateRange dateRange);

  /// Move files to trash
  Future<void> trash(
    List<LocalFile> files, {
    Exception? Function(List<LocalFile> files)? errorBuilder,
  });
}

@npLog
class LocalFilesControllerImpl implements LocalFilesController {
  LocalFilesControllerImpl(this._c);

  @override
  void dispose() {
    _fileChangeListener?.cancel();
  }

  @override
  ValueStream<LocalFilesStreamEvent> get stream => _dataStreamController.stream;

  @override
  Stream<ExceptionEvent> get errorStream => _dataErrorStreamController.stream;

  @override
  ValueStream<LocalTimelineStreamEvent> get timelineStream =>
      _timelineStreamController.stream;

  @override
  Stream<ExceptionEvent> get timelineErrorStream =>
      _timelineErrorStreamController.stream;

  @override
  ValueStream<LocalFilesSummaryStreamEvent> get summaryStream2 {
    if (!_isSummaryStreamInited) {
      _isSummaryStreamInited = true;
      _reloadSummary();
      _initObserver();
    }
    return _summaryStreamController.stream;
  }

  @override
  Stream<ExceptionEvent> get summaryErrorStream =>
      _summaryErrorStreamController.stream;

  @override
  Future<void> queryByFileId(List<String> fileIds) async {
    try {
      final interests =
          fileIds
              .where((e) => !_dataStreamController.value.files.containsKey(e))
              .toList();
      if (interests.isEmpty) {
        return;
      }
      final files = await FindLocalFile(_c)(
        interests,
        onFileNotFound: (fileId) {
          _log.warning("[queryByFileId] File missing: $fileId");
        },
      );
      final data = _toFileMap(files);
      _dataStreamController.addWithValue(
        (v) => v.copyWith(files: v.files.addedAll(data)),
      );
    } catch (e, stackTrace) {
      _dataErrorStreamController.add(ExceptionEvent(e, stackTrace));
    }
  }

  @override
  Future<void> queryTimelineByDateRange(DateRange dateRange) async {
    try {
      final files = await ListLocalFile(_c.localFileRepo)(
        timeRange: dateRange.toLocalTimeRange(),
      );
      final data = _toFileMap(files);
      _timelineStreamController.addWithValue(
        (v) => v.copyWith(data: v.data.addedAll(data)),
      );
      _dataStreamController.addWithValue(
        (v) => v.copyWith(files: v.files.addedAll(data)),
      );
      _addTimelineDateRange(dateRange);
    } catch (e, stackTrace) {
      _log.severe(
        "[queryTimelineByDateRange] Uncaught exception",
        e,
        stackTrace,
      );
      _timelineErrorStreamController.add(ExceptionEvent(e, stackTrace));
    }
  }

  @override
  Future<void> trash(
    List<LocalFile> files, {
    Exception? Function(List<LocalFile> files)? errorBuilder,
  }) async {
    final failures = <LocalFile>[];
    try {
      await TrashLocalFile(_c)(
        files,
        onFailure: (file, error, stackTrace) {
          _log.severe(
            "[trash] Failed while TrashLocalFile: ${logFilename(file.filename)}",
            error,
            stackTrace,
          );
          failures.add(file);
        },
      );
    } catch (e, stackTrace) {
      _log.severe("[trash] Failed while TrashLocalFile", e, stackTrace);
      _dataErrorStreamController.add(ExceptionEvent(e, stackTrace));
      failures.addAll(files);
    }

    final oks =
        files.where((f) => failures.none((e) => e.compareIdentity(f))).toList();
    await _mutex.protect(() async {
      _dataStreamController.addWithValue((value) {
        final result = _mockRemove(
          src: _dataStreamController.value.files,
          files: oks,
        );
        return value.copyWith(files: result);
      });
      _summaryStreamController.addWithValue((value) {
        final next = Map.of(value.summary.items);
        for (final f in oks) {
          final key = f.bestDateTime.toLocal().toDate();
          final original = next[key];
          if (original == null) {
            continue;
          }
          final count = original - 1;
          if (count == 0) {
            next.remove(key);
          } else {
            next[key] = count;
          }
        }
        return value.copyWith(summary: LocalFilesSummary(items: next));
      });
      _timelineStreamController.addWithValue((value) {
        final result = _mockRemove(
          src: _timelineStreamController.value.data,
          files: oks,
        );
        return value.copyWith(data: result);
      });
    });
    if (failures.isNotEmpty) {
      (errorBuilder ?? LocalFileRemoveFailureError.new)
          .call(failures)
          ?.let((e) => _dataErrorStreamController.add(ExceptionEvent(e)));
    }
  }

  Future<_LocalFilesSummaryDiff> _reloadSummary() async {
    final original =
        _summaryStreamController.valueOrNull?.summary ??
        const LocalFilesSummary(items: {});
    final results = await _c.localFileRepo.getFilesSummary();
    final diff = original.diff(results);
    _summaryStreamController.add(
      LocalFilesSummaryStreamEvent(summary: results),
    );
    return diff;
  }

  void _initObserver() {
    _fileChangeListener?.cancel();
    _fileChangeListener = _c.localFileRepo
        .watchFileChanges()
        .debounceTime(const Duration(seconds: 2))
        .listen((_) {
          _reload();
        });
  }

  Future<void> _reload() async {
    _log.info("[_reload] File changed, refreshing");
    // Take the ids of loaded files
    final ids = _dataStreamController.value.data.map((e) => e.id).toList();
    final newFiles = await FindLocalFile(_c)(
      ids,
      onFileNotFound: (_) {
        // file removed, can be ignored
      },
    );
    _dataStreamController.add(
      _LocalFilesStreamEvent(files: _toFileMap(newFiles)),
    );
    final diff = await _reloadSummary();
    final dropDates = [
      ...diff.onlyInThis.keys,
      ...diff.onlyInOther.keys,
      ...diff.updated.keys,
    ];
    if (dropDates.isNotEmpty) {
      _timelineStreamController.addWithValue((value) {
        final next = <String, LocalFile>{};
        for (final e in value.data.entries) {
          if (!dropDates.contains(e.value.bestDateTime.toLocal().toDate())) {
            next[e.key] = e.value;
          }
        }
        return value.copyWith(data: next);
      });
    }
  }

  Map<String, LocalFile> _toFileMap(List<LocalFile> results) {
    return {for (final f in results) f.id: f};
  }

  void _addTimelineDateRange(DateRange dateRange) {
    // merge and sort the ranges
    final sorted =
        List.of(_timelineQueriedRanges)
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

  Map<String, LocalFile> _mockRemove({
    required Map<String, LocalFile> src,
    required List<LocalFile> files,
  }) {
    final next = Map.of(src);
    for (final f in files) {
      next.remove(f.id);
    }
    return next;
  }

  final DiContainer _c;

  final _dataStreamController = BehaviorSubject.seeded(
    _LocalFilesStreamEvent(files: {}),
  );
  final _dataErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  final _timelineStreamController = BehaviorSubject.seeded(
    const LocalTimelineStreamEvent(data: {}),
  );
  final _timelineErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();
  // sorted in descending order
  var _timelineQueriedRanges = <DateRange>[];

  var _isSummaryStreamInited = false;
  final _summaryStreamController =
      BehaviorSubject<LocalFilesSummaryStreamEvent>();
  final _summaryErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  StreamSubscription? _fileChangeListener;

  final _mutex = Mutex();
}

class DummyLocalFilesController implements LocalFilesController {
  @override
  void dispose() {}

  @override
  Future<void> queryByFileId(List<String> fileIds) async {}

  @override
  Future<void> queryTimelineByDateRange(DateRange dateRange) async {}

  @override
  Future<void> trash(
    List<LocalFile> files, {
    Exception? Function(List<LocalFile> files)? errorBuilder,
  }) async {}

  @override
  ValueStream<LocalFilesStreamEvent> get stream => _dataStreamController.stream;

  @override
  Stream<ExceptionEvent> get errorStream => const Stream.empty();

  @override
  Stream<ExceptionEvent> get summaryErrorStream => const Stream.empty();

  @override
  ValueStream<LocalFilesSummaryStreamEvent> get summaryStream2 =>
      _summaryStreamController.stream;

  @override
  Stream<ExceptionEvent> get timelineErrorStream => const Stream.empty();

  @override
  ValueStream<LocalTimelineStreamEvent> get timelineStream =>
      _timelineStreamController.stream;

  final _dataStreamController = BehaviorSubject.seeded(
    _LocalFilesStreamEvent(files: {}),
  );
  final _timelineStreamController = BehaviorSubject.seeded(
    const LocalTimelineStreamEvent(data: {}),
  );
  final _summaryStreamController =
      BehaviorSubject<LocalFilesSummaryStreamEvent>();
}

class _LocalFilesStreamEvent implements LocalFilesStreamEvent {
  _LocalFilesStreamEvent({required this.files, Lazy<List<LocalFile>>? dataLazy})
    : dataLazy = dataLazy ?? (Lazy(() => files.values.toList()));

  _LocalFilesStreamEvent copyWith({Map<String, LocalFile>? files}) {
    return _LocalFilesStreamEvent(
      files: files ?? this.files,
      dataLazy: (files == null) ? dataLazy : null,
    );
  }

  @override
  List<LocalFile> get data => dataLazy();
  @override
  Map<String, LocalFile> get dataMap => files;

  final Map<String, LocalFile> files;
  late final Lazy<List<LocalFile>> dataLazy;
}

@toString
class LocalFileRemoveFailureError implements Exception {
  const LocalFileRemoveFailureError(this.files);

  @override
  String toString() => _$toString();

  final List<LocalFile> files;
}
