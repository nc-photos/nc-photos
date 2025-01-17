import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_string/to_string.dart';

part 'developer/bloc.dart';
part 'developer/state_event.dart';
part 'developer_settings.g.dart';

class DeveloperSettings extends StatelessWidget {
  const DeveloperSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(KiwiContainer().resolve<DiContainer>()),
      child: const _WrappedDeveloperSettings(),
    );
  }
}

class _WrappedDeveloperSettings extends StatefulWidget {
  const _WrappedDeveloperSettings();

  @override
  State<StatefulWidget> createState() => _WrappedDeveloperSettingsState();
}

@npLog
class _WrappedDeveloperSettingsState extends State<_WrappedDeveloperSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<_Bloc, _State>(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null && isPageVisible()) {
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            },
          ),
          BlocListener<_Bloc, _State>(
            listenWhen: (previous, current) =>
                previous.message != current.message,
            listener: (context, state) {
              if (state.message != null && isPageVisible()) {
                SnackBarManager().showSnackBar(SnackBar(
                  content: Text(state.message!.value),
                  duration: k.snackBarDurationNormal,
                ));
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              title: Text("Developer options"),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    title: const Text("Clear image cache"),
                    onTap: () async {
                      context.read<_Bloc>().add(const _ClearImageCache());
                    },
                  ),
                  ListTile(
                    title: const Text("SQL:VACUUM"),
                    onTap: () {
                      context.read<_Bloc>().add(const _VacuumDb());
                    },
                  ),
                  if (isDevMode) ...[
                    ListTile(
                      title: const Text("Export SQLite DB"),
                      onTap: () {
                        context.read<_Bloc>().add(const _ExportDb());
                      },
                    ),
                    if (getRawPlatform().isMobile)
                      ListTile(
                        title: const Text("Clear whitelisted certs"),
                        onTap: () {
                          context
                              .read<_Bloc>()
                              .add(const _ClearCertWhitelist());
                        },
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
