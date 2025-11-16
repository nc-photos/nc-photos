// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_landing.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<Person>? persons,
    bool? isPersonsLoading,
    List<_PersonItem>? transformedPersonItems,
    LocationGroupResult? places,
    bool? isPlacesLoading,
    List<_PlaceItem>? transformedPlaceItems,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic persons,
    dynamic isPersonsLoading,
    dynamic transformedPersonItems,
    dynamic places,
    dynamic isPlacesLoading,
    dynamic transformedPlaceItems,
    dynamic error = copyWithNull,
  }) {
    return _State(
      persons: persons as List<Person>? ?? that.persons,
      isPersonsLoading: isPersonsLoading as bool? ?? that.isPersonsLoading,
      transformedPersonItems:
          transformedPersonItems as List<_PersonItem>? ??
          that.transformedPersonItems,
      places: places as LocationGroupResult? ?? that.places,
      isPlacesLoading: isPlacesLoading as bool? ?? that.isPlacesLoading,
      transformedPlaceItems:
          transformedPlaceItems as List<_PlaceItem>? ??
          that.transformedPlaceItems,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_WrappedSearchLandingStateNpLog on _WrappedSearchLandingState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.search_landing.search_landing._WrappedSearchLandingState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.search_landing.search_landing._Bloc");
}

extension _$_PersonItemNpLog on _PersonItem {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.search_landing.search_landing._PersonItem");
}

extension _$_PlaceItemNpLog on _PlaceItem {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.search_landing.search_landing._PlaceItem");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {persons: [length: ${persons.length}], isPersonsLoading: $isPersonsLoading, transformedPersonItems: [length: ${transformedPersonItems.length}], places: $places, isPlacesLoading: $isPlacesLoading, transformedPlaceItems: [length: ${transformedPlaceItems.length}], error: $error}";
  }
}

extension _$_LoadPersonsToString on _LoadPersons {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadPersons {}";
  }
}

extension _$_TransformPersonItemsToString on _TransformPersonItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformPersonItems {persons: [length: ${persons.length}]}";
  }
}

extension _$_LoadPlacesToString on _LoadPlaces {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadPlaces {}";
  }
}

extension _$_TransformPlaceItemsToString on _TransformPlaceItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformPlaceItems {places: $places}";
  }
}
