import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/data_source.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/theme/dimension.dart';
import 'package:nc_photos/use_case/import_potential_shared_album.dart';
import 'package:nc_photos/widget/home_collections.dart';
import 'package:nc_photos/widget/home_photos2.dart';
import 'package:nc_photos/widget/home_search.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';

part 'home.g.dart';

class HomeArguments {
  HomeArguments(this.account);

  final Account account;
}

class Home extends StatefulWidget {
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
  createState() => _HomeState();

  final Account account;
}

@npLog
class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final accountController = context.read<AccountController>();
    _importPotentialSharedAlbum().then((value) {
      if (value.isNotEmpty) {
        // check if account changed
        if (accountController.account.compareServerIdentity(widget.account)) {
          accountController.accountPrefController.setNewSharedAlbum(true);
        } else {
          AccountPref.of(widget.account).setNewSharedAlbum(true);
        }
      }
    });
    _animationController.value = 1;

    // call once to pre-cache the value
    unawaited(
      context.read<AccountController>().serverController.status.first.then((
        value,
      ) {
        _log.info("Server status: $value");
      }),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: Builder(builder: (context) => _buildContent(context)),
      extendBody: true,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBar(
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
      selectedIndex: _nextPage,
      onDestinationSelected: _onTapNavItem,
      backgroundColor: Theme.of(context).homeNavigationBarBackgroundColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    return PageView.builder(
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
              child: _buildPage(context, index),
            ),
          ),
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const HomePhotos2();

      case 1:
        return HomeSearch(account: widget.account);

      case 2:
        return const HomeCollections();

      default:
        throw ArgumentError("Invalid page index: $index");
    }
  }

  void _onTapNavItem(int index) {
    if (index == _nextPage) {
      if (index == 0) {
        KiwiContainer().resolve<EventBus>().fire(
          const HomePhotos2BackToTopEvent(),
        );
      }
      return;
    }

    _pageController.jumpToPage(index);
    setState(() {
      _nextPage = index;
    });
    _animationController
      ..reset()
      ..forward();
  }

  Future<List<Album>> _importPotentialSharedAlbum() async {
    final c = KiwiContainer().resolve<DiContainer>().copyWith(
      // don't want the potential albums to be cached at this moment
      fileRepo: const OrNull(FileRepo(FileWebdavDataSource())),
      albumRepo: OrNull(AlbumRepo(AlbumRemoteDataSource())),
    );
    try {
      return await ImportPotentialSharedAlbum(c)(
        widget.account,
        context
            .read<AccountController>()
            .accountPrefController
            .shareFolderValue,
      );
    } catch (e, stacktrace) {
      _log.shout(
        "[_importPotentialSharedAlbum] Failed while ImportPotentialSharedAlbum",
        e,
        stacktrace,
      );
      return [];
    }
  }

  final _pageController = PageController(initialPage: 0, keepPage: false);
  int _nextPage = 0;

  late final _animationController = AnimationController(
    duration: k.animationDurationTabTransition,
    vsync: this,
  );
  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  );
}
