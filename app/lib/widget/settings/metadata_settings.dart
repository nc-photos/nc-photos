import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/service/service.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'metadata/bloc.dart';
part 'metadata/state_event.dart';
part 'metadata_settings.g.dart';

class MetadataSettings extends StatelessWidget {
  const MetadataSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(prefController: context.read())..add(const _Init()),
      child: const _WrappedMetadataSettings(),
    );
  }
}

class _WrappedMetadataSettings extends StatefulWidget {
  const _WrappedMetadataSettings();

  @override
  State<StatefulWidget> createState() => _WrappedMetadataSettingsState();
}

class _WrappedMetadataSettingsState extends State<_WrappedMetadataSettings>
    with RouteAware, PageVisibilityMixin {
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
              title: Text(L10n.global().settingsMetadataTitle),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _BlocSelector<bool>(
                  selector: (state) => state.isEnable,
                  builder: (context, state) {
                    return SwitchListTile(
                      title: Text(L10n.global().settingsExifSupportTitle2),
                      subtitle:
                          state
                              ? Text(
                                L10n.global().settingsExifSupportTrueSubtitle,
                              )
                              : null,
                      value: state,
                      onChanged: (value) => _onEnableChanged(context, value),
                    );
                  },
                ),
                if (getRawPlatform().isMobile)
                  _BlocBuilder(
                    buildWhen:
                        (previous, current) =>
                            previous.isEnable != current.isEnable ||
                            previous.isWifiOnly != current.isWifiOnly,
                    builder: (context, state) {
                      return SwitchListTile(
                        title: Text(L10n.global().settingsExifWifiOnlyTitle),
                        subtitle:
                            state.isWifiOnly
                                ? null
                                : Text(
                                  L10n.global()
                                      .settingsExifWifiOnlyFalseSubtitle,
                                ),
                        value: state.isWifiOnly,
                        onChanged:
                            state.isEnable
                                ? (value) {
                                  context.addEvent(_SetWifiOnly(value));
                                }
                                : null,
                      );
                    },
                  ),
                _BlocBuilder(
                  buildWhen:
                      (previous, current) =>
                          previous.isEnable != current.isEnable ||
                          previous.isFallback != current.isFallback,
                  builder:
                      (context, state) => SwitchListTile(
                        title: Text(
                          L10n.global().settingsFallbackClientExifTitle,
                        ),
                        subtitle:
                            state.isFallback
                                ? Text(
                                  L10n.global()
                                      .settingsFallbackClientExifTrueText,
                                )
                                : Text(
                                  L10n.global()
                                      .settingsFallbackClientExifFalseText,
                                ),
                        value: state.isFallback,
                        onChanged:
                            state.isEnable
                                ? (value) {
                                  _onFallbackChanged(context, value);
                                }
                                : null,
                      ),
                ),
              ]),
            ),
            const SliverSafeBottom(),
          ],
        ),
      ),
    );
  }

  Future<void> _onEnableChanged(BuildContext context, bool value) async {
    if (value) {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(L10n.global().exifSupportConfirmationDialogTitle2),
              content: Text(L10n.global().exifSupportNextcloud28Notes),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(L10n.global().enableButtonLabel),
                ),
              ],
            ),
      );
      if (context.mounted && result == true) {
        context.addEvent(const _SetEnable(true));
      }
    } else {
      context.addEvent(const _SetEnable(false));
    }
  }

  Future<void> _onFallbackChanged(BuildContext context, bool value) async {
    if (value) {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                L10n.global().settingsFallbackClientExifConfirmDialogTitle,
              ),
              content: Text(
                L10n.global().settingsFallbackClientExifConfirmDialogText,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(L10n.global().enableButtonLabel),
                ),
              ],
            ),
      );
      if (context.mounted && result == true) {
        context.addEvent(const _SetFallback(true));
      }
    } else {
      context.addEvent(const _SetFallback(false));
    }
  }
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
