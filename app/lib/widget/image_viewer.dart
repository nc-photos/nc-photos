import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/factory.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/flutter_util.dart' as flutter_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/content_uri_image_provider.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/zoomable_viewer.dart';
import 'package:np_common/size.dart';
import 'package:np_log/np_log.dart';

part 'image_viewer.g.dart';

class LocalImageViewer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ImageProvider provider;
    final ImageProvider heroProvider;
    if (file is LocalUriFile) {
      provider = ContentUriImage((file as LocalUriFile).uri);
      heroProvider = ContentUriImage(
        (file as LocalUriFile).uri,
        thumbnailSizeHint: SizeInt.square(k.photoThumbSize),
      );
    } else {
      throw ArgumentError("Invalid file");
    }

    return _ImageViewer(
      canZoom: canZoom,
      onHeightChanged: onHeightChanged,
      onZoomStarted: onZoomStarted,
      onZoomEnded: onZoomEnded,
      child: _ImageViewHeroContainer(
        file: file.toAnyFile(),
        heroImageBuilder:
            (context) => Image(
              image: heroProvider,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                const SizeChangedLayoutNotification().dispatch(context);
                return child;
              },
            ),
        imageBuilder:
            (context, onLoaded) => Image(
              image: provider,
              fit: BoxFit.contain,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onLoaded();
                  });
                }
                const SizeChangedLayoutNotification().dispatch(context);
                return child;
              },
            ),
        onLoaded: onLoaded,
      ),
    );
  }

  final LocalFile file;
  final bool canZoom;
  final VoidCallback? onLoaded;
  final ValueChanged<double>? onHeightChanged;
  final VoidCallback? onZoomStarted;
  final VoidCallback? onZoomEnded;
}

class RemoteImageViewer extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return _ImageViewer(
      canZoom: canZoom,
      onHeightChanged: onHeightChanged,
      onZoomStarted: onZoomStarted,
      onZoomEnded: onZoomEnded,
      child: _ImageViewHeroContainer(
        file: file.toAnyFile(),
        heroImageBuilder:
            (context) => _PreviewImage(account: account, file: file),
        imageBuilder:
            (context, onLoaded) => _FullSizedImage(
              account: account,
              file: file,
              onItemLoaded: onLoaded,
            ),
        onLoaded: onLoaded,
      ),
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

class _ImageViewer extends StatefulWidget {
  const _ImageViewer({
    required this.child,
    required this.canZoom,
    this.onHeightChanged,
    this.onZoomStarted,
    this.onZoomEnded,
  });

  @override
  State<StatefulWidget> createState() => _ImageViewerState();

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
  Widget build(BuildContext context) {
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

class _ImageViewHeroContainer extends StatefulWidget {
  const _ImageViewHeroContainer({
    required this.file,
    required this.heroImageBuilder,
    required this.imageBuilder,
    this.onLoaded,
  });

  @override
  State<StatefulWidget> createState() => _ImageViewHeroContainerState();

  final AnyFile file;
  final Widget Function(BuildContext context) heroImageBuilder;
  final Widget Function(BuildContext context, VoidCallback onLoaded)
  imageBuilder;
  final VoidCallback? onLoaded;
}

@npLog
class _ImageViewHeroContainerState extends State<_ImageViewHeroContainer> {
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: !_isHeroDone || !_isLoaded ? 1 : 0,
          child: Hero(
            tag: flutter_util.HeroTag.fromAnyFile(widget.file),
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
            child: widget.heroImageBuilder(context),
          ),
        ),
        if (_isHeroDone) widget.imageBuilder(context, _onItemLoaded),
      ],
    );
  }

  void _onItemLoaded() {
    if (!_isLoaded) {
      _log.info("[_onItemLoaded]");
      setState(() {
        _isLoaded = true;
      });
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
    return AnyFilePresenterFactory.largeImage(
      file.toAnyFile(),
      account: account,
    ).buildWidget(
      fit: BoxFit.contain,
      imageBuilder: (context, child) {
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
