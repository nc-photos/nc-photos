part of '../slideshow_viewer.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({
    required this.account,
    required this.anyFilesController,
    required this.filesController,
    required this.localFilesController,
    required this.collectionsController,
    required this.afIds,
    required this.startIndex,
    required this.collectionId,
    required this.config,
  }) : super(_State.init()) {
    on<_Init>(_onInit);
    on<_SetCollectionItems>(_onSetCollectionItems);
    on<_MergeFiles>(_onMergeFiles);

    on<_ToggleShowUi>(_onToggleShowUi);
    on<_PreloadSidePages>(_onPreloadSidePages);
    on<_VideoCompleted>(_onVideoCompleted);
    on<_SetPause>(_onSetPause);
    on<_SetPlay>(_onSetPlay);
    on<_RequestPrevPage>(_onRequestPrevPage);
    on<_RequestNextPage>(_onRequestNextPage);
    on<_SetCurrentPage>(_onSetCurrentPage);
    on<_NextPage>(_onNextPage);
    on<_ToggleTimeline>(_onToggleTimeline);
    on<_RequestPage>(_onRequestPage);
    on<_RequestExit>(_onRequestExit);

    if (collectionId != null) {
      _subscriptions.add(
        collectionsController.stream.listen((event) {
          for (final c in event.data) {
            if (c.collection.id == collectionId) {
              _collectionItemsSubscription?.cancel();
              _collectionItemsSubscription = c.controller.stream.listen((
                event,
              ) {
                add(_SetCollectionItems(event.items));
              });
              return;
            }
          }
          _log.warning("[_Bloc] Collection not found: $collectionId");
          add(const _SetCollectionItems(null));
          _collectionItemsSubscription?.cancel();
        }),
      );
    }
    _subscriptions.add(
      stream
          .distinct(
            (a, b) =>
                identical(a.remoteFiles, b.remoteFiles) &&
                identical(a.localFiles, b.localFiles) &&
                identical(a.collectionItems, b.collectionItems),
          )
          .listen((event) {
            add(const _MergeFiles());
          }),
    );
  }

  @override
  Future<void> close() {
    _pageChangeTimer?.cancel();
    _collectionItemsSubscription?.cancel();
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  /// Convert the page index to the corresponding item index
  int convertPageToFileIndex(int pageIndex) {
    if (config.isShuffle) {
      final i = pageIndex ~/ afIds.length;
      if (!_shuffledIndex.containsKey(i)) {
        final index = [for (var i = 0; i < afIds.length; ++i) i];
        _shuffledIndex[i] = index..shuffle();
      }
      return _shuffledIndex[i]![pageIndex % afIds.length];
    } else {
      return _shuffledIndex[0]![pageIndex % afIds.length];
    }
  }

  AnyFile? getFileByPageIndex(int pageIndex) =>
      state.files[convertPageToFileIndex(pageIndex)];

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    // TODO remove this and only query when the file is going to be displayed
    // needed for now because some pages (e.g., search) haven't yet migrated
    await anyFilesController.queryByAfId(afIds);

    final parsedConfig = _parseConfig(
      afIds: afIds,
      startIndex: startIndex,
      config: config,
    );
    _shuffledIndex = {0: parsedConfig.shuffled};
    initialPage = parsedConfig.initial;
    pageCount = parsedConfig.count;
    emit(
      state.copyWith(
        hasInit: true,
        page: initialPage,
        hasPrev: initialPage > 0,
        hasNext: pageCount == null || initialPage < (pageCount! - 1),
      ),
    );
    if (state.files.isNotEmpty) {
      emit(state.copyWith(currentFile: getFileByPageIndex(initialPage)));
    }
    unawaited(_prepareNextPage());

    await Future.wait([
      forEach(
        emit,
        filesController.stream,
        onData: (data) => state.copyWith(remoteFiles: data.data),
      ),
      forEach(
        emit,
        localFilesController.stream,
        onData: (data) => state.copyWith(localFiles: data.data),
      ),
    ]);
  }

  void _onSetCollectionItems(_SetCollectionItems ev, _Emitter emit) {
    _log.info(ev);
    final itemMap =
        ev.value
            ?.whereType<CollectionFileItem>()
            .map((e) => MapEntry(e.file.fdId, e))
            .toMap();
    emit(state.copyWith(collectionItems: itemMap));
  }

  void _onMergeFiles(_MergeFiles ev, _Emitter emit) {
    _log.info(ev);
    if (collectionId != null && state.collectionItems == null) {
      // collection not ready
      return;
    }
    final merged = {
      ...state.remoteFiles
          .map((e) => e.toAnyFile())
          .map((e) => MapEntry(e.id, e))
          .toMap(),
      ...state.localFiles
          .map((e) => e.toAnyFile())
          .map((e) => MapEntry(e.id, e))
          .toMap(),
      if (collectionId != null)
        ...state.collectionItems!.map(
          (_, e) => e.file.toAnyFile().let((f) => MapEntry(f.id, f)),
        ),
    };
    final files = afIds.map((e) => merged[e]).toList();
    emit(state.copyWith(files: files));
    if (state.hasInit) {
      emit(
        state.copyWith(currentFile: files[convertPageToFileIndex(state.page)]),
      );
    }
  }

  void _onToggleShowUi(_ToggleShowUi ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isShowUi: !state.isShowUi));
    if (state.isShowUi) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  }

  void _onPreloadSidePages(_PreloadSidePages ev, Emitter<_State> emit) {
    _log.info(ev);
    // currently pageview doesn't pre-load pages, we do it manually
    // don't pre-load if user already navigated away
    if (state.page != ev.center) {
      return;
    }
    _log.info("[_onPreloadSidePages] Pre-loading nearby images");
    if (ev.center > 0) {
      final prevFile = getFileByPageIndex(ev.center - 1);
      if (prevFile != null &&
          file_util.isSupportedImageMime(prevFile.mime ?? "")) {
        AnyFilePresenterFactory.imageViewer(
          prevFile,
          account: account,
        ).preloadImage();
      }
    }
    if (pageCount == null || ev.center + 1 < pageCount!) {
      final nextFile = getFileByPageIndex(ev.center + 1);
      if (nextFile != null &&
          file_util.isSupportedImageMime(nextFile.mime ?? "")) {
        AnyFilePresenterFactory.imageViewer(
          nextFile,
          account: account,
        ).preloadImage();
      }
    }
  }

  void _onVideoCompleted(_VideoCompleted ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isVideoCompleted: true));
    if (state.isPlay) {
      _gotoNextPage();
    }
  }

  void _onSetPause(_SetPause ev, Emitter<_State> emit) {
    _log.info(ev);
    _pageChangeTimer?.cancel();
    _pageChangeTimer = null;
    emit(state.copyWith(isPlay: false));
  }

  void _onSetPlay(_SetPlay ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.currentFile?.let(
          (e) => file_util.isSupportedVideoMime(e.mime ?? ""),
        ) ==
        true) {
      // only start the countdown if the video completed
      if (state.isVideoCompleted) {
        _pageChangeTimer?.cancel();
        _pageChangeTimer = Timer(config.duration, _gotoNextPage);
      }
    } else {
      _pageChangeTimer?.cancel();
      _pageChangeTimer = Timer(config.duration, _gotoNextPage);
    }
    emit(state.copyWith(isPlay: true));
  }

  void _onRequestPrevPage(_RequestPrevPage ev, Emitter<_State> emit) {
    _log.info(ev);
    _gotoPrevPage();
  }

  void _onRequestNextPage(_RequestNextPage ev, Emitter<_State> emit) {
    _log.info(ev);
    _gotoNextPage();
  }

  void _onSetCurrentPage(_SetCurrentPage ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        page: ev.value,
        currentFile: getFileByPageIndex(ev.value),
        isVideoCompleted: false,
        hasPrev: ev.value > 0,
        hasNext: pageCount == null || ev.value < (pageCount! - 1),
      ),
    );
    if (state.isPlay) {
      _prepareNextPage();
    }
  }

  void _onNextPage(_NextPage ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(nextPage: ev.value, shouldAnimateNextPage: true));
  }

  void _onToggleTimeline(_ToggleTimeline ev, Emitter<_State> emit) {
    _log.info(ev);
    final next = !state.isShowTimeline;
    emit(
      state.copyWith(
        isShowTimeline: next,
        hasShownTimeline: state.hasShownTimeline || next,
      ),
    );
  }

  void _onRequestPage(_RequestPage ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(nextPage: ev.value, shouldAnimateNextPage: false));
  }

  void _onRequestExit(_RequestExit ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(hasRequestExit: true));
  }

  static ({List<int> shuffled, int initial, int? count}) _parseConfig({
    required List<String> afIds,
    required int startIndex,
    required SlideshowConfig config,
  }) {
    final index = [for (var i = 0; i < afIds.length; ++i) i];
    final count = config.isRepeat ? null : afIds.length;
    if (config.isShuffle) {
      return (shuffled: index..shuffle(), initial: 0, count: count);
    } else if (config.isReverse) {
      return (
        shuffled: index.reversed.toList(),
        initial: afIds.length - 1 - startIndex,
        count: count,
      );
    } else {
      return (shuffled: index, initial: startIndex, count: count);
    }
  }

  Future<void> _prepareNextPage() async {
    if (state.currentFile?.let(
          (e) => file_util.isSupportedVideoMime(e.mime ?? ""),
        ) ==
        true) {
      // for videos, we need to wait until it's ended
      return;
    }
    // for photos, we wait for a fixed amount of time defined in config
    _pageChangeTimer?.cancel();
    _pageChangeTimer = Timer(config.duration, _gotoNextPage);
  }

  void _gotoPrevPage() {
    if (isClosed) {
      return;
    }
    final nextPage = state.page - 1;
    if (nextPage < 0) {
      // end reached
      _log.info("[_gotoPrevPage] Reached the end");
      return;
    }
    _log.info("[_gotoPrevPage] To page: $nextPage");
    _pageChangeTimer?.cancel();
    add(_NextPage(nextPage));
  }

  void _gotoNextPage() {
    if (isClosed) {
      return;
    }
    final nextPage = state.page + 1;
    if (pageCount != null && nextPage >= pageCount!) {
      // end reached
      _log.info("[_gotoNextPage] Reached the end");
      return;
    }
    _log.info("[_gotoNextPage] To page: $nextPage");
    _pageChangeTimer?.cancel();
    add(_NextPage(nextPage));
  }

  final Account account;
  final AnyFilesController anyFilesController;
  final FilesController filesController;
  final LocalFilesController localFilesController;
  final CollectionsController collectionsController;
  final List<String> afIds;
  final int startIndex;
  final String? collectionId;
  final SlideshowConfig config;

  late final Map<int, List<int>> _shuffledIndex;
  late final int initialPage;
  late final int? pageCount;
  Timer? _pageChangeTimer;

  final _subscriptions = <StreamSubscription>[];
  StreamSubscription? _collectionItemsSubscription;
}
