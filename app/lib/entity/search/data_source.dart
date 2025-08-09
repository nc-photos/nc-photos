import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/person/builder.dart';
import 'package:nc_photos/entity/search.dart';
import 'package:nc_photos/entity/search_util.dart' as search_util;
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:nc_photos/use_case/list_tagged_file.dart';
import 'package:nc_photos/use_case/person/list_person_face.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'data_source.g.dart';

@npLog
class SearchSqliteDbDataSource implements SearchDataSource {
  const SearchSqliteDbDataSource(this._c);

  @override
  Future<List<FileDescriptor>> list(
    Account account,
    SearchCriteria criteria,
  ) async {
    _log.info("[list] $criteria");
    final stopwatch = Stopwatch()..start();
    try {
      final keywords =
          search_util
              .cleanUpSymbols(criteria.input)
              .split(" ")
              .where((s) => s.isNotEmpty)
              .map((s) => s.toCi().toCaseInsensitiveString())
              .toSet();
      final futures = await Future.wait([
        _listByPath(account, criteria, keywords),
        _listByLocation(account, criteria),
        _listByTag(account, criteria),
        _listByPerson(account, criteria),
      ]);
      return futures.flatten().distinctIf(
        (a, b) => a.compareServerIdentity(b),
        (a) => a.identityHashCode,
      );
    } finally {
      _log.info("[list] Elapsed time: ${stopwatch.elapsedMilliseconds}ms");
    }
  }

  Future<List<FileDescriptor>> _listByPath(
    Account account,
    SearchCriteria criteria,
    Set<String> keywords,
  ) async {
    try {
      final args = {
        #account: account.toDb(),
        #includeRelativeRoots: account.roots,
        #excludeRelativeRoots: [
          remote_storage_util.remoteStorageDirRelativePath,
        ],
        #relativePathKeywords: keywords.toList(),
        #mimes: file_util.supportedFormatMimes,
      };
      for (final f in criteria.filters) {
        args.addAll(f.toQueryArgument());
      }
      final List<DbFileDescriptor> dbFiles = await Function.apply(
        _c.npDb.getFileDescriptors,
        null,
        args,
      );
      return dbFiles
          .map(
            (e) => DbFileDescriptorConverter.fromDb(
              account.userId.toCaseInsensitiveString(),
              e,
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      _log.severe("[_listByPath] Failed while _listByPath", e, stackTrace);
      return [];
    }
  }

  Future<List<FileDescriptor>> _listByLocation(
    Account account,
    SearchCriteria criteria,
  ) async {
    // location search requires exact match, for example, searching "united"
    // will NOT return results from US, UK, UAE, etc. Searching by the alpha2
    // code is supported
    try {
      final args = {
        #account: account.toDb(),
        #includeRelativeRoots: account.roots,
        #excludeRelativeRoots: [
          remote_storage_util.remoteStorageDirRelativePath,
        ],
        #location: criteria.input,
        #mimes: file_util.supportedFormatMimes,
      };
      for (final f in criteria.filters) {
        args.addAll(f.toQueryArgument());
      }
      final List<DbFileDescriptor> dbFiles = await Function.apply(
        _c.npDb.getFileDescriptors,
        null,
        args,
      );
      return dbFiles
          .map(
            (e) => DbFileDescriptorConverter.fromDb(
              account.userId.toCaseInsensitiveString(),
              e,
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      _log.severe(
        "[_listByLocation] Failed while _listByLocation",
        e,
        stackTrace,
      );
      return [];
    }
  }

  Future<List<FileDescriptor>> _listByTag(
    Account account,
    SearchCriteria criteria,
  ) async {
    // tag search requires exact match, for example, searching "super" will NOT
    // return results from "super tag"
    try {
      final dbTag = await _c.npDb.getTagByDisplayName(
        account: account.toDb(),
        displayName: criteria.input,
      );
      if (dbTag == null) {
        return [];
      }
      final tag = DbTagConverter.fromDb(dbTag);
      _log.info("[_listByTag] Found tag: ${tag.displayName}");
      final files = await ListTaggedFile(_c)(account, [tag]);
      return files
          .where((f) => criteria.filters.every((c) => c.isSatisfy(f)))
          .toList();
    } catch (e, stackTrace) {
      _log.severe("[_listByTag] Failed while _listByTag", e, stackTrace);
      return [];
    }
  }

  Future<List<FileDescriptor>> _listByPerson(
    Account account,
    SearchCriteria criteria,
  ) async {
    // person search requires exact match of any parts, for example, searching
    // "Ada" will return results from "Ada Crook" but NOT "Adabelle"
    try {
      final dbPersons = await _c.npDb.searchFaceRecognitionPersonsByName(
        account: account.toDb(),
        name: criteria.input,
      );
      if (dbPersons.isEmpty) {
        return [];
      }
      final persons =
          dbPersons
              .map(DbFaceRecognitionPersonConverter.fromDb)
              .map((p) => PersonBuilder.byFaceRecognitionPerson(account, p))
              .toList();
      _log.info(
        "[_listByPerson] Found people: ${persons.map((p) => p.name).toReadableString()}",
      );
      final futures = await Future.wait(
        persons.map((p) async => ListPersonFace(_c)(account, p).last),
      );
      final faces = futures.flatten().toList();
      final files = await InflateFileDescriptor(
        _c,
      ).call(account, faces.map((e) => e.file).toList());
      return files
          .where((f) => criteria.filters.every((c) => c.isSatisfy(f)))
          .toList();
    } catch (e, stackTrace) {
      _log.severe("[_listByPerson] Failed while _listByPerson", e, stackTrace);
      return [];
    }
  }

  final DiContainer _c;
}
