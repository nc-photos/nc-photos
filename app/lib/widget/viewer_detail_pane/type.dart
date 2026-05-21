part of 'viewer_detail_pane.dart';

@toString
class _SetAlbumCoverFailedError implements Exception {
  const _SetAlbumCoverFailedError();

  @override
  String toString() => _$toString();
}

@toString
class _EditMetadataProgress {
  const _EditMetadataProgress({required this.step, required this.progress});

  @override
  String toString() => _$toString();

  final UpdateAnyFileMetadataStep step;
  final double progress;
}
