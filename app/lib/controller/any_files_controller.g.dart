// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'any_files_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $AnyFilesTimelineStreamEventCopyWithWorker {
  AnyFilesTimelineStreamEvent call({
    Map<String, AnyFile>? data,
    Map<Date, int>? mergedCounts,
    bool? isRemoteDummy,
  });
}

class _$AnyFilesTimelineStreamEventCopyWithWorkerImpl
    implements $AnyFilesTimelineStreamEventCopyWithWorker {
  _$AnyFilesTimelineStreamEventCopyWithWorkerImpl(this.that);

  @override
  AnyFilesTimelineStreamEvent call({
    dynamic data,
    dynamic mergedCounts,
    dynamic isRemoteDummy,
  }) {
    return AnyFilesTimelineStreamEvent(
      data: data as Map<String, AnyFile>? ?? that.data,
      mergedCounts: mergedCounts as Map<Date, int>? ?? that.mergedCounts,
      isRemoteDummy: isRemoteDummy as bool? ?? that.isRemoteDummy,
    );
  }

  final AnyFilesTimelineStreamEvent that;
}

extension $AnyFilesTimelineStreamEventCopyWith on AnyFilesTimelineStreamEvent {
  $AnyFilesTimelineStreamEventCopyWithWorker get copyWith => _$copyWith;
  $AnyFilesTimelineStreamEventCopyWithWorker get _$copyWith =>
      _$AnyFilesTimelineStreamEventCopyWithWorkerImpl(this);
}

abstract class $AnyFilesSummaryStreamEventCopyWithWorker {
  AnyFilesSummaryStreamEvent call({
    AnyFilesSummary? summary,
    bool? hasRemoteData,
  });
}

class _$AnyFilesSummaryStreamEventCopyWithWorkerImpl
    implements $AnyFilesSummaryStreamEventCopyWithWorker {
  _$AnyFilesSummaryStreamEventCopyWithWorkerImpl(this.that);

  @override
  AnyFilesSummaryStreamEvent call({dynamic summary, dynamic hasRemoteData}) {
    return AnyFilesSummaryStreamEvent(
      summary: summary as AnyFilesSummary? ?? that.summary,
      hasRemoteData: hasRemoteData as bool? ?? that.hasRemoteData,
    );
  }

  final AnyFilesSummaryStreamEvent that;
}

extension $AnyFilesSummaryStreamEventCopyWith on AnyFilesSummaryStreamEvent {
  $AnyFilesSummaryStreamEventCopyWithWorker get copyWith => _$copyWith;
  $AnyFilesSummaryStreamEventCopyWithWorker get _$copyWith =>
      _$AnyFilesSummaryStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$AnyFilesControllerNpLog on AnyFilesController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "controller.any_files_controller.AnyFilesController",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$AnyFileRemoveFailureErrorToString on AnyFileRemoveFailureError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "AnyFileRemoveFailureError {files: [length: ${files.length}]}";
  }
}

extension _$AnyFileArchiveFailedErrorToString on AnyFileArchiveFailedError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "AnyFileArchiveFailedError {count: $count}";
  }
}
