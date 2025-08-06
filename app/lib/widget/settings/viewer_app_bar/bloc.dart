part of '../viewer_app_bar_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController, required this.isBottom})
    : super(
        _State.init(
          buttons:
              isBottom
                  ? prefController.viewerBottomAppBarButtonsValue
                  : prefController.viewerAppBarButtonsValue,
        ),
      ) {
    on<_MoveButton>(_onMoveButton);
    on<_RemoveButton>(_onRemoveButton);
    on<_RevertDefault>(_onRevertDefault);

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

  void _onMoveButton(_MoveButton ev, _Emitter emit) {
    _log.info(ev);
    var result = state.buttons.removed(ev.which);
    if (ev.before == null && ev.after == null) {
      // add at the beginning
      emit(state.copyWith(buttons: result..insert(0, ev.which)));
      return;
    }

    final target = (ev.before ?? ev.after)!;
    if (ev.which == target) {
      // dropping on itself, do nothing
      return;
    }
    final found = result.indexOf(target);
    if (found == -1) {
      _log.severe("[_onMoveButton] Target not found: $target");
      return;
    }
    if (ev.before != null) {
      // insert before
      result.insert(found, ev.which);
    } else {
      // insert after
      result.insert(found + 1, ev.which);
    }
    _log.fine(
      "[_onMoveButton] From ${state.buttons.toReadableString()} -> ${result.toReadableString()}",
    );
    emit(state.copyWith(buttons: result));
  }

  void _onRemoveButton(_RemoveButton ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(buttons: state.buttons.removed(ev.value)));
  }

  Future<void> _onRevertDefault(_RevertDefault ev, _Emitter emit) async {
    _log.info(ev);
    if (isBottom) {
      await prefController.setViewerBottomAppBarButtons(null);
      emit(
        state.copyWith(buttons: prefController.viewerBottomAppBarButtonsValue),
      );
    } else {
      await prefController.setViewerAppBarButtons(null);
      emit(state.copyWith(buttons: prefController.viewerAppBarButtonsValue));
    }
  }

  void _onSetError(_SetError ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final PrefController prefController;
  final bool isBottom;

  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
}
