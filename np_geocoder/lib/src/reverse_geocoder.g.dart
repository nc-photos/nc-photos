// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geocoder.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $ReverseGeocoderLocationNameCopyWithWorker {
  ReverseGeocoderLocationName call({int? geonameId, LocalizedString? name});
}

class _$ReverseGeocoderLocationNameCopyWithWorkerImpl
    implements $ReverseGeocoderLocationNameCopyWithWorker {
  _$ReverseGeocoderLocationNameCopyWithWorkerImpl(this.that);

  @override
  ReverseGeocoderLocationName call({dynamic geonameId, dynamic name}) {
    return ReverseGeocoderLocationName(
      geonameId: geonameId as int? ?? that.geonameId,
      name: name as LocalizedString? ?? that.name,
    );
  }

  final ReverseGeocoderLocationName that;
}

extension $ReverseGeocoderLocationNameCopyWith on ReverseGeocoderLocationName {
  $ReverseGeocoderLocationNameCopyWithWorker get copyWith => _$copyWith;
  $ReverseGeocoderLocationNameCopyWithWorker get _$copyWith =>
      _$ReverseGeocoderLocationNameCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$ReverseGeocoderNpLog on ReverseGeocoder {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("src.reverse_geocoder.ReverseGeocoder");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$ReverseGeocoderLocationToString on ReverseGeocoderLocation {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ReverseGeocoderLocation {dataRevision: $dataRevision, latitude: $latitude, longitude: $longitude, countryCode: $countryCode, city: $city, admin1: $admin1, admin2: $admin2}";
  }
}

extension _$ReverseGeocoderLocationNameToString on ReverseGeocoderLocationName {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ReverseGeocoderLocationName {geonameId: $geonameId, name: $name}";
  }
}
