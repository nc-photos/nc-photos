import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/widget/draggable.dart' as my;
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'draggable_item_list.g.dart';

/// Describe an item in a [DraggableItemList]
///
/// Derived classes should implement [operator ==] in order for the list to
/// correctly map the items after changing the list content
abstract class DraggableItemMetadata {
  bool get isDraggable;
}

/// A list where some/all of the items can be dragged to rearrange them
class DraggableItemList<T extends DraggableItemMetadata>
    extends StatefulWidget {
  const DraggableItemList({
    super.key,
    required this.items,
    required this.maxCrossAxisExtent,
    required this.itemBuilder,
    required this.itemDragFeedbackBuilder,
    this.itemDragFeedbackSize,
    required this.staggeredTileBuilder,
    this.onDragResult,
    this.onDraggingChanged,
  });

  @override
  State<StatefulWidget> createState() => _DraggableItemListState<T>();

  final List<T> items;
  final double maxCrossAxisExtent;
  final Widget Function(BuildContext context, int index, T metadata)
      itemBuilder;
  final Widget? Function(BuildContext context, int index, T metadata)?
      itemDragFeedbackBuilder;
  final Size? Function(int index, T metadata)? itemDragFeedbackSize;
  final StaggeredTile? Function(int index, T metadata) staggeredTileBuilder;

  /// Called when an item is dropped to a new place
  ///
  /// [results] contains the rearranged items
  final void Function(List<T> results)? onDragResult;

  /// Called when user started (true) or ended (false) dragging
  final ValueChanged<bool>? onDraggingChanged;
}

@npLog
class _DraggableItemListState<T extends DraggableItemMetadata>
    extends State<DraggableItemList<T>> {
  @override
  Widget build(BuildContext context) {
    return SliverStaggeredGrid.extentBuilder(
      key: ObjectKey(widget.maxCrossAxisExtent),
      maxCrossAxisExtent: widget.maxCrossAxisExtent,
      itemCount: widget.items.length,
      itemBuilder: (context, i) {
        final meta = widget.items[i];
        if (meta.isDraggable) {
          return my.Draggable<_DraggableData>(
            data: _DraggableData(i, meta),
            feedback: SizedBox.fromSize(
              size: widget.itemDragFeedbackSize?.call(i, meta) ??
                  Size.square(widget.maxCrossAxisExtent * .65),
              child: widget.itemDragFeedbackBuilder?.call(context, i, meta),
            ),
            onDropBefore: (data) => _onMoved(data.index, i, true),
            onDropAfter: (data) => _onMoved(data.index, i, false),
            onDragStarted: () {
              widget.onDraggingChanged?.call(true);
            },
            onDragEndedAny: () {
              widget.onDraggingChanged?.call(false);
            },
            child: widget.itemBuilder(context, i, meta),
          );
        } else {
          return widget.itemBuilder(context, i, meta);
        }
      },
      staggeredTileBuilder: (i) =>
          widget.staggeredTileBuilder(i, widget.items[i]),
    );
  }

  void _onMoved(int fromIndex, int toIndex, bool isBefore) {
    if (fromIndex == toIndex) {
      return;
    }
    final newItems = widget.items.toList();
    final moved = newItems.removeAt(fromIndex);
    final newIndex =
        toIndex + (isBefore ? 0 : 1) + (fromIndex < toIndex ? -1 : 0);
    newItems.insert(newIndex, moved);
    widget.onDragResult?.call(newItems);
  }
}

@toString
class _DraggableData {
  const _DraggableData(this.index, this.meta);

  @override
  String toString() => _$toString();

  final int index;
  final DraggableItemMetadata meta;
}
