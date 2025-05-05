import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_datetime/np_datetime.dart';

class ListLocalFile {
  const ListLocalFile(this._c);

  Future<List<LocalFile>> call({TimeRange? timeRange}) =>
      _c.localFileRepo.getFiles(timeRange: timeRange);

  final DiContainer _c;
}
