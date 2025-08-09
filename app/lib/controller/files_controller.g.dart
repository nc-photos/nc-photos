// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $FilesSummaryStreamEventCopyWithWorker {
  FilesSummaryStreamEvent call({DbFilesSummary? summary});
}

class _$FilesSummaryStreamEventCopyWithWorkerImpl
    implements $FilesSummaryStreamEventCopyWithWorker {
  _$FilesSummaryStreamEventCopyWithWorkerImpl(this.that);

  @override
  FilesSummaryStreamEvent call({dynamic summary}) {
    return FilesSummaryStreamEvent(
      summary: summary as DbFilesSummary? ?? that.summary,
    );
  }

  final FilesSummaryStreamEvent that;
}

extension $FilesSummaryStreamEventCopyWith on FilesSummaryStreamEvent {
  $FilesSummaryStreamEventCopyWithWorker get copyWith => _$copyWith;
  $FilesSummaryStreamEventCopyWithWorker get _$copyWith =>
      _$FilesSummaryStreamEventCopyWithWorkerImpl(this);
}

abstract class $TimelineStreamEventCopyWithWorker {
  TimelineStreamEvent call({Map<int, FileDescriptor>? data, bool? isDummy});
}

class _$TimelineStreamEventCopyWithWorkerImpl
    implements $TimelineStreamEventCopyWithWorker {
  _$TimelineStreamEventCopyWithWorkerImpl(this.that);

  @override
  TimelineStreamEvent call({dynamic data, dynamic isDummy}) {
    return TimelineStreamEvent(
      data: data as Map<int, FileDescriptor>? ?? that.data,
      isDummy: isDummy as bool? ?? that.isDummy,
    );
  }

  final TimelineStreamEvent that;
}

extension $TimelineStreamEventCopyWith on TimelineStreamEvent {
  $TimelineStreamEventCopyWithWorker get copyWith => _$copyWith;
  $TimelineStreamEventCopyWithWorker get _$copyWith =>
      _$TimelineStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$FilesControllerNpLog on FilesController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("controller.files_controller.FilesController");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$UpdatePropertyFailureErrorToString on UpdatePropertyFailureError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "UpdatePropertyFailureError {files: [length: ${files.length}]}";
  }
}

extension _$RemoveFailureErrorToString on RemoveFailureError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "RemoveFailureError {files: [length: ${files.length}]}";
  }
}
