import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/flutter_util.dart' as flutter_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/content_uri_image_provider.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/widget/cached_network_image_mod.dart' as mod;
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
  createState() => _LocalImageViewerState();

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
  build(BuildContext context) {
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
    LargeImageCacheManager.inst.getFileStream(
      _getImageUrl(account, file),
      headers: {
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
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
              tag: flutter_util.getImageHeroTag(widget.file),
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
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
              child: _PreviewImage(
                account: widget.account,
                file: widget.file,
              ),
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

String _getImageUrl(Account account, FileDescriptor file) {
  if (file.fdMime == "image/gif") {
    return api_util.getFileUrl(account, file);
  } else {
    return api_util.getFilePreviewUrl(
      account,
      file,
      width: k.photoLargeSize,
      height: k.photoLargeSize,
      isKeepAspectRatio: true,
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({
    required this.account,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return mod.CachedNetworkImage(
      fit: BoxFit.contain,
      cacheManager: ThumbnailCacheManager.inst,
      imageUrl: NetworkRectThumbnail.imageUrlForFile(account, file),
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
      fadeInDuration: const Duration(),
      filterQuality: FilterQuality.high,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      imageBuilder: (context, child, imageProvider) {
        const SizeChangedLayoutNotification().dispatch(context);
        return child;
      },
    );
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
    return mod.CachedNetworkImage(
      fit: BoxFit.contain,
      cacheManager: LargeImageCacheManager.inst,
      imageUrl: _getImageUrl(account, file),
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
      fadeInDuration: const Duration(),
      filterQuality: FilterQuality.high,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      imageBuilder: (context, child, imageProvider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onItemLoaded?.call();
        });
        const SizeChangedLayoutNotification().dispatch(context);
        return child;
      },
    );
  }

  final Account account;
  final FileDescriptor file;
  final VoidCallback? onItemLoaded;
}
