part of 'enhance_result_viewer.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocErrorCatcher<_Event, _State> {
  _Bloc({required this._c, required this.account, required this.persistResult})
    : super(_State.init()) {
    on<_LoadFile>(_onLoadFile);
    on<_SetError>((ev, emit) {
      _log.info(ev);
      emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
    });

    add(const _LoadFile());
  }

  @override
  String get tag => _log.fullName;

  @override
  void handleBlocError(Object error, StackTrace stackTrace) {
    add(_SetError(error, stackTrace));
  }

  Future<void> _onLoadFile(_LoadFile ev, _Emitter emit) async {
    _log.info(ev);
    try {
      final AnyFile anyFile;
      if (persistResult.toLowerCase().startsWith(account.url.toLowerCase())) {
        // remote file
        final filePath = persistResult.substring(account.url.length + 1);
        final file = await LsSingleFile(_c)(account, filePath);
        anyFile = file.toAnyFile();
      } else {
        // local file
        final files = await _c.localFileRepo.getFiles(
          platformIdentifiers: [persistResult],
        );
        if (files.isEmpty) {
          _log.severe("[_onLoadFile] Failed to query file for: $persistResult");
          throw StateError("File not found");
        }
        anyFile = files.first.toAnyFile();
      }
      emit(state.copyWith(file: anyFile));
    } catch (e, stackTrace) {
      emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
    }
  }

  final DiContainer _c;
  final Account account;
  final String persistResult;
}
