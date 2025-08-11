import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:np_collection/src/list_extension.dart';
import 'package:quiver/iterables.dart';

extension IterableExtension<T> on Iterable<T> {
  /// Return a new stable sorted list
  List<T> stableSorted([int Function(T a, T b)? compare]) =>
      toList()..stableSort(compare);

  /// Return a string representation of this iterable by joining the result of
  /// toString for each items
  String toReadableString({int truncate = -1}) {
    return switch (truncate) {
      <= 0 => "[${join(', ')}]",
      _ => "[${take(truncate).join(', ')},...]",
    };
  }

  Iterable<({int i, T e})> withIndex() => mapIndexed((i, e) => (i: i, e: e));

  /// Whether the collection contains an element equal to [element] using the
  /// equality function [equalFn]
  bool containsIf(T element, bool Function(T a, T b) equalFn) =>
      any((e) => equalFn(e, element));

  /// Same as [contains] but uses [identical] to compare the objects
  bool containsIdentical(T element) =>
      containsIf(element, (a, b) => identical(a, b));

  Map<U, List<T>> groupBy<U>({required U Function(T e) key}) {
    return fold<Map<U, List<T>>>(
      {},
      (previousValue, element) =>
          previousValue..putIfAbsent(key(element), () => []).add(element),
    );
  }

  /// Return a new list with only distinct elements
  List<T> distinct() {
    final s = <T>{};
    return where((element) => s.add(element)).toList();
  }

  /// Return a new list with only distinct elements determined by [equalFn]
  List<T> distinctIf(
    bool Function(T a, T b) equalFn,
    int Function(T a) hashCodeFn,
  ) {
    final s = LinkedHashSet(equals: equalFn, hashCode: hashCodeFn);
    return where((element) => s.add(element)).toList();
  }

  /// Invokes [action] on each element of this iterable in iteration order
  /// lazily
  Iterable<T> forEachLazy(void Function(T element) action) sync* {
    for (final e in this) {
      action(e);
      yield e;
    }
  }

  /// Return a list containing elements in this iterable
  ///
  /// If this Iterable is itself a list, this will be returned directly with no
  /// copying
  List<T> asList() {
    if (this is List) {
      return this as List<T>;
    } else {
      return toList();
    }
  }

  /// The first index of [element] in this iterable
  ///
  /// Searches the list from index start to the end of the list. The first time
  /// an object o is encountered so that o == element, the index of o is
  /// returned. Returns -1 if element is not found.
  int indexOf(T element, [int start = 0]) {
    var i = 0;
    for (final e in this) {
      final j = i++;
      if (j < start) {
        continue;
      }
      if (e == element) {
        return j;
      }
    }
    return -1;
  }

  /// The first index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned. Returns -1 if [element] is not found.
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    var i = 0;
    for (final e in this) {
      final j = i++;
      if (j < start) {
        continue;
      }
      if (test(e)) {
        return j;
      }
    }
    return -1;
  }

  Future<List<U>> withPartition<U>(
    FutureOr<Iterable<U>> Function(Iterable<T> sublist) fn,
    int size,
  ) async {
    final products = <U>[];
    final sublists = partition(this, size);
    for (final l in sublists) {
      products.addAll(await fn(l));
    }
    return products;
  }

  Future<void> withPartitionNoReturn(
    FutureOr<void> Function(Iterable<T> sublist) fn,
    int size,
  ) async {
    final sublists = partition(this, size);
    for (final l in sublists) {
      await fn(l);
    }
  }

  Iterable<T> separated(T Function(int index) separatorBuilder) sync* {
    for (final e in indexed) {
      yield e.$2;
      if (e.$1 < length - 1) {
        yield separatorBuilder(e.$1);
      }
    }
  }
}

extension IterableFlattenExtension<T> on Iterable<Iterable<T>> {
  /// Flattens an [Iterable] of [Iterable] values of type [T] to a [Iterable] of
  /// values of type [T].
  ///
  /// This function originated in the xml package
  Iterable<T> flatten() => expand((values) => values);
}

extension IterableComparableExtension<T extends Comparable<T>> on Iterable<T> {
  List<T> sortedBySelf() => sortedBy((e) => e);
}
