import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/memory.dart';
import 'package:nc_photos/widget/photo_list_util.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:test/test.dart';

import '../test_util.dart' as util;

void main() {
  group("MemoryCollectionHelper", () {
    test("same year", _sameYear);
    test("next year", _nextYear);
    group("prev year", () {
      test("same day", _prevYear);
      test("-3 day", _prevYear3DaysBefore);
      test("-2 day", _prevYear2DaysBefore);
      test("+3 day", _prevYear3DaysAfter);
      test("+2 day", _prevYear2DaysAfter);
    });
    group("on feb 29", () {
      test("+feb 26", _onFeb29AddFeb26);
      test("+feb 27", _onFeb29AddFeb27);
      group("non leap year", () {
        test("+mar 4", _onFeb29AddMar4);
        test("+mar 3", _onFeb29AddMar3);
      });
      group("leap year", () {
        test("+mar 3", _onFeb29AddMar3LeapYear);
        test("+mar 2", _onFeb29AddMar2LeapYear);
      });
    });
    group("on jan 1", () {
      test("+dec 31", _onJan1AddDec31);
      test("+dec 31 a year ago", _onJan1AddDec31PrevYear);
    });
    group("on dec 31", () {
      test("+jan 1", _onDec31AddJan1);
    });
    group("on may 15, range=0", () {
      test("+may 16", _onMay15AddMay16Range0);
      test("+may 15", _onMay15AddMay15Range0);
    });
    group("on may 15, range<0", () {
      test("+may 16", _onMay15AddMay16RangeNegative);
    });
  });
}

/// Add a file taken in the same year
///
/// Today: 2021-02-03
/// File: 2021-02-01
/// Expect: empty
void _sameYear() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2021, 2, 3),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the next year. This happens if the user adjusted the
/// system clock
///
/// Today: 2021-02-03
/// File: 2022-02-03
/// Expect: empty
void _nextYear() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2022, 2, 3),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the prev year
///
/// Today: 2021-02-03
/// File: 2020-02-03
/// Expect: [2020]
void _prevYear() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2020, 2, 3),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2020",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2020,
        month: 2,
        day: 3,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken in the prev year
///
/// Today: 2021-02-03
/// File: 2020-01-31
/// Expect: empty
void _prevYear3DaysBefore() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2020, 1, 31),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the prev year
///
/// Today: 2021-02-03
/// File: 2020-02-01
/// Expect: [2020]
void _prevYear2DaysBefore() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2020, 2, 1),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2020",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2020,
        month: 2,
        day: 3,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken in the prev year
///
/// Today: 2021-02-03
/// File: 2020-02-06
/// Expect: empty
void _prevYear3DaysAfter() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2020, 2, 6),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the prev year
///
/// Today: 2021-02-03
/// File: 2020-02-05
/// Expect: [2020]
void _prevYear2DaysAfter() {
  final account = util.buildAccount();
  final today = Date(2021, 2, 3);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2020, 2, 5),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2020",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2020,
        month: 2,
        day: 3,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken in the prev year
///
/// Today: 2020-02-29
/// File: 2019-02-26
/// Expect: empty
void _onFeb29AddFeb26() {
  final account = util.buildAccount();
  final today = Date(2020, 2, 29);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2019, 2, 26),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the prev year
///
/// Today: 2020-02-29
/// File: 2019-02-27
/// Expect: [2019]
void _onFeb29AddFeb27() {
  final account = util.buildAccount();
  final today = Date(2020, 2, 29);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2019, 2, 27),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2019",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2019,
        month: 2,
        day: 29,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken in the prev year
///
/// Today: 2020-02-29
/// File: 2019-03-04
/// Expect: empty
void _onFeb29AddMar4() {
  final account = util.buildAccount();
  final today = Date(2020, 2, 29);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2019, 3, 4),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the prev year
///
/// Today: 2020-02-29
/// File: 2019-03-03
/// Expect: [2019]
void _onFeb29AddMar3() {
  final account = util.buildAccount();
  final today = Date(2020, 2, 29);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2019, 3, 3),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2019",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2019,
        month: 2,
        day: 29,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken in the prev leap year
///
/// Today: 2020-02-29
/// File: 2016-03-03
/// Expect: empty
void _onFeb29AddMar3LeapYear() {
  final account = util.buildAccount();
  final today = Date(2020, 2, 29);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2016, 3, 3),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken in the prev leap year
///
/// Today: 2020-02-29
/// File: 2016-03-02
/// Expect: [2016]
void _onFeb29AddMar2LeapYear() {
  final account = util.buildAccount();
  final today = Date(2020, 2, 29);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2016, 3, 2),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2016",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2016,
        month: 2,
        day: 29,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken around new year's day
///
/// Today: 2020-01-01
/// File: 2019-12-31
/// Expect: empty
void _onJan1AddDec31() {
  final account = util.buildAccount();
  final today = Date(2020, 1, 1);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2019, 12, 31),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Add a file taken around new year's day
///
/// Today: 2020-01-01
/// File: 2018-12-31
/// Expect: [2019]
void _onJan1AddDec31PrevYear() {
  final account = util.buildAccount();
  final today = Date(2020, 1, 1);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2018, 12, 31),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2019",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2019,
        month: 1,
        day: 1,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file taken around new year's day
///
/// Today: 2020-12-31
/// File: 2020-01-01
/// Expect: [2019]
void _onDec31AddJan1() {
  final account = util.buildAccount();
  final today = Date(2020, 12, 31);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 2);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2020, 1, 1),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2019",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2019,
        month: 12,
        day: 31,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file with 0 day offset when range = 0
///
/// Today: 2022-05-15
/// File: 2021-05-15
/// Expect: [2022]
void _onMay15AddMay15Range0() {
  final account = util.buildAccount();
  final today = Date(2022, 5, 15);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 0);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2021, 5, 15),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder).toList(), [
    Collection(
      name: "2021",
      contentProvider: CollectionMemoryProvider(
        account: account,
        year: 2021,
        month: 5,
        day: 15,
        cover: file,
      ),
    ),
  ]);
}

/// Add a file with 1 day offset when range = 0
///
/// Today: 2022-05-15
/// File: 2021-05-16
/// Expect: []
void _onMay15AddMay16Range0() {
  final account = util.buildAccount();
  final today = Date(2022, 5, 15);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: 0);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2021, 5, 16),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

/// Make sure the builder won't throw when range < 0
///
/// Today: 2022-05-15
/// File: 2021-05-16
/// Expect: []
void _onMay15AddMay16RangeNegative() {
  final account = util.buildAccount();
  final today = Date(2022, 5, 15);
  final obj = MemoryCollectionHelper(account, today: today, dayRange: -1);
  final file = util.buildJpegFile(
    path: "",
    fileId: 0,
    lastModified: DateTime.utc(2021, 5, 16),
  );
  obj.addFile(file);
  expect(obj.build(_nameBuilder), []);
}

String _nameBuilder(int year) => "$year";
