part of '../archive_browser.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(L10n.global().albumArchiveLabel),
      floating: true,
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
                icon: const Icon(Icons.unarchive_outlined),
                tooltip: L10n.global().unarchiveTooltip,
                onPressed: () {
                  context.addEvent(const _UnarchiveSelectedItems());
                },
              ),
            ],
          ),
    );
  }
}
