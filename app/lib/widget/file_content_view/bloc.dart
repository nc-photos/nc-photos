part of '../file_content_view.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.prefController,
    required this.account,
    required this.file,
    required bool shouldPlayLivePhoto,
    required bool canZoom,
    required bool canPlay,
    required bool canLoop,
    required bool isPlayControlVisible,
  }) : super(_State.init(
          shouldPlayLivePhoto: shouldPlayLivePhoto,
          canZoom: canZoom,
          canPlay: canPlay,
          canLoop: canLoop,
          isPlayControlVisible: isPlayControlVisible,
        )) {
    on<_Init>(_onInit);
    on<_SetShouldPlayLivePhoto>(_onSetShouldPlayLivePhoto);
    on<_SetCanZoom>(_onSetCanZoom);
    on<_SetCanPlay>(_onSetCanPlay);
    on<_SetCanLoop>(_onSetCanLoop);
    on<_SetIsPlayControlVisible>(_onSetIsPlayControlVisible);
    on<_SetLoaded>(_onSetLoaded);
    on<_SetVideoMetadata>(_onSetVideoMetadata);
    on<_SetIsZoomed>(_onSetIsZoomed);
    on<_SetContentHeight>(_onSetContentHeight);
    on<_ToggleVideoPlay>(_onToggleVideoPlay);
    on<_ToggleVideoLoop>(_onToggleVideoLoop);
    on<_ToggleVideoMute>(_onToggleVideoMute);
    on<_UpdateVideoPlayerValue>(_onUpdateVideoPlayerValue);
    on<_SetLivePhotoLoadFailed>(_onSetLivePhotoLoadFailed);

    on<_SetError>(_onSetError);
  }

  @override
  Future<void> close() {
    _videoController?.dispose();
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  @override
  void onError(Object error, StackTrace stackTrace) {
    // we need this to prevent onError being triggered recursively
    if (!isClosed && !_isHandlingError) {
      _isHandlingError = true;
      try {
        add(_SetError(error, stackTrace));
      } catch (_) {}
      _isHandlingError = false;
    }
    super.onError(error, stackTrace);
  }

  // Read only!
  VideoPlayerController get videoController => _videoController!;

  Future<void> _onInit(_Init ev, _Emitter emit) async {
    _log.info(ev);
    if (file_util.isSupportedVideoFormat(file)) {
      return _initVideo(emit);
    }
  }

  void _onSetShouldPlayLivePhoto(_SetShouldPlayLivePhoto ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(shouldPlayLivePhoto: ev.value));
  }

  void _onSetCanZoom(_SetCanZoom ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(canZoom: ev.value));
  }

  void _onSetCanPlay(_SetCanPlay ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(canPlay: ev.value));
    if (_videoController?.value.isPlaying == true && !ev.value) {
      _videoController?.pause();
    }
  }

  void _onSetCanLoop(_SetCanLoop ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(canLoop: ev.value));
  }

  void _onSetIsPlayControlVisible(_SetIsPlayControlVisible ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isPlayControlVisible: ev.value));
  }

  void _onSetLoaded(_SetLoaded ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isLoaded: true));
  }

  void _onSetVideoMetadata(_SetVideoMetadata ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      videoAspectRatio: ev.aspectRatio,
      videoDuration: ev.duration,
    ));
  }

  void _onSetIsZoomed(_SetIsZoomed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isZoomed: ev.value));
  }

  void _onSetContentHeight(_SetContentHeight ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(contentHeight: ev.value));
  }

  void _onToggleVideoPlay(_ToggleVideoPlay ev, _Emitter emit) {
    _log.info(ev);
    if (_videoController == null) {
      _log.severe("[_onToggleVideoPlay] Video controller is null");
      return;
    }
    final willPlay = !state.isPlaying;
    if (willPlay) {
      if (_videoController!.value.position ==
          _videoController!.value.duration) {
        _videoController!.seekTo(const Duration()).then((_) {
          if (state.canPlay) {
            _videoController!.play();
          }
        });
      } else {
        if (state.canPlay) {
          _videoController!.play();
        }
      }
    } else {
      _videoController!.pause();
    }
  }

  void _onToggleVideoLoop(_ToggleVideoLoop ev, _Emitter emit) {
    _log.info(ev);
    if (_videoController == null) {
      _log.severe("[_onToggleVideoLoop] Video controller is null");
      return;
    }
    final willLoop = _videoController!.value.isLooping == false;
    _videoController!.setLooping(willLoop);
    prefController.setVideoPlayerLoop(willLoop);
  }

  void _onToggleVideoMute(_ToggleVideoMute ev, _Emitter emit) {
    _log.info(ev);
    if (_videoController == null) {
      _log.severe("[_onToggleVideoMute] Video controller is null");
      return;
    }
    final willMute = _videoController!.value.volume != 0;
    _videoController!.setVolume(willMute ? 0 : 1);
    prefController.setVideoPlayerMute(willMute);
  }

  void _onUpdateVideoPlayerValue(_UpdateVideoPlayerValue ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      isPlaying: ev.value.isPlaying,
      videoIsLooping: ev.value.isLooping,
      videoVolume: ev.value.volume,
    ));
    if (ev.value.isPlaying && ev.value.position == ev.value.duration) {
      // finished
      _videoController?.pause();
    }
  }

  void _onSetLivePhotoLoadFailed(_SetLivePhotoLoadFailed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      shouldPlayLivePhoto: false,
      error: (error: ev.error, stackTrace: ev.stackTrace),
    ));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: (error: ev.error, stackTrace: ev.stackTrace)));
  }

  Future<void> _initVideo(_Emitter emit) async {
    try {
      final controller = await _initVideoController();
      _videoController = controller;
      unawaited(
          controller.setVolume(prefController.isVideoPlayerMuteValue ? 0 : 1));
      if (state.canLoop) {
        unawaited(controller.setLooping(prefController.isVideoPlayerLoopValue));
      }
      add(_SetVideoMetadata(
        aspectRatio: controller.value.aspectRatio,
        duration: controller.value.duration,
      ));
      add(const _SetLoaded());
      controller.addListener(() {
        if (_videoController != null) {
          add(_UpdateVideoPlayerValue(_videoController!.value));
        }
      });
      if (state.canPlay) {
        unawaited(controller.play());
      }
    } catch (e, stackTrace) {
      _log.shout("[_initVideo] Failed while initialize", e, stackTrace);
      emit(state.copyWith(loadError: (error: e, stackTrace: stackTrace)));
    }
  }

  Future<VideoPlayerController> _initVideoController() async {
    if (getRawPlatform() != NpPlatform.web) {
      try {
        return await _initVideoControllerWithFileUrl();
      } catch (e, stackTrace) {
        _log.warning(
            "[_initVideoController] Failed while _initVideoControllerWithFileUrl",
            e,
            stackTrace);
      }
    }
    return await _initVideoControllerWithPublicUrl();
  }

  Future<VideoPlayerController> _initVideoControllerWithFileUrl() async {
    final uri = api_util.getFileUri(account, file);
    _log.fine("[_initVideoWithFileUrl] URI: $uri");
    final controller = VideoPlayerController.networkUrl(
      uri,
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
    );
    await controller.initialize();
    return controller;
  }

  Future<VideoPlayerController> _initVideoControllerWithPublicUrl() async {
    final url = await RequestPublicLink()(account, file);
    _log.fine("[_initVideoControllerWithPublicUrl] URL: $url");
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
    );
    await controller.initialize();
    return controller;
  }

  final PrefController prefController;
  final Account account;
  final FileDescriptor file;

  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;

  VideoPlayerController? _videoController;
}
