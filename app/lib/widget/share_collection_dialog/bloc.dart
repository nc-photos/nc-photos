part of '../share_collection_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required DiContainer container,
    required this.account,
    required this.collectionsController,
    required Collection collection,
  }) : _c = container,
       super(_State.init(collection: collection)) {
    on<_UpdateCollection>(_onUpdateCollection);
    on<_LoadSharee>(_onLoadSharee);
    on<_RefreshSuggester>(_onRefreshSuggester);

    on<_ShareEventTag>((ev, emit) {
      if (ev is _Share) {
        return _onShare(ev, emit);
      } else if (ev is _Unshare) {
        return _onUnshare(ev, emit);
      } else {
        throw UnimplementedError();
      }
    });

    on<_SetError>(_onSetError);

    _subscriptions.add(
      collectionsController.stream.listen((event) {
        final c = event.data.firstWhere(
          (d) => state.collection.compareIdentity(d.collection),
        );
        if (!identical(c, state.collection)) {
          add(_UpdateCollection(c.collection));
        }
      }),
    );
    _subscriptions.add(
      collectionsController.errorStream.listen((ev) {
        add(_SetError(ev.error, ev.stackTrace));
      }),
    );
  }

  @override
  String get tag => _log.fullName;

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  void onChange(Change<_State> change) {
    if (change.currentState.sharees != change.nextState.sharees ||
        change.currentState.collection != change.nextState.collection ||
        change.currentState.processingShares !=
            change.nextState.processingShares) {
      add(const _RefreshSuggester());
    }
    super.onChange(change);
  }

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

  void _onUpdateCollection(_UpdateCollection ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(collection: ev.collection));
  }

  Future<void> _onLoadSharee(_LoadSharee ev, Emitter<_State> emit) async {
    _log.info(ev);
    final sharees = await _c.shareeRepo.list(account);
    emit(state.copyWith(sharees: sharees));
  }

  void _onRefreshSuggester(_RefreshSuggester ev, Emitter<_State> emit) {
    _log.info(ev);
    final searchable =
        state.sharees
            ?.where(
              (s) =>
                  !state.collection.shares.any((e) => e.userId == s.shareWith),
            )
            .where(
              (s) =>
                  !state.processingShares.any((e) => e.userId == s.shareWith),
            )
            .where((s) => s.shareWith != account.userId)
            .toList() ??
        [];
    emit(
      state.copyWith(
        shareeSuggester: Suggester<Sharee>(
          items: searchable,
          itemToKeywords: (item) => [item.shareWith, item.label.toCi()],
          maxResult: 10,
        ),
      ),
    );
  }

  Future<void> _onShare(_Share ev, Emitter<_State> emit) async {
    _log.info(ev);
    if (state.collection.shares.any((s) => s.userId == ev.sharee.shareWith) ||
        state.processingShares.any((s) => s.userId == ev.sharee.shareWith)) {
      _log.fine("[_onShare] Already shared with sharee: ${ev.sharee}");
      return;
    }
    emit(
      state.copyWith(
        processingShares: [
          ...state.processingShares,
          CollectionShare(
            userId: ev.sharee.shareWith,
            username: ev.sharee.label,
          ),
        ],
      ),
    );
    try {
      await collectionsController.share(state.collection, ev.sharee);
    } finally {
      emit(
        state.copyWith(
          processingShares:
              state.processingShares
                  .where((s) => s.userId != ev.sharee.shareWith)
                  .toList(),
        ),
      );
    }
  }

  Future<void> _onUnshare(_Unshare ev, Emitter<_State> emit) async {
    _log.info(ev);
    emit(
      state.copyWith(processingShares: [...state.processingShares, ev.share]),
    );
    try {
      await collectionsController.unshare(state.collection, ev.share);
    } finally {
      emit(
        state.copyWith(
          processingShares:
              state.processingShares
                  .where((s) => s.userId != ev.share.userId)
                  .toList(),
        ),
      );
    }
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final DiContainer _c;
  final Account account;
  final CollectionsController collectionsController;

  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
}
