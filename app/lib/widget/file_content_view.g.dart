// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_content_view.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call(
      {bool? shouldPlayLivePhoto,
      bool? canZoom,
      bool? canPlay,
      bool? canLoop,
      bool? isPlayControlVisible,
      bool? isLoaded,
      bool? isZoomed,
      bool? isPlaying,
      double? contentHeight,
      double? videoAspectRatio,
      Duration? videoDuration,
      bool? videoIsLooping,
      double? videoVolume,
      ({Object error, StackTrace? stackTrace})? error,
      ({Object error, StackTrace? stackTrace})? loadError});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call(
      {dynamic shouldPlayLivePhoto,
      dynamic canZoom,
      dynamic canPlay,
      dynamic canLoop,
      dynamic isPlayControlVisible,
      dynamic isLoaded,
      dynamic isZoomed,
      dynamic isPlaying,
      dynamic contentHeight = copyWithNull,
      dynamic videoAspectRatio,
      dynamic videoDuration,
      dynamic videoIsLooping,
      dynamic videoVolume,
      dynamic error = copyWithNull,
      dynamic loadError = copyWithNull}) {
    return _State(
        shouldPlayLivePhoto:
            shouldPlayLivePhoto as bool? ?? that.shouldPlayLivePhoto,
        canZoom: canZoom as bool? ?? that.canZoom,
        canPlay: canPlay as bool? ?? that.canPlay,
        canLoop: canLoop as bool? ?? that.canLoop,
        isPlayControlVisible:
            isPlayControlVisible as bool? ?? that.isPlayControlVisible,
        isLoaded: isLoaded as bool? ?? that.isLoaded,
        isZoomed: isZoomed as bool? ?? that.isZoomed,
        isPlaying: isPlaying as bool? ?? that.isPlaying,
        contentHeight: contentHeight == copyWithNull
            ? that.contentHeight
            : contentHeight as double?,
        videoAspectRatio: videoAspectRatio as double? ?? that.videoAspectRatio,
        videoDuration: videoDuration as Duration? ?? that.videoDuration,
        videoIsLooping: videoIsLooping as bool? ?? that.videoIsLooping,
        videoVolume: videoVolume as double? ?? that.videoVolume,
        error: error == copyWithNull
            ? that.error
            : error as ({Object error, StackTrace? stackTrace})?,
        loadError: loadError == copyWithNull
            ? that.loadError
            : loadError as ({Object error, StackTrace? stackTrace})?);
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$FileContentViewNpLog on FileContentView {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.file_content_view.FileContentView");
}

extension _$_WrappedFileContentViewNpLog on _WrappedFileContentView {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.file_content_view._WrappedFileContentView");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.file_content_view._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {shouldPlayLivePhoto: $shouldPlayLivePhoto, canZoom: $canZoom, canPlay: $canPlay, canLoop: $canLoop, isPlayControlVisible: $isPlayControlVisible, isLoaded: $isLoaded, isZoomed: $isZoomed, isPlaying: $isPlaying, contentHeight: ${contentHeight == null ? null : "${contentHeight!.toStringAsFixed(3)}"}, videoAspectRatio: ${videoAspectRatio.toStringAsFixed(3)}, videoDuration: $videoDuration, videoIsLooping: $videoIsLooping, videoVolume: ${videoVolume.toStringAsFixed(3)}, error: $error, loadError: $loadError}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetShouldPlayLivePhotoToString on _SetShouldPlayLivePhoto {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetShouldPlayLivePhoto {value: $value}";
  }
}

extension _$_SetCanZoomToString on _SetCanZoom {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCanZoom {value: $value}";
  }
}

extension _$_SetCanPlayToString on _SetCanPlay {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCanPlay {value: $value}";
  }
}

extension _$_SetCanLoopToString on _SetCanLoop {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCanLoop {value: $value}";
  }
}

extension _$_SetIsPlayControlVisibleToString on _SetIsPlayControlVisible {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetIsPlayControlVisible {value: $value}";
  }
}

extension _$_SetLoadedToString on _SetLoaded {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetLoaded {}";
  }
}

extension _$_SetVideoMetadataToString on _SetVideoMetadata {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetVideoMetadata {aspectRatio: ${aspectRatio.toStringAsFixed(3)}, duration: $duration}";
  }
}

extension _$_SetContentHeightToString on _SetContentHeight {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetContentHeight {value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetIsZoomedToString on _SetIsZoomed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetIsZoomed {value: $value}";
  }
}

extension _$_ToggleVideoPlayToString on _ToggleVideoPlay {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleVideoPlay {}";
  }
}

extension _$_ToggleVideoLoopToString on _ToggleVideoLoop {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleVideoLoop {}";
  }
}

extension _$_ToggleVideoMuteToString on _ToggleVideoMute {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleVideoMute {}";
  }
}

extension _$_UpdateVideoPlayerValueToString on _UpdateVideoPlayerValue {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UpdateVideoPlayerValue {value: $value}";
  }
}

extension _$_SetLivePhotoLoadFailedToString on _SetLivePhotoLoadFailed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetLivePhotoLoadFailed {error: $error, stackTrace: $stackTrace}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
