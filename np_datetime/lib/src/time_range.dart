enum TimeRangeBound { inclusive, exclusive }

class TimeRange {
  const TimeRange({
    this.from,
    this.fromBound = TimeRangeBound.inclusive,
    this.to,
    this.toBound = TimeRangeBound.exclusive,
  });

  /// Return a copy of the current instance with some changed fields. Setting
  /// null is not supported
  TimeRange copyWith({
    DateTime? from,
    TimeRangeBound? fromBound,
    DateTime? to,
    TimeRangeBound? toBound,
  }) {
    return TimeRange(
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

  final DateTime? from;
  final TimeRangeBound fromBound;
  final DateTime? to;
  final TimeRangeBound toBound;
}

extension TimeRangeExtension on TimeRange {
  /// Return if an arbitrary time [a] is inside this range
  ///
  /// The comparison is independent of whether the time is in UTC or in the
  /// local time zone
  bool isIn(DateTime a) {
    if (from != null) {
      if (a.isBefore(from!)) {
        return false;
      }
      if (fromBound == TimeRangeBound.exclusive) {
        if (a.isAtSameMomentAs(from!)) {
          return false;
        }
      }
    }
    if (to != null) {
      if (a.isAfter(to!)) {
        return false;
      }
      if (toBound == TimeRangeBound.exclusive) {
        if (a.isAtSameMomentAs(to!)) {
          return false;
        }
      }
    }
    return true;
  }
}
