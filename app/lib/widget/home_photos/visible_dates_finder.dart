part of 'home_photos.dart';

class _VisibleDatesFinder {
  _VisibleDatesFinder({
    required this.dateHeight,
    required this.obstructedViewTop,
  });

  Stream<Set<Date>?> get stream => _streamController.stream;

  Stream<Date?> get bestLatestVisibleDate => _bestDateStreamController.stream;

  void setSectionLayouts({
    required List<List<_Item>> transformedItems,
    required List<_SectionLayout> sectionLayouts,
  }) {
    // both need to be set together to prevent them out-syncing
    _transformedItems = transformedItems;
    _sectionLayouts = sectionLayouts;
    _update();
  }

  void setLayoutConstraint({
    required double viewHeight,
    required int itemPerRow,
    required double itemSize,
  }) {
    _viewHeight = viewHeight;
    _itemPerRow = itemPerRow;
    _itemSize = itemSize;
    _update();
  }

  void setScrollOffset(double scrollOffset) {
    _lastScrollOffset = scrollOffset;
    _update();
  }

  void _update() {
    if (_transformedItems == null ||
        _transformedItems!.isEmpty ||
        _sectionLayouts == null ||
        _sectionLayouts!.isEmpty ||
        _viewHeight == null ||
        _itemPerRow == null ||
        _itemSize == null ||
        _lastScrollOffset == null) {
      _streamController.add(null);
      return;
    }
    final (visibleDates, bestDate) = _find(
      transformedItems: _transformedItems!,
      sectionLayouts: _sectionLayouts!,
      viewHeight: _viewHeight!,
      itemPerRow: _itemPerRow!,
      itemSize: _itemSize!,
      scrollOffset: _lastScrollOffset!,
    );
    _streamController.add(visibleDates);
    _bestDateStreamController.add(bestDate);
  }

  (Set<Date>?, Date?) _find({
    required List<List<_Item>> transformedItems,
    required List<_SectionLayout> sectionLayouts,
    required double viewHeight,
    required int itemPerRow,
    required double itemSize,
    required double scrollOffset,
  }) {
    final viewportTop = max(scrollOffset, 0);
    final viewportBottom = viewportTop + viewHeight;

    // find the first on screen section
    var l = 0;
    var r = sectionLayouts.length - 1;
    var firstVisibleSection = sectionLayouts.length - 1;
    while (l <= r) {
      final m = (l + r) ~/ 2;
      if (viewportTop <
          sectionLayouts[m].logicalY + sectionLayouts[m].logicalHeight) {
        firstVisibleSection = m;
        r = m - 1;
      } else {
        l = m + 1;
      }
    }

    final visibleDates = <Date>{};
    Date? bestDate;
    for (var i = firstVisibleSection; i < sectionLayouts.length; ++i) {
      final section = sectionLayouts[i];
      if (section.logicalY >= viewportBottom) {
        break;
      }
      if (section.logicalY < viewportBottom &&
          section.logicalY + section.logicalHeight > viewportTop) {
        if (section.rowCount == 0) {
          continue;
        }
        final itemLogicalY = section.logicalY + dateHeight;
        final firstVisibleRow = ((viewportTop - itemLogicalY) / itemSize)
            .floor()
            .clamp(0, section.rowCount - 1);
        final lastVisibleRow =
            ((viewportBottom - itemLogicalY) / itemSize).ceil().clamp(
              1,
              section.rowCount,
            ) -
            1;
        final firstVisibleItem = firstVisibleRow * itemPerRow;
        final lastVisibleItem = min(
          section.itemCount,
          (lastVisibleRow + 1) * itemPerRow,
        );
        final items = transformedItems[i];
        for (var j = firstVisibleItem; j < lastVisibleItem; ++j) {
          // items[0] is the section header
          final date = _getDateByItem(items[j + 1]);
          if (date != null) {
            visibleDates.add(date);
          }
        }
        if (bestDate == null) {
          for (var j = firstVisibleRow; j <= lastVisibleRow; ++j) {
            if (section.logicalY + dateHeight + (j + 1) * itemSize >=
                viewportTop + obstructedViewTop) {
              final item = j * itemPerRow;
              bestDate = _getDateByItem(items[item + 1]);
              if (bestDate != null) {
                break;
              }
            }
          }
        }
      }
    }
    return (visibleDates, bestDate);
  }

  static Date? _getDateByItem(_Item item) {
    if (item is _FileItem) {
      return item.file.dateTime.toLocal().toDate();
    } else if (item is _SummaryFileItem) {
      return item.date;
    } else {
      return null;
    }
  }

  final double dateHeight;
  final double obstructedViewTop;

  List<List<_Item>>? _transformedItems;
  List<_SectionLayout>? _sectionLayouts;
  double? _viewHeight;
  int? _itemPerRow;
  double? _itemSize;
  double? _lastScrollOffset;

  final _streamController = BehaviorSubject<Set<Date>?>();
  final _bestDateStreamController = BehaviorSubject<Date?>();
}
