import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/request_public_link.dart';
import 'package:nc_photos/widget/disposable.dart';
import 'package:nc_photos/widget/wakelock_util.dart';
import 'package:nc_photos/widget/zoomable_viewer.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:np_ui/np_ui.dart';
import 'package:video_player/video_player.dart';

part 'video_viewer.g.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({
    super.key,
    required this.account,
    required this.file,
    this.onLoaded,
    this.onLoadFailure,
    this.onHeightChanged,
    this.onPlay,
    this.onPause,
    this.isControlVisible = false,
    this.canPlay = true,
    this.canLoop = true,
    required this.canZoom,
    this.onZoomStarted,
    this.onZoomEnded,
  });

  @override
  createState() => _VideoViewerState();

  final Account account;
  final FileDescriptor file;
  final VoidCallback? onLoaded;
  final VoidCallback? onLoadFailure;
  final ValueChanged<double>? onHeightChanged;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final bool isControlVisible;
  final bool canPlay;

  /// If false, disable the loop control and always stop after playing once
  final bool canLoop;

  final bool canZoom;
  final VoidCallback? onZoomStarted;
  final VoidCallback? onZoomEnded;
}

@npLog
class _VideoViewerState extends State<VideoViewer>
    with DisposableManagerMixin<VideoViewer> {
  @override
  void initState() {
    super.initState();
    _getVideoUrl().then((url) {
      if (mounted) {
        setState(() {
          _initController(url);
        });
      }
    }).onError((e, stacktrace) {
      _log.shout("[initState] Failed while _getVideoUrl", e, stacktrace);
      SnackBarManager().showSnackBarForException(e);
      widget.onLoadFailure?.call();
    });
  }

  @override
  void dispose() {
    _controllerValue?.dispose();
    super.dispose();
  }

  @override
  initDisposables() {
    return [
      ...super.initDisposables(),
      WakelockControllerDisposable(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isControllerInitialized && _controller.value.isInitialized) {
      content = _buildPlayer(context);
    } else {
      content = Container();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: content,
    );
  }

  Future<void> _initController(String url) async {
    try {
      _controllerValue = VideoPlayerController.networkUrl(
        Uri.parse(url),
        httpHeaders: {
          "Authorization": AuthUtil.fromAccount(widget.account).toHeaderValue(),
        },
      );
      await _controller.initialize();
      final c = KiwiContainer().resolve<DiContainer>();
      unawaited(_controller.setVolume(c.pref.isVideoPlayerMuteOr() ? 0 : 1));
      if (widget.canLoop) {
        unawaited(_controller.setLooping(c.pref.isVideoPlayerLoopOr()));
      }
      widget.onLoaded?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_key.currentContext != null) {
          widget.onHeightChanged?.call(_key.currentContext!.size!.height);
        }
      });
      _controller.addListener(_onControllerChanged);
      _isControllerInitialized = true;
      setState(() {
        _play();
      });
    } catch (e, stackTrace) {
      _log.shout("[_initController] Failed while initialize", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
      widget.onLoadFailure?.call();
    }
  }

  Widget _buildPlayer(BuildContext context) {
    if (_controller.value.isPlaying && !widget.canPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pause();
      });
    }
    final player = Align(
      alignment: Alignment.center,
      child: AspectRatio(
        key: _key,
        aspectRatio: _controller.value.aspectRatio,
        child: IgnorePointer(
          child: VideoPlayer(_controller),
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: widget.canZoom
              ? ZoomableViewer(
                  onZoomStarted: widget.onZoomStarted,
                  onZoomEnded: widget.onZoomEnded,
                  child: player,
                )
              : player,
        ),
        Positioned.fill(
          child: AnimatedVisibility(
            opacity: widget.isControlVisible ? 1.0 : 0.0,
            duration: k.animationDurationNormal,
            child: Container(
              color: Colors.black45,
              child: Center(
                child: IconButton(
                  icon: Icon(_controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled),
                  iconSize: 48,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  onPressed: () => _controller.value.isPlaying
                      ? _onPausePressed()
                      : _onPlayPressed(),
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
            child: AnimatedVisibility(
              opacity: widget.isControlVisible ? 1.0 : 0.0,
              duration: k.animationDurationNormal,
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _controller,
                      builder: (context, VideoPlayerValue value, child) => Text(
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
                        _controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        colors: VideoProgressColors(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          bufferedColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          playedColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_controller.value.duration != Duration.zero)
                      Text(
                        _durationToString(_controller.value.duration),
                        style: Theme.of(context).textStyleColored(
                          (textTheme) => textTheme.labelLarge,
                          (colorScheme) => colorScheme.onSurface,
                        ),
                      ),
                    const SizedBox(width: 4),
                    if (widget.canLoop) _LoopToggle(controller: _controller),
                    _MuteToggle(controller: _controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPlayPressed() {
    if (_controller.value.position == _controller.value.duration) {
      _controller.seekTo(const Duration()).then((_) {
        setState(() {
          _play();
        });
      });
    } else {
      setState(() {
        _play();
      });
    }
  }

  void _onPausePressed() {
    setState(() {
      _pause();
    });
  }

  void _onControllerChanged() {
    if (!_controller.value.isInitialized) {
      return;
    }
    if (!_isFinished &&
        _controller.value.position == _controller.value.duration) {
      _isFinished = true;
      setState(() {
        _pause();
      });
    }
  }

  void _play() {
    if (widget.canPlay) {
      _isFinished = false;
      _controller.play();
      widget.onPlay?.call();
    }
  }

  void _pause() {
    _controller.pause();
    widget.onPause?.call();
  }

  Future<String> _getVideoUrl() async {
    if (getRawPlatform() == NpPlatform.web) {
      return RequestPublicLink()(widget.account, widget.file);
    } else {
      return api_util.getFileUrl(widget.account, widget.file);
    }
  }

  VideoPlayerController get _controller => _controllerValue!;

  final _key = GlobalKey();
  bool _isControllerInitialized = false;
  VideoPlayerController? _controllerValue;
  var _isFinished = false;
}

class _LoopToggle extends StatefulWidget {
  const _LoopToggle({
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _LoopToggleState();

  final VideoPlayerController controller;
}

class _LoopToggleState extends State<_LoopToggle> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: L10n.global().loopTooltip,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: () {
          final willLoop = !widget.controller.value.isLooping;
          setState(() {
            widget.controller.setLooping(willLoop);
          });
          final c = KiwiContainer().resolve<DiContainer>();
          c.pref.setVideoPlayerLoop(willLoop);
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedSwitcher(
            duration: k.animationDurationNormal,
            child: widget.controller.value.isLooping
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
    );
  }
}

class _MuteToggle extends StatefulWidget {
  const _MuteToggle({
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _MuteToggleState();

  final VideoPlayerController controller;
}

class _MuteToggleState extends State<_MuteToggle> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.controller.value.volume == 0
          ? L10n.global().unmuteTooltip
          : L10n.global().muteTooltip,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: () {
          final willMute = widget.controller.value.volume != 0;
          setState(() {
            widget.controller.setVolume(willMute ? 0 : 1);
          });
          final c = KiwiContainer().resolve<DiContainer>();
          c.pref.setVideoPlayerMute(willMute);
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedSwitcher(
            duration: k.animationDurationNormal,
            child: widget.controller.value.volume == 0
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
