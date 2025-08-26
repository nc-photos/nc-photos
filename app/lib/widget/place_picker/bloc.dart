part of 'place_picker.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.prefController,
    required this.initialPosition,
    required this.initialZoom,
  }) : super(_State.init()) {
    on<_SetPosition>(_onSetPosition);
    on<_Done>(_onDone);
  }

  @override
  String get tag => _log.fullName;

  @override
  bool Function(dynamic, dynamic)? get shouldLog => (currentState, nextState) {
    return currentState.position == nextState.position;
  };

  void _onSetPosition(_SetPosition ev, _Emitter emit) {
    // _log.info(ev);
    emit(state.copyWith(position: ev.value));
  }

  void _onDone(_Done ev, _Emitter emit) {
    _log.info(ev);
    if (prefController.mapBrowserPrevPositionValue == null &&
        state.position != null) {
      prefController.setMapBrowserPrevPosition(state.position!.center);
    }
    emit(state.copyWith(isDone: true));
  }

  final PrefController prefController;
  final MapCoord? initialPosition;
  final double? initialZoom;
}
