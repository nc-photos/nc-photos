import 'dart:async';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/any_file/content/local.dart';
import 'package:nc_photos/entity/any_file/content/nextcloud.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:np_common/size.dart';
import 'package:np_gps_map/np_gps_map.dart';

class AnyFileMergedUriGetter implements AnyFileUriGetter {
  AnyFileMergedUriGetter(AnyFile file)
    : _delegate = AnyFileLocalUriGetter(
        (file.provider as AnyFileMergedProvider).asLocalFile(),
      );

  @override
  Future<Uri> get() => _delegate.get();

  final AnyFileUriGetter _delegate;
}

class AnyFileMergedLargePreviewUriGetter
    implements AnyFileLargePreviewUriGetter {
  AnyFileMergedLargePreviewUriGetter(AnyFile file)
    : _delegate = AnyFileLocalLargePreviewUriGetter(
        (file.provider as AnyFileMergedProvider).asLocalFile(),
      );

  @override
  Future<Uri> get() => _delegate.get();

  final AnyFileLargePreviewUriGetter _delegate;
}

class AnyFileMergedMetadataGetter implements AnyFileMetadataGetter {
  AnyFileMergedMetadataGetter(
    AnyFile file, {
    required DiContainer c,
    required Account account,
  }) : _delegate = AnyFileNextcloudMetadataGetter(
         (file.provider as AnyFileMergedProvider).asRemoteFile(),
         c: c,
         account: account,
       );

  @override
  Future<bool?> get isOwned => _delegate.isOwned;

  @override
  Future<String?> get owner => _delegate.owner;

  @override
  Future<SizeInt?> get size => _delegate.size;

  @override
  Future<int?> get byteSize => _delegate.byteSize;

  @override
  Future<String?> get make => _delegate.make;

  @override
  Future<String?> get model => _delegate.model;

  @override
  Future<AnyFileMetadataRational?> get fNumber => _delegate.fNumber;

  @override
  Future<AnyFileMetadataRational?> get exposureTime => _delegate.exposureTime;

  @override
  Future<AnyFileMetadataRational?> get focalLength => _delegate.focalLength;

  @override
  Future<int?> get isoSpeedRatings => _delegate.isoSpeedRatings;

  @override
  Future<MapCoord?> get gpsCoord => _delegate.gpsCoord;

  @override
  Future<ImageLocation?> get location => _delegate.location;

  @override
  Future<Duration?> get offsetTime => _delegate.offsetTime;

  final AnyFileMetadataGetter _delegate;
}

class AnyFileMergedTagGetter implements AnyFileTagGetter {
  AnyFileMergedTagGetter(
    AnyFile file, {
    required DiContainer c,
    required Account account,
  }) : _delegate = AnyFileNextcloudTagGetter(
         (file.provider as AnyFileMergedProvider).asRemoteFile(),
         c: c,
         account: account,
       );

  @override
  Future<List<AnyFileTag>?> get() => _delegate.get();

  final AnyFileTagGetter _delegate;
}
