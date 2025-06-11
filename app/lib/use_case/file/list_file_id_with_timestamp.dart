import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file/repo.dart';

class ListFileIdWithTimestamp {
  const ListFileIdWithTimestamp({required this.fileRepo});

  Future<List<FileIdWithTimestamp>> call(
    Account account,
    String shareDirPath, {
    bool? isArchived,
  }) => fileRepo.getFileIdWithTimestamps(
    account,
    shareDirPath,
    isArchived: isArchived,
  );

  final FileRepo2 fileRepo;
}
