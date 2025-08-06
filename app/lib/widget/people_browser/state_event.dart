part of '../people_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.persons,
    required this.isLoading,
    required this.transformedItems,
    this.error,
  });

  factory _State.init() =>
      const _State(persons: [], isLoading: false, transformedItems: []);

  @override
  String toString() => _$toString();

  final List<Person> persons;
  final bool isLoading;
  final List<_Item> transformedItems;

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
class _Reload implements _Event {
  const _Reload();

  @override
  String toString() => _$toString();
}

/// Transform the [Person] list (e.g., filtering, sorting, etc)
@toString
class _TransformItems implements _Event {
  const _TransformItems(this.persons);

  @override
  String toString() => _$toString();

  final List<Person> persons;
}
