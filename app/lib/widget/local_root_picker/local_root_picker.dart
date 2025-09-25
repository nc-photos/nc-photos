import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/local_file/get_local_dir_list.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:path/path.dart' as path_lib;
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'local_root_picker.g.dart';
part 'state_event.dart';

class LocalRootPicker extends StatefulWidget {
  const LocalRootPicker({super.key, required this.switchTitle});

  @override
  State<StatefulWidget> createState() => LocalRootPickerState();

  final String switchTitle;
}

class LocalRootPickerState extends State<LocalRootPicker> {
  @override
  void initState() {
    super.initState();
    _bloc = _Bloc(KiwiContainer().resolve(), prefController: context.read())
      ..add(const _ListDir());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: _WrappedLocalRootPicker(switchTitle: widget.switchTitle),
    );
  }

  void save() {
    _bloc.add(const _Save());
  }

  late final _Bloc _bloc;
}

class _WrappedLocalRootPicker extends StatelessWidget {
  const _WrappedLocalRootPicker({required this.switchTitle});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.error,
          listener: (context, error) {
            if (error == null) {
              return;
            }
            if (error.error is PermissionException) {
              SnackBarManager().showSnackBar(
                SnackBar(
                  content: Text(L10n.global().errorNoStoragePermission),
                  duration: k.snackBarDurationNormal,
                ),
              );
            } else {
              SnackBarManager().showSnackBarForException(error.error);
            }
          },
        ),
      ],
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _EnableSwitch(title: switchTitle),
            ),
            Expanded(
              child: _BlocSelector(
                selector: (state) => state.isEnable,
                builder:
                    (context, isEnable) => IgnorePointer(
                      ignoring: !isEnable,
                      child: Opacity(
                        opacity: isEnable ? 1 : .4,
                        child: const _ContentList(),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final String switchTitle;
}

class _EnableSwitch extends StatelessWidget {
  const _EnableSwitch({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(48),
        clipBehavior: Clip.antiAlias,
        child: _BlocSelector(
          selector: (state) => state.isEnable,
          builder:
              (context, isEnable) => SwitchListTile(
                title: Text(title),
                value: isEnable,
                onChanged: (value) {
                  context.addEvent(_SetEnableLocalFile(value));
                },
              ),
        ),
      ),
    );
  }

  final String title;
}

class _ContentList extends StatelessWidget {
  const _ContentList();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.dirs,
      builder:
          (context, dirs) =>
              dirs == null
                  ? const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
                  )
                  : ListView.builder(
                    itemCount: dirs.length + 1,
                    itemBuilder: (context, index) {
                      final dir = index == 0 ? "DCIM" : dirs[index - 1];
                      return _BlocSelector(
                        selector: (state) => state.selectedDirs,
                        builder: (context, selectedDirs) {
                          final selectedMe = selectedDirs.contains(dir);
                          final selectedParent = selectedDirs.any(
                            (e) => file_util.isOrUnderDirPath(dir, e),
                          );
                          return CheckboxListTile(
                            title: Text(path_lib.basename(dir)),
                            subtitle: Text(dir),
                            value: selectedMe || selectedParent,
                            enabled: !(!selectedMe && selectedParent),
                            onChanged: (value) {
                              context.addEvent(
                                value == true
                                    ? _SelectDir(dir)
                                    : _UnselectDir(dir),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
