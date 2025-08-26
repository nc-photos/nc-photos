import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';

part 'repo.g.dart';

class ImageLatLng with EquatableMixin {
  const ImageLatLng({
    required this.latitude,
    required this.longitude,
    required this.fileId,
    required this.fileRelativePath,
    required this.mime,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    fileId,
    fileRelativePath,
    mime,
  ];

  final double latitude;
  final double longitude;
  final int fileId;
  final String fileRelativePath;
  final String? mime;
}

abstract class ImageLocationRepo {
  /// Query all locations with the corresponding file ids
  ///
  /// Returned data are sorted by the file date time in descending order
  Future<List<ImageLatLng>> getLocations(Account account, TimeRange timeRange);
}

@npLog
class BasicImageLocationRepo implements ImageLocationRepo {
  const BasicImageLocationRepo(this.dataSrc);

  @override
  Future<List<ImageLatLng>> getLocations(
    Account account,
    TimeRange timeRange,
  ) => dataSrc.getLocations(account, timeRange);

  final ImageLocationDataSource dataSrc;
}

abstract class ImageLocationDataSource {
  /// Query all locations with the corresponding file ids
  ///
  /// Returned data are sorted by the file date time in descending order
  Future<List<ImageLatLng>> getLocations(Account account, TimeRange timeRange);
}
