import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/local.dart';
import 'package:nc_photos/entity/any_file/presenter/nextcloud.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

/// Perform various ui logics with a file
abstract interface class AnyFilePresenterFactory {
  static AnyFileVideoPlayerControllerPresenter videoPlayerController(
    AnyFile file, {
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudVideoPlayerControllerPresenter(
          file,
          account: account,
        );
      case AnyFileLocalProvider _:
        return AnyFileLocalVideoPlayerControllerPresenter(file);
    }
  }

  static AnyFileLargeImagePresenter largeImage(
    AnyFile file, {
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudLargeImagePresenter(file, account: account);
      case AnyFileLocalProvider _:
        return AnyFileLocalLargeImagePresenter(file);
    }
  }

  static AnyFileImageViewerPresenter imageViewer(
    AnyFile file, {
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudImageViewerPresenter(file, account: account);
      case AnyFileLocalProvider _:
        return AnyFileLocalImageViewerPresenter(file);
    }
  }

  static AnyFilePhotoListImagePresenter photoListImage(
    AnyFile file, {
    required Account account,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudPhotoListImagePresenter(file, account: account);
      case AnyFileLocalProvider _:
        return AnyFileLocalPhotoListImagePresenter(file);
    }
  }
}

abstract interface class AnyFileVideoPlayerControllerPresenter {
  Future<VideoPlayerController> build({LivePhotoType? livePhotoType});
}

abstract interface class AnyFileLargeImagePresenter {
  Widget buildWidget({
    BoxFit? fit,
    Widget Function(BuildContext context, Widget child)? imageBuilder,
  });
}

abstract interface class AnyFileImageViewerPresenter {
  Widget buildWidget({
    required bool canZoom,
    VoidCallback? onLoaded,
    ValueChanged<double>? onHeightChanged,
    VoidCallback? onZoomStarted,
    VoidCallback? onZoomEnded,
  });

  void preloadImage();
}

abstract interface class AnyFilePhotoListImagePresenter {
  Widget buildWidget();
}
