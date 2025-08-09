// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $PlaceStreamEventCopyWithWorker {
  PlaceStreamEvent call({LocationGroupResult? data, bool? hasNext});
}

class _$PlaceStreamEventCopyWithWorkerImpl
    implements $PlaceStreamEventCopyWithWorker {
  _$PlaceStreamEventCopyWithWorkerImpl(this.that);

  @override
  PlaceStreamEvent call({dynamic data, dynamic hasNext}) {
    return PlaceStreamEvent(
      data: data as LocationGroupResult? ?? that.data,
      hasNext: hasNext as bool? ?? that.hasNext,
    );
  }

  final PlaceStreamEvent that;
}

extension $PlaceStreamEventCopyWith on PlaceStreamEvent {
  $PlaceStreamEventCopyWithWorker get copyWith => _$copyWith;
  $PlaceStreamEventCopyWithWorker get _$copyWith =>
      _$PlaceStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$PlacesControllerNpLog on PlacesController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("controller.places_controller.PlacesController");
}
