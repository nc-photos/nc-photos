import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:event_bus/event_bus.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/ci_string.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/favorite.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/future_util.dart' as future_util;
import 'package:nc_photos/or_null.dart';
import 'package:path/path.dart' as path_lib;

/// Mock of [AlbumRepo] where all methods will throw UnimplementedError
class MockAlbumRepo implements AlbumRepo {
  @override
  Future<Album> create(Account account, Album album) {
    throw UnimplementedError();
  }

  @override
  AlbumDataSource get dataSrc => throw UnimplementedError();

  @override
  Future<Album> get(Account account, File albumFile) {
    throw UnimplementedError();
  }

  @override
  Stream<dynamic> getAll(Account account, List<File> albumFiles) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Account account, Album album) {
    throw UnimplementedError();
  }
}

/// [AlbumRepo] mock that support some ops with an internal List
class MockAlbumMemoryRepo extends MockAlbumRepo {
  MockAlbumMemoryRepo([
    List<Album> initialData = const [],
  ]) : albums = initialData.map((a) => a.copyWith()).toList();

  @override
  get(Account account, File albumFile) async {
    return albums.firstWhere((element) =>
        element.albumFile?.compareServerIdentity(albumFile) == true);
  }

  @override
  getAll(Account account, List<File> albumFiles) async* {
    final results = await future_util.waitOr(
      albumFiles.map((f) => get(account, f)),
      (error, stackTrace) => ExceptionEvent(error, stackTrace),
    );
    for (final r in results) {
      yield r;
    }
  }

  @override
  update(Account account, Album album) async {
    final i = albums.indexWhere((element) =>
        element.albumFile?.compareServerIdentity(album.albumFile!) == true);
    albums[i] = album;
  }

  Album findAlbumByPath(String path) =>
      albums.firstWhere((element) => element.albumFile?.path == path);

  final List<Album> albums;
}

/// EventBus that ignore all events
class MockEventBus implements EventBus {
  @override
  destroy() {}

  @override
  fire(event) {}

  @override
  Stream<T> on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  @override
  StreamController get streamController => _streamController;

  final _streamController = StreamController.broadcast();
}

class MockFavoriteRepo implements FavoriteRepo {
  @override
  FavoriteDataSource get dataSrc => throw UnimplementedError();

  @override
  Future<List<Favorite>> list(Account account, File dir) {
    throw UnimplementedError();
  }
}

class MockFavoriteMemoryRepo extends MockFavoriteRepo {
  MockFavoriteMemoryRepo([
    List<Favorite> initialData = const [],
  ]) : favorite = initialData.map((a) => a.copyWith()).toList();

  @override
  list(Account account, File dir) async {
    return favorite.toList();
  }

  final List<Favorite> favorite;
}

/// Mock of [FileDataSource] where all methods will throw UnimplementedError
class MockFileDataSource implements FileDataSource {
  @override
  Future<void> copy(Account account, File f, String destination,
      {bool? shouldOverwrite}) {
    throw UnimplementedError();
  }

  @override
  Future<void> createDir(Account account, String path) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> getBinary(Account account, File f) {
    throw UnimplementedError();
  }

  @override
  Future<List<File>> list(Account account, File dir) {
    throw UnimplementedError();
  }

  @override
  Future<List<File>> listMinimal(Account account, File dir) {
    throw UnimplementedError();
  }

  @override
  Future<File> listSingle(Account account, File f) {
    throw UnimplementedError();
  }

  @override
  Future<void> move(Account account, File f, String destination,
      {bool? shouldOverwrite}) {
    throw UnimplementedError();
  }

  @override
  Future<void> putBinary(Account account, String path, Uint8List content) {
    throw UnimplementedError();
  }

  @override
  Future<void> remove(Account account, File f) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProperty(
    Account account,
    File f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) {
    throw UnimplementedError();
  }
}

/// [FileDataSource] mock that support some ops with an internal List
class MockFileMemoryDataSource extends MockFileDataSource {
  MockFileMemoryDataSource([
    List<File> initialData = const [],
  ]) : files = initialData.map((f) => f.copyWith()).toList() {
    _id = files
            .where((f) => f.fileId != null)
            .map((f) => f.fileId!)
            .fold(-1, math.max) +
        1;
  }

  @override
  list(Account account, File root) async {
    return files.where((f) => path_lib.dirname(f.path) == root.path).toList();
  }

  @override
  listSingle(Account account, File file) async {
    return files.where((f) => f.strippedPath == file.strippedPath).first;
  }

  @override
  remove(Account account, File file) async {
    files.removeWhere((f) {
      if (file.isCollection == true) {
        return file_util.isOrUnderDir(f, file);
      } else {
        return f.compareServerIdentity(file);
      }
    });
  }

  final List<File> files;
  // ignore: unused_field
  var _id = 0;
}

class MockFileWebdavDataSource implements FileWebdavDataSource {
  const MockFileWebdavDataSource(this.src);

  @override
  copy(Account account, File f, String destination, {bool? shouldOverwrite}) =>
      src.copy(account, f, destination, shouldOverwrite: shouldOverwrite);

  @override
  createDir(Account account, String path) => src.createDir(account, path);

  @override
  getBinary(Account account, File f) => src.getBinary(account, f);

  @override
  list(Account account, File dir, {int? depth}) async {
    if (depth == 0) {
      return [await src.listSingle(account, dir)];
    } else {
      return src.list(account, dir);
    }
  }

  @override
  listMinimal(Account account, File dir, {int? depth}) =>
      list(account, dir, depth: depth);

  @override
  listSingle(Account account, File f) => src.listSingle(account, f);

  @override
  move(Account account, File f, String destination, {bool? shouldOverwrite}) =>
      src.move(account, f, destination, shouldOverwrite: shouldOverwrite);

  @override
  putBinary(Account account, String path, Uint8List content) =>
      src.putBinary(account, path, content);

  @override
  remove(Account account, File f) => src.remove(account, f);

  @override
  updateProperty(
    Account account,
    File f, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) =>
      src.updateProperty(
        account,
        f,
        metadata: metadata,
        isArchived: isArchived,
        overrideDateTime: overrideDateTime,
        favorite: favorite,
        location: location,
      );

  final MockFileMemoryDataSource src;
}

/// [FileRepo] mock that support some ops with an internal List
class MockFileMemoryRepo extends FileRepo {
  MockFileMemoryRepo([
    List<File> initialData = const [],
  ]) : super(MockFileMemoryDataSource(initialData));

  List<File> get files {
    return (dataSrc as MockFileMemoryDataSource).files;
  }
}

/// Mock of [ShareRepo] where all methods will throw UnimplementedError
class MockShareRepo implements ShareRepo {
  @override
  Future<Share> create(Account account, File file, String shareWith) {
    throw UnimplementedError();
  }

  @override
  Future<Share> createLink(Account account, File file, {String? password}) {
    throw UnimplementedError();
  }

  @override
  ShareDataSource get dataSrc => throw UnimplementedError();

  @override
  Future<void> delete(Account account, Share share) {
    throw UnimplementedError();
  }

  @override
  Future<List<Share>> list(
    Account account,
    File file, {
    bool? isIncludeReshare,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Share>> listAll(Account account) {
    throw UnimplementedError();
  }

  @override
  Future<List<Share>> listDir(Account account, File dir) {
    throw UnimplementedError();
  }

  @override
  Future<List<Share>> reverseList(Account account, File file) {
    throw UnimplementedError();
  }

  @override
  Future<List<Share>> reverseListAll(Account account) {
    throw UnimplementedError();
  }
}

/// [ShareRepo] mock that support some ops with an internal List
class MockShareMemoryRepo extends MockShareRepo {
  MockShareMemoryRepo([
    List<Share> initialData = const [],
  ]) : shares = List.of(initialData) {
    _id = shares.map((e) => int.parse(e.id)).fold(-1, math.max) + 1;
  }

  @override
  list(
    Account account,
    File file, {
    bool? isIncludeReshare,
  }) async {
    return shares.where((s) {
      if (s.itemSource != file.fileId) {
        return false;
      } else if (isIncludeReshare == true || s.uidOwner == account.userId) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  create(Account account, File file, String shareWith) async {
    final share = Share(
      id: (_id++).toString(),
      shareType: ShareType.user,
      stime: DateTime.utc(2020, 1, 2, 3, 4, 5),
      uidOwner: account.userId,
      displaynameOwner: account.username2,
      uidFileOwner: file.ownerId!,
      path: file.strippedPath,
      itemType: ShareItemType.file,
      mimeType: file.contentType ?? "",
      itemSource: file.fileId!,
      shareWith: shareWith.toCi(),
      shareWithDisplayName: shareWith,
    );
    shares.add(share);
    return share;
  }

  @override
  delete(Account account, Share share) async {
    shares.removeWhere((s) => s.id == share.id);
  }

  final List<Share> shares;
  var _id = 0;
}

/// Mock of [ShareeRepo] where all methods will throw UnimplementedError
class MockShareeRepo implements ShareeRepo {
  @override
  ShareeDataSource get dataSrc => throw UnimplementedError();

  @override
  Future<List<Sharee>> list(Account account) {
    throw UnimplementedError();
  }
}

class MockShareeMemoryRepo extends MockShareeRepo {
  MockShareeMemoryRepo([
    List<Sharee> initialData = const [],
  ]) : sharees = List.of(initialData);

  @override
  list(Account account) async {
    return sharees.where((s) => s.shareWith != account.userId).toList();
  }

  final List<Sharee> sharees;
}

class MockTagRepo implements TagRepo {
  @override
  TagDataSource get dataSrc => throw UnimplementedError();

  @override
  Future<List<Tag>> list(Account account) {
    throw UnimplementedError();
  }

  @override
  Future<List<Tag>> listByFile(Account account, File file) {
    throw UnimplementedError();
  }
}

class MockTagMemoryRepo extends MockTagRepo {
  MockTagMemoryRepo([
    Map<String, List<Tag>> initialData = const {},
  ]) : tags = initialData.map((key, value) => MapEntry(key, List.of(value)));

  @override
  list(Account account) async {
    return tags[account.url]!;
  }

  final Map<String, List<Tag>> tags;
}

class MockPersonRepo implements PersonRepo {
  @override
  PersonDataSource get dataSrc => throw UnimplementedError();

  @override
  Future<List<Person>> list(Account account) {
    throw UnimplementedError();
  }
}

class MockPersonMemoryRepo extends MockPersonRepo {
  MockPersonMemoryRepo([
    Map<String, List<Person>> initialData = const {},
  ]) : persons = initialData.map((key, value) => MapEntry(key, List.of(value)));

  @override
  list(Account account) async {
    return persons[account.id]!;
  }

  final Map<String, List<Person>> persons;
}

extension MockDiContainerExtension on DiContainer {
  MockAlbumMemoryRepo get albumMemoryRepo => albumRepo as MockAlbumMemoryRepo;
  MockFileMemoryRepo get fileMemoryRepo => fileRepo as MockFileMemoryRepo;
  MockShareMemoryRepo get shareMemoryRepo => shareRepo as MockShareMemoryRepo;
  MockShareeMemoryRepo get shareeMemoryRepo =>
      shareeRepo as MockShareeMemoryRepo;
}
