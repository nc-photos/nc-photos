import 'dart:async';

extension MapEntryListExtension<T, U> on Iterable<MapEntry<T, U>> {
  Map<T, U> toMap() => Map.fromEntries(this);
}

extension MapExtension<T, U> on Map<T, U> {
  Future<Map<V, W>> asyncMap<V, W>(
    FutureOr<MapEntry<V, W>> Function(T key, U value) convert,
  ) async {
    final results = await Future.wait(
      entries.map((e) async => await convert(e.key, e.value)),
    );
    return Map.fromEntries(results);
  }

  Map<T, U> addedAll(Map<T, U> other) => {...this, ...other};
}
