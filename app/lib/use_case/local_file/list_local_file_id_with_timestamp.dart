import 'package:nc_photos/entity/local_file/repo.dart';

class ListLocalFileIdWithTimestamp {
  const ListLocalFileIdWithTimestamp({required this.localFileRepo});

  Future<List<LocalFileIdWithTimestamp>> call() =>
      localFileRepo.getFileIdWithTimestamps();

  final LocalFileRepo localFileRepo;
}
