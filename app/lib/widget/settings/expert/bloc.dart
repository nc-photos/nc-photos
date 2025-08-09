part of '../expert_settings.dart';

class _Error {
  const _Error(this.ev, [this.error, this.stackTrace]);

  final _Event ev;
  final Object? error;
  final StackTrace? stackTrace;
}

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.db, required this.prefController})
    : super(_State.init(isNewHttpEngine: prefController.isNewHttpEngineValue)) {
    on<_Init>(_onInit);
    on<_ClearCacheDatabase>(_onClearCacheDatabase);
    on<_SetNewHttpEngine>(_onSetNewHttpEngine);
  }

  @override
  String get tag => _log.fullName;

  Stream<_Error> errorStream() => _errorStream.stream;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    return forEach(
      emit,
      prefController.isNewHttpEngineChange,
      onData: (data) => state.copyWith(isNewHttpEngine: data),
    );
  }

  Future<void> _onClearCacheDatabase(
    _ClearCacheDatabase ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    try {
      final accounts = prefController.accountsValue;
      await db.clearAndInitWithAccounts(accounts.toDb());
      emit(state.copyWith(lastSuccessful: ev));
    } catch (e, stackTrace) {
      _log.shout("[_onClearCacheDatabase] Uncaught exception", e, stackTrace);
      _errorStream.add(_Error(ev, e, stackTrace));
    }
  }

  void _onSetNewHttpEngine(_SetNewHttpEngine ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setNewHttpEngine(ev.value);
  }

  final NpDb db;
  final PrefController prefController;

  final _errorStream = StreamController<_Error>.broadcast();
}
