// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_browser.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    LocationGroupResult? places,
    bool? isLoading,
    List<_Item>? transformedPlaceItems,
    List<_Item>? transformedCountryItems,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic places,
    dynamic isLoading,
    dynamic transformedPlaceItems,
    dynamic transformedCountryItems,
    dynamic error = copyWithNull,
  }) {
    return _State(
      places: places as LocationGroupResult? ?? that.places,
      isLoading: isLoading as bool? ?? that.isLoading,
      transformedPlaceItems:
          transformedPlaceItems as List<_Item>? ?? that.transformedPlaceItems,
      transformedCountryItems:
          transformedCountryItems as List<_Item>? ??
          that.transformedCountryItems,
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

extension _$_WrappedPlacesBrowserStateNpLog on _WrappedPlacesBrowserState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.places_browser._WrappedPlacesBrowserState");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.places_browser._Bloc");
}

extension _$_ItemNpLog on _Item {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.places_browser._Item");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {places: $places, isLoading: $isLoading, transformedPlaceItems: [length: ${transformedPlaceItems.length}], transformedCountryItems: [length: ${transformedCountryItems.length}], error: $error}";
  }
}

extension _$_LoadPlacesToString on _LoadPlaces {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadPlaces {}";
  }
}

extension _$_ReloadToString on _Reload {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Reload {}";
  }
}

extension _$_TransformItemsToString on _TransformItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformItems {places: $places}";
  }
}
