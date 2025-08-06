import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/selectable.dart';
import 'package:nc_photos/widget/selectable_item_list.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
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
    this.maxCrossAxisExtent,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.extentOptimizer,
    this.childBorderRadius,
    this.indicatorAlignment = Alignment.topLeft,
    this.onItemTap,
    this.onSelectionChange,
  }) : assert(maxCrossAxisExtent != null || extentOptimizer != null);

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

  /// The maximum extent of tiles in the cross axis. Required if
  /// [extentOptimizer] is null
  final double? maxCrossAxisExtent;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  // Optimize scrolling performance by providing a fixed extent for items
  final SelectableSectionListExtentOptimizer? extentOptimizer;

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
      maxCrossAxisExtent: widget.maxCrossAxisExtent,
      childAspectRatio: widget.childAspectRatio,
      mainAxisSpacing: widget.mainAxisSpacing,
      crossAxisSpacing: widget.crossAxisSpacing,
      extentOptimizer: widget.extentOptimizer,
    );
  }

  Widget _buildItem(BuildContext context, int section, int index) {
    final meta = widget.sections[section].items[index];
    if (meta.isSelectable) {
      return Selectable(
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
        onLongPress: () => _onItemLongPress(section, index, meta),
        child: widget.itemBuilder(context, section, index, meta),
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
    final currentPos = _SectionPosition(section: section, index: index);
    if (widget.selectedItems.contains(metadata)) {
      // unselect
      setState(() {
        newSelectedItems.remove(metadata);
        _lastSelectPosition = null;
      });
    } else {
      setState(() {
        // select single
        newSelectedItems.add(metadata);
        _lastSelectPosition = currentPos;
      });
    }
    widget.onSelectionChange?.call(context, newSelectedItems);
  }

  void _onItemLongPress(int section, int index, T metadata) {
    if (!widget.sections[section].items.containsIdentical(metadata)) {
      _log.warning(
        "[_onItemLongPress] Item not found in backing list, ignoring",
      );
      return;
    }
    final wasSelecting = _isSelecting;
    final newSelectedItems = Set.of(widget.selectedItems);
    final currentPos = _SectionPosition(section: section, index: index);
    if (_isSelecting && _lastSelectPosition != null) {
      setState(() {
        _selectRange(newSelectedItems, _lastSelectPosition!, currentPos);
        _lastSelectPosition = currentPos;
      });
    } else {
      setState(() {
        // select single
        newSelectedItems.add(metadata);
        _lastSelectPosition = currentPos;
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

  bool get _isSelecting => widget.selectedItems.isNotEmpty;

  _SectionPosition? _lastSelectPosition;
  final _listKey = GlobalKey();
}

class _SliverSectionGridView extends StatelessWidget {
  const _SliverSectionGridView({
    super.key,
    required this.sectionCount,
    required this.sectionTitleBuilder,
    required this.itemCount,
    required this.itemBuilder,
    this.maxCrossAxisExtent,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.extentOptimizer,
  });

  @override
  Widget build(BuildContext context) {
    if (extentOptimizer == null) {
      return _unoptimizedBuild(context);
    } else {
      return _optimizedBuild(context);
    }
  }

  Widget _unoptimizedBuild(BuildContext context) {
    return SliverList.builder(
      itemCount: sectionCount * 2,
      itemBuilder: (context, index) {
        final section = index ~/ 2;
        if (index.isOdd) {
          // item
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent!,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
            ),
            itemCount: itemCount(section),
            itemBuilder:
                (context, index) => itemBuilder(context, section, index),
          );
        } else {
          // section title
          return sectionTitleBuilder(context, section);
        }
      },
    );
  }

  Widget _optimizedBuild(BuildContext context) {
    final sectionItemCounts = List.generate(sectionCount, itemCount);
    final sectionRowCounts = List.generate(
      sectionCount,
      (i) => (sectionItemCounts[i] / extentOptimizer!.itemPerRow).ceil(),
    );
    final rowCount = sectionCount + sectionRowCounts.sum;

    return SuperSliverList.builder(
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
          final firstItemIndex = (row - 1) * extentOptimizer!.itemPerRow;
          final thisRowCount = math.min(
            sectionItemCounts[section] - firstItemIndex,
            extentOptimizer!.itemPerRow,
          );
          return Row(
            children:
                List<Widget>.generate(
                  extentOptimizer!.itemPerRow,
                  (i) => Expanded(
                    child: AspectRatio(
                      aspectRatio: childAspectRatio,
                      child:
                          i < thisRowCount
                              ? itemBuilder(
                                context,
                                section,
                                firstItemIndex + i,
                              )
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
          return extentOptimizer!.titleExtentBuilder(section);
        } else {
          return extentOptimizer!.itemExtentBuilder(section);
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
  final double? maxCrossAxisExtent;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  final SelectableSectionListExtentOptimizer? extentOptimizer;
}

class _SectionPosition with EquatableMixin {
  const _SectionPosition({required this.section, required this.index});

  @override
  List<Object?> get props => [section, index];

  final int section;
  final int index;
}
