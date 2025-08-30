part of 'sync_metadata.dart';

/// Sync metadata using the client side logic
@npLog
class _SyncByApp {
  _SyncByApp({
    required this.account,
    required this.fileRepo,
    required this.fileRepo2,
    required this.db,
    this.interrupter,
    required this.wifiEnsurer,
    required this.batteryEnsurer,
  }) {
    interrupter?.listen((event) {
      _shouldRun = false;
    });
  }

  Future<void> init() async {
    await _geocoder.init();
  }

  Stream<File> syncFiles({required List<int> fileIds}) async* {
    for (final ids in partition(fileIds, 100)) {
      yield* _syncGroup(ids);
    }
  }

  Stream<File> _syncGroup(List<int> fileIds) async* {
    final files = await db.getFilesByFileIds(
      account: account.toDb(),
      fileIds: fileIds,
    );
    for (final dbF in files) {
      final f = DbFileConverter.fromDb(
        account.userId.toCaseInsensitiveString(),
        dbF,
      );
      final result = await syncOne(f);
      if (result != null) {
        yield result;
      }
      if (!_shouldRun) {
        return;
      }
    }
  }

  Future<File?> syncOne(File file) async {
    _log.fine("[syncOne] Syncing ${file.path}");
    try {
      OrNull<Metadata>? metadataUpdate;
      OrNull<ImageLocation>? locationUpdate;
      if (file.metadata == null) {
        // since we need to download multiple images in their original size,
        // we only do it with WiFi
        await wifiEnsurer();
        await batteryEnsurer();
        if (!_shouldRun) {
          return null;
        }
        _log.fine("[syncOne] Updating metadata for ${file.path}");
        final binary = await GetFileBinary(fileRepo)(account, file);
        final metadata = (await LoadMetadata().loadAnyfile(
          file.toAnyFile(),
          binary,
        )).copyWith(fileEtag: file.etag);
        metadataUpdate = OrNull(metadata);
      }

      final lat = (metadataUpdate?.obj ?? file.metadata)?.exif?.gpsLatitudeDeg;
      final lng = (metadataUpdate?.obj ?? file.metadata)?.exif?.gpsLongitudeDeg;
      try {
        ImageLocation? location;
        if (lat != null && lng != null) {
          _log.fine("[syncOne] Reverse geocoding for ${file.path}");
          final l = await _geocoder(lat, lng);
          if (l != null) {
            location = l.toImageLocation();
          }
        }
        locationUpdate = OrNull(location ?? ImageLocation.empty());
      } catch (e, stackTrace) {
        _log.severe(
          "[syncOne] Failed while reverse geocoding: ${file.path}",
          e,
          stackTrace,
        );
        // if failed, we skip updating the location
      }

      if (metadataUpdate != null || locationUpdate != null) {
        await UpdateProperty(fileRepo: fileRepo2)(
          account,
          file,
          metadata: metadataUpdate,
          location: locationUpdate,
        );
        return file;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      _log.severe(
        "[syncOne] Failed while updating metadata: ${file.path}",
        e,
        stackTrace,
      );
      return null;
    }
  }

  final Account account;
  final FileRepo fileRepo;
  final FileRepo2 fileRepo2;
  final NpDb db;
  final Stream<void>? interrupter;
  final WifiEnsurer wifiEnsurer;
  final BatteryEnsurer batteryEnsurer;

  final _geocoder = ReverseGeocoder();
  var _shouldRun = true;
}
