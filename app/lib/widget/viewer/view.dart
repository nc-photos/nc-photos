part of '../viewer.dart';

class _ContentBody extends StatefulWidget {
  const _ContentBody();

  @override
  State<StatefulWidget> createState() => _ContentBodyState();
}

@npLog
class _ContentBodyState extends State<_ContentBody> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen: (previous, current) =>
              previous.pendingRemovePage != current.pendingRemovePage,
          listener: (context, state) {
            final index = state.pendingRemovePage.value;
            if (index == null) {
              return;
            }
            if (state.fileIdOrders.length <= 1) {
              // removing the only item, pop view
              Navigator.of(context).pop();
            } else if (index == state.index) {
              // removing current page
              if (index >= state.fileIdOrders.length - 1) {
                // removing the last item, go back
                _pageViewController
                    .previousPage(
                  duration: k.animationDurationNormal,
                  curve: Curves.easeInOut,
                )
                    .then((_) {
                  if (mounted) {
                    context.addEvent(_RemovePage(index));
                  }
                });
              } else {
                _pageViewController
                    .nextPage(
                  duration: k.animationDurationNormal,
                  curve: Curves.easeInOut,
                )
                    .then((_) {
                  if (mounted) {
                    context.addEvent(_RemovePage(index));
                  }
                });
              }
            } else {
              context.addEvent(_RemovePage(index));
            }
          },
        ),
        _BlocListenerT(
          selector: (state) => state.index,
          listener: (context, index) {
            if (index != _pageViewController.currentPage) {
              _log.info(
                  "[build] Page out sync, correcting: ${_pageViewController.currentPage} -> $index");
              _pageViewController.jumpToPage(index);
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
            const Positioned.fill(
              child: ColoredBox(color: Colors.black),
            ),
            _BlocBuilder(
              buildWhen: (previous, current) =>
                  previous.fileIdOrders != current.fileIdOrders ||
                  previous.isZoomed != current.isZoomed,
              builder: (context, state) => HorizontalPageViewer(
                key: _key,
                pageCount: state.fileIdOrders.length,
                pageBuilder: (context, i) => _PageView(
                  key: Key("FileContentView-${state.fileIdOrders[i]}"),
                  fileId: state.fileIdOrders[i],
                  pageHeight: MediaQuery.of(context).size.height,
                ),
                initialPage: state.index,
                controller: _pageViewController,
                viewportFraction: _viewportFraction,
                canSwitchPage: !state.isZoomed,
                onPageChanged: (from, to) {
                  context.addEvent(_SetIndex(to));
                },
              ),
            ),
            _BlocSelector<bool>(
              selector: (state) => state.isShowAppBar,
              builder: (context, isShowAppBar) => isShowAppBar
                  ? Container(
                      // + status bar height
                      height:
                          kToolbarHeight + MediaQuery.of(context).padding.top,
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

  // prevent view getting disposed
  final _key = GlobalKey();
  final _pageViewController = HorizontalPageViewerController();
}

class _PageView extends StatefulWidget {
  const _PageView({
    super.key,
    required this.fileId,
    required this.pageHeight,
  });

  @override
  State<StatefulWidget> createState() => _PageViewState();

  final int fileId;
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
                  context.state.fileStates[widget.fileId], widget.pageHeight)
              : 0,
    );
    if (context.state.isShowDetailPane && !context.state.isClosingDetailPane) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pageState = context.state.fileStates[widget.fileId];
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
          listenWhen: (previous, current) =>
              previous.openDetailPaneRequest != current.openDetailPaneRequest,
          listener: (context, state) {
            if (!state.canOpenDetailPane) {
              _log.warning("[build] Can't open detail pane right now");
              return;
            }
            if (state.openDetailPaneRequest.value.shouldAnimate) {
              _scrollController.animateTo(
                _calcDetailPaneOpenedScrollPosition(
                    context.state.fileStates[widget.fileId], widget.pageHeight),
                duration: k.animationDurationNormal,
                curve: Curves.easeOut,
              );
            } else {
              _scrollController.jumpTo(_calcDetailPaneOpenedScrollPosition(
                  context.state.fileStates[widget.fileId], widget.pageHeight));
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
          selector: (state) => state.fileStates[widget.fileId]?.itemHeight,
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
        selector: (state) => state.files[widget.fileId],
        builder: (context, file) {
          if (file == null) {
            return const Center(
              child: AppIntermediateCircularProgressIndicator(),
            );
          } else {
            return FractionallySizedBox(
              widthFactor: 1 / _viewportFraction,
              child: NotificationListener<ScrollNotification>(
                onNotification: _onPageContentScrolled,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: _BlocBuilder(
                    buildWhen: (previous, current) =>
                        previous.isZoomed != current.isZoomed,
                    builder: (context, state) => SingleChildScrollView(
                      controller: _scrollController,
                      physics: !state.isZoomed
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      child: Stack(
                        children: [
                          _BlocBuilder(
                            buildWhen: (previous, current) =>
                                previous.fileStates[widget.fileId] !=
                                    current.fileStates[widget.fileId] ||
                                previous.isShowAppBar != current.isShowAppBar ||
                                previous.isDetailPaneActive !=
                                    current.isDetailPaneActive,
                            builder: (context, state) => FileContentView(
                              file: file,
                              shouldPlayLivePhoto: state
                                      .fileStates[widget.fileId]
                                      ?.shouldPlayLivePhoto ??
                                  false,
                              canZoom: !state.isDetailPaneActive,
                              canPlay: !state.isDetailPaneActive,
                              isPlayControlVisible: state.isShowAppBar &&
                                  !state.isDetailPaneActive,
                              onContentHeightChanged: (contentHeight) {
                                context.addEvent(_SetFileContentHeight(
                                    widget.fileId, contentHeight));
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
                                if (state.fileStates[widget.fileId]
                                        ?.shouldPlayLivePhoto ==
                                    true) {
                                  context
                                      .addEvent(_PauseLivePhoto(widget.fileId));
                                }
                              },
                            ),
                          ),
                          _DetailPaneContainer(fileId: widget.fileId),
                        ],
                      ),
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
                  context.state.fileStates[widget.fileId], widget.pageHeight) -
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
    _PageState? pageState, double pageHeight) {
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

const _viewportFraction = 1.05;
