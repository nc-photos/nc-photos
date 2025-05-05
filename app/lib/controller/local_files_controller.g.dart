// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_files_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $LocalTimelineStreamEventCopyWithWorker {
  LocalTimelineStreamEvent call({Map<String, LocalFile>? data});
}

class _$LocalTimelineStreamEventCopyWithWorkerImpl
    implements $LocalTimelineStreamEventCopyWithWorker {
  _$LocalTimelineStreamEventCopyWithWorkerImpl(this.that);

  @override
  LocalTimelineStreamEvent call({dynamic data}) {
    return LocalTimelineStreamEvent(
      data: data as Map<String, LocalFile>? ?? that.data,
    );
  }

  final LocalTimelineStreamEvent that;
}

extension $LocalTimelineStreamEventCopyWith on LocalTimelineStreamEvent {
  $LocalTimelineStreamEventCopyWithWorker get copyWith => _$copyWith;
  $LocalTimelineStreamEventCopyWithWorker get _$copyWith =>
      _$LocalTimelineStreamEventCopyWithWorkerImpl(this);
}

abstract class $LocalFilesSummaryStreamEventCopyWithWorker {
  LocalFilesSummaryStreamEvent call({LocalFilesSummary? summary});
}

class _$LocalFilesSummaryStreamEventCopyWithWorkerImpl
    implements $LocalFilesSummaryStreamEventCopyWithWorker {
  _$LocalFilesSummaryStreamEventCopyWithWorkerImpl(this.that);

  @override
  LocalFilesSummaryStreamEvent call({dynamic summary}) {
    return LocalFilesSummaryStreamEvent(
      summary: summary as LocalFilesSummary? ?? that.summary,
    );
  }

  final LocalFilesSummaryStreamEvent that;
}

extension $LocalFilesSummaryStreamEventCopyWith
    on LocalFilesSummaryStreamEvent {
  $LocalFilesSummaryStreamEventCopyWithWorker get copyWith => _$copyWith;
  $LocalFilesSummaryStreamEventCopyWithWorker get _$copyWith =>
      _$LocalFilesSummaryStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$LocalFilesControllerNpLog on LocalFilesController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "controller.local_files_controller.LocalFilesController",
  );
}
