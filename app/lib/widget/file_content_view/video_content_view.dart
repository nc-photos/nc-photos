part of '../file_content_view.dart';

class _VideoContentView extends StatelessWidget {
  const _VideoContentView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: _BlocSelector(
        selector: (state) => state.isLoaded,
        builder: (context, isLoaded) =>
            isLoaded ? const _VideoPlayerView() : Container(),
      ),
    );
  }
}

class _VideoPlayerView extends StatefulWidget {
  const _VideoPlayerView();

  @override
  State<StatefulWidget> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<_VideoPlayerView>
    with DisposableManagerMixin<_VideoPlayerView> {
  @override
  void initState() {
    super.initState();
    _listenToHeightChanged();
  }

  @override
  List<Disposable> initDisposables() {
    return [
      ...super.initDisposables(),
      WakelockControllerDisposable(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.videoAspectRatio,
      builder: (context, videoAspectRatio) {
        final player = Align(
          alignment: Alignment.center,
          child: AspectRatio(
            key: _key,
            aspectRatio: videoAspectRatio,
            child: IgnorePointer(
              child: VideoPlayer(context.bloc.videoController),
            ),
          ),
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: _BlocSelector(
                selector: (state) => state.canZoom,
                builder: (context, canZoom) => canZoom
                    ? ZoomableViewer(
                        onZoomStarted: () {
                          context.addEvent(const _SetIsZoomed(true));
                        },
                        onZoomEnded: () {
                          context.addEvent(const _SetIsZoomed(false));
                        },
                        child: player,
                      )
                    : player,
              ),
            ),
            Positioned.fill(
              child: _BlocSelector(
                selector: (state) => state.isPlayControlVisible,
                builder: (context, isPlayControlVisible) => AnimatedVisibility(
                  opacity: isPlayControlVisible ? 1.0 : 0.0,
                  duration: k.animationDurationNormal,
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: _BlocSelector(
                        selector: (state) => state.isPlaying,
                        builder: (context, isPlaying) => IconButton(
                          icon: Icon(isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled),
                          iconSize: 48,
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          onPressed: () {
                            context.addEvent(const _ToggleVideoPlay());
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: kToolbarHeight + 8, left: 8, right: 8),
                child: _BlocSelector(
                  selector: (state) => state.isPlayControlVisible,
                  builder: (context, isPlayControlVisible) =>
                      AnimatedVisibility(
                    opacity: isPlayControlVisible ? 1.0 : 0.0,
                    duration: k.animationDurationNormal,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: context.bloc.videoController,
                            builder: (context, value, child) => Text(
                              _durationToString(value.position),
                              style: Theme.of(context).textStyleColored(
                                (textTheme) => textTheme.labelLarge,
                                (colorScheme) => colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: VideoProgressIndicator(
                              context.bloc.videoController,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              colors: VideoProgressColors(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                bufferedColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                playedColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _BlocSelector(
                            selector: (state) => state.videoDuration,
                            builder: (context, videoDuration) =>
                                videoDuration != Duration.zero
                                    ? Text(
                                        _durationToString(videoDuration),
                                        style:
                                            Theme.of(context).textStyleColored(
                                          (textTheme) => textTheme.labelLarge,
                                          (colorScheme) =>
                                              colorScheme.onSurface,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                          ),
                          const SizedBox(width: 4),
                          _BlocSelector(
                            selector: (state) => state.canLoop,
                            builder: (context, canLoop) => canLoop
                                ? const _LoopToggle()
                                : const SizedBox.shrink(),
                          ),
                          const _MuteToggle(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _listenToHeightChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_key.currentContext == null) {
        _listenToHeightChanged();
      } else {
        if (context.mounted) {
          context
              .addEvent(_SetContentHeight(_key.currentContext!.size!.height));
        }
      }
    });
  }

  final _key = GlobalKey();
}

class _LoopToggle extends StatelessWidget {
  const _LoopToggle();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: L10n.global().loopTooltip,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: () {
          context.addEvent(const _ToggleVideoLoop());
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _BlocSelector(
            selector: (state) => state.videoIsLooping,
            builder: (context, videoIsLooping) => AnimatedSwitcher(
              duration: k.animationDurationNormal,
              child: videoIsLooping
                  ? const Icon(
                      Icons.loop,
                      key: Key("loop_on"),
                    )
                  : const Icon(
                      Icons.sync_disabled,
                      key: Key("loop_off"),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MuteToggle extends StatelessWidget {
  const _MuteToggle();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.videoVolume,
      builder: (context, videoVolume) => Tooltip(
        message: videoVolume == 0
            ? L10n.global().unmuteTooltip
            : L10n.global().muteTooltip,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          onTap: () {
          context.addEvent(const _ToggleVideoMute());
          },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AnimatedSwitcher(
              duration: k.animationDurationNormal,
              child: videoVolume == 0
                  ? const Icon(
                      Icons.volume_off_outlined,
                      key: Key("mute_on"),
                    )
                  : const Icon(
                      Icons.volume_up_outlined,
                      key: Key("mute_off"),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

String _durationToString(Duration duration) {
  String product = "";
  if (duration.inHours > 0) {
    product += "${duration.inHours}:";
  }
  final minStr = (duration.inMinutes % 60).toString().padLeft(2, "0");
  final secStr = (duration.inSeconds % 60).toString().padLeft(2, "0");
  product += "$minStr:$secStr";
  return product;
}
