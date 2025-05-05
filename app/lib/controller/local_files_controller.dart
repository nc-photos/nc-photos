import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/rx_extension.dart';
import 'package:nc_photos/use_case/local_file/list_local_file.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'local_files_controller.g.dart';

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

@npLog
class LocalFilesController {
  LocalFilesController(this._c);

  void dispose() {}

  /// Return a stream of local files for timeline
  ///
  /// This stream is typically used for the photo timeline
  ValueStream<LocalTimelineStreamEvent> get timelineStream =>
      _timelineStreamController.stream;

  Stream<ExceptionEvent> get timelineErrorStream =>
      _timelineErrorStreamController.stream;

  /// Return a stream of local file summaries
  ///
  /// File summary contains the number of local files grouped by their dates
  ValueStream<LocalFilesSummaryStreamEvent> get summaryStream2 {
    if (!_isSummaryStreamInited) {
      _isSummaryStreamInited = true;
      _initSummary();
    }
    return _summaryStreamController.stream;
  }

  Stream<ExceptionEvent> get summaryErrorStream =>
      _summaryErrorStreamController.stream;

  Future<void> queryTimelineByDateRange(DateRange dateRange) async {
    try {
      final files = await ListLocalFile(_c)(
        timeRange: dateRange.toLocalTimeRange(),
      );
      final data = _toFileMap(files);
      _timelineStreamController.addWithValue(
        (v) => v.copyWith(data: v.data.addedAll(data)),
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

  Future<void> _initSummary() async {
    final results = await _c.localFileRepo.getFilesSummary();
    _summaryStreamController.add(
      LocalFilesSummaryStreamEvent(summary: results),
    );
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

  final DiContainer _c;

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
}
