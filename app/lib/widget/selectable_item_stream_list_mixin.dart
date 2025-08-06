import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
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
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'selectable_item_stream_list_mixin.g.dart';

abstract class SelectableItem {
  const SelectableItem();

  Widget buildWidget(BuildContext context);

  bool get isTappable => false;
  bool get isSelectable => false;
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);
}

@Deprecated("Use SelectableItemList widget")
mixin SelectableItemStreamListMixin<T extends StatefulWidget> on State<T> {
  @override
  initState() {
    super.initState();
    _keyboardFocus.requestFocus();
  }

  @protected
  void onItemTap(SelectableItem item, int index);

  @protected
  void onVisibilityChanged(
    VisibilityInfo info,
    int index,
    SelectableItem item,
  ) {}

  @protected
  Widget buildItemStreamListOuter(
    BuildContext context, {
    required Widget child,
  }) {
    if (getRawPlatform() == NpPlatform.web) {
      // support shift+click group selection on web
      return RawKeyboardListener(
        onKey: (ev) {
          _isRangeSelectionMode = ev.isShiftPressed;
        },
        focusNode: _keyboardFocus,
        child: child,
      );
    } else {
      return child;
    }
  }

  @protected
  Widget buildItemStreamList({
    required double maxCrossAxisExtent,
    double mainAxisSpacing = 0,
    ValueChanged<double?>? onMaxExtentChanged,
    bool isEnableVisibilityCallback = false,
    BorderRadius? childBorderRadius,
    Alignment indicatorAlignment = Alignment.topLeft,
  }) {
    childBorderRadius ??= BorderRadius.circular(24);

    final Widget content;
    if (onMaxExtentChanged != null) {
      content = MeasurableItemList(
        key: _listKey,
        maxCrossAxisExtent: maxCrossAxisExtent,
        itemCount: _items.length,
        itemBuilder:
            (context, i) => _buildItem(
              context,
              i,
              isEnableVisibilityCallback: isEnableVisibilityCallback,
              childBorderRadius: childBorderRadius!,
              indicatorAlignment: indicatorAlignment,
            ),
        staggeredTileBuilder: (index) => _items[index].staggeredTile,
        mainAxisSpacing: mainAxisSpacing,
        onMaxExtentChanged: onMaxExtentChanged,
      );
    } else {
      content = SliverStaggeredGrid.extentBuilder(
        key: ObjectKey(maxCrossAxisExtent),
        maxCrossAxisExtent: maxCrossAxisExtent,
        itemCount: _items.length,
        itemBuilder:
            (context, i) => _buildItem(
              context,
              i,
              isEnableVisibilityCallback: isEnableVisibilityCallback,
              childBorderRadius: childBorderRadius!,
              indicatorAlignment: indicatorAlignment,
            ),
        staggeredTileBuilder: (index) => _items[index].staggeredTile,
        mainAxisSpacing: mainAxisSpacing,
      );
    }
    if (getRawPlatform() == NpPlatform.android) {
      return WillPopScope(onWillPop: onBackButtonPressed, child: content);
    } else {
      return content;
    }
  }

  @protected
  void clearSelectedItems() {
    _selectedItems.clear();
  }

  @protected
  bool get isSelectionMode => _selectedItems.isNotEmpty;

  @protected
  Iterable<SelectableItem> get selectedListItems => _selectedItems;

  @protected
  List<SelectableItem> get itemStreamListItems => UnmodifiableListView(_items);

  @protected
  set itemStreamListItems(List<SelectableItem> newItems) {
    final lastSelectedItem =
        _lastSelectPosition != null ? _items[_lastSelectPosition!] : null;

    _items = newItems;
    _transformSelectedItems();

    // Keep _lastSelectPosition if no changes, drop otherwise
    int? newLastSelectPosition;
    try {
      if (lastSelectedItem != null &&
          lastSelectedItem == _items[_lastSelectPosition!]) {
        newLastSelectPosition = _lastSelectPosition!;
      }
    } catch (_) {}
    _lastSelectPosition = newLastSelectPosition;

    _$__NpLog.log.info(
      "[itemStreamListItems] updateListHeight: list item changed",
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          (_listKey.currentState as MeasurableItemListState?)
              ?.updateListHeight(),
    );
  }

  @protected
  Future<bool> onBackButtonPressed() async {
    if (!isSelectionMode) {
      return true;
    } else {
      setState(() {
        clearSelectedItems();
      });
      return false;
    }
  }

  Widget _buildItem(
    BuildContext context,
    int index, {
    required bool isEnableVisibilityCallback,
    required BorderRadius childBorderRadius,
    required Alignment indicatorAlignment,
  }) {
    final item = _items[index];
    Widget content = item.buildWidget(context);
    if (item.isSelectable) {
      content = Selectable(
        isSelected: _selectedItems.contains(item),
        iconSize: 32,
        childBorderRadius: childBorderRadius,
        indicatorAlignment: indicatorAlignment,
        onTap: () => _onItemTap(item, index),
        onLongPress:
            isSelectionMode && getRawPlatform() == NpPlatform.web
                ? null
                : () => _onItemLongPress(item, index),
        child: content,
      );
    }
    if (isEnableVisibilityCallback) {
      content = VisibilityDetector(
        key: Key("$_itemKeyPrefix.$index"),
        child: content,
        onVisibilityChanged: (info) => onVisibilityChanged(info, index, item),
      );
    }
    return content;
  }

  void _onItemTap(SelectableItem item, int index) {
    if (isSelectionMode) {
      if (!_items.containsIdentical(item)) {
        _$__NpLog.log.warning(
          "[_onItemTap] Item not found in backing list, ignoring",
        );
        return;
      }
      if (_selectedItems.contains(item)) {
        // unselect
        setState(() {
          _selectedItems.remove(item);
          _lastSelectPosition = null;
        });
      } else {
        // select
        if (_isRangeSelectionMode && _lastSelectPosition != null) {
          setState(() {
            _selectedItems.addAll(
              _items
                  .sublist(
                    math.min(_lastSelectPosition!, index),
                    math.max(_lastSelectPosition!, index) + 1,
                  )
                  .where((e) => e.isSelectable),
            );
            _lastSelectPosition = index;
          });
        } else {
          setState(() {
            _lastSelectPosition = index;
            _selectedItems.add(item);
          });
        }
      }
    } else {
      if (item.isTappable) {
        onItemTap(item, index);
      }
    }
  }

  void _onItemLongPress(SelectableItem item, int index) {
    if (!_items.containsIdentical(item)) {
      _$__NpLog.log.warning(
        "[_onItemLongPress] Item not found in backing list, ignoring",
      );
      return;
    }
    final wasSelectionMode = isSelectionMode;
    if (getRawPlatform() != NpPlatform.web &&
        wasSelectionMode &&
        _lastSelectPosition != null) {
      setState(() {
        _selectedItems.addAll(
          _items
              .sublist(
                math.min(_lastSelectPosition!, index),
                math.max(_lastSelectPosition!, index) + 1,
              )
              .where((e) => e.isSelectable),
        );
        _lastSelectPosition = index;
      });
    } else {
      setState(() {
        _lastSelectPosition = index;
        _selectedItems.add(item);
      });
    }

    // show notification on first entry to selection mode each session
    if (!wasSelectionMode) {
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

  /// Map selected items to the new item list
  void _transformSelectedItems() {
    // TODO too slow!
    final newSelectedItems =
        _selectedItems
            .map((from) {
              try {
                return _items
                    .where((e) => e.isSelectable)
                    .firstWhere((to) => from == to);
              } catch (_) {
                return null;
              }
            })
            .whereType<SelectableItem>()
            .toList();
    _selectedItems
      ..clear()
      ..addAll(newSelectedItems);
  }

  int? _lastSelectPosition;
  bool _isRangeSelectionMode = false;

  var _items = <SelectableItem>[];
  final _selectedItems = <SelectableItem>{};

  final _listKey = GlobalKey();
  late final _itemKeyPrefix =
      "widget.selectable_item_stream_list_mixin.SelectableItemStreamListMixin.${const Uuid().v4()}";

  /// used to gain focus on web for keyboard support
  final _keyboardFocus = FocusNode();
}

@npLog
// ignore: camel_case_types
class __ {}
