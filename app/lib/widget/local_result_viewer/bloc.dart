part of 'local_result_viewer.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.isShowAppBar});

  factory _State.init() {
    return const _State(isShowAppBar: true);
  }

  @override
  String toString() => _$toString();

  final bool isShowAppBar;
}

sealed class _Event {}

@toString
class _ToggleAppBar implements _Event {
  const _ToggleAppBar();

  @override
  String toString() => _$toString();
}

@toString
class _Share implements _Event {
  const _Share();

  @override
  String toString() => _$toString();
}

@npLog
class _LrvBloc extends Bloc<_Event, _State> with BlocLogger {
  _LrvBloc({required this.file}) : super(_State.init()) {
    on<_ToggleAppBar>(_onToggleAppBar);
    on<_Share>(_onShare);
  }

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  void _onToggleAppBar(_ToggleAppBar ev, _Emitter emit) {
    _log.info(ev);
    final to = !state.isShowAppBar;
    emit(state.copyWith(isShowAppBar: to));
    if (to) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  }

  Future<void> _onShare(_Share ev, _Emitter emit) async {
    _log.info(ev);
    if (getRawPlatform() == NpPlatform.android) {
      final uri = await ContentUri.getUriForFile(file.path);
      final share = AndroidFileShare([AndroidFileShareFile(uri, "image/jpeg")]);
      return share.share();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  @override
  String get tag => _log.fullName;

  final File file;

  final _subscriptions = <StreamSubscription>[];
}
