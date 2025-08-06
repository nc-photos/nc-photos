import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/use_case/album/unshare_album_with_user.dart';
import 'package:np_string/np_string.dart';
import 'package:test/test.dart';

import '../mock_type.dart';
import '../test_util.dart' as util;

void main() {
  KiwiContainer().registerInstance<EventBus>(MockEventBus());

  group("UnshareAlbumWithUser", () {
    test("w/o file", _unshareWithoutFile);
    test("w/ file", _unshareWithFile);
    test("w/ file not owned", _unshareWithFileNotOwned);
  });
}

/// Unshare an empty album with a user (user1)
///
/// Expect: user (admin -> user1) removed from album's shares list;
/// share (admin -> user1) for the album json deleted
Future<void> _unshareWithoutFile() async {
  final account = util.buildAccount();
  final album =
      (util.AlbumBuilder()
            ..addShare("user1")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  final c = DiContainer(
    albumRepo: MockAlbumMemoryRepo([album]),
    fileRepo: MockFileMemoryRepo([albumFile]),
    shareRepo: MockShareMemoryRepo([
      util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
      util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
    ]),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());

  await UnshareAlbumWithUser(c)(
    account,
    c.albumMemoryRepo.findAlbumByPath(albumFile.path),
    "user1".toCi(),
  );
  expect(c.albumMemoryRepo.findAlbumByPath(albumFile.path).shares, [
    util.buildAlbumShare(userId: "user2"),
  ]);
  expect(c.shareMemoryRepo.shares, [
    util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
  ]);
}

/// Unshare an album with a user (user1)
///
/// Expect: user (admin -> user1) removed from album's shares list;
/// share (admin -> user1) for the album json deleted;
/// shares (admin -> user1) for the album files deleted
Future<void> _unshareWithFile() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album =
      (util.AlbumBuilder()
            ..addFileItem(files[0])
            ..addShare("user1")
            ..addShare("user2"))
          .build();
  final file1 = files[0];
  final albumFile = album.albumFile!;
  final c = DiContainer(
    albumRepo: MockAlbumMemoryRepo([album]),
    fileRepo: MockFileMemoryRepo([albumFile, file1]),
    shareRepo: MockShareMemoryRepo([
      util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
      util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
      util.buildShare(id: "2", file: file1, shareWith: "user1"),
      util.buildShare(id: "3", file: file1, shareWith: "user2"),
    ]),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());

  await UnshareAlbumWithUser(c)(
    account,
    c.albumMemoryRepo.findAlbumByPath(albumFile.path),
    "user1".toCi(),
  );
  expect(c.albumMemoryRepo.findAlbumByPath(albumFile.path).shares, [
    util.buildAlbumShare(userId: "user2"),
  ]);
  expect(c.shareMemoryRepo.shares, [
    util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
    util.buildShare(id: "3", file: file1, shareWith: "user2"),
  ]);
}

/// Unshare an album with a user (user1), where some files are not owned by us
/// (admin)
///
/// Expect: user (admin -> user1) removed from album's shares list;
/// share (admin -> user1) for the album json deleted;
/// shares (admin -> user1) for the owned album files deleted;
/// shares (user2 -> user1) created by other unchanged
Future<void> _unshareWithFileNotOwned() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)
            ..addJpeg("admin/test1.jpg")
            ..addJpeg("user2/test2.jpg", ownerId: "user2"))
          .build();
  final album =
      (util.AlbumBuilder()
            ..addFileItem(files[0])
            ..addFileItem(files[1], addedBy: "user2")
            ..addShare("user1")
            ..addShare("user2"))
          .build();
  final albumFile = album.albumFile!;
  final c = DiContainer(
    albumRepo: MockAlbumMemoryRepo([album]),
    fileRepo: MockFileMemoryRepo([albumFile, files[0]]),
    shareRepo: MockShareMemoryRepo([
      util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
      util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
      util.buildShare(id: "2", file: files[0], shareWith: "user1"),
      util.buildShare(id: "3", file: files[0], shareWith: "user2"),
      util.buildShare(
        id: "4",
        uidOwner: "user2",
        file: files[1],
        shareWith: "admin",
      ),
      util.buildShare(
        id: "5",
        uidOwner: "user2",
        file: files[1],
        shareWith: "user1",
      ),
    ]),
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());

  await UnshareAlbumWithUser(c)(
    account,
    c.albumMemoryRepo.findAlbumByPath(albumFile.path),
    "user1".toCi(),
  );
  expect(c.albumMemoryRepo.findAlbumByPath(albumFile.path).shares, [
    util.buildAlbumShare(userId: "user2"),
  ]);
  expect(c.shareMemoryRepo.shares, [
    util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
    util.buildShare(id: "3", file: files[0], shareWith: "user2"),
    util.buildShare(
      id: "4",
      uidOwner: "user2",
      file: files[1],
      shareWith: "admin",
    ),
    util.buildShare(
      id: "5",
      uidOwner: "user2",
      file: files[1],
      shareWith: "user1",
    ),
  ]);
}
