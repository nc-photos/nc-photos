import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// ignore: implementation_imports
import 'package:flutter_cache_manager/src/cache_store.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/jxl_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/np_api_util.dart';
import 'package:np_common/size.dart';
import 'package:np_http/np_http.dart';
import 'package:np_log/np_log.dart';

part 'cache_manager_util.g.dart';

class CancelableGetFile {
  CancelableGetFile(this.store);

  Future<FileInfo> getFileUntil(
    String key, {
    bool ignoreMemCache = false,
  }) async {
    FileInfo? product;
    while (product == null && _shouldRun) {
      product = await store.getFile(key, ignoreMemCache: ignoreMemCache);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    if (product == null) {
      return Future.error("Interrupted");
    } else {
      return product;
    }
  }

  void cancel() {
    _shouldRun = false;
  }

  bool get isGood => _shouldRun;

  final CacheStore store;

  bool _shouldRun = true;
}

/// Cache manager for thumbnails
///
/// Thumbnails are pretty small in file size and also critical to the scrolling
/// performance, thus a large number of them will be kept
class ThumbnailCacheManager {
  static const key = "thumbnailCache";
  static CacheManager inst = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 50000,
      fileService: HttpFileService(httpClient: getHttpClient()),
    ),
  );
}

/// Cache manager for large images
///
/// Large images are only loaded when explicitly opening the photos, they are
/// very large in size. Since large images are only viewed one by one (unlike
/// thumbnails), they are less critical to the overall app responsiveness
class LargeImageCacheManager {
  // used in file_paths.xml, must not change
  static const key = "largeImageCache";
  static CacheManager inst = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 1000,
      fileService: HttpFileService(httpClient: getHttpClient()),
    ),
  );
}

/// Cache manager for covers
///
/// Covers are larger than thumbnails but smaller than full sized photos. They
/// are used to represent a collection
class CoverCacheManager {
  static const key = "coverCache";
  static CacheManager inst = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 300,
      fileService: HttpFileService(httpClient: getHttpClient()),
    ),
  );
}

/// Cache manager for original files to support extra image formats
///
/// Currently used for jxl files
class ExtraFormatCacheManager {
  static const key = "extraFormatCache";
  static CacheManager inst = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 8000,
      fileService: HttpFileService(httpClient: getHttpClient()),
    ),
  );
}

enum CachedNetworkImageType { thumbnail, largeImage, cover }

@npLog
class CachedNetworkImageBuilder {
  const CachedNetworkImageBuilder({
    required this.type,
    required this.imageUrl,
    this.mime,
    required this.account,
    this.fit,
    this.imageBuilder,
    this.errorWidget,
  });

  Widget build() {
    // _log.finer("[build] $mime, $imageUrl");
    return CachedNetworkImage(
      fit: fit,
      cacheManager: getCacheManager(type, mime),
      imageUrl: imageUrl,
      httpHeaders: {
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
      fadeInDuration: const Duration(),
      filterQuality: FilterQuality.high,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      imageBuilder: imageBuilder,
      errorWidget: errorWidget,
      customDecoder:
          mime == "image/jxl"
              ? (file, decoder) {
                _log.fine("[build] Using experimental jxl codec: $imageUrl");
                // return decoder(raw);
                return jxlImageCodecFromFile(file, resize: _boundingBox);
              }
              : null,
      compareKey: type.name,
    );
  }

  SizeInt get _boundingBox => switch (type) {
    CachedNetworkImageType.thumbnail => SizeInt.square(k.photoThumbSize),
    CachedNetworkImageType.largeImage => SizeInt.square(k.photoLargeSize),
    CachedNetworkImageType.cover => SizeInt.square(k.coverSize),
  };

  final CachedNetworkImageType type;
  final String imageUrl;
  final String? mime;
  final Account account;
  final BoxFit? fit;
  final ImageWidgetBuilder? imageBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
}

CacheManager getCacheManager(CachedNetworkImageType type, String? mime) {
  if (mime == "image/jxl") {
    return ExtraFormatCacheManager.inst;
  } else {
    return switch (type) {
      CachedNetworkImageType.thumbnail => ThumbnailCacheManager.inst,
      CachedNetworkImageType.largeImage => LargeImageCacheManager.inst,
      CachedNetworkImageType.cover => CoverCacheManager.inst,
    };
  }
}

Future<FileInfo?> getFileFromCache(
  CachedNetworkImageType type,
  String imageUrl,
  String? mime,
) async {
  final cacheManager = getCacheManager(CachedNetworkImageType.largeImage, mime);
  return await cacheManager.getFileFromCache(imageUrl);
}
