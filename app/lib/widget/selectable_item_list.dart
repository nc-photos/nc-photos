import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/measurable_item_list.dart';
import 'package:nc_photos/widget/selectable.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';

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
  void initState() {
    super.initState();
    _keyboardFocus.requestFocus();
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
    if (getRawPlatform() == NpPlatform.web) {
      // support shift+click group selection on web
      return KeyboardListener(
        onKeyEvent: (ev) {
          if (ev is KeyDownEvent) {
            if (ev.logicalKey == LogicalKeyboardKey.shiftLeft ||
                ev.logicalKey == LogicalKeyboardKey.shiftRight) {
              _isKeyboardRangeSelecting = true;
            }
          } else if (ev is KeyUpEvent) {
            if (ev.logicalKey == LogicalKeyboardKey.shiftLeft ||
                ev.logicalKey == LogicalKeyboardKey.shiftRight) {
              _isKeyboardRangeSelecting = false;
            }
          }
        },
        focusNode: _keyboardFocus,
        child: _buildBody(context),
      );
    } else {
      return _buildBody(context);
    }
  }

  Widget _buildBody(BuildContext context) {
    if (widget.onMaxExtentChange != null) {
      return MeasurableItemList(
        key: _listKey,
        maxCrossAxisExtent: widget.maxCrossAxisExtent,
        itemCount: widget.items.length,
        itemBuilder: _buildItem,
        staggeredTileBuilder:
            (i) => widget.staggeredTileBuilder(i, widget.items[i]),
        onMaxExtentChanged: widget.onMaxExtentChange,
      );
    } else {
      return SliverStaggeredGrid.extentBuilder(
        key: ObjectKey(widget.maxCrossAxisExtent),
        maxCrossAxisExtent: widget.maxCrossAxisExtent,
        itemCount: widget.items.length,
        itemBuilder: _buildItem,
        staggeredTileBuilder:
            (i) => widget.staggeredTileBuilder(i, widget.items[i]),
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final meta = widget.items[index];
    if (meta.isSelectable) {
      return Selectable(
        isSelected: widget.selectedItems.contains(meta),
        iconSize: 32,
        childBorderRadius:
            widget.childBorderRadius ?? BorderRadius.circular(24),
        indicatorAlignment: widget.indicatorAlignment,
        onTap:
            _isSelecting
                ? () => _onItemSelect(context, index, meta)
                : () => _onItemTap(context, index, meta),
        onLongPress: () => _onItemLongPress(index, meta),
        child: widget.itemBuilder(context, index, meta),
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
    if (widget.selectedItems.contains(metadata)) {
      // unselect
      setState(() {
        newSelectedItems.remove(metadata);
        _lastSelectPosition = null;
      });
    } else {
      if (_isKeyboardRangeSelecting && _lastSelectPosition != null) {
        setState(() {
          _selectRange(newSelectedItems, _lastSelectPosition!, index);
          _lastSelectPosition = index;
        });
      } else {
        setState(() {
          // select single
          newSelectedItems.add(metadata);
          _lastSelectPosition = index;
        });
      }
    }
    widget.onSelectionChange?.call(context, newSelectedItems);
  }

  void _onItemLongPress(int index, T metadata) {
    if (!widget.items.containsIdentical(metadata)) {
      _log.warning(
        "[_onItemLongPress] Item not found in backing list, ignoring",
      );
      return;
    }
    final wasSelecting = _isSelecting;
    final newSelectedItems = Set.of(widget.selectedItems);
    if (_isSelecting && _lastSelectPosition != null) {
      setState(() {
        _selectRange(newSelectedItems, _lastSelectPosition!, index);
        _lastSelectPosition = index;
      });
    } else {
      setState(() {
        // select single
        newSelectedItems.add(metadata);
        _lastSelectPosition = index;
      });
    }
    widget.onSelectionChange?.call(context, newSelectedItems);

    // show notification on first entry to selection mode in each session
    if (!wasSelecting) {
      if (!SessionStorage().hasShowRangeSelectNotification) {
        SnackBarManager().showSnackBar(
          SnackBar(
            content: Text(
              getRawPlatform() == NpPlatform.web
                  ? L10n.global().webSelectRangeNotification
                  : L10n.global().mobileSelectRangeNotification,
            ),
            duration: k.snackBarDurationNormal,
          ),
          canBeReplaced: true,
        );
        SessionStorage().hasShowRangeSelectNotification = true;
      }
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

  /// Remap selected items to the new item list, typically called after content
  /// of the list was changed
  void _remapSelected() {
    _log.info(
      "[_remapSelected] Mapping ${widget.selectedItems.length} items to new list",
    );
    final newSelected =
        widget.selectedItems
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
      (_) =>
          (_listKey.currentState as MeasurableItemListState?)
              ?.updateListHeight(),
    );
  }

  bool get _isSelecting => widget.selectedItems.isNotEmpty;

  // keyboard support
  final _keyboardFocus = FocusNode();
  int? _lastSelectPosition;
  bool _isKeyboardRangeSelecting = false;

  final _listKey = GlobalKey();
}
