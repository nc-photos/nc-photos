import 'package:clock/clock.dart';

/// A calendar date with no timezone information
class Date implements Comparable<Date> {
  factory Date(int year, [int month = 1, int day = 1]) {
    final d = DateTime.utc(year, month, day);
    return Date._unchecked(d.year, d.month, d.day);
  }

  const Date._unchecked(this.year, [this.month = 1, this.day = 1]);

  /// Convert a [DateTime] object to [Date]. The data is taken from [dateTime]
  /// as-is, the timezone will not be considered
  static Date fromDateTime(DateTime dateTime) =>
      Date._unchecked(dateTime.year, dateTime.month, dateTime.day);

  static Date today() => fromDateTime(clock.now());

  Date copyWith({int? year, int? month, int? day}) {
    return Date(year ?? this.year, month ?? this.month, day ?? this.day);
  }

  @override
  int compareTo(Date other) => toUtcDateTime().compareTo(other.toUtcDateTime());

  @override
  String toString() => "$day/$month/$year";

  @override
  bool operator ==(Object other) =>
      other is Date &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  final int year;
  final int month;
  final int day;
}

extension DateExtension on Date {
  DateTime toUtcDateTime() => DateTime.utc(year, month, day);
  DateTime toLocalDateTime() => DateTime(year, month, day);

  Date add({int? year, int? month, int? day}) {
    final d = DateTime.utc(
      this.year + (year ?? 0),
      this.month + (month ?? 0),
      this.day + (day ?? 0),
    );
    return Date(d.year, d.month, d.day);
  }

  Duration difference(Date other) =>
      toUtcDateTime().difference(other.toUtcDateTime());

  bool isBefore(Date other) {
    if (year > other.year) {
      return false;
    } else if (year < other.year) {
      return true;
    }
    if (month > other.month) {
      return false;
    } else if (month < other.month) {
      return true;
    }
    return day < other.day;
  }

  bool operator <(Date other) => isBefore(other);

  bool isBeforeOrAt(Date other) => !isAfter(other);

  bool operator <=(Date other) => isBeforeOrAt(other);

  bool isAfter(Date other) {
    if (year < other.year) {
      return false;
    } else if (year > other.year) {
      return true;
    }
    if (month < other.month) {
      return false;
    } else if (month > other.month) {
      return true;
    }
    return day > other.day;
  }

  bool operator >(Date other) => isAfter(other);

  bool isAfterOrAt(Date other) => !isBefore(other);

  bool operator >=(Date other) => isAfterOrAt(other);

  /// Return the earlier date
  Date min(Date other) => isBefore(other) ? this : other;

  /// Return the later date
  Date max(Date other) => isAfter(other) ? this : other;
}

extension DateTimeDateExtension on DateTime {
  Date toDate() => Date.fromDateTime(this);
}
