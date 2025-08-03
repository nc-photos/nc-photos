part of '../slideshow_viewer.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // + status bar height
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(192, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0),
                ],
              ),
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () {
                context.addEvent(const _RequestExit());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlBar extends StatelessWidget {
  const _ControlBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(0, 0, 0, 0),
                  Color.fromARGB(192, 0, 0, 0),
                ],
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BlocSelector<bool>(
                  selector: (state) => state.hasPrev,
                  builder: (context, hasPrev) => IconButton(
                    onPressed: hasPrev
                        ? () {
                            context.addEvent(const _RequestPrevPage());
                          }
                        : null,
                    icon: const Icon(Icons.skip_previous_outlined),
                  ),
                ),
                _BlocSelector<bool>(
                  selector: (state) => state.isPlay,
                  builder: (context, isPlay) => isPlay
                      ? IconButton(
                          onPressed: () {
                            context.addEvent(const _SetPause());
                          },
                          icon: const Icon(Icons.pause_outlined, size: 36),
                        )
                      : IconButton(
                          onPressed: () {
                            context.addEvent(const _SetPlay());
                          },
                          icon: const Icon(Icons.play_arrow_outlined, size: 36),
                        ),
                ),
                _BlocSelector<bool>(
                  selector: (state) => state.hasNext,
                  builder: (context, hasNext) => IconButton(
                    onPressed: hasNext
                        ? () {
                            context.addEvent(const _RequestNextPage());
                          }
                        : null,
                    icon: const Icon(Icons.skip_next_outlined),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: IconButton(
                onPressed: () {
                  context.addEvent(const _ToggleTimeline());
                },
                icon: _BlocSelector<bool>(
                  selector: (state) => state.isShowTimeline,
                  builder: (context, isShowTimeline) => isShowTimeline
                      ? const Icon(Icons.view_timeline)
                      : const Icon(Icons.view_timeline_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InitBody extends StatelessWidget {
  const _InitBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(child: CircularProgressIndicator()),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: 0,
          start: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

@npLog
class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.state.isShowTimeline) {
          context.addEvent(const _ToggleTimeline());
        } else {
          context.addEvent(const _ToggleShowUi());
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          _BlocSelector<bool>(
            selector: (state) => state.hasInit,
            builder: (context, hasInit) =>
                hasInit ? const _PageViewer() : const SizedBox.shrink(),
          ),
          _BlocSelector<bool>(
            selector: (state) => state.isShowUi,
            builder: (context, isShowUi) => AnimatedVisibility(
              opacity: isShowUi ? 1 : 0,
              duration: k.animationDurationNormal,
              child: const Align(
                alignment: Alignment.topCenter,
                child: _AppBar(),
              ),
            ),
          ),
          _BlocSelector<bool>(
            selector: (state) => state.isShowUi,
            builder: (context, isShowUi) => AnimatedVisibility(
              opacity: isShowUi ? 1 : 0,
              duration: k.animationDurationNormal,
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: _ControlBar(),
              ),
            ),
          ),
          _BlocSelector<bool>(
            selector: (state) => state.isShowTimeline,
            builder: (context, isShowTimeline) => AnimatedPositionedDirectional(
              top: 0,
              bottom: 0,
              end: isShowTimeline ? 0 : -_Timeline.width,
              duration: k.animationDurationNormal,
              // needed because Timeline rely on some late var
              child: _BlocSelector<bool>(
                selector: (state) => state.hasShownTimeline,
                builder: (context, hasShownTimeline) => Visibility(
                  visible: hasShownTimeline,
                  child: const _Timeline(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageViewer extends StatefulWidget {
  const _PageViewer();

  @override
  State<StatefulWidget> createState() => _PageViewerState();
}

class _PageViewerState extends State<_PageViewer> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen: (previous, current) =>
              previous.nextPage != current.nextPage,
          listener: (context, state) {
            if (state.shouldAnimateNextPage) {
              _controller.animateToPage(
                state.nextPage,
                duration: k.animationDurationLong,
                curve: Curves.easeInOut,
              );
            } else {
              _controller.jumpToPage(state.nextPage);
            }
          },
        ),
      ],
      child: HorizontalPageViewer(
        pageCount: context.bloc.pageCount,
        pageBuilder: (context, index) => FractionallySizedBox(
          widthFactor: 1 / _viewportFraction,
          child: _PageView.ofPage(context, index),
        ),
        initialPage: context.bloc.initialPage,
        controller: _controller,
        viewportFraction: _viewportFraction,
        canSwitchPage: false,
        onPageChanged: (from, to) {
          context.addEvent(_SetCurrentPage(to));
        },
      ),
    );
  }

  final _controller = HorizontalPageViewerController();
}

@npLog
class _PageView extends StatelessWidget {
  const _PageView._({
    required this.page,
    required this.itemIndex,
  });

  factory _PageView.ofPage(BuildContext context, int page) => _PageView._(
        page: page,
        itemIndex: context.bloc.convertPageToFileIndex(page),
      );

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<FileDescriptor?>(
      selector: (state) => state.files[itemIndex],
      builder: (context, file) {
        if (file == null) {
          return Center(
            child: Text(
              L10n.global().fileNotFound,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        if (file_util.isSupportedImageFormat(file)) {
          return _ImagePageView(
            file: file,
            onLoaded: () {
              context.addEvent(_PreloadSidePages(page));
            },
          );
        } else if (file_util.isSupportedVideoFormat(file)) {
          return _VideoPageView(
            file: file,
            onCompleted: () {
              context.addEvent(const _VideoCompleted());
            },
          );
        } else {
          _log.shout("[build] Unknown file format: ${file.fdMime}");
          return const SizedBox.shrink();
        }
      },
    );
  }

  final int page;
  final int itemIndex;
}

class _ImagePageView extends StatelessWidget {
  const _ImagePageView({
    required this.file,
    this.onLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return RemoteImageViewer(
      account: context.bloc.account,
      file: file,
      canZoom: false,
      onLoaded: onLoaded,
    );
  }

  final FileDescriptor file;
  final VoidCallback? onLoaded;
}

class _VideoPageView extends StatelessWidget {
  const _VideoPageView({
    required this.file,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return FileContentView(
      file: file,
      shouldPlayLivePhoto: false,
      canZoom: false,
      canLoop: false,
      isPlayControlVisible: false,
      onLoadFailure: () {
        // error, next
        Future.delayed(const Duration(seconds: 2), onCompleted);
      },
      onVideoPlayingChanged: (isPlaying) {
        if (!isPlaying) {
          // video ended
          Future.delayed(const Duration(seconds: 2), onCompleted);
        }
      },
    );
  }

  final FileDescriptor file;
  final VoidCallback? onCompleted;
}

const _viewportFraction = 1.05;
