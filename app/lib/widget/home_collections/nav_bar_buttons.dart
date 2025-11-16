part of 'home_collections.dart';

class HomeCollectionsNavBarButton extends StatelessWidget {
  const HomeCollectionsNavBarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isMinimized,
    this.isShowIndicator = false,
    this.isEnabled = true,
    this.isUseTooltipWhenMinimized = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isMinimized) {
      return IconButtonTheme(
        data: const IconButtonThemeData(
          style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
        child: IconButton.outlined(
          icon: Stack(
            children: [
              IconTheme(
                data: IconThemeData(
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: icon,
              ),
              if (isShowIndicator)
                const Positioned(
                  right: 2,
                  top: 2,
                  child: _NavBarButtonIndicator(),
                ),
            ],
          ),
          tooltip: isUseTooltipWhenMinimized ? label : null,
          onPressed: isEnabled ? onPressed : null,
        ),
      );
    } else {
      return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: ActionChip(
          avatar: icon,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              if (isShowIndicator) ...const [
                SizedBox(width: 4),
                _NavBarButtonIndicator(),
              ],
            ],
          ),
          onPressed: isEnabled ? onPressed : null,
        ),
      );
    }
  }

  final Widget icon;
  final String label;
  final bool isMinimized;
  final bool isShowIndicator;
  final bool isEnabled;
  final bool isUseTooltipWhenMinimized;
  final VoidCallback? onPressed;
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.icon,
    required this.label,
    required this.isMinimized,
    this.isShowIndicator = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.selectedItems.isEmpty,
      builder:
          (context, isEnabled) => HomeCollectionsNavBarButton(
            icon: icon,
            label: label,
            isMinimized: isMinimized,
            isShowIndicator: isShowIndicator,
            isEnabled: isEnabled,
            onPressed: onPressed,
          ),
    );
  }

  final Widget icon;
  final String label;
  final bool isMinimized;
  final bool isShowIndicator;
  final VoidCallback? onPressed;
}

@npLog
class _NavBarNewButton extends StatelessWidget {
  const _NavBarNewButton();

  @override
  Widget build(BuildContext context) {
    return _NavBarButton(
      icon: const Icon(Icons.add_outlined),
      label: L10n.global().createCollectionTooltip,
      isMinimized: true,
      onPressed: () async {
        try {
          final collection = await showDialog<Collection>(
            context: context,
            builder: (_) => NewCollectionDialog(account: context.bloc.account),
          );
          if (collection == null) {
            return;
          }
          // Right now we don't have a way to add photos inside the
          // CollectionBrowser, eventually we should add that and remove this
          // branching
          if (collection.isDynamicCollection) {
            // open the newly created collection
            unawaited(
              Navigator.of(context).pushNamed(
                CollectionBrowser.routeName,
                arguments: CollectionBrowserArguments(collection),
              ),
            );
          }
        } catch (e, stacktrace) {
          _log.shout("[build] Uncaught exception", e, stacktrace);
          context.addEvent(
            _SetError(
              AppMessageException(
                L10n.global().createCollectionFailureNotification,
              ),
            ),
          );
        }
      },
    );
  }
}

class _NavBarSharingButton extends StatelessWidget {
  const _NavBarSharingButton({required this.isMinimized});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilderEx<bool>(
      stream:
          context
              .read<AccountController>()
              .accountPrefController
              .hasNewSharedAlbum,
      builder: StreamWidgetBuilder.value(
        (context, hasNewSharedAlbum) => _NavBarButton(
          icon: const Icon(Icons.share_outlined),
          label: L10n.global().collectionSharingLabel,
          isMinimized: isMinimized,
          isShowIndicator: hasNewSharedAlbum,
          onPressed: () {
            Navigator.of(context).pushNamed(
              SharingBrowser.routeName,
              arguments: SharingBrowserArguments(context.bloc.account),
            );
          },
        ),
      ),
    );
  }

  final bool isMinimized;
}

class _NavBarEditedButton extends StatelessWidget {
  const _NavBarEditedButton({required this.isMinimized});

  @override
  Widget build(BuildContext context) {
    return _NavBarButton(
      icon: const Icon(Icons.auto_fix_high_outlined),
      label: L10n.global().collectionEditedPhotosLabel,
      isMinimized: isMinimized,
      onPressed: () {
        Navigator.of(context).pushNamed(
          EnhancedPhotoBrowser.routeName,
          arguments: const EnhancedPhotoBrowserArguments(null),
        );
      },
    );
  }

  final bool isMinimized;
}

class _NavBarArchiveButton extends StatelessWidget {
  const _NavBarArchiveButton({required this.isMinimized});

  @override
  Widget build(BuildContext context) {
    return _NavBarButton(
      icon: const Icon(Icons.archive_outlined),
      label: L10n.global().albumArchiveLabel,
      isMinimized: isMinimized,
      onPressed: () {
        Navigator.of(context).pushNamed(ArchiveBrowser.routeName);
      },
    );
  }

  final bool isMinimized;
}

class _NavBarTrashButton extends StatelessWidget {
  const _NavBarTrashButton({required this.isMinimized});

  @override
  Widget build(BuildContext context) {
    return _NavBarButton(
      icon: const Icon(Icons.delete_outlined),
      label: L10n.global().albumTrashLabel,
      isMinimized: isMinimized,
      onPressed: () {
        Navigator.of(context).pushNamed(
          TrashbinBrowser.routeName,
          arguments: TrashbinBrowserArguments(context.bloc.account),
        );
      },
    );
  }

  final bool isMinimized;
}

class _NavBarMapButton extends StatelessWidget {
  const _NavBarMapButton({required this.isMinimized});

  @override
  Widget build(BuildContext context) {
    return _NavBarButton(
      icon: const Icon(Icons.map_outlined),
      label: L10n.global().homeTabMapBrowser,
      isMinimized: isMinimized,
      onPressed: () {
        Navigator.of(context).pushNamed(MapBrowser.routeName);
      },
    );
  }

  final bool isMinimized;
}
