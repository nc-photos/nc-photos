import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'repo.g.dart';

abstract class RecognizeFaceRepo {
  /// Query all [RecognizeFace]s belonging to [account]
  Stream<List<RecognizeFace>> getFaces(Account account);

  /// Query all items belonging to [face]
  Stream<List<RecognizeFaceItem>> getItems(Account account, RecognizeFace face);

  /// Query all items belonging to each face
  Stream<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  });
}

/// A repo that simply relay the call to the backed [NcAlbumDataSource]
@npLog
class BasicRecognizeFaceRepo implements RecognizeFaceRepo {
  const BasicRecognizeFaceRepo(this.dataSrc);

  @override
  Stream<List<RecognizeFace>> getFaces(Account account) async* {
    yield await dataSrc.getFaces(account);
  }

  @override
  Stream<List<RecognizeFaceItem>> getItems(
    Account account,
    RecognizeFace face,
  ) async* {
    yield await dataSrc.getItems(account, face);
  }

  @override
  Stream<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  }) async* {
    yield await dataSrc.getMultiFaceItems(account, faces, onError: onError);
  }

  final RecognizeFaceDataSource dataSrc;
}

abstract class RecognizeFaceDataSource {
  /// Query all [RecognizeFace]s belonging to [account]
  Future<List<RecognizeFace>> getFaces(Account account);

  /// Query all items belonging to [face]
  Future<List<RecognizeFaceItem>> getItems(Account account, RecognizeFace face);

  /// Query all items belonging to each face
  Future<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  });

  /// Query the last items belonging to each face
  Future<Map<RecognizeFace, RecognizeFaceItem>> getMultiFaceLastItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  });
}
