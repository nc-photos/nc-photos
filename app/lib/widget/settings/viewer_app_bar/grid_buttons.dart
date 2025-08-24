part of '../viewer_app_bar_settings.dart';

class _GridButton extends StatelessWidget {
  const _GridButton({required this.tooltip, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: icon,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          tooltip,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  final String tooltip;
  final Widget icon;
}

class _GridLivePhotoButton extends StatelessWidget {
  const _GridLivePhotoButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().livePhotoTooltip,
      icon: const Icon(Icons.motion_photos_pause_outlined),
    );
  }
}

class _GridFavoriteButton extends StatelessWidget {
  const _GridFavoriteButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().favoriteTooltip,
      icon: const Icon(Icons.star_border),
    );
  }
}

class _GridShareButton extends StatelessWidget {
  const _GridShareButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().shareTooltip,
      icon: const Icon(Icons.share_outlined),
    );
  }
}

class _GridEditButton extends StatelessWidget {
  const _GridEditButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().editTooltip,
      icon: const Icon(Icons.tune_outlined),
    );
  }
}

class _GridEnhanceButton extends StatelessWidget {
  const _GridEnhanceButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().enhanceTooltip,
      icon: const Icon(Icons.auto_fix_high_outlined),
    );
  }
}

class _GridDownloadButton extends StatelessWidget {
  const _GridDownloadButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().downloadTooltip,
      icon: const Icon(Icons.download_outlined),
    );
  }
}

class _GridDeleteButton extends StatelessWidget {
  const _GridDeleteButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().deleteTooltip,
      icon: const Icon(Icons.delete_outlined),
    );
  }
}

class _GridArchiveButton extends StatelessWidget {
  const _GridArchiveButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().archiveTooltip,
      icon: const Icon(Icons.archive_outlined),
    );
  }
}

class _GridSlideshowButton extends StatelessWidget {
  const _GridSlideshowButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().slideshowTooltip,
      icon: const Icon(Icons.slideshow_outlined),
    );
  }
}

class _GridSetAsButton extends StatelessWidget {
  const _GridSetAsButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().setAsTooltip,
      icon: const Icon(Icons.launch),
    );
  }
}

class _GridUploadButton extends StatelessWidget {
  const _GridUploadButton();

  @override
  Widget build(BuildContext context) {
    return _GridButton(
      tooltip: L10n.global().uploadTooltip,
      icon: const Icon(Icons.cloud_upload_outlined),
    );
  }
}
