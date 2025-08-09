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
              previous.selectedItems != current.selectedItems,
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
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: L10n.global().addItemToCollectionTooltip,
                onPressed: () => _onAddPressed(context),
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
    final bloc = context.read<_Bloc>();
    final selected =
        bloc.state.selectedItems
            .whereType<_FileItem>()
            .map((e) => e.file)
            .toList();
    if (selected.isEmpty) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().shareSelectedEmptyNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      return;
    }
    final result = await showDialog(
      context: context,
      builder:
          (context) => FileSharerDialog(account: bloc.account, files: selected),
    );
    if (result ?? false) {
      bloc.add(const _SetSelectedItems(items: {}));
    }
  }
}

@npLog
class _SelectionAppBarMenu extends StatelessWidget {
  const _SelectionAppBarMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SelectionMenuOption>(
      tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: _SelectionMenuOption.download,
              child: Text(L10n.global().downloadTooltip),
            ),
            PopupMenuItem(
              value: _SelectionMenuOption.archive,
              child: Text(L10n.global().archiveTooltip),
            ),
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
    );
  }
}
