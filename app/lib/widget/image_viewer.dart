import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/flutter_util.dart' as flutter_util;
import 'package:nc_photos/mobile/android/content_uri_image_provider.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/zoomable_viewer.dart';
import 'package:np_log/np_log.dart';

part 'image_viewer.g.dart';

class LocalImageViewer extends StatefulWidget {
  const LocalImageViewer({
    super.key,
    required this.file,
    required this.canZoom,
    this.onLoaded,
    this.onHeightChanged,
    this.onZoomStarted,
    this.onZoomEnded,
  });

  @override
  State<StatefulWidget> createState() => _LocalImageViewerState();

  final LocalFile file;
  final bool canZoom;
  final VoidCallback? onLoaded;
  final ValueChanged<double>? onHeightChanged;
  final VoidCallback? onZoomStarted;
  final VoidCallback? onZoomEnded;
}

@npLog
class _LocalImageViewerState extends State<LocalImageViewer> {
  @override
  Widget build(BuildContext context) {
    final ImageProvider provider;
    if (widget.file is LocalUriFile) {
      provider = ContentUriImage((widget.file as LocalUriFile).uri);
    } else {
      throw ArgumentError("Invalid file");
    }

    return _ImageViewer(
      canZoom: widget.canZoom,
      onHeightChanged: widget.onHeightChanged,
      onZoomStarted: widget.onZoomStarted,
      onZoomEnded: widget.onZoomEnded,
      child: Hero(
        tag: flutter_util.HeroTag.fromLocalFile(widget.file),
        child: Image(
          image: provider,
          fit: BoxFit.contain,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onItemLoaded();
            });
            return child;
          },
        ),
      ),
    );
  }

  void _onItemLoaded() {
    if (!_isLoaded) {
      _log.info("[_onItemLoaded] ${widget.file.logTag}");
      _isLoaded = true;
      widget.onLoaded?.call();
    }
  }

  var _isLoaded = false;
}

class RemoteImageViewer extends StatefulWidget {
  const RemoteImageViewer({
    super.key,
    required this.account,
    required this.file,
    required this.canZoom,
    this.onLoaded,
    this.onHeightChanged,
    this.onZoomStarted,
    this.onZoomEnded,
  });

  @override
  createState() => _RemoteImageViewerState();

  static void preloadImage(Account account, FileDescriptor file) {
    final cacheManager = getCacheManager(
      CachedNetworkImageType.largeImage,
      file.fdMime,
    );
    cacheManager.getFileStream(
      getViewerUrlForImageFile(account, file),
      headers: {"Authorization": AuthUtil.fromAccount(account).toHeaderValue()},
    );
  }

  final Account account;
  final FileDescriptor file;
  final bool canZoom;
  final VoidCallback? onLoaded;
  final ValueChanged<double>? onHeightChanged;
  final VoidCallback? onZoomStarted;
  final VoidCallback? onZoomEnded;
}

@npLog
class _RemoteImageViewerState extends State<RemoteImageViewer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // needed to get rid of the large image blinking during Hero animation
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ImageViewer(
      canZoom: widget.canZoom,
      onHeightChanged: widget.onHeightChanged,
      onZoomStarted: widget.onZoomStarted,
      onZoomEnded: widget.onZoomEnded,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: !_isHeroDone || !_isLoaded ? 1 : 0,
            child: Hero(
              tag: flutter_util.HeroTag.fromFile(widget.file),
              flightShuttleBuilder: (
                flightContext,
                animation,
                flightDirection,
                fromHeroContext,
                toHeroContext,
              ) {
                _isHeroDone = false;
                animation.addStatusListener(_animationListener);
                return flutter_util.defaultHeroFlightShuttleBuilder(
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                );
              },
              child: _PreviewImage(account: widget.account, file: widget.file),
            ),
          ),
          if (_isHeroDone)
            _FullSizedImage(
              account: widget.account,
              file: widget.file,
              onItemLoaded: _onItemLoaded,
            ),
        ],
      ),
    );
  }

  void _onItemLoaded() {
    if (!_isLoaded) {
      _log.info("[_onItemLoaded]");
      _isLoaded = true;
      widget.onLoaded?.call();
    }
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _isHeroDone = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  var _isLoaded = false;
  // initially set to true such that the large image will show when hero didn't
  // run (i.e., when swiping in viewer)
  var _isHeroDone = true;
}

class _ImageViewer extends StatefulWidget {
  const _ImageViewer({
    required this.child,
    required this.canZoom,
    this.onHeightChanged,
    this.onZoomStarted,
    this.onZoomEnded,
  });

  @override
  createState() => _ImageViewerState();

  final Widget child;
  final bool canZoom;
  final ValueChanged<double>? onHeightChanged;
  final VoidCallback? onZoomStarted;
  final VoidCallback? onZoomEnded;
}

@npLog
class _ImageViewerState extends State<_ImageViewer>
    with TickerProviderStateMixin {
  @override
  build(BuildContext context) {
    final content = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_key.currentContext != null) {
              widget.onHeightChanged?.call(_key.currentContext!.size!.height);
            }
          });
          return false;
        },
        child: SizeChangedLayoutNotifier(
          key: _key,
          child: IntrinsicHeight(child: widget.child),
        ),
      ),
    );
    if (widget.canZoom) {
      return ZoomableViewer(
        onZoomStarted: widget.onZoomStarted,
        onZoomEnded: widget.onZoomEnded,
        child: content,
      );
    } else {
      return content;
    }
  }

  final _key = GlobalKey();
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.account, required this.file});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImageBuilder(
      type: CachedNetworkImageType.thumbnail,
      imageUrl: NetworkRectThumbnail.imageUrlForFile(account, file),
      mime: file.fdMime,
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

class _FullSizedImage extends StatelessWidget {
  const _FullSizedImage({
    required this.account,
    required this.file,
    this.onItemLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImageBuilder(
      type: CachedNetworkImageType.largeImage,
      imageUrl: getViewerUrlForImageFile(account, file),
      mime: file.fdMime,
      account: account,
      fit: BoxFit.contain,
      imageBuilder: (context, child, imageProvider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onItemLoaded?.call();
        });
        const SizeChangedLayoutNotification().dispatch(context);
        return child;
      },
    ).build();
  }

  final Account account;
  final FileDescriptor file;
  final VoidCallback? onItemLoaded;
}
