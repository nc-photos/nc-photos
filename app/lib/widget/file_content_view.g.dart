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
      bool? isPlayControlVisible,
      bool? isLoaded,
      bool? isZoomed,
      bool? isPlaying,
      Unique<bool>? isLivePhotoLoadFailed,
      double? contentHeight,
      ExceptionEvent? error});
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call(
      {dynamic shouldPlayLivePhoto,
      dynamic canZoom,
      dynamic canPlay,
      dynamic isPlayControlVisible,
      dynamic isLoaded,
      dynamic isZoomed,
      dynamic isPlaying,
      dynamic isLivePhotoLoadFailed,
      dynamic contentHeight = copyWithNull,
      dynamic error = copyWithNull}) {
    return _State(
        shouldPlayLivePhoto:
            shouldPlayLivePhoto as bool? ?? that.shouldPlayLivePhoto,
        canZoom: canZoom as bool? ?? that.canZoom,
        canPlay: canPlay as bool? ?? that.canPlay,
        isPlayControlVisible:
            isPlayControlVisible as bool? ?? that.isPlayControlVisible,
        isLoaded: isLoaded as bool? ?? that.isLoaded,
        isZoomed: isZoomed as bool? ?? that.isZoomed,
        isPlaying: isPlaying as bool? ?? that.isPlaying,
        isLivePhotoLoadFailed: isLivePhotoLoadFailed as Unique<bool>? ??
            that.isLivePhotoLoadFailed,
        contentHeight: contentHeight == copyWithNull
            ? that.contentHeight
            : contentHeight as double?,
        error: error == copyWithNull ? that.error : error as ExceptionEvent?);
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
    return "_State {shouldPlayLivePhoto: $shouldPlayLivePhoto, canZoom: $canZoom, canPlay: $canPlay, isPlayControlVisible: $isPlayControlVisible, isLoaded: $isLoaded, isZoomed: $isZoomed, isPlaying: $isPlaying, isLivePhotoLoadFailed: $isLivePhotoLoadFailed, contentHeight: ${contentHeight == null ? null : "${contentHeight!.toStringAsFixed(3)}"}, error: $error}";
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

extension _$_SetPlayingToString on _SetPlaying {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPlaying {}";
  }
}

extension _$_SetPauseToString on _SetPause {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPause {}";
  }
}

extension _$_SetLivePhotoLoadFailedToString on _SetLivePhotoLoadFailed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetLivePhotoLoadFailed {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
