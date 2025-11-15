import 'dart:async';
import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_string/to_string.dart';

part 'any_files_controller.g.dart';

class AnyFilesStreamEvent {
  const AnyFilesStreamEvent({
    required this.data,
    required this.mergedCounts,
    required this.hasRemoteNext,
  });

  /// All files as a map with the id as key
  final Map<String, AnyFile> data;
  final Map<Date, int> mergedCounts;
  final bool hasRemoteNext;
}

@genCopyWith
class AnyFilesTimelineStreamEvent {
  const AnyFilesTimelineStreamEvent({
    required this.data,
    required this.mergedCounts,
    required this.isRemoteDummy,
  });

  /// All files as a map with the id as key
  final Map<String, AnyFile> data;
  final Map<Date, int> mergedCounts;
  final bool isRemoteDummy;
}

class AnyFilesSummary with EquatableMixin {
  const AnyFilesSummary({required this.items});

  @override
  List<Object?> get props => [items];

  final Map<Date, int> items;
}

@genCopyWith
class AnyFilesSummaryStreamEvent {
  const AnyFilesSummaryStreamEvent({
    required this.summary,
    required this.hasRemoteData,
  });

  final AnyFilesSummary summary;
  final bool? hasRemoteData;
}

@npLog
class AnyFilesController {
  AnyFilesController({
    required this.filesController,
    required this.localFilesController,
  }) {
    _subscriptions.add(
      filesController.errorStream.listen(_dataErrorStreamController.add),
    );
    _subscriptions.add(
      localFilesController.errorStream.listen(_dataErrorStreamController.add),
    );
    _subscriptions.add(
      filesController.timelineErrorStream.listen(
        _timelineErrorStreamController.add,
      ),
    );
    _subscriptions.add(
      localFilesController.timelineErrorStream.listen(
        _timelineErrorStreamController.add,
      ),
    );
    // _subscriptions.add(
    //   filesController.summaryErrorStream.listen(
    //     _summaryErrorStreamController.add,
    //   ),
    // );
    _subscriptions.add(
      localFilesController.summaryErrorStream.listen(
        _summaryErrorStreamController.add,
      ),
    );
  }

  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    _isDataStreamInited = false;
    _isTimelineStreamInited = false;
  }

  ValueStream<AnyFilesStreamEvent> get stream {
    if (!_isDataStreamInited) {
      _isDataStreamInited = true;
      _subscriptions.add(
        filesController.stream.listen((_) {
          _mergeFiles();
        }),
      );
      _subscriptions.add(
        localFilesController.stream.listen((_) {
          _mergeFiles();
        }),
      );
    }
    return _dataStreamController.stream;
  }

  Stream<ExceptionEvent> get errorStream => _dataErrorStreamController.stream;

  ValueStream<AnyFilesTimelineStreamEvent> get timelineStream {
    if (!_isTimelineStreamInited) {
      _isTimelineStreamInited = true;
      _subscriptions.add(
        filesController.timelineStream.listen((_) {
          _mergeTimeline();
        }),
      );
      _subscriptions.add(
        localFilesController.timelineStream.listen((_) {
          _mergeTimeline();
        }),
      );
    }
    return _timelineStreamController.stream;
  }

  Stream<ExceptionEvent> get timelineErrorStream =>
      _timelineErrorStreamController.stream;

  /// Return a stream of AnyFile summaries
  ///
  /// File summary contains the number of files grouped by their dates
  ValueStream<AnyFilesSummaryStreamEvent> get summaryStream2 {
    if (!_isSummaryStreamInited) {
      _isSummaryStreamInited = true;
      _subscriptions.add(
        filesController.summaryStream.listen((_) {
          _mergeSummary();
        }),
      );
      _subscriptions.add(
        localFilesController.summaryStream2.listen((_) {
          _mergeSummary();
        }),
      );
    }
    return _summaryStreamController.stream;
  }

  Stream<ExceptionEvent> get summaryErrorStream =>
      _summaryErrorStreamController.stream;

  Future<void> queryByAfId(Iterable<String> afIds) {
    return handleAnyFileIdByType(
      afIds,
      nextcloudHandler:
          (ids) =>
              filesController.queryByFileId(ids.map((e) => e.fileId).toList()),
      localHandler:
          (ids) => localFilesController.queryByFileId(
            ids.map((e) => e.fileId).toList(),
          ),
      mergedHandler:
          (ids) => Future.wait([
            filesController.queryByFileId(
              ids.map((e) => e.remoteFileId).toList(),
            ),
            localFilesController.queryByFileId(
              ids.map((e) => e.localFileId).toList(),
            ),
          ]),
    );
  }

  Future<void> queryTimelineByDateRange(DateRange dateRange) {
    return Future.wait([
      filesController.queryTimelineByDateRange(dateRange),
      localFilesController.queryTimelineByDateRange(dateRange),
    ]);
  }

  Future<void> remove(
    List<AnyFile> files, {
    AnyFileRemoveHint hint = AnyFileRemoveHint.both,
    Exception? Function(List<AnyFile> files)? errorBuilder,
  }) async {
    final groups = groupBy(
      files,
      (e) => switch (e.provider) {
        AnyFileNextcloudProvider _ => AnyFileProviderType.nextcloud,
        AnyFileLocalProvider _ => AnyFileProviderType.local,
        AnyFileMergedProvider _ => AnyFileProviderType.merged,
      },
    );
    final shouldRemoveRemoteMerged =
        hint == AnyFileRemoveHint.remote || hint == AnyFileRemoveHint.both;
    final shouldRemoveLocalMerged =
        hint == AnyFileRemoveHint.local || hint == AnyFileRemoveHint.both;
    final failures = <AnyFile>[];
    await Future.wait([
      if (groups[AnyFileProviderType.nextcloud]?.isNotEmpty == true ||
          (shouldRemoveRemoteMerged &&
              groups[AnyFileProviderType.merged]?.isNotEmpty == true))
        filesController.remove(
          [
            ...?groups[AnyFileProviderType.nextcloud]?.map(
              (e) => (e.provider as AnyFileNextcloudProvider).file,
            ),
            if (shouldRemoveRemoteMerged)
              ...?groups[AnyFileProviderType.merged]?.map(
                (e) => (e.provider as AnyFileMergedProvider).remote.file,
              ),
          ],
          errorBuilder:
              errorBuilder == null
                  ? null
                  : (files) {
                    failures.addAll(files.map((e) => e.toAnyFile()));
                    return null;
                  },
        ),
      if (groups[AnyFileProviderType.local]?.isNotEmpty == true ||
          (shouldRemoveLocalMerged &&
              groups[AnyFileProviderType.merged]?.isNotEmpty == true))
        localFilesController.trash(
          [
            ...?groups[AnyFileProviderType.local]?.map(
              (e) => (e.provider as AnyFileLocalProvider).file,
            ),
            if (shouldRemoveLocalMerged)
              ...?groups[AnyFileProviderType.merged]?.map(
                (e) => (e.provider as AnyFileMergedProvider).local.file,
              ),
          ],
          errorBuilder:
              errorBuilder == null
                  ? null
                  : (files) {
                    failures.addAll(files.map((e) => e.toAnyFile()));
                    return null;
                  },
        ),
    ]);
    if (failures.isNotEmpty) {
      (errorBuilder ?? AnyFileRemoveFailureError.new)
          .call(failures)
          ?.let((e) => _dataErrorStreamController.add(ExceptionEvent(e)));
    }
  }

  Future<void> archive(List<AnyFile> files, {required bool isArchived}) async {
    final groups = groupBy(
      files,
      (e) => switch (e.provider) {
        AnyFileNextcloudProvider _ => AnyFileProviderType.nextcloud,
        AnyFileLocalProvider _ => AnyFileProviderType.local,
        AnyFileMergedProvider _ => AnyFileProviderType.merged,
      },
    );
    if (groups[AnyFileProviderType.nextcloud]?.isNotEmpty == true ||
        groups[AnyFileProviderType.merged]?.isNotEmpty == true) {
      await filesController.updateProperty(
        [
          ...?groups[AnyFileProviderType.nextcloud]?.map(
            (e) => (e.provider as AnyFileNextcloudProvider).file,
          ),
          ...?groups[AnyFileProviderType.merged]?.map(
            (e) => (e.provider as AnyFileMergedProvider).remote.file,
          ),
        ],
        isArchived: OrNull(isArchived),
        errorBuilder: (fileIds) => AnyFileArchiveFailedError(fileIds.length),
      );
    }
  }

  Future<void> _mergeFiles() async {
    final remote = filesController.stream.value;
    final local = localFilesController.stream.value;
    final result = await Isolate.run(() {
      final remoteFiles = remote.dataMap.values.map((e) => e.toAnyFile());
      final localFiles = local.dataMap.values.map((e) => e.toAnyFile());
      return _merge(remoteFiles, localFiles);
    });
    _dataStreamController.add(
      AnyFilesStreamEvent(
        data: result.merged,
        mergedCounts: result.mergedCounts,
        hasRemoteNext: remote.hasNext,
      ),
    );
  }

  Future<void> _mergeTimeline() async {
    final remote = filesController.timelineStream.value;
    final local = localFilesController.timelineStream.value;
    final result = await Isolate.run(() {
      final remoteFiles = remote.data.values.map((e) => e.toAnyFile());
      final localFiles = local.data.values.map((e) => e.toAnyFile());
      return _merge(remoteFiles, localFiles);
    });
    _timelineStreamController.add(
      AnyFilesTimelineStreamEvent(
        data: result.merged,
        mergedCounts: result.mergedCounts,
        isRemoteDummy: remote.isDummy,
      ),
    );
  }

  void _mergeSummary() {
    final remote = filesController.summaryStream.valueOrNull;
    final local = localFilesController.summaryStream2.valueOrNull;
    final result =
        remote?.summary.items.map((k, v) => MapEntry(k, v.count)) ?? const {};
    for (final e in local?.summary.items.entries ?? <MapEntry<Date, int>>[]) {
      result[e.key] = (result[e.key] ?? 0) + e.value;
    }
    _summaryStreamController.add(
      AnyFilesSummaryStreamEvent(
        summary: AnyFilesSummary(items: result),
        hasRemoteData: remote?.summary.items.isNotEmpty,
      ),
    );
  }

  static ({Map<String, AnyFile> merged, Map<Date, int> mergedCounts}) _merge(
    Iterable<AnyFile> a,
    Iterable<AnyFile> b,
  ) {
    final sorted = [...a, ...b]..sort(anyFileMergeSorter);
    final merged = <AnyFile>[];
    final mergedCounts = <Date, int>{};
    for (final e in sorted) {
      if (merged.isEmpty) {
        merged.add(e);
        continue;
      }
      if (isAnyFileMergeable(merged.last, e)) {
        // merge
        final replace = merged.removeLast();
        final remote =
            replace.provider is AnyFileNextcloudProvider ? replace : e;
        final local = replace.provider is AnyFileLocalProvider ? replace : e;
        merged.add(
          AnyFile(
            provider: AnyFileMergedProvider(
              remote: remote.provider.cast(),
              local: local.provider.cast(),
            ),
          ),
        );
        final goneDate = local.dateTime.toLocal().toDate();
        mergedCounts[goneDate] = (mergedCounts[goneDate] ?? 0) + 1;
      } else {
        merged.add(e);
      }
    }
    return (
      merged: merged.map((e) => MapEntry(e.id, e)).toMap(),
      mergedCounts: mergedCounts,
    );
  }

  final FilesController filesController;
  final LocalFilesController localFilesController;

  var _isDataStreamInited = false;
  final _dataStreamController = BehaviorSubject.seeded(
    const AnyFilesStreamEvent(data: {}, mergedCounts: {}, hasRemoteNext: true),
  );
  final _dataErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  var _isTimelineStreamInited = false;
  final _timelineStreamController = BehaviorSubject.seeded(
    const AnyFilesTimelineStreamEvent(
      data: {},
      mergedCounts: {},
      isRemoteDummy: true,
    ),
  );
  final _timelineErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  var _isSummaryStreamInited = false;
  final _summaryStreamController =
      BehaviorSubject<AnyFilesSummaryStreamEvent>();
  final _summaryErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  final _subscriptions = <StreamSubscription>[];
}

enum AnyFileRemoveHint { remote, local, both }

@toString
class AnyFileRemoveFailureError implements Exception {
  const AnyFileRemoveFailureError(this.files);

  @override
  String toString() => _$toString();

  final List<AnyFile> files;
}

@toString
class AnyFileArchiveFailedError implements Exception {
  const AnyFileArchiveFailedError(this.count);

  @override
  String toString() => _$toString();

  final int count;
}
