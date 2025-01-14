part of '../file_content_view.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.shouldPlayLivePhoto,
    required this.canZoom,
    required this.canPlay,
    required this.isPlayControlVisible,
    required this.isLoaded,
    required this.isZoomed,
    required this.isPlaying,
    required this.isLivePhotoLoadFailed,
    this.contentHeight,
    this.error,
  });

  factory _State.init({
    required bool shouldPlayLivePhoto,
    required bool canZoom,
    required bool canPlay,
    required bool isPlayControlVisible,
  }) =>
      _State(
        shouldPlayLivePhoto: shouldPlayLivePhoto,
        canZoom: canZoom,
        canPlay: canPlay,
        isPlayControlVisible: isPlayControlVisible,
        isLoaded: false,
        isZoomed: false,
        isPlaying: false,
        isLivePhotoLoadFailed: Unique(false),
      );

  @override
  String toString() => _$toString();

  final bool shouldPlayLivePhoto;
  final bool canZoom;
  final bool canPlay;
  final bool isPlayControlVisible;
  final bool isLoaded;
  final bool isZoomed;
  final bool isPlaying;
  final Unique<bool> isLivePhotoLoadFailed;
  final double? contentHeight;

  final ExceptionEvent? error;
}

abstract class _Event {}

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
class _SetPlaying implements _Event {
  const _SetPlaying();

  @override
  String toString() => _$toString();
}

@toString
class _SetPause implements _Event {
  const _SetPause();

  @override
  String toString() => _$toString();
}

@toString
class _SetLivePhotoLoadFailed implements _Event {
  const _SetLivePhotoLoadFailed();

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
