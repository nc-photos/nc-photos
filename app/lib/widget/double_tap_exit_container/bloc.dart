part of 'double_tap_exit_container.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.prefController})
    : super(_State.init(isDoubleTapExit: prefController.isDoubleTapExitValue)) {
    on<_SetDoubleTapExit>(_onSetDoubleTapExit);
    on<_SetCanPop>(_onSetCanPop);
    on<_OnPopInvoked>(_onOnPopInvoked);

    _subscriptions.add(
      prefController.isDoubleTapExitChange.listen((ev) {
        add(_SetDoubleTapExit(ev));
      }),
    );
  }

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _timer?.cancel();
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  void _onSetDoubleTapExit(_SetDoubleTapExit ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isDoubleTapExit: ev.value));
  }

  void _onSetCanPop(_SetCanPop ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(canPop: ev.value));
  }

  void _onOnPopInvoked(_OnPopInvoked ev, _Emitter emit) {
    _log.info(ev);
    if (state.isDoubleTapExit && !state.canPop) {
      emit(state.copyWith(canPop: true));
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 5), () {
        add(const _SetCanPop(false));
      });
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().doubleTapExitNotification),
          duration: k.snackBarDurationShort,
        ),
      );
    }
  }

  final PrefController prefController;

  final _subscriptions = <StreamSubscription>[];
  Timer? _timer;
}
