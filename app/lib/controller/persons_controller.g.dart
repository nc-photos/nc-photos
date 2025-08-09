// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persons_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $PersonStreamEventCopyWithWorker {
  PersonStreamEvent call({List<Person>? data, bool? hasNext});
}

class _$PersonStreamEventCopyWithWorkerImpl
    implements $PersonStreamEventCopyWithWorker {
  _$PersonStreamEventCopyWithWorkerImpl(this.that);

  @override
  PersonStreamEvent call({dynamic data, dynamic hasNext}) {
    return PersonStreamEvent(
      data: data as List<Person>? ?? that.data,
      hasNext: hasNext as bool? ?? that.hasNext,
    );
  }

  final PersonStreamEvent that;
}

extension $PersonStreamEventCopyWith on PersonStreamEvent {
  $PersonStreamEventCopyWithWorker get copyWith => _$copyWith;
  $PersonStreamEventCopyWithWorker get _$copyWith =>
      _$PersonStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$PersonsControllerNpLog on PersonsController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("controller.persons_controller.PersonsController");
}
