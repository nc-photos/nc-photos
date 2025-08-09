// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharings_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $SharingStreamEventCopyWithWorker {
  SharingStreamEvent call({List<SharingStreamData>? data, bool? hasNext});
}

class _$SharingStreamEventCopyWithWorkerImpl
    implements $SharingStreamEventCopyWithWorker {
  _$SharingStreamEventCopyWithWorkerImpl(this.that);

  @override
  SharingStreamEvent call({dynamic data, dynamic hasNext}) {
    return SharingStreamEvent(
      data: data as List<SharingStreamData>? ?? that.data,
      hasNext: hasNext as bool? ?? that.hasNext,
    );
  }

  final SharingStreamEvent that;
}

extension $SharingStreamEventCopyWith on SharingStreamEvent {
  $SharingStreamEventCopyWithWorker get copyWith => _$copyWith;
  $SharingStreamEventCopyWithWorker get _$copyWith =>
      _$SharingStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$SharingsControllerNpLog on SharingsController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "controller.sharings_controller.SharingsController",
  );
}
