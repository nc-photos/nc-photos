import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/ad_hoc.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/image_location/repo.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/jxl_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_extension.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/widget/collection_browser/collection_browser.dart';
import 'package:nc_photos/widget/measure.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/size.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'map_browser.g.dart';
part 'state_event.dart';
part 'type.dart';
part 'view.dart';

class MapBrowser extends StatelessWidget {
  static const routeName = "/map-browser";

  static Route buildRoute(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => const MapBrowser(), settings: settings);

  const MapBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => _Bloc(
            KiwiContainer().resolve(),
            account: context.read<AccountController>().account,
            prefController: context.read(),
          )..add(const _LoadData()),
      child: const _WrappedMapBrowser(),
    );
  }
}

class _WrappedMapBrowser extends StatelessWidget {
  const _WrappedMapBrowser();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT<ExceptionEvent?>(
          selector: (state) => state.error,
          listener: (context, error) {
            if (error != null) {
              SnackBarManager().showSnackBarForException(error.error);
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            const _MapView(),
            Positioned.directional(
              textDirection: Directionality.of(context),
              top: MediaQuery.of(context).padding.top + 8,
              end: 8,
              child: const _DateRangeToggle(),
            ),
            _BlocSelector<bool>(
              selector: (state) => state.isShowDataRangeControlPanel,
              builder:
                  (context, isShowAnyPanel) => Positioned.fill(
                    child:
                        isShowAnyPanel
                            ? GestureDetector(
                              onTap: () {
                                context.addEvent(const _CloseControlPanel());
                              },
                            )
                            : const SizedBox.shrink(),
                  ),
            ),
            Positioned(
              left: 8,
              right: 8,
              top: MediaQuery.of(context).padding.top + 8,
              child: _BlocSelector<bool>(
                selector: (state) => state.isShowDataRangeControlPanel,
                builder:
                    (context, isShowDataRangeControlPanel) => _PanelContainer(
                      isShow: isShowDataRangeControlPanel,
                      child: const _DateRangeControlPanel(),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
