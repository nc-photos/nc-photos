import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:np_ui/np_ui.dart';

enum PlaceSort {
  count(0),
  name(1),
  latestDate(2);

  const PlaceSort(this.value);

  static PlaceSort? tryFromValue(int value) =>
      PlaceSort.values.firstWhereOrNull((e) => e.value == value);

  final int value;
}

int Function(LocationGroup a, LocationGroup b, Locale locale) getPlaceSorter(
  PlaceSort sort,
) {
  return switch (sort) {
    PlaceSort.count => _countSorter,
    PlaceSort.name => _nameSorter,
    PlaceSort.latestDate => _latestDateSorter,
  };
}

int _countSorter(LocationGroup a, LocationGroup b, Locale locale) {
  final compare = b.count.compareTo(a.count);
  if (compare == 0) {
    return _nameSorter(a, b, locale);
  } else {
    return compare;
  }
}

int _nameSorter(LocationGroup a, LocationGroup b, Locale locale) {
  return a.name.ofLocale(locale).compareTo(b.name.ofLocale(locale));
}

int _latestDateSorter(LocationGroup a, LocationGroup b, Locale locale) {
  final compare = b.latestDateTime.compareTo(a.latestDateTime);
  if (compare == 0) {
    return _nameSorter(a, b, locale);
  } else {
    return compare;
  }
}
