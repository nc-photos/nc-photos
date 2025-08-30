import 'dart:async';

import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/exif_util.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/use_case/load_metadata.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_common/size.dart';
import 'package:np_exiv2/np_exiv2.dart';
import 'package:np_gps_map/np_gps_map.dart';

class AnyFileLocalUriGetter implements AnyFileUriGetter {
  AnyFileLocalUriGetter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<Uri> get() async {
    if (_provider.file is LocalUriFile) {
      return Uri.parse((_provider.file as LocalUriFile).uri);
    } else {
      throw UnimplementedError();
    }
  }

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalLargePreviewUriGetter
    implements AnyFileLargePreviewUriGetter {
  AnyFileLocalLargePreviewUriGetter(AnyFile file)
    : _impl = AnyFileLocalUriGetter(file);

  @override
  Future<Uri> get() => _impl.get();

  final AnyFileLocalUriGetter _impl;
}

class AnyFileLocalMetadataGetter implements AnyFileMetadataGetter {
  AnyFileLocalMetadataGetter(this.file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<bool?> get isOwned => Future.value(true);

  @override
  Future<String?> get owner => Future.value(null);

  @override
  Future<SizeInt?> get size => Future.value(_provider.file.size);

  @override
  Future<int?> get byteSize => Future.value(_provider.file.byteSize);

  @override
  Future<String?> get make => _ensureMetadata().then((e) => e?.exif?.make);

  @override
  Future<String?> get model => _ensureMetadata().then((e) => e?.exif?.model);

  @override
  Future<AnyFileMetadataRational?> get fNumber =>
      _ensureMetadata().then((e) => e?.exif?.fNumber?.toAnyFile());

  @override
  Future<AnyFileMetadataRational?> get exposureTime =>
      _ensureMetadata().then((e) => e?.exif?.exposureTime?.toAnyFile());

  @override
  Future<AnyFileMetadataRational?> get focalLength =>
      _ensureMetadata().then((e) => e?.exif?.focalLength?.toAnyFile());

  @override
  Future<int?> get isoSpeedRatings =>
      _ensureMetadata().then((e) => e?.exif?.isoSpeedRatings);

  @override
  Future<MapCoord?> get gpsCoord => _ensureMetadata().then((e) {
    final lat = e?.exif?.gpsLatitudeDeg;
    final lng = e?.exif?.gpsLongitudeDeg;
    if (lat != null && lng != null) {
      return MapCoord(lat, lng);
    } else {
      return null;
    }
  });

  @override
  Future<ImageLocation?> get location => Future.value(null);

  Future<Metadata?> _ensureMetadata() {
    if (_metadataTask == null) {
      _metadataTask = Completer();
      _loadMetadata().then(_metadataTask!.complete);
    }
    return _metadataTask!.future;
  }

  Future<Metadata?> _loadMetadata() async {
    if (file_util.isSupportedImageMime(file.mime ?? "")) {
      if (_provider.file is LocalUriFile) {
        final data = await ContentUri.readUri(
          (_provider.file as LocalUriFile).uri,
        );
        return LoadMetadata().loadAnyfile(file, data);
      }
    }
    return null;
  }

  final AnyFile file;

  final AnyFileLocalProvider _provider;
  Completer<Metadata?>? _metadataTask;
}

class AnyFileLocalTagGetter implements AnyFileTagGetter {
  const AnyFileLocalTagGetter();

  @override
  Future<List<AnyFileTag>?> get() => Future.value(null);
}

extension on Rational {
  AnyFileMetadataRational toAnyFile() {
    return AnyFileMetadataRational(numerator, denominator);
  }
}
