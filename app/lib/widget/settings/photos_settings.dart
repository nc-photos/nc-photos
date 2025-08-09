import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'photos/bloc.dart';
part 'photos/state_event.dart';
part 'photos_settings.g.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;

class PhotosSettings extends StatelessWidget {
  const PhotosSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => _Bloc(
            prefController: context.read(),
            accountPrefController:
                context.read<AccountController>().accountPrefController,
          ),
      child: const _WrappedPhotosSettings(),
    );
  }
}

class _WrappedPhotosSettings extends StatefulWidget {
  const _WrappedPhotosSettings();

  @override
  State<StatefulWidget> createState() => _WrappedPhotosSettingsState();
}

class _WrappedPhotosSettingsState extends State<_WrappedPhotosSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          _BlocListener(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null && isPageVisible()) {
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(L10n.global().photosTabLabel),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _BlocBuilder(
                  buildWhen:
                      (previous, current) =>
                          previous.isEnableMemories != current.isEnableMemories,
                  builder: (context, state) {
                    return SwitchListTile(
                      title: Text(L10n.global().settingsMemoriesTitle),
                      subtitle: Text(L10n.global().settingsMemoriesSubtitle),
                      value: state.isEnableMemories,
                      onChanged: (value) {
                        _bloc.add(_SetEnableMemories(value));
                      },
                    );
                  },
                ),
                _BlocBuilder(
                  buildWhen:
                      (previous, current) =>
                          previous.memoriesRange != current.memoriesRange ||
                          previous.isEnableMemories != current.isEnableMemories,
                  builder: (context, state) {
                    return ListTile(
                      title: Text(L10n.global().settingsMemoriesRangeTitle),
                      subtitle: Text(
                        L10n.global().settingsMemoriesRangeValueText(
                          state.memoriesRange,
                        ),
                      ),
                      onTap: () => _onMemoriesRangeTap(context),
                      enabled: state.isEnableMemories,
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onMemoriesRangeTap(BuildContext context) async {
    var memoriesRange = _bloc.state.memoriesRange;
    final result = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            content: _MemoriesRangeSlider(
              initialRange: memoriesRange,
              onChanged: (value) {
                memoriesRange = value;
              },
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(L10n.global().applyButtonLabel),
              ),
            ],
          ),
    );
    if (!context.mounted ||
        result != true ||
        memoriesRange == _bloc.state.memoriesRange) {
      return;
    }
    _bloc.add(_SetMemoriesRange(memoriesRange));
  }

  late final _bloc = context.read<_Bloc>();
}

class _MemoriesRangeSlider extends StatefulWidget {
  const _MemoriesRangeSlider({required this.initialRange, this.onChanged});

  @override
  State<StatefulWidget> createState() => _MemoriesRangeSliderState();

  final int initialRange;
  final ValueChanged<int>? onChanged;
}

class _MemoriesRangeSliderState extends State<_MemoriesRangeSlider> {
  @override
  void initState() {
    super.initState();
    _memoriesRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            L10n.global().settingsMemoriesRangeValueText(_memoriesRange),
          ),
        ),
        StatefulSlider(
          initialValue: _memoriesRange.toDouble(),
          min: 0,
          max: 4,
          divisions: 4,
          onChangeEnd: (value) async {
            setState(() {
              _memoriesRange = value.toInt();
            });
            widget.onChanged?.call(_memoriesRange);
          },
        ),
      ],
    );
  }

  late int _memoriesRange;
}
