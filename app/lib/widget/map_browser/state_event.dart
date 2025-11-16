part of 'map_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.data,
    this.initialPoint,
    required this.isShowDataRangeControlPanel,
    required this.dateRangeType,
    required this.localDateRange,
    required this.prefDateRangeType,
    this.error,
  });

  factory _State.init({
    required _DateRangeType dateRangeType,
    required DateRange localDateRange,
    _DateRangeType? prefDateRangeType,
  }) {
    return _State(
      data: const [],
      isShowDataRangeControlPanel: false,
      dateRangeType: dateRangeType,
      localDateRange: localDateRange,
      prefDateRangeType: prefDateRangeType ?? dateRangeType,
    );
  }

  @override
  String toString() => _$toString();

  final List<_DataPoint> data;
  final MapCoord? initialPoint;

  final bool isShowDataRangeControlPanel;
  final _DateRangeType dateRangeType;
  final DateRange localDateRange;
  final _DateRangeType prefDateRangeType;

  final ExceptionEvent? error;
}

abstract class _Event {
  const _Event();
}

@toString
class _LoadData implements _Event {
  const _LoadData();

  @override
  String toString() => _$toString();
}

@toString
class _OpenDataRangeControlPanel implements _Event {
  const _OpenDataRangeControlPanel();

  @override
  String toString() => _$toString();
}

@toString
class _CloseControlPanel implements _Event {
  const _CloseControlPanel();

  @override
  String toString() => _$toString();
}

@toString
class _SetDateRangeType implements _Event {
  const _SetDateRangeType(this.value);

  @override
  String toString() => _$toString();

  final _DateRangeType value;
}

@toString
class _SetLocalDateRange implements _Event {
  const _SetLocalDateRange(this.value);

  @override
  String toString() => _$toString();

  final DateRange value;
}

@toString
class _SetPrefDateRangeType implements _Event {
  const _SetPrefDateRangeType(this.value);

  @override
  String toString() => _$toString();

  final _DateRangeType value;
}

@toString
class _SetAsDefaultRange implements _Event {
  const _SetAsDefaultRange();

  @override
  String toString() => _$toString();
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
