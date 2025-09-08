import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/entity/local_file/repo.dart';
import 'package:np_datetime/np_datetime.dart';

class ListLocalFile {
  const ListLocalFile({
    required this.localFileRepo,
    required this.prefController,
  });

  Future<List<LocalFile>> call({
    TimeRange? timeRange,
    List<String>? dirWhitelist,
    bool? isAscending,
    int? offset,
    int? limit,
  }) {
    if (prefController.isEnableLocalFileValue) {
      return localFileRepo.getFiles(
        timeRange: timeRange,
        dirWhitelist: dirWhitelist,
        isAscending: isAscending,
        offset: offset,
        limit: limit,
      );
    } else {
      return Future.value(const []);
    }
  }

  final LocalFileRepo localFileRepo;
  final PrefController prefController;
}
