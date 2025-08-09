part of '../home_photos2.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.files,
    required this.isLoading,
    required this.transformedItems,
    required this.selectedItems,
    required this.visibleDates,
    required this.queriedDates,
    required this.isEnableMemoryCollection,
    required this.memoryCollections,
    this.syncProgress,
    required this.zoom,
    this.scale,
    required this.finger,
    this.viewWidth,
    this.viewHeight,
    this.viewOverlayPadding,
    this.itemPerRow,
    this.itemSize,
    required this.isScrolling,
    required this.filesSummary,
    this.minimapItems,
    required this.minimapYRatio,
    this.scrollDate,
    required this.hasMissingVideoPreview,
    this.error,
  });

  factory _State.init({
    required bool isEnableMemoryCollection,
    required int zoom,
  }) => _State(
    files: const [],
    isLoading: false,
    transformedItems: const [],
    selectedItems: const {},
    visibleDates: const {},
    queriedDates: const {},
    isEnableMemoryCollection: isEnableMemoryCollection,
    memoryCollections: const [],
    zoom: zoom,
    finger: 0,
    isScrolling: false,
    filesSummary: const DbFilesSummary(items: {}),
    minimapYRatio: 1,
    hasMissingVideoPreview: false,
  );

  @override
  String toString() => _$toString();

  final List<FileDescriptor> files;
  final bool isLoading;
  final List<List<_Item>> transformedItems;
  final Set<_Item> selectedItems;
  final DbFilesSummary filesSummary;
  final Set<_VisibleDate> visibleDates;
  final Set<Date> queriedDates;

  final bool isEnableMemoryCollection;
  final List<Collection> memoryCollections;

  final Progress? syncProgress;

  final int zoom;
  final double? scale;
  final int finger;

  final double? viewWidth;
  final double? viewHeight;
  final double? viewOverlayPadding;
  final int? itemPerRow;
  final double? itemSize;
  final bool isScrolling;
  final List<_MinimapItem>? minimapItems;
  final double minimapYRatio;
  final Date? scrollDate;

  final bool hasMissingVideoPreview;

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

/// User explicitly requested to refresh the data, e.g., performed the
/// pull-to-refresh action
@toString
class _RequestRefresh implements _Event {
  const _RequestRefresh();

  @override
  String toString() => _$toString();
}

/// Transform the file list (e.g., filtering, sorting, etc)
@toString
class _TransformItems implements _Event {
  const _TransformItems(this.files, this.summary);

  @override
  String toString() => _$toString();

  final List<FileDescriptor> files;
  final DbFilesSummary summary;
}

@toString
class _OnItemTransformed implements _Event {
  const _OnItemTransformed(this.items, this.dates);

  @override
  String toString() => _$toString();

  final List<List<_Item>> items;
  final Set<Date> dates;
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
class _AddSelectedItemsToCollection implements _Event {
  const _AddSelectedItemsToCollection(this.collection);

  @override
  String toString() => _$toString();

  final Collection collection;
}

@toString
class _ArchiveSelectedItems implements _Event {
  const _ArchiveSelectedItems();

  @override
  String toString() => _$toString();
}

@toString
class _DeleteSelectedItems implements _Event {
  const _DeleteSelectedItems();

  @override
  String toString() => _$toString();
}

@toString
class _DownloadSelectedItems implements _Event {
  const _DownloadSelectedItems();

  @override
  String toString() => _$toString();
}

@toString
class _AddVisibleDate implements _Event {
  const _AddVisibleDate(this.date);

  @override
  String toString() => _$toString();

  final _VisibleDate date;
}

@toString
class _RemoveVisibleDate implements _Event {
  const _RemoveVisibleDate(this.date);

  @override
  String toString() => _$toString();

  final _VisibleDate date;
}

@toString
class _SetSyncProgress implements _Event {
  const _SetSyncProgress(this.progress);

  @override
  String toString() => _$toString();

  final Progress? progress;
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
class _SetFinger implements _Event {
  const _SetFinger(this.value);

  @override
  String toString() => _$toString();

  final int value;
}

@toString
class _StartScrolling implements _Event {
  const _StartScrolling();

  @override
  String toString() => _$toString();
}

@toString
class _EndScrolling implements _Event {
  const _EndScrolling();

  @override
  String toString() => _$toString();
}

@toString
class _SetLayoutConstraint implements _Event {
  const _SetLayoutConstraint(
    this.viewWidth,
    this.viewHeight,
    this.viewOverlayPadding,
  );

  @override
  String toString() => _$toString();

  final double viewWidth;
  final double viewHeight;
  final double viewOverlayPadding;
}

@toString
class _TransformMinimap implements _Event {
  const _TransformMinimap();

  @override
  String toString() => _$toString();
}

@toString
class _UpdateScrollDate implements _Event {
  const _UpdateScrollDate();

  @override
  String toString() => _$toString();
}

@toString
class _SetEnableMemoryCollection implements _Event {
  const _SetEnableMemoryCollection(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _UpdateZoom implements _Event {
  const _UpdateZoom();

  @override
  String toString() => _$toString();
}

@toString
class _UpdateDateTimeGroup implements _Event {
  const _UpdateDateTimeGroup();

  @override
  String toString() => _$toString();
}

@toString
class _UpdateMemories implements _Event {
  const _UpdateMemories();

  @override
  String toString() => _$toString();
}

@toString
class _TripMissingVideoPreview implements _Event {
  const _TripMissingVideoPreview();

  @override
  String toString() => _$toString();
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
