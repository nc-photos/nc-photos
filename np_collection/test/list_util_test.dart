import 'package:np_collection/src/list_util.dart';
import 'package:test/test.dart';

void main() {
  group("list_util", () {
    group("diff", () {
      test("extra b begin", _diffExtraBBegin);
      test("extra b end", _diffExtraBEnd);
      test("extra b mid", _diffExtraBMid);
      test("empty a", _diffAEmpty);
      test("extra a begin", _diffExtraABegin);
      test("extra a end", _diffExtraAEnd);
      test("extra a mid", _diffExtraAMid);
      test("empty b", _diffBEmpty);
      test("no matches", _diffNoMatches);
      test("repeated elements", _diffRepeatedElements);
      test("repeated elements 2", _diffRepeatedElements2);
      test("mix", _diffMix);
    });

    group("mergeSortedLists", () {
      test("distinct", _mergeSortedListsDistinct);
      test("equal", _mergeSortedListsEqual);
      test("trailing a", _mergeSortedListsTrailingA);
      test("trailing b", _mergeSortedListsTrailingB);
      test("equal2", _mergeSortedListsEqual2);
    });
  });
}

/// Diff with extra elements at the beginning of list b
///
/// a: [3, 4, 5]
/// b: [1, 2, 3, 4, 5]
/// Expect: [1, 2], []
void _diffExtraBBegin() {
  final diff = getDiff([3, 4, 5], [1, 2, 3, 4, 5]);
  expect(diff.onlyInB, [1, 2]);
  expect(diff.onlyInA, []);
}

/// Diff with extra elements at the end of list b
///
/// a: [1, 2, 3]
/// b: [1, 2, 3, 4, 5]
/// Expect: [4, 5], []
void _diffExtraBEnd() {
  final diff = getDiff([1, 2, 3], [1, 2, 3, 4, 5]);
  expect(diff.onlyInB, [4, 5]);
  expect(diff.onlyInA, []);
}

/// Diff with extra elements in the middle of list b
///
/// a: [1, 2, 5]
/// b: [1, 2, 3, 4, 5]
/// Expect: [3, 4], []
void _diffExtraBMid() {
  final diff = getDiff([1, 2, 5], [1, 2, 3, 4, 5]);
  expect(diff.onlyInB, [3, 4]);
  expect(diff.onlyInA, []);
}

/// Diff with list a being empty
///
/// a: []
/// b: [1, 2, 3]
/// Expect: [1, 2, 3], []
void _diffAEmpty() {
  final diff = getDiff(<int>[], [1, 2, 3]);
  expect(diff.onlyInB, [1, 2, 3]);
  expect(diff.onlyInA, []);
}

/// Diff with extra elements at the beginning of list a
///
/// a: [1, 2, 3, 4, 5]
/// b: [3, 4, 5]
/// Expect: [], [1, 2]
void _diffExtraABegin() {
  final diff = getDiff([1, 2, 3, 4, 5], [3, 4, 5]);
  expect(diff.onlyInB, []);
  expect(diff.onlyInA, [1, 2]);
}

/// Diff with extra elements at the end of list a
///
/// a: [1, 2, 3, 4, 5]
/// b: [1, 2, 3]
/// Expect: [], [4, 5]
void _diffExtraAEnd() {
  final diff = getDiff([1, 2, 3, 4, 5], [1, 2, 3]);
  expect(diff.onlyInB, []);
  expect(diff.onlyInA, [4, 5]);
}

/// Diff with extra elements in the middle of list a
///
/// a: [1, 2, 3, 4, 5]
/// b: [1, 2, 5]
/// Expect: [], [3, 4]
void _diffExtraAMid() {
  final diff = getDiff([1, 2, 3, 4, 5], [1, 2, 5]);
  expect(diff.onlyInB, []);
  expect(diff.onlyInA, [3, 4]);
}

/// Diff with list b being empty
///
/// a: [1, 2, 3]
/// b: []
/// Expect: [], [1, 2, 3]
void _diffBEmpty() {
  final diff = getDiff([1, 2, 3], <int>[]);
  expect(diff.onlyInB, []);
  expect(diff.onlyInA, [1, 2, 3]);
}

/// Diff with no matches between list a and b
///
/// a: [1, 3, 5]
/// b: [2, 4]
/// Expect: [2, 4], [1, 3, 5]
void _diffNoMatches() {
  final diff = getDiff([1, 3, 5], [2, 4]);
  expect(diff.onlyInB, [2, 4]);
  expect(diff.onlyInA, [1, 3, 5]);
}

/// Diff between list a and b with repeated elements
///
/// a: [1, 2, 3]
/// b: [1, 2, 2, 3]
/// Expect: [2], []
void _diffRepeatedElements() {
  final diff = getDiff([1, 2, 3], [1, 2, 2, 3]);
  expect(diff.onlyInB, [2]);
  expect(diff.onlyInA, []);
}

/// Diff between list a and b with repeated elements
///
/// a: [1, 3, 4, 4, 5]
/// b: [1, 2, 2, 3, 5]
/// Expect: [2, 2], [4, 4]
void _diffRepeatedElements2() {
  final diff = getDiff([1, 3, 4, 4, 5], [1, 2, 2, 3, 5]);
  expect(diff.onlyInB, [2, 2]);
  expect(diff.onlyInA, [4, 4]);
}

/// Diff between list a and b
///
/// a: [2, 3, 7, 10, 11, 12]
/// b: [1, 3, 4, 8, 13, 14]
/// Expect: [1, 4, 8, 13, 14], [2, 7, 10, 11, 12]
void _diffMix() {
  final diff = getDiff([2, 3, 7, 10, 11, 12], [1, 3, 4, 8, 13, 14]);
  expect(diff.onlyInB, [1, 4, 8, 13, 14]);
  expect(diff.onlyInA, [2, 7, 10, 11, 12]);
}

void _mergeSortedListsDistinct() {
  final a = [1, 3, 4, 7];
  final b = [2, 5, 6, 8];
  expect(mergeSortedLists(a, b, (a, b) => a.compareTo(b)), [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
  ]);
}

class _MergeSortedListsEqualObj
    implements Comparable<_MergeSortedListsEqualObj> {
  const _MergeSortedListsEqualObj(this.from, this.value);

  @override
  int compareTo(_MergeSortedListsEqualObj other) {
    return value.compareTo(other.value);
  }

  @override
  String toString() => "$from$value";

  final String from;
  final int value;
}

void _mergeSortedListsEqual() {
  final a = [
    const _MergeSortedListsEqualObj("A", 1),
    const _MergeSortedListsEqualObj("A", 3),
    const _MergeSortedListsEqualObj("A", 4),
  ];
  final b = [
    const _MergeSortedListsEqualObj("B", 2),
    const _MergeSortedListsEqualObj("B", 3),
    const _MergeSortedListsEqualObj("B", 5),
  ];
  expect(mergeSortedLists(a, b, (a, b) => a.compareTo(b)), [
    const _MergeSortedListsEqualObj("A", 1),
    const _MergeSortedListsEqualObj("B", 2),
    const _MergeSortedListsEqualObj("A", 3),
    const _MergeSortedListsEqualObj("B", 3),
    const _MergeSortedListsEqualObj("A", 4),
    const _MergeSortedListsEqualObj("B", 5),
  ]);
}

/// Merge list with different size where a.length > b.length
///
/// a: [2, 3, 4]
/// b: [1]
/// Expect: [1, 2, 3, 4]
void _mergeSortedListsTrailingA() {
  final a = [2, 3, 4];
  final b = [1];
  expect(mergeSortedLists(a, b, (a, b) => a.compareTo(b)), [1, 2, 3, 4]);
}

/// Merge list with different size where b.length > a.length
///
/// a: [1]
/// b: [2, 3, 4]
/// Expect: [1, 2, 3, 4]
void _mergeSortedListsTrailingB() {
  final a = [1];
  final b = [2, 3, 4];
  expect(mergeSortedLists(a, b, (a, b) => a.compareTo(b)), [1, 2, 3, 4]);
}

class _MergeSortedListsEqual2Obj
    implements Comparable<_MergeSortedListsEqual2Obj> {
  const _MergeSortedListsEqual2Obj(this.from, this.value);

  @override
  int compareTo(_MergeSortedListsEqual2Obj other) {
    var a = value.compareTo(other.value);
    if (a == 0) {
      a = other.from.compareTo(from);
    }
    return a;
  }

  @override
  String toString() => "$from$value";

  final String from;
  final int value;
}

void _mergeSortedListsEqual2() {
  final a = [
    const _MergeSortedListsEqual2Obj("A", 4),
    const _MergeSortedListsEqual2Obj("A", 3),
    const _MergeSortedListsEqual2Obj("A", 1),
  ];
  final b = [
    const _MergeSortedListsEqual2Obj("B", 5),
    const _MergeSortedListsEqual2Obj("B", 3),
    const _MergeSortedListsEqual2Obj("B", 2),
  ];
  expect(
    mergeSortedLists(a.reversed, b.reversed, (a, b) => a.compareTo(b)).reversed,
    [
      const _MergeSortedListsEqual2Obj("B", 5),
      const _MergeSortedListsEqual2Obj("A", 4),
      const _MergeSortedListsEqual2Obj("A", 3),
      const _MergeSortedListsEqual2Obj("B", 3),
      const _MergeSortedListsEqual2Obj("B", 2),
      const _MergeSortedListsEqual2Obj("A", 1),
    ],
  );
}
