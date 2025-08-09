import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';

class PersonThumbnail extends StatefulWidget {
  const PersonThumbnail({
    super.key,
    required this.dimension,
    required this.account,
    required this.coverUrl,
    required this.coverMime,
    required this.person,
  });

  @override
  State<StatefulWidget> createState() => _PersonThumbnailState();

  final double dimension;
  final Account account;
  final String? coverUrl;
  final String? coverMime;
  final Person person;
}

class _PersonThumbnailState extends State<PersonThumbnail> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    try {
      var m = Matrix4.identity();
      if (_layoutSize != null) {
        final ratio =
            widget.dimension /
            math.min(_layoutSize!.width, _layoutSize!.height);
        final mm = widget.person.getCoverTransform(
          widget.dimension.toInt(),
          (_layoutSize!.width * ratio).toInt(),
          (_layoutSize!.height * ratio).toInt(),
        );
        if (mm != null) {
          m = mm;
        }
      }
      content = Transform(
        transform: m,
        child: NetworkRectThumbnail(
          account: widget.account,
          imageUrl: widget.coverUrl!,
          mime: widget.coverMime,
          errorBuilder: (_) => const _Placeholder(),
          onSize: (size) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _layoutSize = size;
              });
            });
          },
        ),
      );
      if (_layoutSize == null) {
        content = Opacity(opacity: 0, child: content);
      }
    } catch (_) {
      content = const FittedBox(child: _Placeholder());
    }

    return ClipRRect(
      child: SizedBox.square(
        dimension: widget.dimension,
        child: Container(
          color: Theme.of(context).listPlaceholderBackgroundColor,
          constraints: const BoxConstraints.expand(),
          child: content,
        ),
      ),
    );
  }

  Size? _layoutSize;
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.person,
        color: Theme.of(context).listPlaceholderForegroundColor,
      ),
    );
  }
}
