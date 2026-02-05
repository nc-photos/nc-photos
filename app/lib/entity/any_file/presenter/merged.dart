import 'package:flutter/material.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/factory.dart';
import 'package:nc_photos/entity/any_file/presenter/local.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

class AnyFileMergedVideoPlayerControllerPresenter
    implements AnyFileVideoPlayerControllerPresenter {
  AnyFileMergedVideoPlayerControllerPresenter(AnyFile file)
    : _delegate = AnyFileLocalVideoPlayerControllerPresenter(
        (file.provider as AnyFileMergedProvider).asLocalFile(),
      );

  @override
  Future<VideoPlayerController> build({LivePhotoType? livePhotoType}) =>
      _delegate.build(livePhotoType: livePhotoType);

  final AnyFileVideoPlayerControllerPresenter _delegate;
}

class AnyFileMergedLargeImagePresenter implements AnyFileLargeImagePresenter {
  AnyFileMergedLargeImagePresenter(AnyFile file)
    : _delegate = AnyFileLocalLargeImagePresenter(
        (file.provider as AnyFileMergedProvider).asLocalFile(),
      );

  @override
  Widget buildWidget({
    BoxFit? fit,
    Widget Function(BuildContext context, Widget child)? imageBuilder,
    Widget Function(BuildContext context)? errorBuilder,
  }) => _delegate.buildWidget(
    fit: fit,
    imageBuilder: imageBuilder,
    errorBuilder: errorBuilder,
  );

  final AnyFileLargeImagePresenter _delegate;
}

class AnyFileMergedImageViewerPresenter implements AnyFileImageViewerPresenter {
  AnyFileMergedImageViewerPresenter(AnyFile file)
    : _delegate = AnyFileLocalImageViewerPresenter(
        (file.provider as AnyFileMergedProvider).asLocalFile(),
      );

  @override
  Widget buildWidget({
    required bool canZoom,
    VoidCallback? onLoaded,
    ValueChanged<double>? onHeightChanged,
    VoidCallback? onZoomStarted,
    VoidCallback? onZoomEnded,
  }) => _delegate.buildWidget(
    canZoom: canZoom,
    onLoaded: onLoaded,
    onHeightChanged: onHeightChanged,
    onZoomStarted: onZoomStarted,
    onZoomEnded: onZoomEnded,
  );

  @override
  void preloadImage() => _delegate.preloadImage();

  final AnyFileImageViewerPresenter _delegate;
}

class AnyFileMergedPhotoListImagePresenter
    implements AnyFilePhotoListImagePresenter {
  AnyFileMergedPhotoListImagePresenter(AnyFile file)
    : _provider = file.provider as AnyFileMergedProvider;

  @override
  Widget buildWidget({bool? shouldShowFavorite, bool? shouldUseHero}) {
    return PhotoListLocalImage(
      file: _provider.local.file,
      backupStatus: PhotoListLocalFileBackupStatus.backedUp,
    );
  }

  final AnyFileMergedProvider _provider;
}

class AnyFileMergedPhotoListVideoPresenter
    implements AnyFilePhotoListVideoPresenter {
  AnyFileMergedPhotoListVideoPresenter(AnyFile file)
    : _provider = file.provider as AnyFileMergedProvider;

  @override
  Widget buildWidget({bool? shouldShowFavorite}) {
    return PhotoListLocalVideo(
      file: _provider.local.file,
      backupStatus: PhotoListLocalFileBackupStatus.backedUp,
    );
  }

  final AnyFileMergedProvider _provider;
}
