import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:path/path.dart' as path_lib;
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'dir_picker.g.dart';
part 'state_event.dart';
part 'view.dart';

class DirPicker extends StatelessWidget {
  const DirPicker({
    super.key,
    required this.account,
    required this.strippedRootDir,
    this.initialPicks,
    this.isMultipleSelections = true,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _DpBloc(
        fileRepo: KiwiContainer().resolve<DiContainer>().fileRepoRemote,
        account: account,
        rootDir: file_util.unstripPath(account, strippedRootDir),
        isMultipleSelections: isMultipleSelections,
        validator: validator,
        initialPicks: initialPicks,
      ),
      child: _WrappedDirPicker(onChanged: onChanged),
    );
  }

  final Account account;
  final String strippedRootDir;
  final bool isMultipleSelections;
  final List<File>? initialPicks;

  /// Return whether a dir is a valid target to be picked
  final bool Function(File dir)? validator;
  final ValueChanged<List<File>>? onChanged;
}

class _WrappedDirPicker extends StatelessWidget {
  const _WrappedDirPicker({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.picks,
          listener: (context, picks) {
            onChanged?.call(picks);
          },
        ),
        _BlocListenerT(
          selector: (state) => state.message,
          listener: (context, message) {
            if (message != null) {
              SnackBarManager().showSnackBar(
                SnackBar(
                  content: Text(message.value),
                  duration: k.snackBarDurationNormal,
                ),
              );
            }
          },
        ),
        _BlocListenerT(
          selector: (state) => state.error,
          listener: (context, error) {
            if (error != null) {
              SnackBarManager().showSnackBarForException(error.error);
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _BlocSelector(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) =>
                  isLoading ? const SizedBox.shrink() : const _DirList(),
            ),
          ),
          _BlocSelector(
            selector: (state) => state.isLoading,
            builder: (context, isLoading) => isLoading
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  final ValueChanged<List<File>>? onChanged;
}

enum _PickState { notPicked, picked, childPicked }

typedef _BlocBuilder = BlocBuilder<_DpBloc, _State>;
// typedef _BlocListener = BlocListener<_DpBloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_DpBloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_DpBloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _DpBloc get bloc => read<_DpBloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
