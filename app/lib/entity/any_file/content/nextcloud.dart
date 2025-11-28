import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:nc_photos/use_case/list_file_tag.dart';
import 'package:np_common/size.dart';
import 'package:np_exiv2/np_exiv2.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';

part 'nextcloud.g.dart';

class AnyFileNextcloudUriGetter implements AnyFileUriGetter {
  AnyFileNextcloudUriGetter(AnyFile file, {required this.account})
    : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<Uri> get() async {
    return Uri.parse("${account.url}/${_provider.file.fdPath}");
  }

  final Account account;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudLargePreviewUriGetter
    implements AnyFileLargePreviewUriGetter {
  AnyFileNextcloudLargePreviewUriGetter(AnyFile file, {required this.account})
    : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<Uri> get() async {
    final fileInfo = await getFileFromCache(
      CachedNetworkImageType.largeImage,
      getViewerUrlForImageFile(account, _provider.file),
      _provider.file.fdMime,
    );
    return Uri.parse("file://${fileInfo!.file.path}");
  }

  final Account account;

  final AnyFileNextcloudProvider _provider;
}

class AnyFileNextcloudMetadataGetter implements AnyFileMetadataGetter {
  AnyFileNextcloudMetadataGetter(
    AnyFile file, {
    required this.c,
    required this.account,
  }) : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<bool?> get isOwned async {
    final file = await _ensureFile();
    return file?.isOwned(account.userId);
  }

  @override
  Future<String?> get owner async {
    final file = await _ensureFile();
    return file?.ownerDisplayName ?? file?.ownerId.toString();
  }

  @override
  Future<SizeInt?> get size async {
    final file = await _ensureFile();
    if (file?.metadata?.imageWidth != null &&
        file?.metadata?.imageHeight != null) {
      return SizeInt(file!.metadata!.imageWidth!, file.metadata!.imageHeight!);
    } else {
      return null;
    }
  }

  @override
  Future<int?> get byteSize async {
    final file = await _ensureFile();
    return file?.contentLength;
  }

  @override
  Future<String?> get make async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.make;
  }

  @override
  Future<String?> get model async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.model;
  }

  @override
  Future<AnyFileMetadataRational?> get fNumber async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.fNumber?.toAnyFile();
  }

  @override
  Future<AnyFileMetadataRational?> get exposureTime async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.exposureTime?.toAnyFile();
  }

  @override
  Future<AnyFileMetadataRational?> get focalLength async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.focalLength?.toAnyFile();
  }

  @override
  Future<int?> get isoSpeedRatings async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.isoSpeedRatings;
  }

  @override
  Future<MapCoord?> get gpsCoord async {
    final file = await _ensureFile();
    final gps = file?.metadata?.gpsCoord;
    if (gps != null) {
      return MapCoord(gps.lat, gps.lng);
    } else {
      return null;
    }
  }

  @override
  Future<ImageLocation?> get location async {
    final file = await _ensureFile();
    return file?.location;
  }

  @override
  Future<Duration?> get offsetTime async {
    final file = await _ensureFile();
    return file?.metadata?.exif?.offsetTimeOriginal;
  }

  Future<File?> _ensureFile() async {
    if (_initCompleter == null) {
      _initCompleter = Completer();
      unawaited(
        InflateFileDescriptor(c)(account, [_provider.file]).then((value) {
          _initCompleter!.complete(value.firstOrNull);
        }),
      );
    }
    return _initCompleter!.future;
  }

  final DiContainer c;
  final Account account;

  final AnyFileNextcloudProvider _provider;
  Completer<File>? _initCompleter;
}

@npLog
class AnyFileNextcloudTagGetter implements AnyFileTagGetter {
  AnyFileNextcloudTagGetter(
    AnyFile file, {
    required this.c,
    required this.account,
  }) : _provider = file.provider as AnyFileNextcloudProvider;

  @override
  Future<List<AnyFileTag>?> get() => _ensureTags();

  Future<List<AnyFileTag>?> _ensureTags() async {
    if (_initCompleter == null) {
      _initCompleter = Completer();
      if (file_util.isNcAlbumFile(account, _provider.file)) {
        // tag is not supported here
        _initCompleter!.complete(null);
      } else {
        try {
          final tags = await ListFileTag(c)(account, _provider.file);
          _initCompleter!.complete(
            tags
                .map((t) => AnyFileTag(t.id.toString(), t.displayName))
                .toList(),
          );
        } catch (e, stackTrace) {
          _log.shout("[_ensureTags] Failed while ListFileTag", e, stackTrace);
        }
      }
    }
    return _initCompleter!.future;
  }

  final DiContainer c;
  final Account account;

  final AnyFileNextcloudProvider _provider;
  Completer<List<AnyFileTag>?>? _initCompleter;
}

extension on Rational {
  AnyFileMetadataRational toAnyFile() {
    return AnyFileMetadataRational(numerator, denominator);
  }
}
