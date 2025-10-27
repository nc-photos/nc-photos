import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/local.dart';
import 'package:nc_photos/entity/any_file/content/merged.dart';
import 'package:nc_photos/entity/any_file/content/nextcloud.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:np_common/size.dart';
import 'package:np_gps_map/np_gps_map.dart';

abstract interface class AnyFileContentGetterFactory {
  /// Return the uri of this file
  static AnyFileUriGetter uri(AnyFile file, {required Account account}) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudUriGetter(file, account: account);
      case AnyFileLocalProvider _:
        return AnyFileLocalUriGetter(file);
      case AnyFileMergedProvider _:
        return AnyFileMergedUriGetter(file);
    }
  }

  /// Return the uri of this file's preview image
  ///
  /// This might be identical to [get] if a preview is n/a
  static AnyFileLargePreviewUriGetter largePreviewuri(
    AnyFile file, {
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudLargePreviewUriGetter(file, account: account);
      case AnyFileLocalProvider _:
        return AnyFileLocalLargePreviewUriGetter(file);
      case AnyFileMergedProvider _:
        return AnyFileMergedLargePreviewUriGetter(file);
    }
  }

  static AnyFileMetadataGetter metadata(
    AnyFile file, {
    required DiContainer c,
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudMetadataGetter(file, c: c, account: account);
      case AnyFileLocalProvider _:
        return AnyFileLocalMetadataGetter(file);
      case AnyFileMergedProvider _:
        return AnyFileMergedMetadataGetter(file, c: c, account: account);
    }
  }

  static AnyFileTagGetter tag(
    AnyFile file, {
    required DiContainer c,
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudTagGetter(file, c: c, account: account);
      case AnyFileLocalProvider _:
        return const AnyFileLocalTagGetter();
      case AnyFileMergedProvider _:
        return AnyFileMergedTagGetter(file, c: c, account: account);
    }
  }
}

abstract interface class AnyFileUriGetter {
  /// Return the content uri of this file
  Future<Uri> get();
}

abstract interface class AnyFileLargePreviewUriGetter {
  /// Return the content uri of this file's preview image
  ///
  /// This might be identical to [AnyFileUriGetter.get] if a preview is not
  /// available
  Future<Uri> get();
}

/// A type containing a numerator and a denominator to represent a decimal
/// number, commonly used in EXIF
class AnyFileMetadataRational {
  const AnyFileMetadataRational(this.numerator, this.denominator);

  double toDouble() => numerator / denominator;

  @override
  String toString() => "$numerator/$denominator";

  final int numerator;
  final int denominator;
}

abstract interface class AnyFileMetadataGetter {
  /// Return whether this file is owned by the current user, or null if sharing
  /// is not supported
  Future<bool?> get isOwned;

  /// Return the name of the owner of this file, or null if not supported
  Future<String?> get owner;

  /// Return the resolution of this image/video, or null if irrelevant
  Future<SizeInt?> get size;

  /// Return the size of this file in byte
  Future<int?> get byteSize;

  Future<String?> get make;

  Future<String?> get model;

  Future<AnyFileMetadataRational?> get fNumber;

  Future<AnyFileMetadataRational?> get exposureTime;

  Future<AnyFileMetadataRational?> get focalLength;

  Future<int?> get isoSpeedRatings;

  Future<MapCoord?> get gpsCoord;

  Future<ImageLocation?> get location;
}

class AnyFileTag {
  const AnyFileTag(this.id, this.name);

  final String id;
  final String name;
}

abstract interface class AnyFileTagGetter {
  /// Return the list of tags associated to this file
  Future<List<AnyFileTag>?> get();
}
