part of 'dir_picker.dart';

class _DirList extends StatelessWidget {
  const _DirList();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.currentDir != current.currentDir ||
          previous.items != current.items ||
          previous.picks != current.picks,
      builder: (context, state) {
        final bloc = context.bloc;
        final isTopLevel = state.currentDir.path == bloc.rootDir;
        return AnimatedSwitcher(
          duration: k.animationDurationNormal,
          // see AnimatedSwitcher.defaultLayoutBuilder
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          ),
          // needed to prevent background color overflowing the parent bound,
          // see: https://github.com/flutter/flutter/issues/86584
          child: Material(
            type: MaterialType.transparency,
            child: ListView.separated(
              key: Key(state.currentDir.path),
              itemBuilder: (context, index) {
                if (!isTopLevel && index == 0) {
                  return ListTile(
                    dense: true,
                    leading: const SizedBox(width: 24),
                    title: Text(L10n.global().rootPickerNavigateUpItemText),
                    onTap: () {
                      context.addEvent(
                        _Navigate(
                          File(path: path_lib.dirname(state.currentDir.path)),
                        ),
                      );
                    },
                  );
                } else {
                  final item = state.items[index - (isTopLevel ? 0 : 1)];
                  if (bloc.isMultipleSelections) {
                    return _MultiSelectDirItem(
                      item: item,
                      canPick:
                          !item.isE2ee &&
                          bloc.validator?.call(item.file) != false,
                      pickState: _getPickState(
                        item.file,
                        state.picks,
                        bloc.isMultipleSelections,
                      ),
                    );
                  } else {
                    return _SingleSelectDirItem(
                      item: item,
                      canPick:
                          !item.isE2ee &&
                          bloc.validator?.call(item.file) != false,
                    );
                  }
                }
              },
              separatorBuilder: (context, index) => const Divider(height: 2),
              itemCount: state.items.length + (isTopLevel ? 0 : 1),
            ),
          ),
        );
      },
    );
  }

  static _PickState _getPickState(
    File dir,
    List<File> picks,
    bool isMultipleSelections,
  ) {
    var product = _PickState.notPicked;
    for (final p in picks) {
      if (isMultipleSelections) {
        // exact match, or parent is picked
        if (file_util.isOrUnderDir(dir, p)) {
          return _PickState.picked;
        }
        if (file_util.isUnderDir(p, dir)) {
          product = _PickState.childPicked;
        }
      } else {
        if (dir.fdPath == p.fdPath) {
          return _PickState.picked;
        }
      }
    }
    return product;
  }
}

class _SingleSelectDirItem extends StatelessWidget {
  const _SingleSelectDirItem({required this.item, required this.canPick});

  @override
  Widget build(BuildContext context) {
    IconData? iconData;
    Color? iconColor;
    if (!canPick) {
      if (item.isE2ee) {
        iconData = Icons.lock_outlined;
        iconColor = M3.of(context).checkbox.disabled.container;
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      dense: true,
      leading: canPick
          ? IconButton(
              icon: Icon(
                Icons.folder_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: null,
            )
          : IconButton(icon: Icon(iconData, color: iconColor), onPressed: null),
      title: Text(item.file.filename),
      textColor: item.isE2ee
          ? M3.of(context).checkbox.disabled.container
          : null,
      onTap: item.isE2ee
          ? null
          : () {
              context.addEvent(_Navigate(item.file));
            },
    );
  }

  final _DpItem item;
  final bool canPick;
}

class _MultiSelectDirItem extends StatelessWidget {
  const _MultiSelectDirItem({
    required this.item,
    required this.canPick,
    required this.pickState,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData;
    Color? iconColor;
    if (canPick) {
      switch (pickState) {
        case _PickState.picked:
          iconData = Icons.check_box;
          iconColor = CheckboxTheme.of(
            context,
          ).fillColor!.resolve({WidgetState.selected});
          break;

        case _PickState.childPicked:
          iconData = Icons.indeterminate_check_box;
          iconColor = CheckboxTheme.of(
            context,
          ).fillColor!.resolve({WidgetState.selected});
          break;

        case _PickState.notPicked:
          iconData = Icons.check_box_outline_blank;
          iconColor = Theme.of(context).colorScheme.onSurface;
          break;
      }
    } else if (item.isE2ee) {
      iconData = Icons.lock_outlined;
      iconColor = M3.of(context).checkbox.disabled.container;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      dense: true,
      leading: canPick
          ? IconButton(
              icon: AnimatedSwitcher(
                duration: k.animationDurationShort,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  iconData,
                  key: ValueKey(pickState),
                  color: iconColor,
                ),
              ),
              onPressed: () {
                if (pickState == _PickState.picked) {
                  context.addEvent(_Unpick(item.file));
                } else {
                  context.addEvent(_Pick(item.file));
                }
              },
            )
          : IconButton(icon: Icon(iconData, color: iconColor), onPressed: null),
      title: Text(item.file.filename),
      textColor: item.isE2ee
          ? M3.of(context).checkbox.disabled.container
          : null,
      onTap: item.isE2ee
          ? null
          : () {
              context.addEvent(_Navigate(item.file));
            },
    );
  }

  final _DpItem item;
  final bool canPick;
  final _PickState pickState;
}
