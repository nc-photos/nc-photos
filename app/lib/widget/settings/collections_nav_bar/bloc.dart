part of '../collections_nav_bar_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController, required this.isBottom})
    : super(
        _State.init(buttons: prefController.homeCollectionsNavBarButtonsValue),
      ) {
    on<_MoveButton>(_onMoveButton);
    on<_RemoveButton>(_onRemoveButton);
    on<_ToggleMinimized>(_onToggleMinimized);
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
    final pos = state.buttons.indexWhere((e) => e.type == ev.which);
    final found = pos >= 0 ? state.buttons[pos] : null;
    final insert =
        found ??
        PrefHomeCollectionsNavButton(type: ev.which, isMinimized: false);
    var result =
        pos >= 0 ? state.buttons.removedAt(pos) : List.of(state.buttons);
    if (ev.before == null && ev.after == null) {
      // add at the beginning
      emit(state.copyWith(buttons: result..insert(0, insert)));
      return;
    }

    final target = (ev.before ?? ev.after)!;
    if (ev.which == target) {
      // dropping on itself, do nothing
      return;
    }
    final targetPos = result.indexWhere((e) => e.type == target);
    if (targetPos == -1) {
      _log.severe("[_onMoveButton] Target not found: $target");
      return;
    }
    if (ev.before != null) {
      // insert before
      result.insert(targetPos, insert);
    } else {
      // insert after
      result.insert(targetPos + 1, insert);
    }
    _log.fine(
      "[_onMoveButton] From ${state.buttons.toReadableString()} -> ${result.toReadableString()}",
    );
    emit(state.copyWith(buttons: result));
  }

  void _onRemoveButton(_RemoveButton ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        buttons: state.buttons.removedWhere((e) => e.type == ev.value),
      ),
    );
  }

  void _onToggleMinimized(_ToggleMinimized ev, _Emitter emit) {
    _log.info(ev);
    final result = List.of(state.buttons);
    final pos = result.indexWhere((e) => e.type == ev.value);
    if (pos == -1) {
      // button not enabled
      _log.severe(
        "[_onToggleMinimized] Type not found in buttons: ${ev.value}",
      );
      return;
    }
    result[pos] = PrefHomeCollectionsNavButton(
      type: ev.value,
      isMinimized: !result[pos].isMinimized,
    );
    emit(state.copyWith(buttons: result));
  }

  Future<void> _onRevertDefault(_RevertDefault ev, _Emitter emit) async {
    _log.info(ev);
    await prefController.setHomeCollectionsNavBarButtons(null);
    emit(
      state.copyWith(buttons: prefController.homeCollectionsNavBarButtonsValue),
    );
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
