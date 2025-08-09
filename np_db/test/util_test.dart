import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:test/test.dart';

void main() {
  group("DbFilesSummaryExtension", () {
    group("diff", () {
      test("extra other begin", _diffExtraOtherBegin);
      test("extra other end", _diffExtraOtherEnd);
      test("extra other mid", _diffExtraOtherMid);
      test("empty this", _diffThisEmpty);
      test("extra this begin", _diffExtraThisBegin);
      test("extra this end", _diffExtraThisEnd);
      test("extra this mid", _diffExtraThisMid);
      test("empty other", _diffOtherEmpty);
      test("no matches", _diffNoMatches);
    });
  });
}

/// Diff with extra elements at the beginning of other list
///
/// this: {13/1/2024: 5, 12/1/2024: 4}
/// other: {15/1/2024: 7 ,14/1/2024: 6, 13/1/2024: 5, 12/1/2024: 4}
/// Expect: {}, {15/1/2024: 7 ,14/1/2024: 6}, {}
void _diffExtraOtherBegin() {
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
    },
  );
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 15): const DbFilesSummaryItem(count: 7),
      Date(2024, 1, 14): const DbFilesSummaryItem(count: 6),
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: const {},
      onlyInOther: {
        Date(2024, 1, 15): const DbFilesSummaryItem(count: 7),
        Date(2024, 1, 14): const DbFilesSummaryItem(count: 6),
      },
      updated: const {},
    ),
  );
}

/// Diff with extra elements at the end of other list
///
/// this: {13/1/2024: 5, 12/1/2024: 4}
/// other: {13/1/2024: 5, 12/1/2024: 4, 11/1/2024: 3, 10/1/2024: 2}
/// Expect: {}, {11/1/2024: 3, 10/1/2024: 2}, {}
void _diffExtraOtherEnd() {
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
    },
  );
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: const {},
      onlyInOther: {
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
        Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      },
      updated: const {},
    ),
  );
}

/// Diff with extra elements in the middle of other list
///
/// this: {13/1/2024: 5, 12/1/2024: 4, 9/1/2024: 1}
/// other: {13/1/2024: 5, 12/1/2024: 4, 11/1/2024: 3, 10/1/2024: 2, 9/1/2024: 1}
/// Expect: {}, {11/1/2024: 3, 10/1/2024: 2}, {}
void _diffExtraOtherMid() {
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 9): const DbFilesSummaryItem(count: 1),
    },
  );
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      Date(2024, 1, 9): const DbFilesSummaryItem(count: 1),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: const {},
      onlyInOther: {
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
        Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      },
      updated: const {},
    ),
  );
}

/// Diff with this being empty
///
/// this: {}
/// other: {13/1/2024: 5, 12/1/2024: 4, 11/1/2024: 3, 10/1/2024: 2, 9/1/2024: 1}
/// Expect: {}, {11/1/2024: 3, 10/1/2024: 2}, {}
void _diffThisEmpty() {
  const obj = DbFilesSummary(items: {});
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: const {},
      onlyInOther: {
        Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
        Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      },
      updated: const {},
    ),
  );
}

/// Diff with extra elements at the beginning of this list
///
/// this: {15/1/2024: 7 ,14/1/2024: 6, 13/1/2024: 5, 12/1/2024: 4}
/// other: {13/1/2024: 5, 12/1/2024: 4}
/// Expect: {15/1/2024: 7 ,14/1/2024: 6}, {}, {}
void _diffExtraThisBegin() {
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
    },
  );
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 15): const DbFilesSummaryItem(count: 7),
      Date(2024, 1, 14): const DbFilesSummaryItem(count: 6),
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: {
        Date(2024, 1, 15): const DbFilesSummaryItem(count: 7),
        Date(2024, 1, 14): const DbFilesSummaryItem(count: 6),
      },
      onlyInOther: const {},
      updated: const {},
    ),
  );
}

/// Diff with extra elements at the end of this list
///
/// this: {13/1/2024: 5, 12/1/2024: 4, 11/1/2024: 3, 10/1/2024: 2}
/// other: {13/1/2024: 5, 12/1/2024: 4}
/// Expect: {11/1/2024: 3, 10/1/2024: 2}, {}, {}
void _diffExtraThisEnd() {
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
    },
  );
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: {
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
        Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      },
      onlyInOther: const {},
      updated: const {},
    ),
  );
}

/// Diff with extra elements in the middle of this list
///
/// this: {13/1/2024: 5, 12/1/2024: 4, 11/1/2024: 3, 10/1/2024: 2, 9/1/2024: 1}
/// other: {13/1/2024: 5, 12/1/2024: 4, 9/1/2024: 1}
/// Expect: {11/1/2024: 3, 10/1/2024: 2}, {}, {}
void _diffExtraThisMid() {
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 9): const DbFilesSummaryItem(count: 1),
    },
  );
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      Date(2024, 1, 9): const DbFilesSummaryItem(count: 1),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: {
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
        Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      },
      onlyInOther: const {},
      updated: const {},
    ),
  );
}

/// Diff with other being empty
///
/// this: {13/1/2024: 5, 12/1/2024: 4, 11/1/2024: 3, 10/1/2024: 2, 9/1/2024: 1}
/// other: {}
/// Expect: {11/1/2024: 3, 10/1/2024: 2}, {}, {}
void _diffOtherEmpty() {
  const other = DbFilesSummary(items: {});
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: {
        Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
        Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      },
      onlyInOther: const {},
      updated: const {},
    ),
  );
}

/// Diff with no matches between this and other
///
/// this: {13/1/2024: 5, 11/1/2024: 3, 9/1/2024: 1}
/// other: {12/1/2024: 4, 10/1/2024: 2}
/// Expect: [2, 4], [1, 3, 5]
void _diffNoMatches() {
  final other = DbFilesSummary(
    items: {
      Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
      Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
      Date(2024, 1, 9): const DbFilesSummaryItem(count: 1),
    },
  );
  final obj = DbFilesSummary(
    items: {
      Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
      Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
    },
  );
  expect(
    obj.diff(other),
    DbFilesSummaryDiff(
      onlyInThis: {
        Date(2024, 1, 12): const DbFilesSummaryItem(count: 4),
        Date(2024, 1, 10): const DbFilesSummaryItem(count: 2),
      },
      onlyInOther: {
        Date(2024, 1, 13): const DbFilesSummaryItem(count: 5),
        Date(2024, 1, 11): const DbFilesSummaryItem(count: 3),
        Date(2024, 1, 9): const DbFilesSummaryItem(count: 1),
      },
      updated: const {},
    ),
  );
}
