part of 'collection_picker.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.collections,
    required this.isLoading,
    required this.transformedItems,
    this.result,
    this.error,
  });

  factory _State.init() {
    return const _State(
      collections: [],
      isLoading: false,
      transformedItems: [],
    );
  }

  @override
  String toString() => _$toString();

  final List<Collection> collections;
  final bool isLoading;
  final List<_Item> transformedItems;
  final Collection? result;

  final ExceptionEvent? error;
}

abstract class _Event {
  const _Event();
}

/// Load the list of collections belonging to this account
@toString
class _LoadCollections implements _Event {
  const _LoadCollections();

  @override
  String toString() => _$toString();
}

/// Transform the collection list (e.g., filtering, sorting, etc)
@toString
class _TransformItems implements _Event {
  const _TransformItems(this.collections);

  @override
  String toString() => _$toString();

  final List<Collection> collections;
}

/// Select a collection
@toString
class _SelectCollection implements _Event {
  const _SelectCollection(this.collection);

  @override
  String toString() => _$toString();

  final Collection collection;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
