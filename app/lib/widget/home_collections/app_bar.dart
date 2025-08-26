part of '../home_collections.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder:
          (context, state) => HomeSliverAppBar(
            account: context.bloc.account,
            isShowProgressIcon: state.isLoading,
            menuActions: [
              PopupMenuItem(
                value: _menuValueSort,
                child: Text(L10n.global().sortTooltip),
              ),
              PopupMenuItem(
                value: _menuValueImport,
                child: Text(L10n.global().importFoldersTooltip),
              ),
            ],
            onSelectedMenuActions: (option) {
              switch (option) {
                case _menuValueSort:
                  _onSortPressed(context);
                  break;

                case _menuValueImport:
                  _onImportPressed(context);
                  break;
              }
            },
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: _NavigationBar(),
            ),
          ),
    );
  }

  Future<void> _onSortPressed(BuildContext context) async {
    final sort = context.state.sort;
    final result = await showDialog<collection_util.CollectionSort>(
      context: context,
      builder:
          (context) => FancyOptionPicker(
            title: Text(L10n.global().sortOptionDialogTitle),
            items: [
              FancyOptionPickerItem(
                label: L10n.global().sortOptionTimeDescendingLabel,
                isSelected:
                    sort == collection_util.CollectionSort.dateDescending,
                onSelect: () {
                  Navigator.of(
                    context,
                  ).pop(collection_util.CollectionSort.dateDescending);
                },
              ),
              FancyOptionPickerItem(
                label: L10n.global().sortOptionTimeAscendingLabel,
                isSelected:
                    sort == collection_util.CollectionSort.dateAscending,
                onSelect: () {
                  Navigator.of(
                    context,
                  ).pop(collection_util.CollectionSort.dateAscending);
                },
              ),
              FancyOptionPickerItem(
                label: L10n.global().sortOptionAlbumNameLabel,
                isSelected:
                    sort == collection_util.CollectionSort.nameAscending,
                onSelect: () {
                  Navigator.of(
                    context,
                  ).pop(collection_util.CollectionSort.nameAscending);
                },
              ),
              FancyOptionPickerItem(
                label: L10n.global().sortOptionAlbumNameDescendingLabel,
                isSelected:
                    sort == collection_util.CollectionSort.nameDescending,
                onSelect: () {
                  Navigator.of(
                    context,
                  ).pop(collection_util.CollectionSort.nameDescending);
                },
              ),
            ],
          ),
    );
    if (result == null) {
      return;
    }
    context.addEvent(_SetCollectionSort(result));
  }

  void _onImportPressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      AlbumImporter.routeName,
      arguments: AlbumImporterArguments(context.bloc.account),
    );
  }

  static const _menuValueImport = 0;
  static const _menuValueSort = 1;
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
                icon: const Icon(Icons.delete_outlined),
                tooltip: L10n.global().deleteTooltip,
                onPressed: () {
                  context.addEvent(const _RemoveSelectedItems());
                },
              ),
            ],
          ),
    );
  }
}
