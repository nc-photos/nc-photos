part of 'dir_picker.dart';

@npLog
class _DpBloc extends Bloc<_Event, _State>
    with BlocLogger, BlocErrorCatcher<_Event, _State> {
  _DpBloc({
    required this.fileRepo,
    required this.account,
    required this.rootDir,
    required this.isMultipleSelections,
    this.validator,
    List<File>? initialPicks,
  }) : super(
         _State.init(
           currentDir: isMultipleSelections
               ? File(path: rootDir)
               : (initialPicks?.firstOrNull ?? File(path: rootDir)),
           picks: initialPicks?.toList() ?? const [],
         ),
       ) {
    on<_Navigate>(_onNavigate);
    on<_Pick>(_onPick);
    on<_Unpick>(_onUnpick);
    on<_SetError>(_onSetError);

    add(_Navigate(state.currentDir));
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
  void handleBlocError(Object error, StackTrace stackTrace) {
    add(_SetError(error, stackTrace));
  }

  Future<void> _onNavigate(_Navigate ev, _Emitter emit) async {
    _log.info(ev);
    final token = ++_navigateToken;
    emit(state.copyWith(isLoading: true));
    try {
      if (ev.dir.path.contains("e2ee-test")) {
        throw ApiException(response: api.Response(403, {}, ""));
      }
      final items = await _list(ev.dir);
      if (token != _navigateToken) {
        return;
      }
      emit(state.copyWith(currentDir: ev.dir, items: items, isLoading: false));
      if (!isMultipleSelections) {
        emit(
          state.copyWith(
            picks: ev.dir.strippedPathWithEmpty.isEmpty ? [] : [ev.dir],
          ),
        );
      }
    } catch (e, stackTrace) {
      if (token != _navigateToken) {
        return;
      }
      final parentPath = path_lib.dirname(ev.dir.path);
      final siblings = _cache[parentPath];
      final statusCode = e is ApiException ? e.response.statusCode : null;
      if (siblings != null && (statusCode == 403 || statusCode == 404)) {
        if (statusCode == 404) {
          // this could happen when the server db contains dangling entries
          _log.warning(
            "[_onNavigate] HTTP404 error while listing dir: ${logFilename(ev.dir.path)}",
          );
          _cache[parentPath] = siblings.removedWhere(
            (i) => i.file.path == ev.dir.path,
          );
        } else {
          _log.warning(
            "[_onNavigate] HTTP403 error, likely E2EE dir: ${ev.dir.path}",
          );
          _cache[parentPath] = siblings
              .map(
                (e) => e.file.path == ev.dir.path
                    ? _DpItem(e.file, isE2ee: true)
                    : e,
              )
              .toList();
        }
        emit(state.copyWith(items: _cache[parentPath], isLoading: false));
      } else {
        _log.severe("[_onNavigate] Failed while listing dir", e, stackTrace);
        emit(
          state.copyWith(
            isLoading: false,
            error: ExceptionEvent(e, stackTrace),
          ),
        );
      }
    }
  }

  void _onPick(_Pick ev, _Emitter emit) {
    _log.info(ev);
    final List<File> picks;
    if (state.picks.any((e) => file_util.isOrUnderDir(ev.dir, e))) {
      // already picked by itself or a parent
      return;
    }
    picks = [
      // remove children
      ...state.picks.where((e) => !file_util.isUnderDir(e, ev.dir)),
      ev.dir,
    ];
    _log.fine("[_onPick] Picked: ${_pickListToString(picks)}");
    emit(state.copyWith(picks: picks));
  }

  void _onUnpick(_Unpick ev, _Emitter emit) {
    _log.info(ev);
    if (state.picks.any((p) => p.path == ev.dir.path)) {
      final picks = state.picks.where((p) => p.path != ev.dir.path).toList();
      _log.fine("[_onUnpick] Picked: ${_pickListToString(picks)}");
      emit(state.copyWith(picks: picks));
      return;
    }

    // look for the closest picked parent dir
    final parents =
        state.picks.where((p) => file_util.isUnderDir(ev.dir, p)).toList()
          ..sort((a, b) => b.path.length.compareTo(a.path.length));
    if (parents.isEmpty) {
      _log.warning("[_onUnpick] Dir not picked: ${ev.dir.path}");
      return;
    }
    final parent = parents.first;
    try {
      final picks = [
        ...state.picks.where((p) => !identical(p, parent)),
        ..._pickAllExclude(parent.path, ev.dir),
      ];
      _log.fine("[_onUnpick] Picked: ${_pickListToString(picks)}");
      emit(state.copyWith(picks: picks));
    } catch (e, stackTrace) {
      _log.severe("[_onUnpick] Failed to unpick dir", e, stackTrace);
      emit(
        state.copyWith(
          message: StateMessage(
            L10n.global().rootPickerUnpickFailureNotification,
          ),
        ),
      );
    }
  }

  void _onSetError(_SetError ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  Future<List<_DpItem>> _list(File dir) async {
    final cache = _cache[dir.path];
    if (cache != null) {
      return cache;
    }
    final files = await LsMinimal(fileRepo)(account, dir);
    final items = files
        .where((f) => f.isCollection ?? false)
        .map((f) => _DpItem(f))
        .toList();
    _cache[dir.path] = items;
    return items;
  }

  /// Return all descendants of [dirPath] that need to be picked such that
  /// everything is picked except [exclude]
  List<File> _pickAllExclude(String dirPath, File exclude) {
    final children = _cache[dirPath];
    if (children == null) {
      throw StateError("Dir not listed: $dirPath");
    }
    final products = <File>[];
    for (final c in children) {
      if (c.file.path == exclude.path) {
        continue;
      } else if (file_util.isUnderDir(exclude, c.file)) {
        products.addAll(_pickAllExclude(c.file.path, exclude));
      } else if (!c.isE2ee) {
        products.add(c.file);
      }
    }
    return products;
  }

  static String _pickListToString(List<File> items) =>
      "['${items.map((e) => e.path).join('\', \'')}']";

  final FileRepo fileRepo;
  final Account account;
  final String rootDir;
  final bool isMultipleSelections;

  /// Return whether a dir is a valid target to be picked
  final bool Function(File dir)? validator;

  final _cache = <String, List<_DpItem>>{};
  var _navigateToken = 0;

  final _subscriptions = <StreamSubscription>[];
}
