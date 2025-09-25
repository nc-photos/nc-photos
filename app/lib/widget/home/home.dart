import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/data_source.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/permission_util.dart';
import 'package:nc_photos/platform/features.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/theme/dimension.dart';
import 'package:nc_photos/use_case/import_potential_shared_album.dart';
import 'package:nc_photos/widget/home_collections.dart';
import 'package:nc_photos/widget/home_photos2.dart';
import 'package:nc_photos/widget/home_search.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_permission/np_platform_permission.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'home.g.dart';
part 'state_event.dart';

class HomeArguments {
  const HomeArguments(this.account);

  final Account account;
}

class Home extends StatelessWidget {
  static const routeName = "/home";

  static Route buildRoute(HomeArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => Home.fromArgs(args),
        settings: settings,
      );

  const Home({super.key, required this.account});

  Home.fromArgs(HomeArguments args, {Key? key})
    : this(key: key, account: args.account);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              _Bloc(accountController: context.read(), account: account)
                ..add(const _Init()),
      child: const _WrappedHome(),
    );
  }

  final Account account;
}

class _WrappedHome extends StatefulWidget {
  const _WrappedHome();

  @override
  State<StatefulWidget> createState() => _WrappedHomeState();
}

@npLog
class _WrappedHomeState extends State<_WrappedHome>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController.value = 1;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.page,
          listener: (context, page) {
            _pageController.jumpToPage(page);
            _animationController
              ..reset()
              ..forward();
          },
        ),
      ],
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const _NavigationTabBar(),
        body: _BlocSelector(
          selector: (state) => state.isInitDone,
          builder:
              (context, isInitDone) =>
                  isInitDone
                      ? PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder:
                            (context, index) => SlideTransition(
                              position: Tween(
                                begin: const Offset(0, .05),
                                end: Offset.zero,
                              ).animate(_animation),
                              child: FadeTransition(
                                opacity: _animation,
                                child: switch (index) {
                                  0 => const HomePhotos2(),
                                  1 => HomeSearch(
                                    account: context.bloc.account,
                                  ),
                                  2 => const HomeCollections(),
                                  _ =>
                                    throw ArgumentError(
                                      "Invalid page index: $index",
                                    ),
                                },
                              ),
                            ),
                      )
                      : Container(),
        ),
      ),
    );
  }

  final _pageController = PageController(initialPage: 0, keepPage: false);

  late final _animationController = AnimationController(
    duration: k.animationDurationTabTransition,
    vsync: this,
  );
  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  );
}

class _NavigationTabBar extends StatelessWidget {
  const _NavigationTabBar();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.page,
      builder:
          (context, page) => NavigationBar(
            height: AppDimension.of(context).homeBottomAppBarHeight,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.photo_outlined),
                selectedIcon: const Icon(Icons.photo),
                label: L10n.global().photosTabLabel,
              ),
              NavigationDestination(
                icon: const Icon(Icons.search),
                label: L10n.global().searchTooltip,
              ),
              NavigationDestination(
                icon: const Icon(Icons.grid_view_outlined),
                selectedIcon: const Icon(Icons.grid_view_sharp),
                label: L10n.global().collectionsTooltip,
              ),
            ],
            selectedIndex: page,
            onDestinationSelected: (value) {
              context.addEvent(_ChangePage(value));
            },
            backgroundColor: Theme.of(context).homeNavigationBarBackgroundColor,
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
