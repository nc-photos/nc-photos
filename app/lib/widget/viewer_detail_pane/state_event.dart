part of 'viewer_detail_pane.dart';

@genCopyWith
@toString
final class _State {
  const _State({
    required this.file,
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
    this.offsetTime,
    this.fps,
    this.duration,
    required this.canRemoveFromAlbum,
    required this.canSetCover,
    required this.canAddToCollection,
    required this.canSetAs,
    required this.canArchive,
    required this.canDelete,
    this.editMetadataProgress,
    this.error,
  });

  factory _State.init({required AnyFile file}) => _State(
    file: file,
    canRemoveFromAlbum: false,
    canSetCover: false,
    canAddToCollection: false,
    canSetAs: false,
    canArchive: false,
    canDelete: false,
  );

  @override
  String toString() => _$toString();

  final AnyFile file;
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
  final Duration? offsetTime;
  final double? fps;
  final Duration? duration;

  final bool canRemoveFromAlbum;
  final bool canSetCover;
  final bool canAddToCollection;
  final bool canSetAs;
  final bool canArchive;
  final bool canDelete;

  final _EditMetadataProgress? editMetadataProgress;

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

@toString
class _SetFile implements _Event {
  const _SetFile(this.file);

  @override
  String toString() => _$toString();

  final AnyFile file;
}

@toString
class _FileUpdated implements _Event {
  const _FileUpdated();

  @override
  String toString() => _$toString();
}

@toString
class _EditDateTime implements _Event {
  const _EditDateTime(this.value);

  @override
  String toString() => _$toString();

  final ZonedDateTime value;
}
