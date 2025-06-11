part of 'viewer_detail_pane.dart';

@genCopyWith
@toString
final class _State {
  const _State({
    this.isOwned,
    this.owner,
    this.size,
    this.byteSize,
    this.model,
    this.fNumber,
    this.exposureTime,
    this.focalLength,
    this.isoSpeedRatings,
    this.gps,
    this.location,
    this.tags,
    required this.canRemoveFromAlbum,
    required this.canSetCover,
    required this.canAddToCollection,
    required this.canSetAs,
    required this.canArchive,
    required this.canDelete,
    this.error,
  });

  factory _State.init() => const _State(
    canRemoveFromAlbum: false,
    canSetCover: false,
    canAddToCollection: false,
    canSetAs: false,
    canArchive: false,
    canDelete: false,
  );

  @override
  String toString() => _$toString();

  final bool? isOwned;
  final String? owner;
  final SizeInt? size;
  final int? byteSize;
  final String? model;
  final double? fNumber;
  final String? exposureTime;
  final double? focalLength;
  final int? isoSpeedRatings;
  final MapCoord? gps;
  final ImageLocation? location;
  final List<AnyFileTag>? tags;

  final bool canRemoveFromAlbum;
  final bool canSetCover;
  final bool canAddToCollection;
  final bool canSetAs;
  final bool canArchive;
  final bool canDelete;

  final ExceptionEvent? error;
}

sealed class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _SetAlbumCover implements _Event {
  const _SetAlbumCover();

  @override
  String toString() => _$toString();
}
