import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_datetime/np_datetime.dart';

class ListFile {
  const ListFile(this._c);

  Future<List<FileDescriptor>> call(
    Account account,
    String shareDirPath, {
    TimeRange? timeRange,
    bool? isArchived,
    bool? isAscending,
    int? offset,
    int? limit,
  }) => _c.fileRepo2.getFileDescriptors(
    account,
    shareDirPath,
    timeRange: timeRange,
    isArchived: isArchived,
    isAscending: isAscending,
    offset: offset,
    limit: limit,
  );

  final DiContainer _c;
}
