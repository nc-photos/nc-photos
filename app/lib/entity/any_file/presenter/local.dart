import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/factory.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/mobile/local_media_image.dart';
import 'package:nc_photos/widget/image_viewer.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:np_log/np_log.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

part 'local.g.dart';

@npLog
class AnyFileLocalVideoPlayerControllerPresenter
    implements AnyFileVideoPlayerControllerPresenter {
  AnyFileLocalVideoPlayerControllerPresenter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Future<VideoPlayerController> build({LivePhotoType? livePhotoType}) async {
    if (_provider.file is LocalUriFile) {
      return _buildVideoControllerWithContentUri(
        _provider.file as LocalUriFile,
        livePhotoType: livePhotoType,
      );
    } else {
      throw StateError("File type not supported");
    }
  }

  VideoPlayerController _buildVideoControllerWithContentUri(
    LocalUriFile file, {
    LivePhotoType? livePhotoType,
  }) {
    _log.fine("[_buildVideoControllerWithContentUri] URI: ${file.uri}");
    return VideoPlayerController.contentUri(
      Uri.parse(file.uri),
      livePhotoType: livePhotoType,
    );
  }

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalLargeImagePresenter implements AnyFileLargeImagePresenter {
  AnyFileLocalLargeImagePresenter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Widget buildWidget({
    BoxFit? fit,
    Widget Function(BuildContext context, Widget child)? imageBuilder,
    Widget Function(BuildContext context)? errorBuilder,
  }) {
    final provider = LocalMediaImage(_provider.file.platformIdentifier);
    return Image(
      image: provider,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return imageBuilder?.call(context, child) ?? child;
      },
      errorBuilder:
          errorBuilder == null
              ? null
              : (context, error, stackTrace) {
                return errorBuilder.call(context);
              },
    );
  }

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalImageViewerPresenter implements AnyFileImageViewerPresenter {
  AnyFileLocalImageViewerPresenter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Widget buildWidget({
    required bool canZoom,
    VoidCallback? onLoaded,
    ValueChanged<double>? onHeightChanged,
    VoidCallback? onZoomStarted,
    VoidCallback? onZoomEnded,
  }) {
    return LocalImageViewer(
      file: _provider.file,
      canZoom: canZoom,
      onLoaded: onLoaded,
      onHeightChanged: onHeightChanged,
      onZoomStarted: onZoomStarted,
      onZoomEnded: onZoomEnded,
    );
  }

  @override
  void preloadImage() {}

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalPhotoListImagePresenter
    implements AnyFilePhotoListImagePresenter {
  AnyFileLocalPhotoListImagePresenter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Widget buildWidget({
    bool? shouldShowFavorite,
    bool? shouldUseHero,
    bool? isUploading,
  }) {
    return PhotoListLocalImage(
      file: _provider.file,
      backupStatus:
          isUploading == true
              ? PhotoListLocalFileBackupStatus.uploading
              : PhotoListLocalFileBackupStatus.none,
    );
  }

  final AnyFileLocalProvider _provider;
}

class AnyFileLocalPhotoListVideoPresenter
    implements AnyFilePhotoListVideoPresenter {
  AnyFileLocalPhotoListVideoPresenter(AnyFile file)
    : _provider = file.provider as AnyFileLocalProvider;

  @override
  Widget buildWidget({bool? shouldShowFavorite, bool? isUploading}) {
    return PhotoListLocalVideo(
      file: _provider.file,
      backupStatus:
          isUploading == true
              ? PhotoListLocalFileBackupStatus.uploading
              : PhotoListLocalFileBackupStatus.none,
    );
  }

  final AnyFileLocalProvider _provider;
}
