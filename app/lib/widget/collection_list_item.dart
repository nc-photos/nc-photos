import 'package:flutter/material.dart';
import 'package:nc_photos/theme.dart';

class CollectionListSmall extends StatelessWidget {
  const CollectionListSmall({
    super.key,
    required this.label,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        SizedBox.expand(child: child),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: .5),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.black.withValues(alpha: .5),
                constraints: const BoxConstraints(minWidth: double.infinity),
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).onDarkSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
    if (onTap != null) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          content,
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      );
    }
    return Container(
      color: Theme.of(context).listPlaceholderBackgroundColor,
      constraints: const BoxConstraints.expand(),
      child: content,
    );
  }

  final String label;
  final Widget? child;
  final VoidCallback? onTap;
}
