// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_date_time_edit_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({ZonedDateTime? dateTime});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({dynamic dateTime}) {
    return _State(dateTime: dateTime as ZonedDateTime? ?? that.dateTime);
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.photo_date_time_edit_dialog._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {dateTime: $dateTime}";
  }
}

extension _$_SetDateToString on _SetDate {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDate {value: $value}";
  }
}

extension _$_SetTimeToString on _SetTime {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetTime {value: $value}";
  }
}

extension _$_SetTimeZoneOffsetToString on _SetTimeZoneOffset {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetTimeZoneOffset {isNegative: $isNegative, hour: $hour, min: $min}";
  }
}
