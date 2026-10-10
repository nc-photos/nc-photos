import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' hide Selectable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/widget/selectable.dart';
import 'package:nc_photos/widget/selectable_item_list.dart';
import 'package:nc_photos/widget/swipe_select_guide/swipe_select_guide.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

export 'package:nc_photos/widget/selectable_item_list.dart'
    show SelectableItemMetadata;

part 'selectable_section_list.g.dart';

class SelectableSection<T extends SelectableItemMetadata> {
  const SelectableSection({required this.header, required this.items});

  final T header;
  final List<T> items;
}

class SelectableSectionListExtentOptimizer {
  const SelectableSectionListExtentOptimizer({
    required this.itemPerRow,
    required this.titleExtentBuilder,
    required this.itemExtentBuilder,
  });

  final int itemPerRow;
  final double Function(int section) titleExtentBuilder;
  final double Function(int section) itemExtentBuilder;
}

class SelectableSectionList<T extends SelectableItemMetadata>
    extends StatefulWidget {
  const SelectableSectionList({
    super.key,
    required this.sections,
    this.selectedItems = const {},
    required this.sectionHeaderBuilder,
    required this.itemBuilder,
    this.childAspectRatio = 1,
    this.crossAxisSpacing = 0,
    required this.extentOptimizer,
    this.childBorderRadius,
    this.indicatorAlignment = Alignment.topLeft,
    this.onItemTap,
    this.onSelectionChange,
  });

  @override
  State<StatefulWidget> createState() => _SelectableSectionListState<T>();

  final List<SelectableSection<T>> sections;
  final Set<T> selectedItems;
  final Widget Function(BuildContext context, int section, T metadata)
  sectionHeaderBuilder;
  final Widget Function(
    BuildContext context,
    int section,
    int index,
    T metadata,
  )
  itemBuilder;

  final double childAspectRatio;
  final double crossAxisSpacing;

  // Optimize scrolling performance by providing a fixed extent for items
  final SelectableSectionListExtentOptimizer extentOptimizer;

  final BorderRadius? childBorderRadius;
  final Alignment indicatorAlignment;

  final void Function(BuildContext context, int section, int index, T metadata)?
  onItemTap;
  final void Function(BuildContext context, Set<T> selected)? onSelectionChange;
}

@npLog
class _SelectableSectionListState<T extends SelectableItemMetadata>
    extends State<SelectableSectionList<T>> {
  @override
  void dispose() {
    _dragScroller?.stopAutoScroll();
    _swipeSelectRecognizer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SliverSectionGridView(
      key: _listKey,
      sectionCount: widget.sections.length,
      sectionTitleBuilder: (context, section) {
        final meta = widget.sections[section].header;
        return widget.sectionHeaderBuilder(context, section, meta);
      },
      itemCount: (section) => widget.sections[section].items.length,
      itemBuilder: _buildItem,
      childAspectRatio: widget.childAspectRatio,
      crossAxisSpacing: widget.crossAxisSpacing,
      extentOptimizer: widget.extentOptimizer,
    );
  }

  Widget _buildItem(BuildContext context, int section, int index) {
    final meta = widget.sections[section].items[index];
    if (meta.isSelectable) {
      final pos = _SectionPosition(section: section, index: index);
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
                _onItemSelect(context, section, index, meta);
              } else {
                _onItemTap(context, section, index, meta);
              }
            },
            child: widget.itemBuilder(context, section, index, meta),
          ),
        ),
      );
    } else {
      return widget.itemBuilder(context, section, index, meta);
    }
  }

  void _onItemTap(BuildContext context, int section, int index, T metadata) {
    widget.onItemTap?.call(context, section, index, metadata);
  }

  void _onItemSelect(BuildContext context, int section, int index, T metadata) {
    if (!widget.sections[section].items.containsIdentical(metadata)) {
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
    _SectionPosition pos,
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

  _SwipeSelectState<T>? _onSwipeSelectStart(_SectionPosition pos, T metadata) {
    if (!widget.sections[pos.section].items.containsIdentical(metadata)) {
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
    final pos = _sectionByGlobalPosition(globalPosition);
    if (pos != null) {
      state.currentPos = pos;
      if (pos != state.beginPos) {
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
      _onItemTap(
        context,
        drag.beginPos.section,
        drag.beginPos.index,
        drag.beginMetadata,
      );
    }
  }

  /// Select items between two indexes [a] and [b] in [target] list
  ///
  /// [a] and [b] are not necessary to be sorted, this method will handle both
  /// [a] > [b] and [a] < [b] cases
  void _selectRange(
    Set<SelectableItemMetadata> target,
    _SectionPosition a,
    _SectionPosition b,
  ) {
    if (a.section == b.section) {
      // same section
      final beg = math.min(a.index, b.index);
      final end = math.max(a.index, b.index) + 1;
      target.addAll(
        widget.sections[a.section].items
            .sublist(beg, end)
            .where((e) => e.isSelectable),
      );
    } else {
      if (a.section < b.section) {
        // forward
        target.addAll(
          widget.sections[a.section].items
              .sublist(a.index)
              .where((e) => e.isSelectable),
        );
        _selectRange(
          target,
          _SectionPosition(section: a.section + 1, index: 0),
          b,
        );
      } else {
        // backward
        _selectRange(target, b, a);
      }
    }
  }

  void _applySwipeSelection(_SwipeSelectState<T> drag) {
    final swipeSelected = <SelectableItemMetadata>{};
    _selectRange(swipeSelected, drag.beginPos, drag.currentPos);
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

  _SectionPosition? _sectionByGlobalPosition(Offset globalPosition) {
    final view = View.maybeOf(context);
    if (view == null) {
      return null;
    }
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(result, globalPosition, view.viewId);
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderMetaData && target.metaData is _SectionPosition) {
        return target.metaData as _SectionPosition;
      }
    }
    return null;
  }

  bool get _isSelecting => widget.selectedItems.isNotEmpty;

  final _listKey = GlobalKey();
  _SwipeSelectState<T>? _swipeSelectState;
  EdgeDraggingAutoScroller? _dragScroller;
  MultiDragGestureRecognizer? _swipeSelectRecognizer;
  Offset? _prevSwipeSelectPosition;

  late final _prefController = context.read<PrefController>();
}

class _SliverSectionGridView extends StatelessWidget {
  const _SliverSectionGridView({
    super.key,
    required this.sectionCount,
    required this.sectionTitleBuilder,
    required this.itemCount,
    required this.itemBuilder,
    this.childAspectRatio = 1,
    this.crossAxisSpacing = 0,
    required this.extentOptimizer,
  });

  @override
  Widget build(BuildContext context) {
    final sectionItemCounts = List.generate(sectionCount, itemCount);
    final sectionRowCounts = List.generate(
      sectionCount,
      (i) => (sectionItemCounts[i] / extentOptimizer.itemPerRow).ceil(),
    );
    final rowCount = sectionCount + sectionRowCounts.sum;

    return SuperSliverList.builder(
      // SuperSliverList does not seems to clear the cache automatically when
      // the list content changed
      key: Key("SelectableSectionList.SuperSliverList.$rowCount"),
      itemCount: rowCount,
      itemBuilder: (context, index) {
        final (section, row) = _listIndexToSectionAndRow(
          sectionRowCounts,
          index,
        );
        if (row == 0) {
          // section title
          return sectionTitleBuilder(context, section);
        } else {
          // item
          final firstItemIndex = (row - 1) * extentOptimizer.itemPerRow;
          final thisRowCount = math.min(
            sectionItemCounts[section] - firstItemIndex,
            extentOptimizer.itemPerRow,
          );
          return Row(
            children: List<Widget>.generate(
              extentOptimizer.itemPerRow,
              (i) => Expanded(
                child: AspectRatio(
                  aspectRatio: childAspectRatio,
                  child: i < thisRowCount
                      ? itemBuilder(context, section, firstItemIndex + i)
                      : const SizedBox.shrink(),
                ),
              ),
            ).separated((_) => SizedBox(width: crossAxisSpacing)).toList(),
          );
        }
      },
      extentEstimation: (index, crossAxisExtent) {
        if (index == null) {
          return 0;
        }
        final (section, row) = _listIndexToSectionAndRow(
          sectionRowCounts,
          index,
        );
        if (row == 0) {
          return extentOptimizer.titleExtentBuilder(section);
        } else {
          return extentOptimizer.itemExtentBuilder(section);
        }
      },
    );
  }

  (int section, int row) _listIndexToSectionAndRow(
    List<int> sectionRowCounts,
    int index,
  ) {
    var remain = index;
    var i = 0;
    while (true) {
      final thisCount = sectionRowCounts[i] + 1;
      if (remain - thisCount < 0) {
        // this section
        return (i, remain);
      } else {
        remain -= thisCount;
        ++i;
      }
    }
  }

  final int sectionCount;
  final Widget Function(BuildContext context, int section) sectionTitleBuilder;
  final int Function(int section) itemCount;
  final Widget Function(BuildContext context, int section, int index)
  itemBuilder;
  final double childAspectRatio;
  final double crossAxisSpacing;

  final SelectableSectionListExtentOptimizer extentOptimizer;
}

class _SectionPosition with EquatableMixin {
  const _SectionPosition({required this.section, required this.index});

  @override
  List<Object?> get props => [section, index];

  final int section;
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

  final _SectionPosition beginPos;
  final T beginMetadata;
  // select/unselect
  final bool isSelectMode;
  final Set<T> originalSelectedItems;
  final void Function(DragUpdateDetails details)? onUpdate;
  final void Function(DragEndDetails details)? onEnd;
  final void Function()? onCancel;

  _SectionPosition currentPos;
  var hasSwiped = false;
}
