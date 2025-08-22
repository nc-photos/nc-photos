import 'package:nc_photos/entity/local_file/repo.dart';

class ListLocalFileIdWithTimestamp {
  const ListLocalFileIdWithTimestamp({required this.localFileRepo});

  Future<List<LocalFileIdWithTimestamp>> call({List<String>? dirWhitelist}) =>
      localFileRepo.getFileIdWithTimestamps(dirWhitelist: dirWhitelist);

  final LocalFileRepo localFileRepo;
}
