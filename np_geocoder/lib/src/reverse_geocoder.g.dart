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
  ReverseGeocoderLocationName call({
    String? name,
    String? admin1,
    String? admin2,
  });
}

class _$ReverseGeocoderLocationNameCopyWithWorkerImpl
    implements $ReverseGeocoderLocationNameCopyWithWorker {
  _$ReverseGeocoderLocationNameCopyWithWorkerImpl(this.that);

  @override
  ReverseGeocoderLocationName call({
    dynamic name = copyWithNull,
    dynamic admin1 = copyWithNull,
    dynamic admin2 = copyWithNull,
  }) {
    return ReverseGeocoderLocationName(
      name: name == copyWithNull ? that.name : name as String?,
      admin1: admin1 == copyWithNull ? that.admin1 : admin1 as String?,
      admin2: admin2 == copyWithNull ? that.admin2 : admin2 as String?,
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
    return "ReverseGeocoderLocation {latitude: $latitude, longitude: $longitude, countryCode: $countryCode, names: $names}";
  }
}

extension _$ReverseGeocoderLocationNameToString on ReverseGeocoderLocationName {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ReverseGeocoderLocationName {name: $name, admin1: $admin1, admin2: $admin2}";
  }
}
