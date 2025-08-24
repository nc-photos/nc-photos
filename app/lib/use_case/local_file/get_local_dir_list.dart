import 'package:nc_photos/entity/local_file/repo.dart';

class GetLocalDirList {
  const GetLocalDirList(this.localFileRepo);

  Future<List<String>> call() => localFileRepo.getDirList();

  final LocalFileRepo localFileRepo;
}
