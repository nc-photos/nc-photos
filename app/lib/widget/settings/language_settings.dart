import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'language/bloc.dart';
part 'language/state_event.dart';
part 'language_settings.g.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;

class LanguageSettings extends StatelessWidget {
  static const routeName = "/language-settings";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) => const LanguageSettings(),
    settings: settings,
  );

  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(prefController: context.read()),
      child: const _WrappedLanguageSettings(),
    );
  }
}

class _WrappedLanguageSettings extends StatefulWidget {
  const _WrappedLanguageSettings();

  @override
  State<StatefulWidget> createState() => _WrappedLanguageSettingsState();
}

class _WrappedLanguageSettingsState extends State<_WrappedLanguageSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    context.read<_Bloc>().add(const _Init());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
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
      child: Scaffold(
        appBar: AppBar(
          title: _BlocBuilder(
            buildWhen:
                (previous, current) => previous.selected != current.selected,
            builder:
                (context, state) => Text(L10n.global().settingsLanguageTitle),
          ),
        ),
        body: _BlocBuilder(
          buildWhen:
              (previous, current) => previous.selected != current.selected,
          builder: (context, state) {
            final langs = language_util.supportedLanguages.values.toList();
            return ListView.builder(
              itemCount: langs.length,
              itemBuilder: (context, index) {
                final lang = langs[index];
                return FancyOptionPickerItemView(
                  label: lang.nativeName,
                  description: lang.isoName,
                  isSelected: lang.langId == state.selected.langId,
                  onSelect: () {
                    context.read<_Bloc>().add(_SelectLanguage(lang));
                  },
                  dense: true,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
