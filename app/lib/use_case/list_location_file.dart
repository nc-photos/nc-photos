import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';

class ListLocationFile {
  const ListLocationFile(this._c);

  /// List all files located in [place], [countryCode]
  Future<List<File>> call(
    Account account,
    File dir,
    String? place,
    String countryCode,
  ) async {
    final dbFiles = await _c.npDb.getFilesByDirKeyAndLocation(
      account: account.toDb(),
      dirRelativePath: dir.strippedPathWithEmpty,
      place: place,
      countryCode: countryCode,
    );
    return dbFiles
        .map((f) => DbFileConverter.fromDb(account.userId.toString(), f))
        .toList();
  }

  final DiContainer _c;
}
