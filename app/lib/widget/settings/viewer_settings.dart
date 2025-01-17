import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/gps_map_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/settings/viewer_app_bar_settings.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:np_ui/np_ui.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:to_string/to_string.dart';

part 'viewer/bloc.dart';
part 'viewer/state_event.dart';
part 'viewer_settings.g.dart';

typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

class ViewerSettings extends StatelessWidget {
  const ViewerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(
        prefController: context.read(),
      ),
      child: const _WrappedViewerSettings(),
    );
  }
}

class _WrappedViewerSettings extends StatefulWidget {
  const _WrappedViewerSettings();

  @override
  State<StatefulWidget> createState() => _WrappedViewerSettingsState();
}

@npLog
class _WrappedViewerSettingsState extends State<_WrappedViewerSettings>
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
              title: Text(L10n.global().settingsViewerTitle),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (getRawPlatform().isMobile)
                    _BlocSelector<int>(
                      selector: (state) => state.screenBrightness,
                      builder: (context, state) {
                        return SwitchListTile(
                          title:
                              Text(L10n.global().settingsScreenBrightnessTitle),
                          subtitle: Text(L10n.global()
                              .settingsScreenBrightnessDescription),
                          value: state >= 0,
                          onChanged: (value) =>
                              _onScreenBrightnessChanged(context, value),
                        );
                      },
                    ),
                  if (getRawPlatform().isMobile)
                    _BlocSelector<bool>(
                      selector: (state) => state.isForceRotation,
                      builder: (context, state) {
                        return SwitchListTile(
                          title: Text(L10n.global().settingsForceRotationTitle),
                          subtitle: Text(
                              L10n.global().settingsForceRotationDescription),
                          value: state,
                          onChanged: (value) {
                            _bloc.add(_SetForceRotation(value));
                          },
                        );
                      },
                    ),
                  _BlocSelector<GpsMapProvider>(
                    selector: (state) => state.gpsMapProvider,
                    builder: (context, state) {
                      return ListTile(
                        title: Text(L10n.global().settingsMapProviderTitle),
                        subtitle: Text(state.toUserString()),
                        onTap: () => _onMapProviderTap(context),
                      );
                    },
                  ),
                  ListTile(
                    title:
                        Text(L10n.global().settingsViewerCustomizeAppBarTitle),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ViewerAppBarSettings(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                        L10n.global().settingsViewerCustomizeBottomAppBarTitle),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ViewerBottomAppBarSettings(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onScreenBrightnessChanged(
      BuildContext context, bool value) async {
    if (!value) {
      _bloc.add(const _SetScreenBrightness(-1));
      return;
    }

    final result = await showDialog<double>(
      context: context,
      builder: (_) => const _BrightnessDialog(initialValue: 0.5),
    );
    if (!context.mounted || result == null) {
      return;
    }
    _bloc.add(_SetScreenBrightness(result));
  }

  Future<void> _onMapProviderTap(BuildContext context) async {
    final result = await showDialog<GpsMapProvider>(
      context: context,
      builder: (context) => FancyOptionPicker(
        items: GpsMapProvider.values
            .map((provider) => FancyOptionPickerItem(
                  label: provider.toUserString(),
                  isSelected: provider == _bloc.state.gpsMapProvider,
                  onSelect: () {
                    _log.info(
                        "[_onMapProviderTap] Set map provider: ${provider.toUserString()}");
                    Navigator.of(context).pop(provider);
                  },
                ))
            .toList(),
      ),
    );
    if (!context.mounted ||
        result == null ||
        result == _bloc.state.gpsMapProvider) {
      return;
    }
    _bloc.add(_SetGpsMapProvider(result));
  }

  late final _bloc = context.read<_Bloc>();
}

class _BrightnessDialog extends StatefulWidget {
  const _BrightnessDialog({
    required this.initialValue,
  });

  @override
  State<StatefulWidget> createState() => _BrightnessDialogState();

  final double initialValue;
}

@npLog
class _BrightnessDialogState extends State<_BrightnessDialog> {
  @override
  void initState() {
    super.initState();
    ScreenBrightness().setScreenBrightness(widget.initialValue);
    _value = widget.initialValue;
  }

  @override
  void dispose() {
    ScreenBrightness().resetScreenBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().settingsScreenBrightnessTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(L10n.global().settingsScreenBrightnessDescription),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(Icons.brightness_low),
              Expanded(
                child: StatefulSlider(
                  initialValue: widget.initialValue,
                  min: 0.01,
                  onChangeEnd: (value) async {
                    _value = value;
                    try {
                      await ScreenBrightness().setScreenBrightness(value);
                    } catch (e, stackTrace) {
                      _log.severe(
                          "Failed while setScreenBrightness", e, stackTrace);
                    }
                  },
                ),
              ),
              const Icon(Icons.brightness_high),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_value);
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  late double _value;
}
