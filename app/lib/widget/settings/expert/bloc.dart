part of 'expert_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with
        BlocLogger,
        BlocForEachMixin<_Event, _State>,
        BlocErrorCatcher<_Event, _State> {
  _Bloc({required this.db, required this.prefController})
    : super(_State.init(isNewHttpEngine: prefController.isNewHttpEngineValue)) {
    on<_Init>(_onInit);
    on<_ClearCacheDatabase>(_onClearCacheDatabase);
    on<_SetNewHttpEngine>(_onSetNewHttpEngine);
    on<_SetError>((ev, emit) {
      _log.info(ev);
      emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
    });
  }

  @override
  String get tag => _log.fullName;

  @override
  void handleBlocError(Object error, StackTrace stackTrace) {
    add(_SetError(error, stackTrace));
  }

  Future<void> _onInit(_Init ev, _Emitter emit) async {
    _log.info(ev);
    return forEach(
      emit,
      prefController.isNewHttpEngineChange,
      onData: (data) => state.copyWith(isNewHttpEngine: data),
    );
  }

  Future<void> _onClearCacheDatabase(
    _ClearCacheDatabase ev,
    _Emitter emit,
  ) async {
    _log.info(ev);
    try {
      final accounts = prefController.accountsValue;
      await db.clearAndInitWithAccounts(accounts.toDb());
      emit(state.copyWith(lastSuccessful: ev));
    } catch (e, stackTrace) {
      _log.shout("[_onClearCacheDatabase] Uncaught exception", e, stackTrace);
      emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
    }
  }

  void _onSetNewHttpEngine(_SetNewHttpEngine ev, _Emitter emit) {
    _log.info(ev);
    prefController.setNewHttpEngine(ev.value);
  }

  final NpDb db;
  final PrefController prefController;
}
