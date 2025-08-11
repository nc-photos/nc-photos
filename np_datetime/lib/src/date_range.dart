import 'package:np_datetime/src/date.dart';
import 'package:np_datetime/src/time_range.dart';

class DateRange {
  const DateRange({
    this.from,
    this.fromBound = TimeRangeBound.inclusive,
    this.to,
    this.toBound = TimeRangeBound.exclusive,
  });

  /// Return a copy of the current instance with some changed fields. Setting
  /// null is not supported
  DateRange copyWith({
    Date? from,
    TimeRangeBound? fromBound,
    Date? to,
    TimeRangeBound? toBound,
  }) {
    return DateRange(
      from: from ?? this.from,
      fromBound: fromBound ?? this.fromBound,
      to: to ?? this.to,
      toBound: toBound ?? this.toBound,
    );
  }

  @override
  String toString() {
    return "${fromBound == TimeRangeBound.inclusive ? "[" : "("}"
        "$from, $to"
        "${toBound == TimeRangeBound.inclusive ? "]" : ")"}";
  }

  final Date? from;
  final TimeRangeBound fromBound;
  final Date? to;
  final TimeRangeBound toBound;
}

extension DateRangeExtension on DateRange {
  /// Return if an arbitrary time [a] is inside this range
  ///
  /// The comparison is independent of whether the time is in UTC or in the
  /// local time zone
  bool contains(Date a) {
    if (from != null) {
      if (a.isBefore(from!)) {
        return false;
      }
      if (fromBound == TimeRangeBound.exclusive) {
        if (a == from) {
          return false;
        }
      }
    }
    if (to != null) {
      if (a.isAfter(to!)) {
        return false;
      }
      if (toBound == TimeRangeBound.exclusive) {
        if (a == to!) {
          return false;
        }
      }
    }
    return true;
  }

  bool isOverlapped(DateRange other) {
    final aFrom = _inclusiveFrom;
    final aTo = _inclusiveTo;
    final bFrom = other._inclusiveFrom;
    final bTo = other._inclusiveTo;
    return (aFrom == null || bTo == null || aFrom <= bTo) &&
        (bFrom == null || aTo == null || bFrom <= aTo);
  }

  /// Return the union of two DateRanges
  ///
  /// Warning: this function always assume the two DateRanges being overlapped,
  /// you may want to call [isOverlapped] first
  DateRange union(DateRange other) {
    assert(isOverlapped(other));
    return DateRange(
      from:
          from == null || other.from == null
              ? null
              : _inclusiveFrom!.min(other._inclusiveFrom!),
      fromBound: TimeRangeBound.inclusive,
      to:
          to == null || other.to == null
              ? null
              : _inclusiveTo!.max(other._inclusiveTo!),
      toBound: TimeRangeBound.inclusive,
    );
  }

  TimeRange toLocalTimeRange() => TimeRange(
    from: from?.toLocalDateTime(),
    fromBound: fromBound,
    to:
        (toBound == TimeRangeBound.inclusive ? to?.add(day: 1) : to)
            ?.toLocalDateTime(),
    toBound: TimeRangeBound.exclusive,
  );

  Date? get _inclusiveFrom =>
      fromBound == TimeRangeBound.inclusive ? from : from?.add(day: -1);
  Date? get _inclusiveTo =>
      toBound == TimeRangeBound.inclusive ? to : to?.add(day: -1);
}
