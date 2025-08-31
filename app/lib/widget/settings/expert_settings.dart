import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/trusted_cert_manager.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'expert/bloc.dart';
part 'expert/state_event.dart';
part 'expert_settings.g.dart';

class ExpertSettings extends StatelessWidget {
  const ExpertSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              _Bloc(db: context.read(), prefController: context.read())
                ..add(const _Init()),
      child: const _WrappedExpertSettings(),
    );
  }
}

class _WrappedExpertSettings extends StatefulWidget {
  const _WrappedExpertSettings();

  @override
  State<StatefulWidget> createState() => _WrappedExpertSettingsState();
}

@npLog
class _WrappedExpertSettingsState extends State<_WrappedExpertSettings> {
  @override
  void initState() {
    super.initState();
    _errorSubscription = context.read<_Bloc>().errorStream().listen((error) {
      if (error.ev is _ClearCacheDatabase) {
        SnackBarManager().showSnackBarForException(error.error);
      }
    });
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder:
            (context) => MultiBlocListener(
              listeners: [
                _BlocListener(
                  listenWhen:
                      (previous, current) =>
                          !identical(
                            previous.lastSuccessful,
                            current.lastSuccessful,
                          ),
                  listener: (context, state) {
                    if (state.lastSuccessful is _ClearCacheDatabase) {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              content: Text(
                                L10n.global()
                                    .settingsClearCacheDatabaseSuccessNotification,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    MaterialLocalizations.of(
                                      context,
                                    ).closeButtonLabel,
                                  ),
                                ),
                              ],
                            ),
                      );
                    }
                  },
                ),
                _BlocListenerT<bool>(
                  selector: (state) => state.isNewHttpEngine,
                  listener: (context, isNewHttpEngine) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            content: Text(
                              L10n.global().settingsRestartNeededDialog,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  MaterialLocalizations.of(
                                    context,
                                  ).closeButtonLabel,
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(L10n.global().settingsExpertTitle),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 8),
                          Text(L10n.global().settingsExpertWarningText),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ListTile(
                        title: Text(
                          L10n.global().settingsClearCacheDatabaseTitle,
                        ),
                        subtitle: Text(
                          L10n.global().settingsClearCacheDatabaseDescription,
                        ),
                        onTap: () {
                          context.read<_Bloc>().add(
                            const _ClearCacheDatabase(),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          L10n.global().settingsManageTrustedCertificateTitle,
                        ),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(TrustedCertManager.routeName);
                        },
                      ),
                      _BlocSelector<bool>(
                        selector: (state) => state.isNewHttpEngine,
                        builder:
                            (context, isNewHttpEngine) => CheckboxListTile(
                              title: Text(
                                L10n.global().settingsUseNewHttpEngine,
                              ),
                              value: isNewHttpEngine,
                              onChanged: (value) async {
                                if (value == true) {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) =>
                                            const _NewHttpEngineDialog(),
                                  );
                                  if (context.mounted && result == true) {
                                    context.addEvent(
                                      const _SetNewHttpEngine(true),
                                    );
                                  }
                                } else {
                                  context.addEvent(
                                    const _SetNewHttpEngine(false),
                                  );
                                }
                              },
                            ),
                      ),
                    ]),
                  ),
                  const SliverSafeBottom(),
                ],
              ),
            ),
      ),
    );
  }

  late final StreamSubscription _errorSubscription;
}

class _NewHttpEngineDialog extends StatelessWidget {
  const _NewHttpEngineDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().settingsUseNewHttpEngine),
      content: Text(L10n.global().settingsUseNewHttpEngineDescription),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(L10n.global().enableButtonLabel),
        ),
      ],
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
