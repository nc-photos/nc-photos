// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_browser.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<_DataPoint>? data,
    MapCoord? initialPoint,
    bool? isShowDataRangeControlPanel,
    _DateRangeType? dateRangeType,
    DateRange? localDateRange,
    _DateRangeType? prefDateRangeType,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic data,
    dynamic initialPoint = copyWithNull,
    dynamic isShowDataRangeControlPanel,
    dynamic dateRangeType,
    dynamic localDateRange,
    dynamic prefDateRangeType,
    dynamic error = copyWithNull,
  }) {
    return _State(
      data: data as List<_DataPoint>? ?? that.data,
      initialPoint:
          initialPoint == copyWithNull
              ? that.initialPoint
              : initialPoint as MapCoord?,
      isShowDataRangeControlPanel:
          isShowDataRangeControlPanel as bool? ??
          that.isShowDataRangeControlPanel,
      dateRangeType: dateRangeType as _DateRangeType? ?? that.dateRangeType,
      localDateRange: localDateRange as DateRange? ?? that.localDateRange,
      prefDateRangeType:
          prefDateRangeType as _DateRangeType? ?? that.prefDateRangeType,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.map_browser.map_browser._Bloc");
}

extension _$_GoogleMarkerBuilderNpLog on _GoogleMarkerBuilder {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.map_browser.map_browser._GoogleMarkerBuilder",
  );
}

extension _$_GoogleMarkerBitmapBuilderNpLog on _GoogleMarkerBitmapBuilder {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.map_browser.map_browser._GoogleMarkerBitmapBuilder",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {data: [length: ${data.length}], initialPoint: $initialPoint, isShowDataRangeControlPanel: $isShowDataRangeControlPanel, dateRangeType: ${dateRangeType.name}, localDateRange: $localDateRange, prefDateRangeType: ${prefDateRangeType.name}, error: $error}";
  }
}

extension _$_LoadDataToString on _LoadData {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadData {}";
  }
}

extension _$_OpenDataRangeControlPanelToString on _OpenDataRangeControlPanel {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OpenDataRangeControlPanel {}";
  }
}

extension _$_CloseControlPanelToString on _CloseControlPanel {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_CloseControlPanel {}";
  }
}

extension _$_SetDateRangeTypeToString on _SetDateRangeType {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDateRangeType {value: ${value.name}}";
  }
}

extension _$_SetLocalDateRangeToString on _SetLocalDateRange {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetLocalDateRange {value: $value}";
  }
}

extension _$_SetPrefDateRangeTypeToString on _SetPrefDateRangeType {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPrefDateRangeType {value: ${value.name}}";
  }
}

extension _$_SetAsDefaultRangeToString on _SetAsDefaultRange {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAsDefaultRange {}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
