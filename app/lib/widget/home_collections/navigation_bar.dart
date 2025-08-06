part of '../home_collections.dart';

enum HomeCollectionsNavBarButtonType {
  // the order must not be changed
  sharing,
  edited,
  archive,
  trash,
  map;

  static HomeCollectionsNavBarButtonType fromValue(int value) =>
      HomeCollectionsNavBarButtonType.values[value];
}

class _NavigationBar extends StatefulWidget {
  const _NavigationBar();

  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<_NavigationBar> {
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: FadeOutListContainer(
              scrollController: _scrollController,
              child: _BlocSelector(
                selector: (state) => state.navBarButtons,
                builder: (context, navBarButtons) {
                  final buttons =
                      navBarButtons
                          .map((e) => _buildButton(context, e))
                          .nonNulls
                          .toList();
                  return ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: buttons.length,
                    itemBuilder: (context, i) => Center(child: buttons[i]),
                    separatorBuilder: (context, _) => const SizedBox(width: 12),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          const _NavBarNewButton(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget? _buildButton(BuildContext context, PrefHomeCollectionsNavButton btn) {
    switch (btn.type) {
      case HomeCollectionsNavBarButtonType.sharing:
        return _NavBarSharingButton(isMinimized: btn.isMinimized);
      case HomeCollectionsNavBarButtonType.edited:
        return features.isSupportEnhancement
            ? _NavBarEditedButton(isMinimized: btn.isMinimized)
            : null;
      case HomeCollectionsNavBarButtonType.archive:
        return _NavBarArchiveButton(isMinimized: btn.isMinimized);
      case HomeCollectionsNavBarButtonType.trash:
        return _NavBarTrashButton(isMinimized: btn.isMinimized);
      case HomeCollectionsNavBarButtonType.map:
        return _NavBarMapButton(isMinimized: btn.isMinimized);
    }
  }

  final _scrollController = ScrollController();
}

class _NavBarButtonIndicator extends StatelessWidget {
  const _NavBarButtonIndicator();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 4,
        height: 4,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
