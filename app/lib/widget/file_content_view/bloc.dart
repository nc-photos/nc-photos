part of '../file_content_view.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.account,
    required this.file,
    required bool shouldPlayLivePhoto,
    required bool canZoom,
    required bool canPlay,
    required bool isPlayControlVisible,
  }) : super(_State.init(
          shouldPlayLivePhoto: shouldPlayLivePhoto,
          canZoom: canZoom,
          canPlay: canPlay,
          isPlayControlVisible: isPlayControlVisible,
        )) {
    on<_SetShouldPlayLivePhoto>(_onSetShouldPlayLivePhoto);
    on<_SetCanZoom>(_onSetCanZoom);
    on<_SetCanPlay>(_onSetCanPlay);
    on<_SetIsPlayControlVisible>(_onSetIsPlayControlVisible);
    on<_SetLoaded>(_onSetLoaded);
    on<_SetIsZoomed>(_onSetIsZoomed);
    on<_SetContentHeight>(_onSetContentHeight);
    on<_SetPlaying>(_onSetPlaying);
    on<_SetPause>(_onSetPause);
    on<_SetLivePhotoLoadFailed>(_onSetLivePhotoLoadFailed);

    on<_SetError>(_onSetError);
  }

  @override
  Future<void> close() {
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
  }

  void _onSetIsPlayControlVisible(_SetIsPlayControlVisible ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isPlayControlVisible: ev.value));
  }

  void _onSetLoaded(_SetLoaded ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isLoaded: true));
  }

  void _onSetIsZoomed(_SetIsZoomed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isZoomed: ev.value));
  }

  void _onSetContentHeight(_SetContentHeight ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(contentHeight: ev.value));
  }

  void _onSetPlaying(_SetPlaying ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isPlaying: true));
  }

  void _onSetPause(_SetPause ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isPlaying: false));
  }

  void _onSetLivePhotoLoadFailed(_SetLivePhotoLoadFailed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      shouldPlayLivePhoto: false,
      isLivePhotoLoadFailed: Unique(true),
    ));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final Account account;
  final FileDescriptor file;

  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
}
