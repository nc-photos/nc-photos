import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/entity/any_file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/mobile/android/content_uri_image_provider.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/request_public_link.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

part 'live_photo_viewer.g.dart';

class LivePhotoViewer extends StatefulWidget {
  const LivePhotoViewer({
    super.key,
    required this.account,
    required this.file,
    this.onLoaded,
    this.onLoadFailure,
    this.onHeightChanged,
    this.canPlay = true,
    this.livePhotoType,
  });

  @override
  State<StatefulWidget> createState() => _LivePhotoViewerState();

  final Account account;
  final AnyFile file;
  final VoidCallback? onLoaded;
  final void Function(Object? error, StackTrace? stackTrace)? onLoadFailure;
  final ValueChanged<double>? onHeightChanged;
  final bool canPlay;
  final LivePhotoType? livePhotoType;
}

@npLog
class _LivePhotoViewerState extends State<LivePhotoViewer> {
  @override
  void initState() {
    super.initState();
    _initController().onError((e, stackTrace) {
      _log.shout("[initState] Failed while _initController", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
      widget.onLoadFailure?.call(e, stackTrace);
    });

    _lifecycleListener = AppLifecycleListener(
      onShow: () {
        if (_controller.value.isInitialized) {
          _controller.pause();
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _controller.removeListener(_onControllerChanged);
    _controllerValue?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isControllerInitialized && _controller.value.isInitialized) {
      content = _buildPlayer(context);
    } else {
      content = _PlaceHolderView(account: widget.account, file: widget.file);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: content,
    );
  }

  Future<void> _initController() async {
    try {
      _controllerValue = await _createVideoController();
      await _controller.initialize();
      await _controller.setVolume(0);
      await _controller.setLooping(true);
      widget.onLoaded?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_key.currentContext != null) {
          widget.onHeightChanged?.call(_key.currentContext!.size!.height);
        }
      });
      _controller.addListener(_onControllerChanged);
      setState(() {
        _isControllerInitialized = true;
      });
      await _controller.play();
    } catch (e, stackTrace) {
      _log.shout("[_initController] Failed while initialize", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
      widget.onLoadFailure?.call(e, stackTrace);
    }
  }

  Future<VideoPlayerController> _createVideoController() async {
    if (widget.file is FileDescriptor) {
      if (getRawPlatform() != NpPlatform.web) {
        try {
          return _createVideoControllerWithFileUrl(
            widget.file as FileDescriptor,
          );
        } catch (e, stackTrace) {
          _log.warning(
            "[_createVideoController] Failed while _createVideoControllerWithFileUrl",
            e,
            stackTrace,
          );
        }
      }
      return await _createVideoControllerWithPublicUrl(
        widget.file as FileDescriptor,
      );
    } else if (widget.file is LocalUriFile) {
      return _createVideoControllerWithContentUri(widget.file as LocalUriFile);
    } else {
      throw StateError("File type not supported");
    }
  }

  VideoPlayerController _createVideoControllerWithFileUrl(FileDescriptor file) {
    final uri = api_util.getFileUri(widget.account, file);
    _log.fine("[_createVideoWithFileUrl] URI: $uri");
    final controller = VideoPlayerController.networkUrl(
      uri,
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(widget.account).toHeaderValue(),
      },
      livePhotoType: widget.livePhotoType,
    );
    return controller;
  }

  Future<VideoPlayerController> _createVideoControllerWithPublicUrl(
    FileDescriptor file,
  ) async {
    final url = await RequestPublicLink()(widget.account, file);
    _log.fine("[_createVideoControllerWithPublicUrl] URL: $url");
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(widget.account).toHeaderValue(),
      },
      livePhotoType: widget.livePhotoType,
    );
    return controller;
  }

  VideoPlayerController _createVideoControllerWithContentUri(
    LocalUriFile file,
  ) {
    _log.fine("[_createVideoControllerWithContentUri] URI: ${file.uri}");
    final controller = VideoPlayerController.contentUri(
      Uri.parse(file.uri),
      livePhotoType: widget.livePhotoType,
    );
    return controller;
  }

  Widget _buildPlayer(BuildContext context) {
    if (_controller.value.isPlaying && !widget.canPlay) {
      _log.info("Pause playback");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.pause();
      });
    } else if (!_controller.value.isPlaying && widget.canPlay) {
      _log.info("Resume playback");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.play();
      });
    }
    return Center(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AspectRatio(
              key: _key,
              aspectRatio: _controller.value.aspectRatio,
              child: IgnorePointer(child: VideoPlayer(_controller)),
            ),
          ),
          if (!_isLoaded) ...[
            _PlaceHolderView(account: widget.account, file: widget.file),
          ],
        ],
      ),
    );
  }

  void _onControllerChanged() {
    if (!_controller.value.isInitialized) {
      return;
    }
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = !_isPlaying;
        _isLoaded = true;
      });
    }
  }

  VideoPlayerController get _controller => _controllerValue!;

  final _key = GlobalKey();
  bool _isControllerInitialized = false;
  VideoPlayerController? _controllerValue;
  var _isPlaying = false;
  var _isLoaded = false;
  late final AppLifecycleListener _lifecycleListener;
}

class _PlaceHolderView extends StatelessWidget {
  const _PlaceHolderView({required this.account, required this.file});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (file is FileDescriptor)
          _RemotePlaceHolderView(account: account, file: file as FileDescriptor)
        else if (file is LocalUriFile)
          _LocalPlaceHolderView(file: file as LocalUriFile),
        ColoredBox(color: Colors.black.withValues(alpha: .7)),
        const Center(child: _ProgressIndicator()),
      ],
    );
  }

  final Account account;
  final AnyFile file;
}

class _RemotePlaceHolderView extends StatelessWidget {
  const _RemotePlaceHolderView({required this.account, required this.file});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImageBuilder(
      type: CachedNetworkImageType.largeImage,
      imageUrl: getViewerUrlForImageFile(account, file),
      mime: file.afMime,
      account: account,
      fit: BoxFit.contain,
      imageBuilder: (context, child, imageProvider) {
        const SizeChangedLayoutNotification().dispatch(context);
        return child;
      },
    ).build();
  }

  final Account account;
  final FileDescriptor file;
}

class _LocalPlaceHolderView extends StatelessWidget {
  const _LocalPlaceHolderView({required this.file});

  @override
  Widget build(BuildContext context) {
    final provider = ContentUriImage(file.uri);
    return Image(image: provider, fit: BoxFit.contain);
  }

  final LocalUriFile file;
}

class _ProgressIndicator extends StatefulWidget {
  const _ProgressIndicator();

  @override
  State<StatefulWidget> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: animationController.drive(
            CurveTween(curve: Curves.easeInOutCubic),
          ),
          filterQuality: FilterQuality.high,
          child: Icon(
            Icons.motion_photos_on_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Icon(
          Icons.play_arrow_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
}
