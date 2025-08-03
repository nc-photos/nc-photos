import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:np_log/np_log.dart';

part 'draggable.g.dart';

@npLog
class Draggable<T extends Object> extends StatelessWidget {
  const Draggable({
    super.key,
    required this.data,
    required this.child,
    this.feedback,
    this.onDropBefore,
    this.onDropAfter,
    this.onDragStarted,
    this.onDragEndedAny,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildIndicator(alignment, isActive) {
      return Stack(
        children: [
          Container(),
          Visibility(
            visible: isActive,
            child: Align(
              alignment: alignment,
              child: Container(
                constraints: const BoxConstraints.tightFor(width: 2),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        LongPressDraggable<T>(
          data: data,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          onDragStarted: onDragStarted,
          onDragEnd: (_) => onDragEndedAny?.call(),
          onDragCompleted: onDragEndedAny,
          onDraggableCanceled: (v, o) => onDragEndedAny?.call(),
          feedback: Material(
            type: MaterialType.transparency,
            child: FractionalTranslation(
              translation: const Offset(-.5, -.5),
              child: Opacity(
                opacity: .5,
                child: feedback ?? child,
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: .25,
            child: child,
          ),
          child: child,
        ),
        if (onDropBefore != null || onDropAfter != null)
          Positioned.fill(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (onDropBefore != null)
                  Expanded(
                    child: DragTarget<T>(
                      builder: (context, candidateItems, rejectedItems) {
                        return buildIndicator(AlignmentDirectional.centerStart,
                            candidateItems.isNotEmpty);
                      },
                      onAcceptWithDetails: (details) {
                        _log.fine(
                            "[build] Dropping ${details.data} before $data");
                        onDropBefore!(details.data);
                      },
                    ),
                  ),
                if (onDropAfter != null)
                  Expanded(
                    child: DragTarget<T>(
                      builder: (context, candidateItems, rejectedItems) {
                        return buildIndicator(AlignmentDirectional.centerEnd,
                            candidateItems.isNotEmpty);
                      },
                      onAcceptWithDetails: (details) {
                        _log.fine(
                            "[build] Dropping ${details.data} after $data");
                        onDropAfter!(details.data);
                      },
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  final T data;
  final Widget child;
  final Widget? feedback;

  /// Called when some item dropped before this item
  final DragTargetAccept<T>? onDropBefore;

  /// Called when some item dropped after this item
  final DragTargetAccept<T>? onDropAfter;

  final VoidCallback? onDragStarted;

  /// Called when either one of onDragEnd, onDragCompleted or
  /// onDraggableCanceled is called.
  ///
  /// The callback might be called multiple times per each drag event
  final VoidCallback? onDragEndedAny;
}
