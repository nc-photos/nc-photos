part of '../viewer_app_bar_settings.dart';

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.tooltip, required this.icon});

  @override
  Widget build(BuildContext context) {
    return icon;
  }

  final String tooltip;
  final Widget icon;
}

class _DemoMoreButton extends StatelessWidget {
  const _DemoMoreButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SnackBarManager().showSnackBar(
          SnackBar(
            content: Text(L10n.global().customizeButtonsUnsupportedWarning),
            duration: k.snackBarDurationNormal,
          ),
        );
      },
      onLongPress: () {
        SnackBarManager().showSnackBar(
          SnackBar(
            content: Text(L10n.global().customizeButtonsUnsupportedWarning),
            duration: k.snackBarDurationNormal,
          ),
        );
      },
      child: AbsorbPointer(
        absorbing: true,
        child: IconButton(onPressed: () {}, icon: Icon(Icons.adaptive.more)),
      ),
    );
  }
}

class _DemoLivePhotoButton extends StatelessWidget {
  const _DemoLivePhotoButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().livePhotoTooltip,
      icon: const Icon(Icons.motion_photos_pause_outlined),
    );
  }
}

class _DemoFavoriteButton extends StatelessWidget {
  const _DemoFavoriteButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().favoriteTooltip,
      icon: const Icon(Icons.star_border),
    );
  }
}

class _DemoShareButton extends StatelessWidget {
  const _DemoShareButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().shareTooltip,
      icon: const Icon(Icons.share_outlined),
    );
  }
}

class _DemoEditButton extends StatelessWidget {
  const _DemoEditButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().editTooltip,
      icon: const Icon(Icons.tune_outlined),
    );
  }
}

class _DemoEnhanceButton extends StatelessWidget {
  const _DemoEnhanceButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().enhanceTooltip,
      icon: const Icon(Icons.auto_fix_high_outlined),
    );
  }
}

class _DemoDownloadButton extends StatelessWidget {
  const _DemoDownloadButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().downloadTooltip,
      icon: const Icon(Icons.download_outlined),
    );
  }
}

class _DemoDeleteButton extends StatelessWidget {
  const _DemoDeleteButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().deleteTooltip,
      icon: const Icon(Icons.delete_outlined),
    );
  }
}

class _DemoArchiveButton extends StatelessWidget {
  const _DemoArchiveButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().archiveTooltip,
      icon: const Icon(Icons.archive_outlined),
    );
  }
}

class _DemoSlideshowButton extends StatelessWidget {
  const _DemoSlideshowButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().slideshowTooltip,
      icon: const Icon(Icons.slideshow_outlined),
    );
  }
}

class _DemoSetAsButton extends StatelessWidget {
  const _DemoSetAsButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().setAsTooltip,
      icon: const Icon(Icons.launch),
    );
  }
}

class _DemoUploadButton extends StatelessWidget {
  const _DemoUploadButton();

  @override
  Widget build(BuildContext context) {
    return _DemoButton(
      tooltip: L10n.global().uploadTooltip,
      icon: const Icon(Icons.cloud_upload_outlined),
    );
  }
}
