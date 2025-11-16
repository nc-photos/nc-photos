part of 'archive_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.files,
    required this.isLoading,
    required this.transformedItems,
    required this.selectedItems,
    required this.visibleItems,
    required this.zoom,
    this.scale,
    this.error,
  });

  factory _State.init({required int zoom}) => _State(
    files: const [],
    isLoading: false,
    transformedItems: const [],
    selectedItems: const {},
    visibleItems: const {},
    zoom: zoom,
  );

  @override
  String toString() => _$toString();

  final List<FileDescriptor> files;
  final bool isLoading;
  final List<_Item> transformedItems;
  final Set<_Item> selectedItems;
  final Set<_VisibleItem> visibleItems;

  final int zoom;
  final double? scale;

  final ExceptionEvent? error;
}

abstract class _Event {}

/// Load the files
@toString
class _LoadItems implements _Event {
  const _LoadItems();

  @override
  String toString() => _$toString();
}

@toString
class _Reload implements _Event {
  const _Reload();

  @override
  String toString() => _$toString();
}

/// Transform the file list (e.g., filtering, sorting, etc)
@toString
class _TransformItems implements _Event {
  const _TransformItems(this.items);

  @override
  String toString() => _$toString();

  final List<FileDescriptor> items;
}

@toString
class _OnItemTransformed implements _Event {
  const _OnItemTransformed(this.items);

  @override
  String toString() => _$toString();

  final List<_Item> items;
}

/// Set the currently selected items
@toString
class _SetSelectedItems implements _Event {
  const _SetSelectedItems({required this.items});

  @override
  String toString() => _$toString();

  final Set<_Item> items;
}

@toString
class _UnarchiveSelectedItems implements _Event {
  const _UnarchiveSelectedItems();

  @override
  String toString() => _$toString();
}

@toString
class _StartScaling implements _Event {
  const _StartScaling();

  @override
  String toString() => _$toString();
}

@toString
class _EndScaling implements _Event {
  const _EndScaling();

  @override
  String toString() => _$toString();
}

@toString
class _SetScale implements _Event {
  const _SetScale(this.scale);

  @override
  String toString() => _$toString();

  final double scale;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
