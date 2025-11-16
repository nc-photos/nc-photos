part of 'places_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.places,
    required this.isLoading,
    required this.transformedPlaceItems,
    required this.transformedCountryItems,
    this.error,
  });

  factory _State.init() => const _State(
    places: LocationGroupResult([], [], [], []),
    isLoading: false,
    transformedPlaceItems: [],
    transformedCountryItems: [],
  );

  @override
  String toString() => _$toString();

  final LocationGroupResult places;
  final bool isLoading;
  final List<_Item> transformedPlaceItems;
  final List<_Item> transformedCountryItems;

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
