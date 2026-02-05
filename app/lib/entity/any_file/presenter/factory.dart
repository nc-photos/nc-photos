import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/local.dart';
import 'package:nc_photos/entity/any_file/presenter/merged.dart';
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
      case AnyFileMergedProvider _:
        return AnyFileMergedVideoPlayerControllerPresenter(file);
    }
  }

  static AnyFileLargeImagePresenter largeImage(
    AnyFile file, {
    required Account account,
    required PrefController? prefController,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        if (prefController?.isViewerUseOriginalImageValue ?? false) {
          return AnyFileNextcloudOriginalImagePresenter(file, account: account);
        } else {
          return AnyFileNextcloudLargeImagePresenter(file, account: account);
        }
      case AnyFileLocalProvider _:
        return AnyFileLocalLargeImagePresenter(file);
      case AnyFileMergedProvider _:
        return AnyFileMergedLargeImagePresenter(file);
    }
  }

  static AnyFileImageViewerPresenter imageViewer(
    AnyFile file, {
    required Account account,
    required PrefController? prefController,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudImageViewerPresenter(
          file,
          prefController: prefController,
          account: account,
        );
      case AnyFileLocalProvider _:
        return AnyFileLocalImageViewerPresenter(file);
      case AnyFileMergedProvider _:
        return AnyFileMergedImageViewerPresenter(file);
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
      case AnyFileMergedProvider _:
        return AnyFileMergedPhotoListImagePresenter(file);
    }
  }

  static AnyFilePhotoListVideoPresenter photoListVideo(
    AnyFile file, {
    required Account account,
    VoidCallback? onError,
  }) {
    switch (file.provider) {
      case AnyFileNextcloudProvider _:
        return AnyFileNextcloudPhotoListVideoPresenter(
          file,
          account: account,
          onError: onError,
        );
      case AnyFileLocalProvider _:
        return AnyFileLocalPhotoListVideoPresenter(file);
      case AnyFileMergedProvider _:
        return AnyFileMergedPhotoListVideoPresenter(file);
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
    Widget Function(BuildContext context)? errorBuilder,
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
  Widget buildWidget({
    bool? shouldShowFavorite,
    bool? shouldUseHero,
    bool? isUploading,
  });
}

abstract interface class AnyFilePhotoListVideoPresenter {
  Widget buildWidget({bool? shouldShowFavorite, bool? isUploading});
}
