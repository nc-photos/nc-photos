import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/local_file/repo.dart';

class ListLocalFileIdWithTimestamp {
  const ListLocalFileIdWithTimestamp({
    required this.localFileRepo,
    required this.prefController,
  });

  Future<List<LocalFileIdWithTimestamp>> call({List<String>? dirWhitelist}) {
    if (dirWhitelist?.isEmpty == true) {
      // no point doing anything
      return Future.value(const []);
    }
    if (prefController.isEnableLocalFileValue) {
      return localFileRepo.getFileIdWithTimestamps(dirWhitelist: dirWhitelist);
    } else {
      return Future.value(const []);
    }
  }

  final LocalFileRepo localFileRepo;
  final PrefController prefController;
}
