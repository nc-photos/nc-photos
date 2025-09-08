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
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'local_root_picker.g.dart';
part 'state_event.dart';

class LocalRootPicker extends StatelessWidget {
  const LocalRootPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              _Bloc(KiwiContainer().resolve(), prefController: context.read())
                ..add(const _ListDir()),
      child: const _WrappedLocalRootPicker(),
    );
  }
}

class _WrappedLocalRootPicker extends StatelessWidget {
  const _WrappedLocalRootPicker();

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
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          context.addEvent(const _Save());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(L10n.global().settingsDeviceMediaTitle),
            actions: [
              _BlocSelector(
                selector: (state) => state.isEnable,
                builder:
                    (context, isEnable) => Switch(
                      value: isEnable,
                      onChanged: (value) {
                        context.addEvent(_SetEnableLocalFile(value));
                      },
                    ),
              ),
            ],
          ),
          body: _BlocSelector(
            selector: (state) => state.isEnable,
            builder:
                (context, isEnable) => IgnorePointer(
                  ignoring: !isEnable,
                  child: Opacity(
                    opacity: isEnable ? 1 : .4,
                    child: _BlocSelector(
                      selector: (state) => state.dirs,
                      builder:
                          (context, dirs) =>
                              dirs == null
                                  ? const LinearProgressIndicator()
                                  : ListView.builder(
                                    itemCount: dirs.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return CheckboxListTile(
                                          title: const Text("DCIM"),
                                          value: true,
                                          enabled: false,
                                          onChanged: (_) {},
                                        );
                                      } else {
                                        final dir = dirs[index - 1];
                                        return _BlocSelector(
                                          selector:
                                              (state) => state.selectedDirs,
                                          builder: (context, selectedDirs) {
                                            final selectedMe = selectedDirs
                                                .contains(dir);
                                            final selectedParent = selectedDirs
                                                .any(
                                                  (e) => file_util
                                                      .isOrUnderDirPath(dir, e),
                                                );
                                            return CheckboxListTile(
                                              title: Text(dir),
                                              value:
                                                  selectedMe || selectedParent,
                                              enabled:
                                                  !(!selectedMe &&
                                                      selectedParent),
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
                                      }
                                    },
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
