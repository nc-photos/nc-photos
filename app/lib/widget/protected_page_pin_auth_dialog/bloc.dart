part of '../protected_page_pin_auth_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.pin, required this.removeItemBuilder})
    : _rand = Random(),
      _hasher = sha256,
      super(_State.init()) {
    on<_PushDigit>(_onPushDigit);
    on<_PopDigit>(_onPopDigit);
    on<_SetupConfirmPin>(_onSetupConfirmPin);
  }

  void _onPushDigit(_PushDigit ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.input.length >= 6) {
      // max length of pin is 6
      emit(state.copyWith(isPinError: Unique(true)));
      return;
    }
    final index = state.input.length;
    emit(
      state.copyWith(
        input: "${state.input}${ev.digit}",
        obsecuredInput: state.obsecuredInput.added(_rand.nextInt(65536)),
      ),
    );
    listKey.currentState?.insertItem(index, duration: k.animationDurationLong);

    if (state.input.length >= 4 && pin != null) {
      // valid pin must contain at least 4 digits
      final hash = _hasher.convert(state.input.codeUnits);
      if (hash.toString().toCi() == pin) {
        emit(state.copyWith(isAuthorized: true));
      }
    }
  }

  void _onPopDigit(_PopDigit ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.input.isEmpty) {
      return;
    }
    final index = state.input.length - 1;
    final item = state.obsecuredInput.last;
    emit(
      state.copyWith(
        input: state.input.slice(0, -1),
        obsecuredInput: state.obsecuredInput.pySlice(0, -1),
      ),
    );
    listKey.currentState?.removeItem(
      index,
      (context, animation) => removeItemBuilder(context, animation, item),
      duration: k.animationDurationNormal,
    );
  }

  void _onSetupConfirmPin(_SetupConfirmPin ev, Emitter<_State> emit) {
    _log.info(ev);
    final hash = _hasher.convert(state.input.codeUnits);
    emit(state.copyWith(setupResult: hash.toString().toCi()));
  }

  final CiString? pin;
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    int value,
  )
  removeItemBuilder;

  final listKey = GlobalKey<AnimatedListState>();

  final Random _rand;
  final Hash _hasher;
}
