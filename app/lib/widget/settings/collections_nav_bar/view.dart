part of '../collections_nav_bar_settings.dart';

class _DemoView extends StatefulWidget {
  const _DemoView();

  @override
  State<StatefulWidget> createState() => _DemoViewState();
}

class _DemoViewState extends State<_DemoView> {
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.buttons,
      builder: (context, buttons) {
        final navBar = SizedBox(
          height: 48,
          child: Row(
            children: [
              Expanded(
                child: FadeOutListContainer(
                  scrollController: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16 - 6),
                    itemCount: buttons.length,
                    itemBuilder: (context, i) {
                      final btn = buttons[i];
                      return my.Draggable<HomeCollectionsNavBarButtonType>(
                        data: btn.type,
                        feedback: _CandidateButtonDelegate(btn.type),
                        onDropBefore: (data) {
                          context.addEvent(
                            _MoveButton.before(which: data, target: btn.type),
                          );
                        },
                        onDropAfter: (data) {
                          context.addEvent(
                            _MoveButton.after(which: data, target: btn.type),
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: _DemoButtonDelegate(
                              btn.type,
                              isMinimized: btn.isMinimized,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const _NewButton(),
              const SizedBox(width: 16),
            ],
          ),
        );
        if (buttons.isEmpty) {
          return DragTarget<HomeCollectionsNavBarButtonType>(
            builder:
                (context, candidateData, rejectedData) => SizedBox(
                  height: 48,
                  child: Stack(
                    children: [
                      navBar,
                      IgnorePointer(
                        child: Opacity(
                          opacity: candidateData.isNotEmpty ? .35 : 0,
                          child: Container(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            onAcceptWithDetails: (details) {
              context.addEvent(_MoveButton.first(which: details.data));
            },
          );
        } else {
          return navBar;
        }
      },
    );
  }

  final _scrollController = ScrollController();
}

class _DemoButtonDelegate extends StatelessWidget {
  const _DemoButtonDelegate(this.type, {required this.isMinimized});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HomeCollectionsNavBarButtonType.sharing:
        return _SharingButton(
          isMinimized: isMinimized,
          onPressed: () {
            context.addEvent(_ToggleMinimized(type));
          },
        );
      case HomeCollectionsNavBarButtonType.edited:
        return _EditedButton(
          isMinimized: isMinimized,
          onPressed: () {
            context.addEvent(_ToggleMinimized(type));
          },
        );
      case HomeCollectionsNavBarButtonType.archive:
        return _ArchiveButton(
          isMinimized: isMinimized,
          onPressed: () {
            context.addEvent(_ToggleMinimized(type));
          },
        );
      case HomeCollectionsNavBarButtonType.trash:
        return _TrashButton(
          isMinimized: isMinimized,
          onPressed: () {
            context.addEvent(_ToggleMinimized(type));
          },
        );
      case HomeCollectionsNavBarButtonType.map:
        return _MapButton(
          isMinimized: isMinimized,
          onPressed: () {
            context.addEvent(_ToggleMinimized(type));
          },
        );
    }
  }

  final HomeCollectionsNavBarButtonType type;
  final bool isMinimized;
}

class _CandidateGrid extends StatelessWidget {
  const _CandidateGrid();

  @override
  Widget build(BuildContext context) {
    return DragTarget<HomeCollectionsNavBarButtonType>(
      builder:
          (context, candidateData, rejectedData) => Stack(
            children: [
              _BlocSelector(
                selector: (state) => state.buttons,
                builder:
                    (context, buttons) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 16,
                        runSpacing: 8,
                        children:
                            HomeCollectionsNavBarButtonType.values
                                .where((e) => !buttons.any((b) => b.type == e))
                                .map(
                                  (e) => my.Draggable<
                                    HomeCollectionsNavBarButtonType
                                  >(
                                    data: e,
                                    feedback: _CandidateButtonDelegate(e),
                                    child: _CandidateButtonDelegate(e),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
              ),
              IgnorePointer(
                child: Opacity(
                  opacity: candidateData.isNotEmpty ? .1 : 0,
                  child: Container(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
      onAcceptWithDetails: (details) {
        context.addEvent(_RemoveButton(details.data));
      },
      onWillAcceptWithDetails: (details) {
        // moving down
        return context.state.buttons.any((e) => e.type == details.data);
      },
    );
  }
}

class _CandidateButtonDelegate extends StatelessWidget {
  const _CandidateButtonDelegate(this.type);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HomeCollectionsNavBarButtonType.sharing:
        return const _SharingButton(isMinimized: false);
      case HomeCollectionsNavBarButtonType.edited:
        return const _EditedButton(isMinimized: false);
      case HomeCollectionsNavBarButtonType.archive:
        return const _ArchiveButton(isMinimized: false);
      case HomeCollectionsNavBarButtonType.trash:
        return const _TrashButton(isMinimized: false);
      case HomeCollectionsNavBarButtonType.map:
        return const _MapButton(isMinimized: false);
    }
  }

  final HomeCollectionsNavBarButtonType type;
}
