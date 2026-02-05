import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:np_math/np_math.dart';

extension ListExtension<T> on List<T> {
  Iterable<T> takeIndex(List<int> indexes) => indexes.map((e) => this[e]);

  // Like slice in python
  List<T> pySlice(int start, [int? stop, int step = 1]) {
    assert(step > 0);
    if (start < 0) {
      start = math.max(length + start, 0);
    }
    if (stop != null && stop < 0) {
      stop = math.max(length + stop, 0);
    }
    if (start >= length) {
      return [];
    } else if (stop == null) {
      final sub = sublist(start);
      if (step <= 1) {
        return sub;
      } else {
        return sub.whereIndexed((index, _) => index % step == 0).toList();
      }
    } else if (start >= stop) {
      return [];
    } else {
      final sub = sublist(start, math.min(stop, length));
      if (step <= 1) {
        return sub;
      } else {
        return sub.whereIndexed((index, _) => index % step == 0).toList();
      }
    }
  }

  void stableSort([int Function(T a, T b)? compare]) {
    mergeSort(this, compare: compare);
  }

  /// In-place transform and return this
  ///
  /// Since the elements are in-place transformed, they have to share the same
  /// type
  List<T> transform(T Function(T element) fn) {
    for (final i in 0.until(length)) {
      this[i] = fn(this[i]);
    }
    return this;
  }

  Future<List<U>> asyncMap<U>(Future<U> Function(T element) fn) async {
    final results = <U>[];
    for (final e in this) {
      results.add(await fn(e));
    }
    return results;
  }

  /// [map] with access to nearby elements
  ///
  /// Does not work well with nullable elements as prev and next return null for
  /// the first and last element
  Iterable<U> map3<U>(U Function(T e, T? prev, T? next) toElement) sync* {
    for (var i = 0; i < length; ++i) {
      yield toElement(
        this[i],
        i == 0 ? null : this[i - 1],
        i == length - 1 ? null : this[i + 1],
      );
    }
  }

  /// [expand] with access to nearby elements
  ///
  /// Does not work well with nullable elements as prev and next return null for
  /// the first and last element
  Iterable<U> expand3<U>(
    Iterable<U> Function(T e, T? prev, T? next) toElements,
  ) sync* {
    for (var i = 0; i < length; ++i) {
      yield* toElements(
        this[i],
        i == 0 ? null : this[i - 1],
        i == length - 1 ? null : this[i + 1],
      );
    }
  }

  List<T> added(T value) => toList()..add(value);

  List<T> addedAll(Iterable<T> values) => toList()..addAll(values);

  List<T> removed(T value) => toList()..remove(value);

  List<T> removedAt(int index) => toList()..removeAt(index);

  List<T> removedWhere(bool Function(T element) test) =>
      toList()..removeWhere(test);

  /// Removes first object from this list that satisfies [test].
  void removeFirstWhere(bool Function(T element) test) {
    final found = indexWhere(test);
    if (found != -1) {
      removeAt(found);
    }
  }

  List<T> removedFirstWhere(bool Function(T element) test) =>
      toList()..removeFirstWhere(test);

  List<T> inserted(int index, T element) => toList()..insert(index, element);
}
