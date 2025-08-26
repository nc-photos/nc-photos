part of '../database_extension.dart';

class CompleteAlbum {
  const CompleteAlbum(this.album, this.albumFileId, this.shares);

  final Album album;
  final int albumFileId;
  final List<AlbumShare> shares;
}

class CompleteAlbumCompanion {
  const CompleteAlbumCompanion(this.album, this.albumFileId, this.shares);

  final AlbumsCompanion album;
  final int albumFileId;
  final List<AlbumSharesCompanion> shares;
}

extension SqliteDbAlbumExtension on SqliteDb {
  Future<List<CompleteAlbum>> queryAlbumsByAlbumFileIds({
    required ByAccount account,
    required List<int> fileIds,
  }) async {
    _log.info("[queryAlbumsByAlbumFileIds] fileIds: $fileIds");
    final fileIdToRowId = await _accountFileRowIdsOf(
      account,
      fileIds.map(DbFileKey.byId).toList(),
    );
    final query = select(albums).join([
      leftOuterJoin(albumShares, albumShares.album.equalsExp(albums.rowId)),
    ])..where(albums.file.isIn(fileIdToRowId.values.map((e) => e.fileRowId)));
    final albumWithShares =
        await query
            .map(
              (r) => _AlbumWithShare(
                r.readTable(albums),
                r.readTableOrNull(albumShares),
              ),
            )
            .get();

    // group entries together
    final rowIdToFileId = <int, int>{};
    for (final e in fileIdToRowId.entries) {
      rowIdToFileId[e.value.fileRowId] = e.key;
    }
    final fileIdToResult = <int, CompleteAlbum>{};
    for (final s in albumWithShares) {
      final fid = rowIdToFileId[s.album.file];
      if (fid == null) {
        _log.severe(
          "[queryAlbumsByAlbumFileIds] File missing for album (rowId: ${s.album.rowId}",
        );
      } else {
        fileIdToResult[fid] ??= CompleteAlbum(s.album, fid, []);
        if (s.share != null) {
          fileIdToResult[fid]!.shares.add(s.share!);
        }
      }
    }
    return fileIdToResult.values.toList();
  }

  Future<void> syncAlbum({
    required ByAccount account,
    required String? albumFileEtag,
    required CompleteAlbumCompanion obj,
  }) async {
    _log.info("[syncAlbum] album: ${obj.album.name}");
    final fileRowIds =
        (await _accountFileRowIdsOfSingle(
          account,
          DbFileKey.byId(obj.albumFileId),
        ))!;
    final album = obj.album.copyWith(
      file: Value(fileRowIds.fileRowId),
      fileEtag: Value(albumFileEtag),
    );
    var rowId = await _albumRowIdByFileRowId(this, fileRowIds.fileRowId);
    if (rowId == null) {
      // insert
      _log.info("[syncAlbum] Insert new album");
      final insertedAlbum = await into(albums).insertReturning(album);
      rowId = insertedAlbum.rowId;
    } else {
      // update
      await (update(albums)..where((t) => t.rowId.equals(rowId!))).write(album);
      await (delete(albumShares)..where((t) => t.album.equals(rowId!))).go();
    }
    if (obj.shares.isNotEmpty) {
      await batch((batch) {
        batch.insertAll(
          albumShares,
          obj.shares.map((s) => s.copyWith(album: Value(rowId!))),
        );
      });
    }
  }
}

class _AlbumWithShare {
  const _AlbumWithShare(this.album, this.share);

  final Album album;
  final AlbumShare? share;
}

Future<int?> _albumRowIdByFileRowId(SqliteDb db, int fileRowId) {
  final query =
      db.selectOnly(db.albums)
        ..addColumns([db.albums.rowId])
        ..where(db.albums.file.equals(fileRowId))
        ..limit(1);
  return query.map((r) => r.read(db.albums.rowId)!).getSingleOrNull();
}
