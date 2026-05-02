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
  Stream<List<RecognizeFace>> getFaces(
    Account account, {
    required bool shouldUseApiKey,
  });

  /// Query all items belonging to [face]
  Stream<List<RecognizeFaceItem>> getItems(
    Account account,
    RecognizeFace face, {
    required bool shouldUseApiKey,
  });

  /// Query all items belonging to each face
  Stream<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    required bool shouldUseApiKey,
    ErrorWithValueHandler<RecognizeFace>? onError,
  });
}

/// A repo that simply relay the call to the backed [RecognizeFaceDataSource]
@npLog
class BasicRecognizeFaceRepo implements RecognizeFaceRepo {
  const BasicRecognizeFaceRepo(this.dataSrc);

  @override
  Stream<List<RecognizeFace>> getFaces(
    Account account, {
    required bool shouldUseApiKey,
  }) async* {
    yield await dataSrc.getFaces(account, shouldUseApiKey: shouldUseApiKey);
  }

  @override
  Stream<List<RecognizeFaceItem>> getItems(
    Account account,
    RecognizeFace face, {
    required bool shouldUseApiKey,
  }) async* {
    yield await dataSrc.getItems(
      account,
      face,
      shouldUseApiKey: shouldUseApiKey,
    );
  }

  @override
  Stream<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    required bool shouldUseApiKey,
    ErrorWithValueHandler<RecognizeFace>? onError,
  }) async* {
    yield await dataSrc.getMultiFaceItems(
      account,
      faces,
      shouldUseApiKey: shouldUseApiKey,
      onError: onError,
    );
  }

  final RecognizeFaceDataSource dataSrc;
}

abstract class RecognizeFaceDataSource {
  /// Query all [RecognizeFace]s belonging to [account]
  Future<List<RecognizeFace>> getFaces(
    Account account, {
    required bool shouldUseApiKey,
  });

  /// Query all items belonging to [face]
  Future<List<RecognizeFaceItem>> getItems(
    Account account,
    RecognizeFace face, {
    required bool shouldUseApiKey,
  });

  /// Query all items belonging to each face
  Future<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    required bool shouldUseApiKey,
    ErrorWithValueHandler<RecognizeFace>? onError,
  });

  /// Query the last items belonging to each face
  Future<Map<RecognizeFace, RecognizeFaceItem>> getMultiFaceLastItems(
    Account account,
    List<RecognizeFace> faces, {
    required bool shouldUseApiKey,
    ErrorWithValueHandler<RecognizeFace>? onError,
  });
}
