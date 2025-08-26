import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/memory.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';

part 'photo_list_util.g.dart';

class DateGroupHelper {
  DateGroupHelper({required this.isMonthOnly});

  Date? onDate(Date date) {
    if (date.year != _currentDate?.year ||
        date.month != _currentDate?.month ||
        (!isMonthOnly && date.day != _currentDate?.day)) {
      _currentDate = date;
      return date;
    } else {
      return null;
    }
  }

  final bool isMonthOnly;
  Date? _currentDate;
}

/// Build memory collection from files
///
/// Feb 29 is treated as Mar 1 on non leap years
@npLog
class MemoryCollectionHelper {
  MemoryCollectionHelper(this.account, {Date? today, required int dayRange})
    : _tzOffset = clock.now().timeZoneOffset,
      // today = (today?.toLocal() ?? clock.now()).toMidnight(),
      dayRange = math.max(dayRange, 0) {
    this.today = today ?? Date.today();
  }

  void addFile(FileDescriptor f, {Date? localDate}) {
    // too slow
    // final localDate = f.fdDateTime.toLocal().toMidnight();
    localDate ??= f.fdDateTime.add(_tzOffset).toDate();
    final diff = today.difference(localDate).inDays;
    if (diff < 300) {
      return;
    }
    for (final dy in [0, -1, 1]) {
      if (today
              .copyWith(year: localDate.year + dy)
              .difference(localDate)
              .abs()
              .inDays <=
          dayRange) {
        _log.fine(
          "[addFile] Add file (${f.fdDateTime}) to ${localDate.year + dy}",
        );
        _addFileToYear(f, localDate.year + dy);
        break;
      }
    }
  }

  /// Build list of memory albums
  ///
  /// [nameBuilder] is a function that return the name of the album for a
  /// particular year
  List<Collection> build(String Function(int year) nameBuilder) {
    return _data.entries
        .sorted((a, b) => b.key.compareTo(a.key))
        .map(
          (e) => Collection(
            name: nameBuilder(e.key),
            contentProvider: CollectionMemoryProvider(
              account: account,
              year: e.key,
              month: today.month,
              day: today.day,
              cover: e.value.coverFile,
            ),
          ),
        )
        .toList();
  }

  void _addFileToYear(FileDescriptor f, int year) {
    final item = _data[year];
    final date = today.copyWith(year: year);
    if (item == null) {
      _data[year] = _MemoryCollectionHelperItem(date, f);
    } else {
      final coverDiff = _MemoryCollectionHelperItem.getCoverDiff(date, f);
      if (coverDiff < item.coverDiff) {
        item.coverFile = f;
        item.coverDiff = coverDiff;
      }
    }
  }

  final Account account;
  late final Date today;
  final int dayRange;
  final Duration _tzOffset;
  final _data = <int, _MemoryCollectionHelperItem>{};
}

int getThumbSize(int zoomLevel) {
  switch (zoomLevel) {
    case -1:
      return 96;

    case 1:
      return 176;

    case 2:
      return 256;

    case 0:
    default:
      return 112;
  }
}

class _MemoryCollectionHelperItem {
  _MemoryCollectionHelperItem(this.date, this.coverFile)
    : coverDiff = getCoverDiff(date, coverFile);

  static Duration getCoverDiff(Date date, FileDescriptor f) =>
      f.fdDateTime
          .add(_tzOffset)
          .difference(date.toLocalDateTime().copyWith(hour: 12))
          .abs();

  final Date date;
  FileDescriptor coverFile;
  Duration coverDiff;

  static final Duration _tzOffset = clock.now().timeZoneOffset;
}
