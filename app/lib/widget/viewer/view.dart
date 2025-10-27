part of 'viewer.dart';

class _ContentBody extends StatefulWidget {
  const _ContentBody();

  @override
  State<StatefulWidget> createState() => _ContentBodyState();
}

@npLog
class _ContentBodyState extends State<_ContentBody> {
  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(_onPageViewChanged);
  }

  @override
  void dispose() {
    _pageViewController.removeListener(_onPageViewChanged);
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen:
              (previous, current) =>
                  previous.pendingRemoveFile != current.pendingRemoveFile,
          listener: (context, state) {
            final file = state.pendingRemoveFile.value;
            if (file == null) {
              return;
            }
            if (file.id == state.currentFile?.id) {
              // removing current page
              if (state.forwardBound != null &&
                  state.index >= state.forwardBound! - 1) {
                // removing the last item, go back
                _pageViewController
                    .animateToPreviousPage(
                      duration: k.animationDurationNormal,
                      curve: Curves.easeInOut,
                    )
                    .then((_) {
                      if (mounted) {
                        context.addEvent(_RemoveFile(file));
                      }
                    });
              } else {
                _pageViewController
                    .animateToNextPage(
                      duration: k.animationDurationNormal,
                      curve: Curves.easeInOut,
                    )
                    .then((_) {
                      if (mounted) {
                        context.addEvent(_RemoveFile(file));
                      }
                    });
              }
            } else {
              context.addEvent(_RemoveFile(file));
            }
          },
        ),
        _BlocListenerT(
          selector: (state) => state.index,
          listener: (context, index) {
            final currPage = _pageViewController.pageF;
            if (currPage != null && (index - currPage).abs() >= 1) {
              _log.info(
                "[build] Page out sync, correcting: $currPage -> $index",
              );
              _pageViewController.jumpToPage(index);
            }
          },
        ),
        _BlocListener(
          listenWhen:
              (previous, current) =>
                  previous.index != current.index ||
                  previous.backwardBound != current.backwardBound ||
                  previous.forwardBound != current.forwardBound,
          listener: (context, state) {
            if (state.backwardBound != null &&
                state.forwardBound != null &&
                state.backwardBound! >= state.forwardBound!) {
              // no more file
              Navigator.of(context).pop();
            } else if (state.backwardBound != null &&
                state.index < state.backwardBound!) {
              _log.info(
                "[build] Exceed backward bound, bound: ${state.backwardBound!}, now: ${state.index}",
              );
              _pageViewController.animateTo(
                state.backwardBound! *
                    _pageViewController.position.viewportDimension,
                duration: k.animationDurationNormal,
                curve: Curves.ease,
              );
            } else if (state.forwardBound != null &&
                state.index > state.forwardBound!) {
              _log.info(
                "[build] Exceed forward bound, bound: ${state.forwardBound!}, now: ${state.index}",
              );
              _pageViewController.animateTo(
                state.forwardBound! *
                    _pageViewController.position.viewportDimension,
                duration: k.animationDurationNormal,
                curve: Curves.ease,
              );
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          context.addEvent(const _ToggleAppBar());
        },
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.black)),
            _BlocBuilder(
              buildWhen:
                  (previous, current) =>
                      previous.isZoomed != current.isZoomed ||
                      previous.removedAfIds != current.removedAfIds,
              builder:
                  (context, state) => InfinitePageView(
                    key: _key,
                    itemBuilder:
                        (context, i) => _BlocBuilder(
                          buildWhen:
                              (previous, current) =>
                                  previous.pageAfIdMap[i] !=
                                      current.pageAfIdMap[i] ||
                                  previous.backwardBound !=
                                      current.backwardBound ||
                                  previous.forwardBound != current.forwardBound,
                          builder: (context, state) {
                            final afId = state.pageAfIdMap[i];
                            if ((state.backwardBound != null &&
                                    i < state.backwardBound!) ||
                                (state.forwardBound != null &&
                                    i > state.forwardBound!)) {
                              return Center(
                                child: Text(
                                  L10n.global().viewerLastPageText,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else if (afId == null) {
                              return const Center(
                                child:
                                    AppIntermediateCircularProgressIndicator(),
                              );
                            } else {
                              return _PageView(
                                key: Key("Viewer-$afId"),
                                afId: afId,
                                pageHeight: MediaQuery.of(context).size.height,
                              );
                            }
                          },
                        ),
                    controller: _pageViewController,
                    physics:
                        !state.isZoomed
                            ? null
                            : const NeverScrollableScrollPhysics(),
                  ),
            ),
            _BlocSelector<bool>(
              selector: (state) => state.isShowAppBar,
              builder:
                  (context, isShowAppBar) =>
                      isShowAppBar
                          ? Container(
                            // + status bar height
                            height:
                                kToolbarHeight +
                                MediaQuery.of(context).padding.top,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: [
                                  Color.fromARGB(192, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _onPageViewChanged() {
    final currPage = _pageViewController.pageF;
    if (currPage != null && (context.state.index - currPage).abs() >= .9) {
      context.addEvent(_SetIndex(currPage.round()));
    }
  }

  // prevent view getting disposed
  final _key = GlobalKey();
  final _pageViewController = InfiniteScrollController();
}

class _PageView extends StatefulWidget {
  const _PageView({super.key, required this.afId, required this.pageHeight});

  @override
  State<StatefulWidget> createState() => _PageViewState();

  final String afId;
  final double pageHeight;
}

@npLog
class _PageViewState extends State<_PageView> {
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset:
          context.state.isShowDetailPane && !context.state.isClosingDetailPane
              ? _calcDetailPaneOpenedScrollPosition(
                context.state.fileStates[widget.afId],
                widget.pageHeight,
              )
              : 0,
    );
    if (context.state.isShowDetailPane && !context.state.isClosingDetailPane) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pageState = context.state.fileStates[widget.afId];
        if (mounted && pageState?.itemHeight != null) {
          _hasInitDetailPane = true;
          context.addEvent(const _OpenDetailPane(false));
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen:
              (previous, current) =>
                  previous.openDetailPaneRequest !=
                  current.openDetailPaneRequest,
          listener: (context, state) {
            if (!state.canOpenDetailPane) {
              _log.warning("[build] Can't open detail pane right now");
              return;
            }
            if (state.openDetailPaneRequest.value.shouldAnimate) {
              _scrollController.animateTo(
                _calcDetailPaneOpenedScrollPosition(
                  context.state.fileStates[widget.afId],
                  widget.pageHeight,
                ),
                duration: k.animationDurationNormal,
                curve: Curves.easeOut,
              );
            } else {
              _scrollController.jumpTo(
                _calcDetailPaneOpenedScrollPosition(
                  context.state.fileStates[widget.afId],
                  widget.pageHeight,
                ),
              );
            }
          },
        ),
        _BlocListenerT(
          selector: (state) => state.closeDetailPane,
          listener: (context, state) {
            _scrollController.animateTo(
              0,
              duration: k.animationDurationNormal,
              curve: Curves.easeOut,
            );
          },
        ),
        _BlocListenerT(
          selector: (state) => state.fileStates[widget.afId]?.itemHeight,
          listener: (context, itemHeight) {
            if (itemHeight != null && !_hasInitDetailPane) {
              if (context.state.isShowDetailPane &&
                  !context.state.isClosingDetailPane) {
                _hasInitDetailPane = true;
                context.addEvent(const _OpenDetailPane(false));
              }
            }
          },
        ),
      ],
      child: _BlocSelector(
        selector: (state) => state.mergedAfIdFileMap[widget.afId],
        builder: (context, file) {
          if (file == null) {
            return const Center(
              child: AppIntermediateCircularProgressIndicator(),
            );
          } else {
            return NotificationListener<ScrollNotification>(
              onNotification: _onPageContentScrolled,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: _BlocBuilder(
                  buildWhen:
                      (previous, current) =>
                          previous.isZoomed != current.isZoomed,
                  builder:
                      (context, state) => SingleChildScrollView(
                        controller: _scrollController,
                        physics:
                            !state.isZoomed
                                ? null
                                : const NeverScrollableScrollPhysics(),
                        child: Stack(
                          children: [
                            _BlocBuilder(
                              buildWhen:
                                  (previous, current) =>
                                      previous.fileStates[widget.afId] !=
                                          current.fileStates[widget.afId] ||
                                      previous.isShowAppBar !=
                                          current.isShowAppBar ||
                                      previous.isDetailPaneActive !=
                                          current.isDetailPaneActive,
                              builder:
                                  (context, state) => FileContentView(
                                    file: file,
                                    shouldPlayLivePhoto:
                                        state
                                            .fileStates[widget.afId]
                                            ?.shouldPlayLivePhoto ??
                                        false,
                                    canZoom: !state.isDetailPaneActive,
                                    canPlay: !state.isDetailPaneActive,
                                    isPlayControlVisible:
                                        state.isShowAppBar &&
                                        !state.isDetailPaneActive,
                                    onContentHeightChanged: (contentHeight) {
                                      context.addEvent(
                                        _SetFileContentHeight(
                                          widget.afId,
                                          contentHeight,
                                        ),
                                      );
                                    },
                                    onZoomChanged: (isZoomed) {
                                      context.addEvent(_SetIsZoomed(isZoomed));
                                    },
                                    onVideoPlayingChanged: (isPlaying) {
                                      if (isPlaying) {
                                        context.addEvent(const _HideAppBar());
                                      } else {
                                        context.addEvent(const _ShowAppBar());
                                      }
                                    },
                                    onLoadFailure: () {
                                      if (state
                                              .fileStates[widget.afId]
                                              ?.shouldPlayLivePhoto ==
                                          true) {
                                        context.addEvent(
                                          _PauseLivePhoto(widget.afId),
                                        );
                                      }
                                    },
                                  ),
                            ),
                            _DetailPaneContainer(afId: widget.afId),
                          ],
                        ),
                      ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  bool _onPageContentScrolled(ScrollNotification notification) {
    if (!context.state.canOpenDetailPane) {
      return false;
    }
    if (notification is ScrollStartNotification) {
      _scrollStartPosition = _scrollController.position.pixels;
    }
    if (notification is ScrollEndNotification) {
      _scrollStartPosition = null;
      final scrollPos = _scrollController.position;
      if (scrollPos.pixels == 0) {
        context.addEvent(const _DetailPaneClosed());
      } else if (scrollPos.pixels <
          _calcDetailPaneOpenedScrollPosition(
                context.state.fileStates[widget.afId],
                widget.pageHeight,
              ) -
              1) {
        if (scrollPos.userScrollDirection == ScrollDirection.reverse) {
          // upward, open the pane to its minimal size
          context.addEvent(const _OpenDetailPane(true));
        } else if (scrollPos.userScrollDirection == ScrollDirection.forward) {
          // downward, close the pane
          context.addEvent(const _CloseDetailPane());
        }
      }
    } else if (notification is ScrollUpdateNotification) {
      if (!context.state.isShowDetailPane) {
        context.addEvent(const _ShowDetailPane());
      }
    }

    if (notification is OverscrollNotification) {
      if (_scrollStartPosition == 0) {
        // start at top
        _overscrollSum += notification.overscroll;
        if (_overscrollSum < -144) {
          // and scroll downwards
          Navigator.of(context).pop();
        }
      }
    } else {
      _overscrollSum = 0;
    }
    return false;
  }

  late final ScrollController _scrollController;

  double? _scrollStartPosition;
  var _overscrollSum = 0.0;
  var _hasInitDetailPane = false;
}

double _calcDetailPaneOpenedScrollPosition(
  _PageState? pageState,
  double pageHeight,
) {
  // distance of the detail pane from the top edge
  const distanceFromTop = 196;
  return max(_calcDetailPaneOffset(pageState, pageHeight) - distanceFromTop, 0);
}

double _calcDetailPaneOffset(_PageState? pageState, double pageHeight) {
  if (pageState?.itemHeight == null) {
    return pageHeight;
  } else {
    return pageState!.itemHeight! +
        (pageHeight - pageState.itemHeight!) / 2 -
        4;
  }
}

extension on InfiniteScrollController {
  double? get pageF {
    if (!hasClients || !position.hasViewportDimension) {
      return null;
    }
    return offset / position.viewportDimension;
  }

  // ignore: unused_element
  int? get page => pageF?.round();

  void jumpToPage(int page) {
    assert(position.hasViewportDimension);
    jumpTo(page * position.viewportDimension);
  }

  Future<void> animateToPreviousPage({
    required Duration duration,
    required Curve curve,
  }) {
    if (!hasClients || !position.hasViewportDimension) {
      return Future.value();
    }
    final p = page;
    if (p == null) {
      return Future.value();
    }
    final dst = p - 1;
    return animateTo(
      dst * position.viewportDimension,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> animateToNextPage({
    required Duration duration,
    required Curve curve,
  }) {
    if (!hasClients || !position.hasViewportDimension) {
      return Future.value();
    }
    final p = page;
    if (p == null) {
      return Future.value();
    }
    final dst = p + 1;
    return animateTo(
      dst * position.viewportDimension,
      duration: duration,
      curve: curve,
    );
  }
}
