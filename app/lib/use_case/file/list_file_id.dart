import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file/repo.dart';

class ListFileId {
  const ListFileId({required this.fileRepo});

  Future<List<int>> call(
    Account account,
    String shareDirPath, {
    bool? isArchived,
  }) => fileRepo.getFileIds(account, shareDirPath, isArchived: isArchived);

  final FileRepo2 fileRepo;
}
