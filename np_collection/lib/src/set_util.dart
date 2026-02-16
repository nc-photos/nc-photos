extension SetExtension<T> on Set<T> {
  Set<T> added(T element) => toSet()..add(element);
  Set<T> addedAll(Iterable<T> elements) => toSet()..addAll(elements);

  Set<T> removed(T element) => toSet()..remove(element);
  Set<T> removedAll(Iterable<T> elements) => toSet()..removeAll(elements);
}
