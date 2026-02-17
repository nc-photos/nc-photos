part of 'collection_browser.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final c = KiwiContainer().resolve<DiContainer>();
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.items != current.items ||
              previous.collection != current.collection,
      builder: (context, state) {
        final adapter = CollectionAdapter.of(
          c,
          context.bloc.account,
          state.collection,
        );
        final canRename = adapter.isPermitted(CollectionCapability.rename);
        final canManualCover = adapter.isPermitted(
          CollectionCapability.manualCover,
        );
        final canShare = adapter.isPermitted(CollectionCapability.share);
        return SafeArea(
          child: Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children:
                  [
                    BackButton(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                    const Spacer(),
                    if (canShare)
                      IconButton(
                        onPressed: () => _onSharePressed(context),
                        icon: const Icon(Icons.share_outlined),
                        tooltip: L10n.global().shareTooltip,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                        ),
                      ),
                    if (state.collection.isPendingSharedAlbum)
                      IconButton(
                        onPressed:
                            () => _onAddToCollectionsViewPressed(context),
                        icon: const AssetIcon(asset.icAddCollectionsOutlined24),
                        tooltip: L10n.global().addToCollectionsViewTooltip,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                        ),
                      ),
                    if (state.items.isNotEmpty || canRename)
                      PopupMenuButton<_MenuOption>(
                        tooltip:
                            MaterialLocalizations.of(context).moreButtonTooltip,
                        itemBuilder:
                            (_) => [
                              if (canRename)
                                PopupMenuItem(
                                  value: _MenuOption.edit,
                                  child: Text(L10n.global().editTooltip),
                                ),
                              if (canManualCover && adapter.isManualCover())
                                PopupMenuItem(
                                  value: _MenuOption.unsetCover,
                                  child: Text(
                                    L10n.global().unsetAlbumCoverTooltip,
                                  ),
                                ),
                              if (state.items.isNotEmpty) ...[
                                PopupMenuItem(
                                  value: _MenuOption.download,
                                  child: Text(L10n.global().downloadTooltip),
                                ),
                                PopupMenuItem(
                                  value: _MenuOption.export,
                                  child: Text(
                                    L10n.global().exportCollectionTooltip,
                                  ),
                                ),
                              ],
                              if (state.collection.contentProvider
                                      is CollectionAlbumProvider &&
                                  CollectionAdapter.of(
                                    c,
                                    context.bloc.account,
                                    state.collection,
                                  ).isPermitted(CollectionCapability.share))
                                PopupMenuItem(
                                  value: _MenuOption.albumFixShare,
                                  child: Text(L10n.global().fixSharesTooltip),
                                ),
                            ],
                        onSelected: (option) {
                          _onMenuSelected(context, option);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                        ),
                      ),
                  ].separated((_) => const SizedBox(width: 4)).toList(),
            ),
          ),
        );
      },
    );
  }

  void _onMenuSelected(BuildContext context, _MenuOption option) {
    switch (option) {
      case _MenuOption.edit:
        context.read<_Bloc>().add(const _BeginEdit());
        break;
      case _MenuOption.unsetCover:
        context.read<_Bloc>().add(const _UnsetCover());
        break;
      case _MenuOption.download:
        context.read<_Bloc>().add(const _Download());
        break;
      case _MenuOption.export:
        _onExportSelected(context);
        break;
      case _MenuOption.albumFixShare:
        _onAlbumFixShareSelected(context);
        break;
    }
  }

  Future<void> _onExportSelected(BuildContext context) async {
    final bloc = context.read<_Bloc>();
    final result = await showDialog<Collection>(
      context: context,
      builder:
          (_) => ExportCollectionDialog(
            account: bloc.account,
            collection: bloc.state.collection,
            items: bloc.state.items,
          ),
    );
    if (result != null) {
      Navigator.of(context).pop();
    }
  }

  void _onAlbumFixShareSelected(BuildContext context) {
    final bloc = context.read<_Bloc>();
    final collection = bloc.state.collection;
    final album = (collection.contentProvider as CollectionAlbumProvider).album;
    Navigator.of(context).pushNamed(
      AlbumShareOutlierBrowser.routeName,
      arguments: AlbumShareOutlierBrowserArguments(bloc.account, album),
    );
  }

  Future<void> _onSharePressed(BuildContext context) async {
    final bloc = context.read<_Bloc>();
    await showDialog(
      context: context,
      builder:
          (_) => ShareCollectionDialog(
            account: bloc.account,
            collection: bloc.state.collection,
          ),
    );
  }

  Future<void> _onAddToCollectionsViewPressed(BuildContext context) async {
    context.read<_Bloc>().add(const _ImportPendingSharedCollection());
  }
}

class _CoverView extends StatelessWidget {
  const _CoverView();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.cover != current.cover ||
              previous.collection != current.collection,
      builder: (context, state) {
        if (state.cover?.url != null) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height / 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: flutter_util.HeroTag.fromCollection(state.collection),
                  child: FittedBox(
                    clipBehavior: Clip.hardEdge,
                    fit: BoxFit.cover,
                    child:
                        CachedNetworkImageBuilder(
                          type: CachedNetworkImageType.cover,
                          imageUrl: state.cover!.url,
                          mime: state.cover!.mime,
                          account: context.bloc.account,
                          errorWidget: (context, url, error) {
                            // just leave it empty
                            return Container();
                          },
                        ).build(),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black45],
                      begin: Alignment(0, -.5),
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    state.collection.name,
                    style: Theme.of(context).textStyleColored(
                      (textTheme) => textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: -2,
                        height: .92,
                      ),
                      (colorScheme) => colorScheme.onDarkSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
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
              previous.selectedItems != current.selectedItems,
      builder:
          (context, state) => BoxSelectionAppBar(
            count: state.selectedItems.length,
            onClosePressed: () {
              context.read<_Bloc>().add(const _SetSelectedItems(items: {}));
            },
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: L10n.global().shareTooltip,
                onPressed: () {
                  _onSelectionSharePressed(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_outlined),
                tooltip: L10n.global().addItemToCollectionTooltip,
                onPressed: () {
                  _onSelectionAddPressed(context);
                },
              ),
              PopupMenuButton<_SelectionMenuOption>(
                tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                itemBuilder:
                    (context) => [
                      if (context.read<_Bloc>().isCollectionCapabilityPermitted(
                            CollectionCapability.manualItem,
                          ) &&
                          state.isSelectionRemovable)
                        PopupMenuItem(
                          value: _SelectionMenuOption.removeFromAlbum,
                          child: Text(L10n.global().removeFromAlbumTooltip),
                        ),
                      PopupMenuItem(
                        value: _SelectionMenuOption.download,
                        child: Text(L10n.global().downloadTooltip),
                      ),
                      if (state.isSelectionManageableFile) ...[
                        PopupMenuItem(
                          value: _SelectionMenuOption.archive,
                          child: Text(L10n.global().archiveTooltip),
                        ),
                        if (context
                                .read<_Bloc>()
                                .isCollectionCapabilityPermitted(
                                  CollectionCapability.deleteItem,
                                ) &&
                            state.isSelectionDeletable)
                          PopupMenuItem(
                            value: _SelectionMenuOption.delete,
                            child: Text(L10n.global().deleteTooltip),
                          ),
                      ],
                    ],
                onSelected: (option) {
                  _onSelectionMenuSelected(context, option);
                },
              ),
            ],
          ),
    );
  }

  void _onSelectionMenuSelected(
    BuildContext context,
    _SelectionMenuOption option,
  ) {
    switch (option) {
      case _SelectionMenuOption.download:
        context.read<_Bloc>().add(const _DownloadSelectedItems());
        break;
      case _SelectionMenuOption.removeFromAlbum:
        context.read<_Bloc>().add(const _RemoveSelectedItemsFromCollection());
        break;
      case _SelectionMenuOption.archive:
        context.read<_Bloc>().add(const _ArchiveSelectedItems());
        break;
      case _SelectionMenuOption.delete:
        context.read<_Bloc>().add(const _DeleteSelectedItems());
        break;
    }
  }

  Future<void> _onSelectionSharePressed(BuildContext context) async {
    context.addEvent(const _ShareSelectedItems());
  }

  Future<void> _onSelectionAddPressed(BuildContext context) async {
    final collection = await Navigator.of(
      context,
    ).pushNamed<Collection>(CollectionPicker.routeName);
    if (collection == null) {
      return;
    }
    context.read<_Bloc>().add(_AddSelectedItemsToCollection(collection));
  }
}

class _EditPickerAppBar extends StatelessWidget {
  const _EditPickerAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: () {
          context.addEvent(const _CancelEditPickerMode());
        },
      ),
      title: Text(L10n.global().collectionAddItemTitle),
    );
  }
}

class _EditAppBar extends StatelessWidget {
  const _EditAppBar();

  @override
  Widget build(BuildContext context) {
    final capabilitiesAdapter = CollectionAdapter.of(
      KiwiContainer().resolve<DiContainer>(),
      context.read<_Bloc>().account,
      context.read<_Bloc>().state.collection,
    );
    return AppBar(
      title: TextFormField(
        initialValue: context.read<_Bloc>().state.currentEditName,
        decoration: InputDecoration(hintText: L10n.global().nameInputHint),
        validator: (_) {
          // use text in state here because the value might be wrong if user
          // scrolled the app bar off screen
          if (context.read<_Bloc>().state.currentEditName.isNotEmpty) {
            return null;
          } else {
            return L10n.global().nameInputInvalidEmpty;
          }
        },
        onChanged: (value) {
          context.read<_Bloc>().add(_EditName(value));
        },
        style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor),
      ),
      leading: IconButton(
        icon: const Icon(Icons.check_outlined),
        color: Theme.of(context).colorScheme.primary,
        tooltip: L10n.global().doneButtonTooltip,
        onPressed: () {
          context.read<_Bloc>().add(const _DoneEdit());
        },
      ),
      actions: [
        if (capabilitiesAdapter.isPermitted(CollectionCapability.labelItem))
          IconButton(
            icon: const Icon(Icons.text_fields_outlined),
            tooltip: L10n.global().albumAddTextTooltip,
            onPressed: () {
              context.addEvent(const _RequestAddLabel());
            },
          ),
        if (capabilitiesAdapter.isPermitted(CollectionCapability.mapItem))
          _BlocSelector(
            selector: (state) => state.isAddMapBusy,
            builder:
                (context, isAddMapBusy) =>
                    isAddMapBusy
                        ? const IconButton(
                          icon: AppBarProgressIndicator(),
                          onPressed: null,
                        )
                        : IconButton(
                          icon: const Icon(Icons.map_outlined),
                          tooltip: L10n.global().albumAddMapTooltip,
                          onPressed: () {
                            context.addEvent(const _RequestAddMap());
                          },
                        ),
          ),
        if (capabilitiesAdapter.isPermitted(CollectionCapability.sort))
          IconButton(
            icon: const Icon(Icons.sort_by_alpha_outlined),
            tooltip: L10n.global().sortTooltip,
            onPressed: () => _onSortPressed(context),
          ),
      ],
    );
  }

  Future<void> _onSortPressed(BuildContext context) async {
    final current = context.read<_Bloc>().state.run(
      (s) => s.editSort ?? s.collection.itemSort,
    );
    final result = await showDialog<CollectionItemSort>(
      context: context,
      builder:
          (context) => FancyOptionPicker(
            title: Text(L10n.global().sortOptionDialogTitle),
            items:
                [
                      _SortDialogParams(
                        L10n.global().sortOptionTimeDescendingLabel,
                        CollectionItemSort.dateDescending,
                      ),
                      _SortDialogParams(
                        L10n.global().sortOptionTimeAscendingLabel,
                        CollectionItemSort.dateAscending,
                      ),
                      _SortDialogParams(
                        L10n.global().sortOptionFilenameAscendingLabel,
                        CollectionItemSort.nameAscending,
                      ),
                      _SortDialogParams(
                        L10n.global().sortOptionFilenameDescendingLabel,
                        CollectionItemSort.nameDescending,
                      ),
                      if (current == CollectionItemSort.manual)
                        _SortDialogParams(
                          L10n.global().sortOptionManualLabel,
                          CollectionItemSort.manual,
                        ),
                    ]
                    .map(
                      (e) => FancyOptionPickerItem(
                        label: e.label,
                        isSelected: current == e.value,
                        onSelect: () {
                          Navigator.of(context).pop(e.value);
                        },
                      ),
                    )
                    .toList(),
          ),
    );
    if (result == null) {
      return;
    }
    context.read<_Bloc>().add(_EditSort(result));
  }
}

enum _MenuOption { edit, unsetCover, download, export, albumFixShare }

enum _SelectionMenuOption { download, removeFromAlbum, archive, delete }

class _SortDialogParams {
  const _SortDialogParams(this.label, this.value);

  final String label;
  final CollectionItemSort value;
}
