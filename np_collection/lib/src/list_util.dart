import 'package:np_collection/src/iterator_extension.dart';

/// Contain results from the diff functions
///
/// [onlyInA] contains items exist in a but not b, [onlyInB] contains items
/// exist in b but not a
class DiffResult<T> {
  const DiffResult({required this.onlyInA, required this.onlyInB});

  final List<T> onlyInB;
  final List<T> onlyInA;
}

/// Return the difference between two sorted lists, [a] and [b]
///
/// [a] and [b] MUST be sorted in ascending order, otherwise the result is
/// undefined
DiffResult<T> getDiffWith<T>(
  Iterable<T> a,
  Iterable<T> b,
  int Function(T a, T b) comparator,
) {
  final aIt = a.iterator, bIt = b.iterator;
  final aMissing = <T>[], bMissing = <T>[];
  while (true) {
    if (!aIt.moveNext()) {
      // no more elements in a
      bIt.iterate((obj) => aMissing.add(obj));
      return DiffResult(onlyInB: aMissing, onlyInA: bMissing);
    }
    if (!bIt.moveNext()) {
      // no more elements in b
      // needed because aIt has already advanced
      bMissing.add(aIt.current);
      aIt.iterate((obj) => bMissing.add(obj));
      return DiffResult(onlyInB: aMissing, onlyInA: bMissing);
    }
    final result = _diffUntilEqual(aIt, bIt, comparator);
    aMissing.addAll(result.onlyInB);
    bMissing.addAll(result.onlyInA);
  }
}

DiffResult<T> getDiff<T extends Comparable>(Iterable<T> a, Iterable<T> b) =>
    getDiffWith(a, b, Comparable.compare);

/// Merge two sorted list, [a] and [b] into one single sorted list
///
/// Both lists MUST be sorted in ascending order by [comparator], otherwise the
/// behavior is undefined. If two elements are compared equally with each other,
/// the one in [a] is preferred
List<T> mergeSortedLists<T>(
  Iterable<T> a,
  Iterable<T> b,
  int Function(T a, T b) comparator,
) {
  final results = <T>[];
  var aIt = a.iterator;
  var bIt = b.iterator;
  var shouldMoveA = true;
  var shouldMoveB = true;
  while (true) {
    if (shouldMoveA && !aIt.moveNext()) {
      // no more elements in a
      if (!shouldMoveB) {
        // needed because bIt.current not yet added
        results.add(bIt.current);
      }
      bIt.iterate(results.add);
      return results;
    }
    if (shouldMoveB && !bIt.moveNext()) {
      // no more elements in b
      results.add(aIt.current);
      aIt.iterate(results.add);
      return results;
    }
    shouldMoveA = false;
    shouldMoveB = false;
    var diff = comparator(aIt.current, bIt.current);
    if (diff <= 0) {
      // a[i] < b[j]
      results.add(aIt.current);
      shouldMoveA = true;
    } else {
      results.add(bIt.current);
      shouldMoveB = true;
    }
  }
}

DiffResult<T> _diffUntilEqual<T>(
  Iterator<T> aIt,
  Iterator<T> bIt,
  int Function(T a, T b) comparator,
) {
  final a = aIt.current, b = bIt.current;
  final diff = comparator(a, b);
  if (diff < 0) {
    // a < b
    if (!aIt.moveNext()) {
      return DiffResult(onlyInB: [b] + bIt.toList(), onlyInA: [a]);
    } else {
      final result = _diffUntilEqual(aIt, bIt, comparator);
      return DiffResult(onlyInB: result.onlyInB, onlyInA: [a] + result.onlyInA);
    }
  } else if (diff > 0) {
    // a > b
    if (!bIt.moveNext()) {
      return DiffResult(onlyInB: [b], onlyInA: [a] + aIt.toList());
    } else {
      final result = _diffUntilEqual(aIt, bIt, comparator);
      return DiffResult(onlyInB: [b] + result.onlyInB, onlyInA: result.onlyInA);
    }
  } else {
    // a == b
    return const DiffResult(onlyInB: [], onlyInA: []);
  }
}
