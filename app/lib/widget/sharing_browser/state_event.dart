part of '../sharing_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.items,
    required this.isLoading,
    required this.transformedItems,
    this.error,
  });

  factory _State.init() =>
      const _State(items: [], isLoading: true, transformedItems: []);

  @override
  String toString() => _$toString();

  final List<SharingStreamData> items;
  final bool isLoading;
  final List<_Item> transformedItems;

  final ExceptionEvent? error;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _TransformItems implements _Event {
  const _TransformItems(this.items);

  @override
  String toString() => _$toString();

  final List<SharingStreamData> items;
}

@toString
class _ListSharingBlocShareRemoved implements _Event {
  const _ListSharingBlocShareRemoved(this.shares);

  @override
  String toString() => _$toString();

  @Format(r"${$?.toReadableString()}")
  final List<Share> shares;
}

@toString
class _ListSharingBlocPendingSharedAlbumMoved implements _Event {
  const _ListSharingBlocPendingSharedAlbumMoved(
    this.account,
    this.file,
    this.destination,
  );

  @override
  String toString() => _$toString();

  final Account account;
  final File file;
  final String destination;
}
