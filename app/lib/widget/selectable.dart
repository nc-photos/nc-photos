import 'package:flutter/material.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/widget/animated_smooth_clip_r_rect.dart';

// Overlay a check mark if an item is selected
class Selectable extends StatelessWidget {
  const Selectable({
    super.key,
    required this.child,
    this.isSelected = false,
    required this.iconSize,
    this.borderRadius,
    this.childBorderRadius = BorderRadius.zero,
    this.indicatorAlignment = Alignment.topLeft,
    this.onTap,
    this.onLongPress,
  });

  @override
  build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (isSelected)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: borderRadius,
              ),
            ),
          ),
        AnimatedScale(
          scale: isSelected ? .85 : 1,
          curve: Curves.easeInOut,
          duration: k.animationDurationNormal,
          child:
              childBorderRadius != BorderRadius.zero
                  ? AnimatedSmoothClipRRect(
                    smoothness: 1,
                    borderRadius:
                        isSelected ? childBorderRadius : BorderRadius.zero,
                    side: BorderSide(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Theme.of(context).colorScheme.secondaryContainer
                                  .withValues(alpha: 0),
                      width: isSelected ? 4 : 0,
                    ),
                    curve: Curves.easeInOut,
                    duration: k.animationDurationNormal,
                    child: child,
                  )
                  : child,
        ),
        Align(
          alignment: indicatorAlignment,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0,
            duration: k.animationDurationNormal,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: iconSize - 2,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Icon(
                  Icons.check_circle_outlined,
                  size: iconSize,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ],
            ),
          ),
        ),
        if (onTap != null || onLongPress != null)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                borderRadius: borderRadius,
              ),
            ),
          ),
      ],
    );
  }

  final Widget child;
  final bool isSelected;
  final double iconSize;
  final BorderRadius? borderRadius;

  /// Border radius used to clip the child widget when selected
  final BorderRadius childBorderRadius;
  final Alignment indicatorAlignment;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
}
