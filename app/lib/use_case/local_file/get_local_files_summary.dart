import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/local_file/repo.dart';

class GetLocalFilesSummary {
  const GetLocalFilesSummary({
    required this.localFileRepo,
    required this.prefController,
  });

  Future<LocalFilesSummary> call({List<String>? dirWhitelist}) {
    if (prefController.isEnableLocalFileValue) {
      return localFileRepo.getFilesSummary(dirWhitelist: dirWhitelist);
    } else {
      return Future.value(const LocalFilesSummary(items: {}));
    }
  }

  final LocalFileRepo localFileRepo;
  final PrefController prefController;
}
