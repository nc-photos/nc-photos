part of 'search_landing.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.persons,
    required this.isPersonsLoading,
    required this.transformedPersonItems,
    required this.places,
    required this.isPlacesLoading,
    required this.transformedPlaceItems,
    this.error,
  });

  factory _State.init() => const _State(
    persons: [],
    isPersonsLoading: false,
    transformedPersonItems: [],
    places: LocationGroupResult([], [], [], []),
    isPlacesLoading: false,
    transformedPlaceItems: [],
  );

  @override
  String toString() => _$toString();

  final List<Person> persons;
  final bool isPersonsLoading;
  final List<_PersonItem> transformedPersonItems;
  final LocationGroupResult places;
  final bool isPlacesLoading;
  final List<_PlaceItem> transformedPlaceItems;

  final ExceptionEvent? error;
}

abstract class _Event {}

/// Load the list of [Person]s belonging to this account
@toString
class _LoadPersons implements _Event {
  const _LoadPersons();

  @override
  String toString() => _$toString();
}

@toString
class _TransformPersonItems implements _Event {
  const _TransformPersonItems(this.persons);

  @override
  String toString() => _$toString();

  final List<Person> persons;
}

/// Load the location groups belonging to this account
@toString
class _LoadPlaces implements _Event {
  const _LoadPlaces();

  @override
  String toString() => _$toString();
}

/// Transform the location groups (e.g., filtering, sorting, etc)
@toString
class _TransformPlaceItems implements _Event {
  const _TransformPlaceItems(this.places);

  @override
  String toString() => _$toString();

  final LocationGroupResult places;
}
