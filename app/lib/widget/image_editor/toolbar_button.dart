import 'package:flutter/material.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:np_ui/np_ui.dart';

/// Button in the image editor toolbar
///
/// If [activationOrder] != null, this button is considered activated. And if
/// [activationOrder] >= 0, a number will be drawn on top to represent its
/// current order.
class ToolbarButton extends StatelessWidget {
  const ToolbarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.activationOrder,
  });

  @override
  build(BuildContext context) {
    final Color backgroundColor, foregroundColor;
    if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
      foregroundColor = Theme.of(context).colorScheme.onSecondaryContainer;
    } else {
      if (isActivated) {
        backgroundColor = M3.of(context).filterChip.disabled.containerSelected;
        foregroundColor = Theme.of(context).colorScheme.onSurface;
      } else {
        backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
        foregroundColor = M3.of(context).filterChip.disabled.labelText;
      }
    }
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedOpacity(
                    opacity: isSelected || isActivated ? 1 : 0,
                    duration: k.animationDurationNormal,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: backgroundColor,
                      ),
                    ),
                  ),
                  Center(child: Icon(icon, size: 32, color: foregroundColor)),
                  if (isActivated && activationOrder! >= 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          (activationOrder! + 1).toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: foregroundColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isActivated => activationOrder != null;

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
  final int? activationOrder;
}
