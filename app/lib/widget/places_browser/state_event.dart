part of 'places_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.places,
    required this.isLoading,
    required this.transformedPlaceItems,
    required this.transformedCountryItems,
    required this.sort,
    this.error,
  });

  factory _State.init({required PlaceSort sort}) => _State(
    places: const LocationGroupResult([], [], [], []),
    isLoading: false,
    transformedPlaceItems: const [],
    transformedCountryItems: const [],
    sort: sort,
  );

  @override
  String toString() => _$toString();

  final LocationGroupResult places;
  final bool isLoading;
  final List<_Item> transformedPlaceItems;
  final List<_Item> transformedCountryItems;
  final PlaceSort sort;

  final ExceptionEvent? error;
}

abstract class _Event {}

/// Load the location groups belonging to this account
@toString
class _LoadPlaces implements _Event {
  const _LoadPlaces();

  @override
  String toString() => _$toString();
}

@toString
class _Reload implements _Event {
  const _Reload();

  @override
  String toString() => _$toString();
}

/// Transform the location groups (e.g., filtering, sorting, etc)
@toString
class _TransformItems implements _Event {
  const _TransformItems(this.places);

  @override
  String toString() => _$toString();

  final LocationGroupResult places;
}

@toString
class _SetSort implements _Event {
  const _SetSort(this.sort);

  @override
  String toString() => _$toString();

  final PlaceSort sort;
}
