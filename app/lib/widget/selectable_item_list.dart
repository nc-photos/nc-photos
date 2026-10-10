import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' hide Selectable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/widget/measurable_item_list.dart';
import 'package:nc_photos/widget/selectable.dart';
import 'package:nc_photos/widget/swipe_select_guide/swipe_select_guide.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'selectable_item_list.g.dart';

/// Describe an item in a [SelectableItemList]
///
/// Derived classes should implement [operator ==] in order for the list to
/// correctly map the items after changing the list content
abstract class SelectableItemMetadata {
  bool get isSelectable;
}

class SelectableItemList<T extends SelectableItemMetadata>
    extends StatefulWidget {
  const SelectableItemList({
    super.key,
    required this.items,
    this.selectedItems = const {},
    required this.maxCrossAxisExtent,
    required this.itemBuilder,
    required this.staggeredTileBuilder,
    this.childBorderRadius,
    this.indicatorAlignment = Alignment.topLeft,
    this.onItemTap,
    this.onSelectionChange,
    this.onMaxExtentChange,
  });

  @override
  State<StatefulWidget> createState() => _SelectableItemListState<T>();

  final List<T> items;
  final Set<T> selectedItems;
  final double maxCrossAxisExtent;
  // why are these dynamic instead of T? Because dart is stupid...
  final Widget Function(BuildContext context, int index, T metadata)
  itemBuilder;
  final StaggeredTile? Function(int index, T metadata) staggeredTileBuilder;
  final BorderRadius? childBorderRadius;
  final Alignment indicatorAlignment;

  final void Function(BuildContext context, int index, T metadata)? onItemTap;
  final void Function(BuildContext context, Set<T> selected)? onSelectionChange;
  final ValueChanged<double?>? onMaxExtentChange;
}

@npLog
class _SelectableItemListState<T extends SelectableItemMetadata>
    extends State<SelectableItemList<T>> {
  @override
  void dispose() {
    _dragScroller?.stopAutoScroll();
    _swipeSelectRecognizer?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectableItemList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items == oldWidget.items) {
      return;
    }
    _remapSelected();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onMaxExtentChange != null) {
      return MeasurableItemList(
        key: _listKey,
        maxCrossAxisExtent: widget.maxCrossAxisExtent,
        itemCount: widget.items.length,
        itemBuilder: _buildItem,
        staggeredTileBuilder: (i) =>
            widget.staggeredTileBuilder(i, widget.items[i]),
        onMaxExtentChanged: widget.onMaxExtentChange,
      );
    } else {
      return SliverStaggeredGrid.extentBuilder(
        key: ObjectKey(widget.maxCrossAxisExtent),
        maxCrossAxisExtent: widget.maxCrossAxisExtent,
        itemCount: widget.items.length,
        itemBuilder: _buildItem,
        staggeredTileBuilder: (i) =>
            widget.staggeredTileBuilder(i, widget.items[i]),
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final meta = widget.items[index];
    if (meta.isSelectable) {
      final pos = _ItemPosition(index: index);
      return Listener(
        onPointerDown: (event) => _onItemPointerDown(context, event, pos, meta),
        child: MetaData(
          metaData: pos,
          behavior: HitTestBehavior.opaque,
          child: Selectable(
            isSelected: widget.selectedItems.contains(meta),
            iconSize: 32,
            childBorderRadius:
                widget.childBorderRadius ?? BorderRadius.circular(24),
            indicatorAlignment: widget.indicatorAlignment,
            onTap: () {
              if (_isSelecting) {
                _onItemSelect(context, index, meta);
              } else {
                _onItemTap(context, index, meta);
              }
            },
            child: widget.itemBuilder(context, index, meta),
          ),
        ),
      );
    } else {
      return widget.itemBuilder(context, index, meta);
    }
  }

  void _onItemTap(BuildContext context, int index, T metadata) {
    widget.onItemTap?.call(context, index, metadata);
  }

  void _onItemSelect(BuildContext context, int index, T metadata) {
    if (!widget.items.containsIdentical(metadata)) {
      _log.warning("[_onItemSelect] Item not found in backing list, ignoring");
      return;
    }
    final newSelectedItems = Set.of(widget.selectedItems);
    if (!newSelectedItems.remove(metadata)) {
      newSelectedItems.add(metadata);
    }
    _notifySelectionChange(newSelectedItems);
  }

  void _onItemPointerDown(
    BuildContext context,
    PointerDownEvent event,
    _ItemPosition pos,
    T metadata,
  ) {
    if (_swipeSelectState != null) {
      return;
    }
    _swipeSelectRecognizer?.dispose();
    final r = DelayedMultiDragGestureRecognizer(debugOwner: this);
    r.gestureSettings = MediaQuery.maybeGestureSettingsOf(context);
    r.onStart = (_) => _onSwipeSelectStart(pos, metadata);
    r.addPointer(event);
    _swipeSelectRecognizer = r;
  }

  _SwipeSelectState<T>? _onSwipeSelectStart(_ItemPosition pos, T metadata) {
    if (!widget.items.containsIdentical(metadata)) {
      _log.warning(
        "[_onSwipeSelectStart] Item not found in backing list, ignoring",
      );
      return null;
    }
    Feedback.forLongPress(context);
    _dragScroller?.stopAutoScroll();

    // long press w/o swiping = open to preview; long press w/ swiping = select
    _SwipeSelectState<T>? swipeSelectState;
    swipeSelectState = _SwipeSelectState<T>(
      beginPos: pos,
      beginMetadata: metadata,
      isSelectMode: !widget.selectedItems.contains(metadata),
      originalSelectedItems: Set.of(widget.selectedItems),
      onUpdate: (details) {
        _onSwipeSelectUpdate(swipeSelectState!, details.globalPosition);
      },
      onEnd: (details) {
        _onSwipeSelectEnd(swipeSelectState!, isCanceled: false);
      },
      onCancel: () {
        _onSwipeSelectEnd(swipeSelectState!, isCanceled: true);
      },
    );
    if (!_isSelecting) {
      // always select the very first item
      swipeSelectState.hasSwiped = true;
    }
    _swipeSelectState = swipeSelectState;
    _dragScroller = EdgeDraggingAutoScroller(
      Scrollable.of(context),
      onScrollViewScrolled: () {
        _onSwipeSelectAutoScrolled(swipeSelectState!);
      },
      velocityScalar: 150,
    );
    if (_prefController.isShowSwipeSelectGuideValue) {
      showDialog(
        context: context,
        builder: (context) => const Dialog(child: SwipeSelectGuide()),
      );
      _prefController.setShowSwipeSelectGuide(false);
    }
    return swipeSelectState;
  }

  void _onSwipeSelectUpdate(_SwipeSelectState<T> state, Offset globalPosition) {
    _prevSwipeSelectPosition = globalPosition;
    final index = _itemByGlobalPosition(globalPosition);
    if (index != null) {
      state.currentPos = _ItemPosition(index: index);
      if (state.currentPos != state.beginPos) {
        state.hasSwiped = true;
      }
      if (state.hasSwiped) {
        _applySwipeSelection(state);
      }
    }
    _dragScroller?.startAutoScrollIfNecessary(
      Rect.fromCenter(center: globalPosition, width: 160, height: 160),
    );
  }

  void _onSwipeSelectAutoScrolled(_SwipeSelectState<T> state) {
    if (_prevSwipeSelectPosition == null) {
      return;
    }
    _onSwipeSelectUpdate(state, _prevSwipeSelectPosition!);
  }

  void _onSwipeSelectEnd(
    _SwipeSelectState<T> drag, {
    required bool isCanceled,
  }) {
    if (identical(_swipeSelectState, drag)) {
      _swipeSelectState = null;
      _prevSwipeSelectPosition = null;
    }
    _dragScroller?.stopAutoScroll();
    _swipeSelectRecognizer?.dispose();
    _swipeSelectRecognizer = null;
    if (!isCanceled && !drag.hasSwiped) {
      // w/o swiping = open to preview
      _onItemTap(context, drag.beginPos.index, drag.beginMetadata);
    }
  }

  /// Select items between two indexes [a] and [b] in [target] list
  ///
  /// [a] and [b] are not necessary to be sorted, this method will handle both
  /// [a] > [b] and [a] < [b] cases
  void _selectRange(Set<SelectableItemMetadata> target, int a, int b) {
    final beg = math.min(a, b);
    final end = math.max(a, b) + 1;
    target.addAll(widget.items.sublist(beg, end).where((e) => e.isSelectable));
  }

  void _applySwipeSelection(_SwipeSelectState<T> drag) {
    final swipeSelected = <SelectableItemMetadata>{};
    _selectRange(swipeSelected, drag.beginPos.index, drag.currentPos.index);
    final newSelectedItems = Set.of(drag.originalSelectedItems);
    if (drag.isSelectMode) {
      newSelectedItems.addAll(swipeSelected.cast<T>());
    } else {
      newSelectedItems.removeAll(swipeSelected);
    }
    _notifySelectionChange(newSelectedItems);
  }

  void _notifySelectionChange(Set<T> newSelectedItems) {
    if (setEquals(newSelectedItems, widget.selectedItems)) {
      // no change
      return;
    }
    widget.onSelectionChange?.call(context, newSelectedItems);
  }

  int? _itemByGlobalPosition(Offset globalPosition) {
    final view = View.maybeOf(context);
    if (view == null) {
      return null;
    }
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(result, globalPosition, view.viewId);
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderMetaData && target.metaData is _ItemPosition) {
        return (target.metaData as _ItemPosition).index;
      }
    }
    return null;
  }

  /// Remap selected items to the new item list, typically called after content
  /// of the list was changed
  void _remapSelected() {
    _log.info(
      "[_remapSelected] Mapping ${widget.selectedItems.length} items to new list",
    );
    final newSelected = widget.selectedItems
        .map((from) => widget.items.firstWhereOrNull((to) => from == to))
        .nonNulls
        .toSet();
    if (newSelected.length != widget.selectedItems.length) {
      _log.warning(
        "[_remapSelected] ${widget.selectedItems.length - newSelected.length} items not found in the new list",
      );
    }
    widget.onSelectionChange?.call(context, newSelected);
    // TODO remap lastSelectPosition

    _log.info("[_remapSelected] updateListHeight: list item changed");
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => (_listKey.currentState as MeasurableItemListState?)
          ?.updateListHeight(),
    );
  }

  bool get _isSelecting => widget.selectedItems.isNotEmpty;

  final _listKey = GlobalKey();
  _SwipeSelectState<T>? _swipeSelectState;
  EdgeDraggingAutoScroller? _dragScroller;
  MultiDragGestureRecognizer? _swipeSelectRecognizer;
  Offset? _prevSwipeSelectPosition;

  late final _prefController = context.read<PrefController>();
}

class _ItemPosition with EquatableMixin {
  const _ItemPosition({required this.index});

  @override
  List<Object?> get props => [index];

  final int index;
}

class _SwipeSelectState<T extends SelectableItemMetadata> extends Drag {
  _SwipeSelectState({
    required this.beginPos,
    required this.beginMetadata,
    required this.isSelectMode,
    required this.originalSelectedItems,
    this.onUpdate,
    this.onEnd,
    this.onCancel,
  }) : currentPos = beginPos;

  @override
  void update(DragUpdateDetails details) {
    onUpdate?.call(details);
  }

  @override
  void end(DragEndDetails details) {
    onEnd?.call(details);
  }

  @override
  void cancel() {
    onCancel?.call();
  }

  final _ItemPosition beginPos;
  final T beginMetadata;
  // select/unselect
  final bool isSelectMode;
  final Set<T> originalSelectedItems;
  final void Function(DragUpdateDetails details)? onUpdate;
  final void Function(DragEndDetails details)? onEnd;
  final void Function()? onCancel;

  _ItemPosition currentPos;
  var hasSwiped = false;
}
