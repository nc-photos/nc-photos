part of 'viewer.dart';

class _DetailPaneContainer extends StatelessWidget {
  const _DetailPaneContainer({required this.afId});

  final String afId;

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.isShowDetailPane != current.isShowDetailPane ||
              previous.isZoomed != current.isZoomed ||
              previous.fileStates[afId] != current.fileStates[afId],
      builder:
          (context, state) => IgnorePointer(
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
                    builder:
                        (context) => Container(
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
                              state.fileStates[afId],
                              MediaQuery.of(context).size.height,
                            ),
                          ),
                          // this visibility widget avoids loading the detail pane
                          // until it's actually opened, otherwise swiping between
                          // photos will slow down severely
                          child: Visibility(
                            visible: state.isShowDetailPane,
                            child: _DetailPane(afId: afId),
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
  const _DetailPane({required this.afId});

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.mergedAfIdFileMap[afId] !=
                  current.mergedAfIdFileMap[afId] ||
              previous.collection != current.collection ||
              previous.collectionItems?[afId] != current.collectionItems?[afId],
      builder: (context, state) {
        final file = state.mergedAfIdFileMap[afId];
        final collection = state.collection;
        final collectionItem = state.collectionItems?[afId];
        return file == null
            ? const SizedBox.shrink()
            : ViewerDetailPane2(
              file: file,
              fromCollection:
                  collection != null && collectionItem != null
                      ? ViewerSingleCollectionData(collection, collectionItem)
                      : null,
              onRemoveFromCollectionPressed: (_) {
                context.addEvent(_RemoveFromCollection(collectionItem!));
              },
              onArchivePressed: (_) {
                context.addEvent(_Archive(afId));
              },
              onUnarchivePressed: (_) {
                context.addEvent(_Unarchive(afId));
              },
              onSlideshowPressed: () {
                context.addEvent(_StartSlideshow(afId));
              },
              onDeletePressed: (_) {
                context.addEvent(_Delete(afId));
              },
            );
      },
    );
  }

  final String afId;
}
