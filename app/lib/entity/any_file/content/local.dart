import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:np_common/size.dart';
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
  AnyFileLocalMetadataGetter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<bool?> get isOwned => Future.value(true);

  @override
  Future<String?> get owner => Future.value(null);

  @override
  Future<SizeInt?> get size => Future.value(_provider.file.size);

  @override
  Future<int?> get byteSize => Future.value(null);

  @override
  Future<String?> get make => Future.value(null);

  @override
  Future<String?> get model => Future.value(null);

  @override
  Future<AnyFileMetadataRational?> get fNumber => Future.value(null);

  @override
  Future<AnyFileMetadataRational?> get exposureTime => Future.value(null);

  @override
  Future<AnyFileMetadataRational?> get focalLength => Future.value(null);

  @override
  Future<int?> get isoSpeedRatings => Future.value(null);

  @override
  Future<MapCoord?> get gpsCoord => Future.value(null);

  @override
  Future<ImageLocation?> get location => Future.value(null);

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalTagGetter implements AnyFileTagGetter {
  const AnyFileLocalTagGetter();

  @override
  Future<List<AnyFileTag>?> get() => Future.value(null);
}
