import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/ls_dir.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:path/path.dart' as path_lib;

part 'dir_picker.g.dart';

class DirPicker extends StatefulWidget {
  const DirPicker({
    super.key,
    required this.account,
    required this.strippedRootDir,
    this.initialPicks,
    this.isMultipleSelections = true,
    this.validator,
    this.onConfirmed,
  });

  @override
  createState() => DirPickerState();

  final Account account;
  final String strippedRootDir;
  final bool isMultipleSelections;
  final List<File>? initialPicks;

  /// Return whether [dir] is a valid target to be picked
  final bool Function(File dir)? validator;
  final ValueChanged<List<File>>? onConfirmed;
}

@npLog
class DirPickerState extends State<DirPicker> {
  @override
  initState() {
    super.initState();
    _root = LsDirBlocItem(File(path: _rootDir), false, []);
    _initBloc();
    if (widget.initialPicks != null) {
      _picks.addAll(widget.initialPicks!);
    }
  }

  @override
  build(BuildContext context) {
    return BlocListener<LsDirBloc, LsDirBlocState>(
      bloc: _bloc,
      listener: (context, state) => _onStateChange(context, state),
      child: BlocBuilder<LsDirBloc, LsDirBlocState>(
        bloc: _bloc,
        builder: (context, state) => _buildContent(context, state),
      ),
    );
  }

  /// Calls the onConfirmed method with the current picked dirs
  void confirm() {
    widget.onConfirmed?.call(_picks);
  }

  void _initBloc() {
    _log.info("[_initBloc] Initialize bloc");
    _navigateInto(File(path: _rootDir));
  }

  Widget _buildContent(BuildContext context, LsDirBlocState state) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: state is LsDirBlocLoading
              ? Container()
              : _buildList(context, state),
        ),
        if (state is LsDirBlocLoading)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildList(BuildContext context, LsDirBlocState state) {
    final isTopLevel = _currentPath == _rootDir;
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
      // needed to prevent background color overflowing the parent bound, see:
      // https://github.com/flutter/flutter/issues/86584
      child: Material(
        type: MaterialType.transparency,
        child: ListView.separated(
          key: Key(_currentPath),
          itemBuilder: (context, index) {
            if (!isTopLevel && index == 0) {
              return ListTile(
                dense: true,
                leading: const SizedBox(width: 24),
                title: Text(L10n.global().rootPickerNavigateUpItemText),
                onTap: () {
                  try {
                    _navigateInto(File(path: path_lib.dirname(_currentPath)));
                  } catch (e) {
                    SnackBarManager().showSnackBarForException(e);
                  }
                },
              );
            } else {
              return _buildItem(
                  context, state.items[index - (isTopLevel ? 0 : 1)]);
            }
          },
          separatorBuilder: (context, index) => const Divider(height: 2),
          itemCount: state.items.length + (isTopLevel ? 0 : 1),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, LsDirBlocItem item) {
    final canPick = !item.isE2ee && widget.validator?.call(item.file) != false;
    final pickState = _isItemPicked(item);

    IconData? iconData;
    Color? iconColor;
    if (canPick) {
      switch (pickState) {
        case _PickState.picked:
          iconData = widget.isMultipleSelections
              ? Icons.check_box
              : Icons.radio_button_checked;
          iconColor = CheckboxTheme.of(context)
              .fillColor!
              .resolve({WidgetState.selected});
          break;

        case _PickState.childPicked:
          iconData = widget.isMultipleSelections
              ? Icons.indeterminate_check_box
              : Icons.remove_circle_outline;
          iconColor = CheckboxTheme.of(context)
              .fillColor!
              .resolve({WidgetState.selected});
          break;

        case _PickState.notPicked:
          iconData = widget.isMultipleSelections
              ? Icons.check_box_outline_blank
              : Icons.radio_button_unchecked;
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
                  _unpick(item);
                } else {
                  _pick(item);
                }
              },
            )
          : IconButton(
              icon: Icon(iconData, color: iconColor),
              onPressed: null,
            ),
      title: Text(item.file.filename),
      trailing: item.children?.isNotEmpty == true
          ? const Icon(Icons.arrow_forward_ios)
          : null,
      textColor:
          item.isE2ee ? M3.of(context).checkbox.disabled.container : null,
      onTap: item.children?.isNotEmpty == true
          ? () {
              try {
                _navigateInto(item.file);
              } catch (e) {
                SnackBarManager().showSnackBarForException(e);
              }
            }
          : null,
    );
  }

  void _onStateChange(BuildContext context, LsDirBlocState state) {
    if (state is LsDirBlocSuccess) {
      if (!_fillResult(_root, state)) {
        _log.shout("[_onStateChange] Failed while _fillResult" +
            (isDevMode
                ? ", root:\n${_root.toString(isDeep: true)}\nstate: ${state.root.path}"
                : ""));
      }
    } else if (state is LsDirBlocFailure) {
      SnackBarManager().showSnackBarForException(state.exception);
    }
  }

  /// Fill query results from bloc to our item tree
  bool _fillResult(LsDirBlocItem root, LsDirBlocSuccess state) {
    if (root.file.path == state.root.path) {
      if (root.children?.isNotEmpty != true) {
        root.children = state.items;
      }
      return true;
    } else if (state.root.path.startsWith(root.file.path)) {
      for (final child in root.children ?? <LsDirBlocItem>[]) {
        if (_fillResult(child, state)) {
          return true;
        }
      }
      return false;
    } else {
      // not us, not child of us
      return false;
    }
  }

  /// Pick an item
  void _pick(LsDirBlocItem item) {
    setState(() {
      if (!widget.isMultipleSelections) {
        _picks.clear();
      }
      _picks.add(item.file);
      _picks = _optimizePicks(_root);
    });
    _log.fine("[_pick] Picked: ${_pickListToString(_picks)}");
  }

  /// Optimize the picked array
  ///
  /// 1) If a parent directory is picked, all children will be ignored
  List<File> _optimizePicks(LsDirBlocItem item) {
    if (_picks.any((element) => element.path == item.file.path)) {
      // this dir is explicitly picked, nothing more to do
      return [item.file];
    }
    if (item.children == null || item.children!.isEmpty) {
      return [];
    }

    final products = <File>[];
    for (final i in item.children!) {
      products.addAll(_optimizePicks(i));
    }
    // // see if all children are being picked
    // if (item != _root &&
    //     products.length >= item.children.length &&
    //     item.children.every((element) => products.contains(element))) {
    //   // all children are being picked, add [item] to list and remove its
    //   // children
    //   _log.fine(
    //       "[_optimizePicks] All children under '${item.file.path}' are being picked, optimized");
    //   return products
    //       .where((element) => !item.children.contains(element))
    //       .toList()
    //         ..add(item);
    // }
    return products;
  }

  /// Unpick an item
  void _unpick(LsDirBlocItem item) {
    setState(() {
      if (_picks.any((element) => element.path == item.file.path)) {
        // ourself is being picked, simple
        _picks =
            _picks.where((element) => element.path != item.file.path).toList();
      } else {
        // Look for the closest picked dir
        final parents = _picks
            .where((element) => item.file.path.startsWith(element.path))
            .toList()
          ..sort((a, b) => b.path.length.compareTo(a.path.length));
        final parent = parents.first;
        try {
          _picks.addAll(_pickedAllExclude(path: parent.path, exclude: item)
              .map((e) => e.file));
          _picks.removeWhere((element) => identical(element, parent));
        } catch (_) {
          SnackBarManager().showSnackBar(SnackBar(
            content: Text(L10n.global().rootPickerUnpickFailureNotification),
            duration: k.snackBarDurationNormal,
          ));
        }
      }
    });
    _log.fine("[_unpick] Picked: ${_pickListToString(_picks)}");
  }

  /// Return a list where all children of [path] or [item], except [exclude],
  /// are picked
  ///
  /// Either [path] or [item] must be set, If both are set, [item] takes
  /// priority
  List<LsDirBlocItem> _pickedAllExclude({
    String? path,
    LsDirBlocItem? item,
    required LsDirBlocItem exclude,
  }) {
    assert(path != null || item != null);
    if (item == null) {
      final item = _findChildItemByPath(_root, path!);
      return _pickedAllExclude(item: item, exclude: exclude);
    }

    if (item.file.path == exclude.file.path) {
      return [];
    }
    _log.fine(
        "[_pickedAllExclude] Unpicking '${item.file.path}' and picking children");
    final products = <LsDirBlocItem>[];
    for (final i in item.children ?? <LsDirBlocItem>[]) {
      if (file_util.isOrUnderDir(exclude.file, i.file)) {
        // [i] is a parent of exclude
        products.addAll(_pickedAllExclude(item: i, exclude: exclude));
      } else {
        products.add(i);
      }
    }
    return products;
  }

  /// Return the child/grandchild/... item of [parent] with [path]
  LsDirBlocItem _findChildItemByPath(LsDirBlocItem parent, String path) {
    if (path == parent.file.path) {
      return parent;
    }
    for (final c in parent.children ?? <LsDirBlocItem>[]) {
      if (path == c.file.path || path.startsWith("${c.file.path}/")) {
        return _findChildItemByPath(c, path);
      }
    }
    // ???
    _log.shout(
        "[_findChildItemByPath] Failed finding child item for '$path' under '${parent.file.path}'");
    throw ArgumentError("Path not found");
  }

  _PickState _isItemPicked(LsDirBlocItem item) {
    var product = _PickState.notPicked;
    for (final p in _picks) {
      // exact match, or parent is picked
      if (file_util.isOrUnderDir(item.file, p)) {
        product = _PickState.picked;
        // no need to check the remaining ones
        break;
      }
      if (file_util.isUnderDir(p, item.file)) {
        product = _PickState.childPicked;
      }
    }
    if (product == _PickState.childPicked) {}
    return product;
  }

  /// Return the string representation of a list of LsDirBlocItem
  static String _pickListToString(List<File> items) =>
      "['${items.map((e) => e.path).join('\', \'')}']";

  void _navigateInto(File file) {
    _currentPath = file.path;
    _bloc.add(LsDirBlocQuery(widget.account, file, depth: 2));
  }

  late final String _rootDir =
      file_util.unstripPath(widget.account, widget.strippedRootDir);

  late final _bloc = LsDirBloc(
    KiwiContainer().resolve<DiContainer>().fileRepoRemote,
    isListMinimal: true,
  );
  late LsDirBlocItem _root;

  var _currentPath = "";
  var _picks = <File>[];
}

enum _PickState {
  notPicked,
  picked,
  childPicked,
}
