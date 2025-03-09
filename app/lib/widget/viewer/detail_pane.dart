part of 'viewer.dart';

class _DetailPaneContainer extends StatelessWidget {
  const _DetailPaneContainer({
    required this.fileId,
  });

  final int fileId;

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.isShowDetailPane != current.isShowDetailPane ||
          previous.isZoomed != current.isZoomed ||
          previous.fileStates[fileId] != current.fileStates[fileId],
      builder: (context, state) => IgnorePointer(
        ignoring: !state.isShowDetailPane,
        child: Visibility(
          visible: !state.isZoomed,
          child: AnimatedOpacity(
            opacity: state.isShowDetailPane ? 1 : 0,
            duration: k.animationDurationNormal,
            onEnd: () {
              if (!state.isShowDetailPane) {
                context.addEvent(const _SetDetailPaneInactive());
              }
            },
            child: Theme(
              data: buildTheme(context, context.bloc.brightness),
              child: Builder(
                builder: (context) => Container(
                  alignment: Alignment.topLeft,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                  margin: EdgeInsets.only(
                    top: _calcDetailPaneOffset(
                      state.fileStates[fileId],
                      MediaQuery.of(context).size.height,
                    ),
                  ),
                  // this visibility widget avoids loading the detail pane
                  // until it's actually opened, otherwise swiping between
                  // photos will slow down severely
                  child: Visibility(
                    visible: state.isShowDetailPane,
                    child: _DetailPane(fileId: fileId),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailPane extends StatelessWidget {
  const _DetailPane({
    required this.fileId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.mergedFileIdFileMap[fileId] !=
              current.mergedFileIdFileMap[fileId] ||
          previous.collection != current.collection ||
          previous.collectionItems?[fileId] != current.collectionItems?[fileId],
      builder: (context, state) {
        final file = state.mergedFileIdFileMap[fileId];
        final collection = state.collection;
        final collectionItem = state.collectionItems?[fileId];
        return file == null
            ? const SizedBox.shrink()
            : ViewerDetailPane(
                account: context.bloc.account,
                fd: file,
                fromCollection: collection != null && collectionItem != null
                    ? ViewerSingleCollectionData(collection, collectionItem)
                    : null,
                onRemoveFromCollectionPressed: (_) {
                  context.addEvent(_RemoveFromCollection(collectionItem!));
                },
                onArchivePressed: (_) {
                  context.addEvent(_Archive(fileId));
                },
                onUnarchivePressed: (_) {
                  context.addEvent(_Unarchive(fileId));
                },
                onSlideshowPressed: () {
                  context.addEvent(_StartSlideshow(fileId));
                },
                onDeletePressed: (_) {
                  context.addEvent(_Delete(fileId));
                },
              );
      },
    );
  }

  final int fileId;
}
