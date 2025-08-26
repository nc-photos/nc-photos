part of '../home_photos2.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<bool>(
      selector: (state) => state.isLoading || state.syncProgress != null,
      builder:
          (context, isProcessing) => HomeSliverAppBar(
            account: context.bloc.account,
            isShowProgressIcon: isProcessing,
          ),
    );
  }
}

@npLog
class _SelectionAppBar extends StatelessWidget {
  const _SelectionAppBar();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.selectedItems != current.selectedItems ||
              previous.selectedCanAddToCollection !=
                  current.selectedCanAddToCollection,
      builder:
          (context, state) => SelectionAppBar(
            count: state.selectedItems.length,
            onClosePressed: () {
              context.addEvent(const _SetSelectedItems(items: {}));
            },
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: L10n.global().shareTooltip,
                onPressed: () => _onSharePressed(context),
              ),
              if (state.selectedCanAddToCollection)
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: L10n.global().addItemToCollectionTooltip,
                  onPressed: () => _onAddPressed(context),
                ),
              if (state.selectedCanUpload)
                IconButton(
                  icon: const Icon(Icons.cloud_upload_outlined),
                  tooltip: L10n.global().uploadTooltip,
                  onPressed: () => _onUploadPressed(context),
                ),
              const _SelectionAppBarMenu(),
            ],
          ),
    );
  }

  Future<void> _onAddPressed(BuildContext context) async {
    final collection = await Navigator.of(
      context,
    ).pushNamed<Collection>(CollectionPicker.routeName);
    if (collection == null) {
      return;
    }
    context.bloc.add(_AddSelectedItemsToCollection(collection));
  }

  Future<void> _onSharePressed(BuildContext context) async {
    context.addEvent(const _ShareSelectedItems());
  }

  void _onUploadPressed(BuildContext context) {
    context.addEvent(const _UploadSelectedItems());
  }
}

@npLog
class _SelectionAppBarMenu extends StatelessWidget {
  const _SelectionAppBarMenu();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.selectedCanArchive != current.selectedCanArchive ||
              previous.selectedCanDownload != current.selectedCanDownload ||
              previous.selectedCanDelete != current.selectedCanDelete,
      builder:
          (context, state) =>
              state.selectedCanDownload ||
                      state.selectedCanArchive ||
                      state.selectedCanDelete
                  ? PopupMenuButton<_SelectionMenuOption>(
                    tooltip:
                        MaterialLocalizations.of(context).moreButtonTooltip,
                    itemBuilder:
                        (context) => [
                          if (state.selectedCanDownload)
                            PopupMenuItem(
                              value: _SelectionMenuOption.download,
                              child: Text(L10n.global().downloadTooltip),
                            ),
                          if (state.selectedCanArchive)
                            PopupMenuItem(
                              value: _SelectionMenuOption.archive,
                              child: Text(L10n.global().archiveTooltip),
                            ),
                          if (state.selectedCanDelete)
                            PopupMenuItem(
                              value: _SelectionMenuOption.delete,
                              child: Text(L10n.global().deleteTooltip),
                            ),
                        ],
                    onSelected: (option) {
                      switch (option) {
                        case _SelectionMenuOption.archive:
                          context.addEvent(const _ArchiveSelectedItems());
                          break;
                        case _SelectionMenuOption.delete:
                          context.addEvent(const _DeleteSelectedItems());
                          break;
                        case _SelectionMenuOption.download:
                          context.addEvent(const _DownloadSelectedItems());
                          break;
                      }
                    },
                  )
                  : const SizedBox.shrink(),
    );
  }
}
