import 'package:clock/clock.dart';
import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:nc_photos/use_case/album/share_album_with_user.dart';
import 'package:np_common/or_null.dart';
import 'package:np_string/np_string.dart';
import 'package:test/test.dart';

import '../mock_type.dart';
import '../test_util.dart' as util;

void main() {
  KiwiContainer().registerInstance<EventBus>(MockEventBus());

  group("ShareAlbumWithUser", () {
    test("w/o file", _shareWithoutFile);
    test("w/ file", _shareWithFile);
    test("w/ file owned by user", _shareWithFileOwnedByUser);
    test("shared album", _shareSharedAlbum);
  });
}

/// Share an empty album with a user (user1)
///
/// Expect: share (admin -> user1) added to album's shares list;
/// a new share (admin -> user1) is created for the album json
Future<void> _shareWithoutFile() async {
  final account = util.buildAccount();
  final album = util.AlbumBuilder().build();
  final albumFile = album.albumFile!;
  final albumRepo = MockAlbumMemoryRepo([album]);
  final shareRepo = MockShareMemoryRepo();

  await ShareAlbumWithUser(shareRepo, albumRepo)(
    account,
    albumRepo.findAlbumByPath(albumFile.path),
    util.buildSharee(shareWith: "user1".toCi()),
  );
  expect(
    albumRepo
        .findAlbumByPath(albumFile.path)
        .shares
        ?.map(
          (s) => s.copyWith(
            // we need to set a known value to sharedAt
            sharedAt: OrNull(DateTime.utc(2020, 1, 2, 3, 4, 5)),
          ),
        )
        .toList(),
    [util.buildAlbumShare(userId: "user1")],
  );
  expect(shareRepo.shares, [
    util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
  ]);
}

/// Share an album with files to a user (user1)
///
/// Expect: share (admin -> user1) added to album's shares list;
/// new shares (admin -> user1) are created for the album json and the album
/// files
Future<void> _shareWithFile() async {
  final account = util.buildAccount();
  final files =
      (util.FilesBuilder(initialFileId: 1)..addJpeg("admin/test1.jpg")).build();
  final album = (util.AlbumBuilder()..addFileItem(files[0])).build();
  final file1 = files[0];
  final albumFile = album.albumFile!;
  final albumRepo = MockAlbumMemoryRepo([album]);
  final shareRepo = MockShareMemoryRepo();

  await ShareAlbumWithUser(shareRepo, albumRepo)(
    account,
    albumRepo.findAlbumByPath(albumFile.path),
    util.buildSharee(shareWith: "user1".toCi()),
  );
  expect(
    albumRepo
        .findAlbumByPath(albumFile.path)
        .shares
        ?.map(
          (s) => s.copyWith(
            // we need to set a known value to sharedAt
            sharedAt: OrNull(DateTime.utc(2020, 1, 2, 3, 4, 5)),
          ),
        )
        .toList(),
    [util.buildAlbumShare(userId: "user1")],
  );
  expect(shareRepo.shares, [
    util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
    util.buildShare(id: "1", file: file1, shareWith: "user1"),
  ]);
}

/// Share an album with files owned by user (user1) to that user (user1)
///
/// Expect: share (admin -> user1) added to album's shares list;
/// new shares (admin -> user1) are created for the album json
Future<void> _shareWithFileOwnedByUser() async {
  await withClock(Clock.fixed(DateTime.utc(2020, 1, 2, 3, 4, 5)), () async {
    final account = util.buildAccount();
    final files =
        (util.FilesBuilder(initialFileId: 1)
          ..addJpeg("admin/test1.jpg", ownerId: "user1")).build();
    final album = (util.AlbumBuilder()..addFileItem(files[0])).build();
    final albumFile = album.albumFile!;
    final albumRepo = MockAlbumMemoryRepo([album]);
    final shareRepo = MockShareMemoryRepo();

    await ShareAlbumWithUser(shareRepo, albumRepo)(
      account,
      albumRepo.findAlbumByPath(albumFile.path),
      util.buildSharee(shareWith: "user1".toCi()),
    );
    expect(albumRepo.findAlbumByPath(albumFile.path).shares?.toList(), [
      util.buildAlbumShare(userId: "user1"),
    ]);
    expect(shareRepo.shares, [
      util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
    ]);
  });
}

/// Share a shared album (admin -> user1) with a user (user2)
///
/// Expect: share (admin -> user2) added to album's shares list;
/// a new share (admin -> user2) is created for the album json
Future<void> _shareSharedAlbum() async {
  final account = util.buildAccount();
  final album = (util.AlbumBuilder()..addShare("user1")).build();
  final albumFile = album.albumFile!;
  final albumRepo = MockAlbumMemoryRepo([album]);
  final shareRepo = MockShareMemoryRepo([
    util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
  ]);

  await ShareAlbumWithUser(shareRepo, albumRepo)(
    account,
    albumRepo.findAlbumByPath(albumFile.path),
    util.buildSharee(shareWith: "user2".toCi()),
  );
  expect(
    albumRepo
        .findAlbumByPath(albumFile.path)
        .shares
        ?.map(
          (s) => s.copyWith(
            // we need to set a known value to sharedAt
            sharedAt: OrNull(DateTime.utc(2020, 1, 2, 3, 4, 5)),
          ),
        )
        .toList(),
    [
      util.buildAlbumShare(userId: "user1"),
      util.buildAlbumShare(userId: "user2"),
    ],
  );
  expect(shareRepo.shares, [
    util.buildShare(id: "0", file: albumFile, shareWith: "user1"),
    util.buildShare(id: "1", file: albumFile, shareWith: "user2"),
  ]);
}
