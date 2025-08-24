part of 'local_root_picker.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc(this._c, {required this.prefController})
    : super(_State.init(selectedDirs: prefController.localDirsValue.toSet())) {
    on<_ListDir>(_onListDir);
    on<_SelectDir>(_onSelectDir);
    on<_UnselectDir>(_onUnselectDir);
    on<_Save>(_onSave);

    on<_SetError>((ev, emit) {
      emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
    });
  }

  @override
  String? get tag => _log.fullName;

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

  Future<void> _onListDir(_ListDir ev, _Emitter emit) async {
    _log.info(ev);
    try {
      var dirs = await GetLocalDirList(_c.localFileRepo)();
      // remove DCIM as its always included
      dirs.removeWhere((e) => file_util.isOrUnderDirPath(e, "DCIM"));
      // remove trialing /
      dirs = dirs.map((e) => e.trimRightAny("/")).toList();
      dirs.sort();
      emit(state.copyWith(dirs: dirs));
    } catch (e, stackTrace) {
      _log.severe("[_onListDir] Exception", e, stackTrace);
      if (state.dirs == null) {
        emit(state.copyWith(dirs: const []));
      }
      add(_SetError(e, stackTrace));
    }
  }

  Future<void> _onSelectDir(_SelectDir ev, _Emitter emit) async {
    _log.info(ev);
    emit(state.copyWith(selectedDirs: state.selectedDirs.added(ev.value)));
  }

  Future<void> _onUnselectDir(_UnselectDir ev, _Emitter emit) async {
    _log.info(ev);
    emit(state.copyWith(selectedDirs: state.selectedDirs.removed(ev.value)));
  }

  void _onSave(_Save ev, _Emitter emit) {
    _log.info(ev);
    if (!setEquals(state.selectedDirs, prefController.localDirsValue.toSet())) {
      _log.info("[_onSave] Upload local dirs list: ${state.selectedDirs}");
      prefController.setLocalDirs(state.selectedDirs.toList());
    }
  }

  final DiContainer _c;
  final PrefController prefController;

  var _isHandlingError = false;
}
