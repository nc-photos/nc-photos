part of '../file_content_view.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.shouldPlayLivePhoto,
    required this.canZoom,
    required this.canPlay,
    required this.canLoop,
    required this.isPlayControlVisible,
    required this.isLoaded,
    required this.isZoomed,
    required this.isPlaying,
    required this.videoAspectRatio,
    required this.videoDuration,
    required this.videoIsLooping,
    required this.videoVolume,
    this.contentHeight,
    this.error,
    this.loadError,
  });

  factory _State.init({
    required bool shouldPlayLivePhoto,
    required bool canZoom,
    required bool canPlay,
    required bool canLoop,
    required bool isPlayControlVisible,
  }) => _State(
    shouldPlayLivePhoto: shouldPlayLivePhoto,
    canZoom: canZoom,
    canPlay: canPlay,
    canLoop: canLoop,
    isPlayControlVisible: isPlayControlVisible,
    isLoaded: false,
    isZoomed: false,
    isPlaying: false,
    videoAspectRatio: 1,
    videoDuration: Duration.zero,
    videoIsLooping: false,
    videoVolume: 0,
  );

  @override
  String toString() => _$toString();

  final bool shouldPlayLivePhoto;
  final bool canZoom;
  final bool canPlay;
  final bool canLoop;
  final bool isPlayControlVisible;
  final bool isLoaded;
  final bool isZoomed;
  final bool isPlaying;
  final double? contentHeight;

  // video player
  final double videoAspectRatio;
  final Duration videoDuration;
  final bool videoIsLooping;
  final double videoVolume;

  final ({Object error, StackTrace? stackTrace})? error;
  final ({Object error, StackTrace? stackTrace})? loadError;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _SetShouldPlayLivePhoto implements _Event {
  const _SetShouldPlayLivePhoto(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetCanZoom implements _Event {
  const _SetCanZoom(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetCanPlay implements _Event {
  const _SetCanPlay(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetCanLoop implements _Event {
  const _SetCanLoop(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetIsPlayControlVisible implements _Event {
  const _SetIsPlayControlVisible(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetLoaded implements _Event {
  const _SetLoaded();

  @override
  String toString() => _$toString();
}

@toString
class _SetVideoMetadata implements _Event {
  const _SetVideoMetadata({required this.aspectRatio, required this.duration});

  @override
  String toString() => _$toString();

  final double aspectRatio;
  final Duration duration;
}

@toString
class _SetContentHeight implements _Event {
  const _SetContentHeight(this.value);

  @override
  String toString() => _$toString();

  final double value;
}

@toString
class _SetIsZoomed implements _Event {
  const _SetIsZoomed(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _ToggleVideoPlay implements _Event {
  const _ToggleVideoPlay();

  @override
  String toString() => _$toString();
}

@toString
class _ToggleVideoLoop implements _Event {
  const _ToggleVideoLoop();

  @override
  String toString() => _$toString();
}

@toString
class _ToggleVideoMute implements _Event {
  const _ToggleVideoMute();

  @override
  String toString() => _$toString();
}

@toString
class _UpdateVideoPlayerValue implements _Event {
  const _UpdateVideoPlayerValue(this.value);

  @override
  String toString() => _$toString();

  final VideoPlayerValue value;
}

@toString
class _SetLivePhotoLoadFailed implements _Event {
  const _SetLivePhotoLoadFailed(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
