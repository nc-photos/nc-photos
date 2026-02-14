import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:np_common/object_util.dart';

/// A square thumbnail widget for a file
class NetworkRectThumbnail extends StatefulWidget {
  const NetworkRectThumbnail({
    super.key,
    required this.account,
    required this.imageUrl,
    required this.mime,
    this.dimension,
    this.cacheType = CachedNetworkImageType.thumbnail,
    required this.errorBuilder,
    this.onSize,
    this.onDominantColor,
  });

  static String imageUrlForFile(Account account, FileDescriptor file) {
    return getThumbnailUrlForImageFile(account, file);
  }

  @override
  State<StatefulWidget> createState() => NetworkRectThumbnailState();

  final Account account;
  final String imageUrl;
  final String? mime;
  final double? dimension;
  final CachedNetworkImageType cacheType;
  final Widget Function(BuildContext context) errorBuilder;
  final ValueChanged<Size>? onSize;
  final ValueChanged<ColorScheme>? onDominantColor;
}

class NetworkRectThumbnailState extends State<NetworkRectThumbnail> {
  @override
  Widget build(BuildContext context) {
    final child = FittedBox(
      clipBehavior: Clip.hardEdge,
      fit: BoxFit.cover,
      child:
          CachedNetworkImageBuilder(
            type: widget.cacheType,
            imageUrl: widget.imageUrl,
            mime: widget.mime,
            account: widget.account,
            imageBuilder: (_, child, imageProvider) {
              if (widget.onDominantColor != null) {
                final currentTheme = Theme.of(context);
                if (!identical(_theme, currentTheme)) {
                  _theme = Theme.of(context);
                  ColorScheme.fromImageProvider(
                    provider: imageProvider,
                    brightness: _theme!.brightness,
                  ).then((cs) {
                    widget.onDominantColor?.call(cs);
                  });
                }
              }
              return _SizeObserver(onSize: widget.onSize, child: child);
            },
            errorWidget:
                (context, __, ___) => SizedBox.square(
                  dimension: widget.dimension,
                  child: widget.errorBuilder(context),
                ),
          ).build(),
    );
    if (widget.dimension != null) {
      return SizedBox.square(dimension: widget.dimension, child: child);
    } else {
      return AspectRatio(aspectRatio: 1, child: child);
    }
  }

  ThemeData? _theme;
}

class _SizeObserver extends SingleChildRenderObjectWidget {
  const _SizeObserver({super.child, this.onSize});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(
      onLayoutChangedCallback: () {
        if (onSize != null) {
          final size = context.findRenderObject()?.as<RenderBox>()?.size;
          if (size != null) {
            onSize?.call(size);
          }
        }
      },
    );
  }

  final ValueChanged<Size>? onSize;
}

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    RenderBox? child,
    required this.onLayoutChangedCallback,
  }) : super(child);

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      onLayoutChangedCallback();
    }
    _oldSize = size;
  }

  final VoidCallback onLayoutChangedCallback;

  Size? _oldSize;
}
