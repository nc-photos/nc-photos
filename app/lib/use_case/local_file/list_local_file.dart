import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/entity/local_file/repo.dart';
import 'package:np_datetime/np_datetime.dart';

class ListLocalFile {
  const ListLocalFile(this.localFileRepo);

  Future<List<LocalFile>> call({
    TimeRange? timeRange,
    List<String>? dirWhitelist,
    bool? isAscending,
    int? offset,
    int? limit,
  }) => localFileRepo.getFiles(
    timeRange: timeRange,
    dirWhitelist: dirWhitelist,
    isAscending: isAscending,
    offset: offset,
    limit: limit,
  );

  final LocalFileRepo localFileRepo;
}
