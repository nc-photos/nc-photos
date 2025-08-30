import 'dart:async';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/controller/trusted_cert_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/navigation_manager.dart';
import 'package:nc_photos/protected_page_handler.dart';
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/album_dir_picker.dart';
import 'package:nc_photos/widget/album_importer.dart';
import 'package:nc_photos/widget/album_share_outlier_browser.dart';
import 'package:nc_photos/widget/archive_browser.dart';
import 'package:nc_photos/widget/changelog.dart';
import 'package:nc_photos/widget/collection_browser.dart';
import 'package:nc_photos/widget/collection_picker.dart';
import 'package:nc_photos/widget/collection_viewer/collection_viewer.dart';
import 'package:nc_photos/widget/connect2/connect.dart';
import 'package:nc_photos/widget/convert_settings/convert_settings.dart';
import 'package:nc_photos/widget/enhanced_photo_browser.dart';
import 'package:nc_photos/widget/home/home.dart';
import 'package:nc_photos/widget/image_editor.dart';
import 'package:nc_photos/widget/image_enhancer.dart';
import 'package:nc_photos/widget/local_file_viewer.dart';
import 'package:nc_photos/widget/map_browser.dart';
import 'package:nc_photos/widget/people_browser.dart';
import 'package:nc_photos/widget/place_picker/place_picker.dart';
import 'package:nc_photos/widget/places_browser.dart';
import 'package:nc_photos/widget/result_viewer.dart';
import 'package:nc_photos/widget/root_picker.dart';
import 'package:nc_photos/widget/settings.dart';
import 'package:nc_photos/widget/settings/account_settings.dart';
import 'package:nc_photos/widget/settings/enhancement_settings.dart';
import 'package:nc_photos/widget/settings/language_settings.dart';
import 'package:nc_photos/widget/setup.dart';
import 'package:nc_photos/widget/share_folder_picker.dart';
import 'package:nc_photos/widget/shared_file_viewer.dart';
import 'package:nc_photos/widget/sharing_browser.dart';
import 'package:nc_photos/widget/sign_in.dart';
import 'package:nc_photos/widget/slideshow_viewer.dart';
import 'package:nc_photos/widget/splash.dart';
import 'package:nc_photos/widget/timeline_viewer/timeline_viewer.dart';
import 'package:nc_photos/widget/trashbin_browser.dart';
import 'package:nc_photos/widget/trashbin_viewer.dart';
import 'package:nc_photos/widget/trusted_cert_manager.dart';
import 'package:nc_photos/widget/upload_folder_picker.dart';
import 'package:np_common/color.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'my_app.g.dart';
part 'my_app/app_lock.dart';
part 'my_app/bloc.dart';
part 'my_app/logger.dart';
part 'my_app/state_event.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DiContainer _c = KiwiContainer().resolve<DiContainer>();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => PrefController(_c.pref)),
        RepositoryProvider(create: (_) => SecurePrefController(_c.securePref)),
        RepositoryProvider<LocalFilesController>(
          create: (context) {
            if (getRawPlatform() == NpPlatform.android) {
              if (AndroidInfo().sdkInt >= AndroidVersion.TIRAMISU) {
                return LocalFilesControllerImpl(
                  _c,
                  prefController: context.read(),
                );
              }
            }
            return DummyLocalFilesController();
          },
        ),
        RepositoryProvider(
          create:
              (context) => AccountController(
                prefController: context.read(),
                localFilesController: context.read(),
              ),
        ),
        RepositoryProvider<NpDb>(create: (_) => _c.npDb),
        RepositoryProvider<TrustedCertController>(
          create:
              (_) => TrustedCertController(manager: SelfSignedCertManager()),
        ),
      ],
      child: BlocProvider(
        create: (context) => _Bloc(prefController: context.read()),
        child: const _WrappedApp(),
      ),
    );
  }

  static RouteObserver get routeObserver => _routeObserver;

  static BuildContext get globalContext => _globalContext;

  static final _routeObserver = RouteObserver<PageRoute>();
  static late BuildContext _globalContext;
}

class _WrappedApp extends StatefulWidget {
  const _WrappedApp();

  @override
  State<StatefulWidget> createState() => _WrappedAppState();
}

@npLog
class _WrappedAppState extends State<_WrappedApp>
    implements SnackBarHandler, NavigationHandler {
  @override
  void initState() {
    super.initState();
    SnackBarManager().registerHandler(this);
    NavigationManager().setHandler(this);

    _bloc.add(const _Init());
  }

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.language != current.language ||
              previous.isDarkTheme != current.isDarkTheme ||
              previous.isFollowSystemTheme != current.isFollowSystemTheme ||
              previous.isUseBlackInDarkTheme != current.isUseBlackInDarkTheme ||
              previous.seedColor != current.seedColor ||
              previous.secondarySeedColor != current.secondarySeedColor,
      builder:
          (context, state) => DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              SessionStorage()
                ..lightDynamicColorScheme = lightDynamic
                ..darkDynamicColorScheme = darkDynamic
                ..isSupportDynamicColor = lightDynamic != null;
              final ThemeMode themeMode;
              if (state.isFollowSystemTheme) {
                themeMode = ThemeMode.system;
              } else {
                themeMode =
                    state.isDarkTheme ? ThemeMode.dark : ThemeMode.light;
              }
              return MaterialApp(
                onGenerateTitle:
                    (context) => AppLocalizations.of(context)!.appTitle,
                theme: buildLightTheme(context, lightDynamic),
                darkTheme: buildDarkTheme(context, darkDynamic),
                themeMode: themeMode,
                initialRoute: Splash.routeName,
                onGenerateRoute: _onGenerateRoute,
                navigatorObservers: [MyApp.routeObserver, _NavigatorLogger()],
                navigatorKey: _navigatorKey,
                scaffoldMessengerKey: _scaffoldMessengerKey,
                locale: state.language.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) {
                  MyApp._globalContext = context;
                  return _ThemedMyApp(child: child!);
                },
                debugShowCheckedModeBanner: false,
                scrollBehavior: const _MyScrollBehavior(),
              );
            },
          ),
    );
  }

  @override
  void dispose() {
    SnackBarManager().unregisterHandler(this);
    NavigationManager().unsetHandler(this);
    super.dispose();
  }

  @override
  showSnackBar(SnackBar snackBar) =>
      _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);

  @override
  getNavigator() => _navigatorKey.currentState;

  Map<String, Route Function(RouteSettings)> _getRouter() => {
    Setup.routeName: Setup.buildRoute,
    SignIn.routeName: SignIn.buildRoute,
    Splash.routeName: Splash.buildRoute,
    CollectionPicker.routeName: CollectionPicker.buildRoute,
    LanguageSettings.routeName: LanguageSettings.buildRoute,
    PeopleBrowser.routeName: PeopleBrowser.buildRoute,
    EnhancementSettings.routeName: EnhancementSettings.buildRoute,
    Settings.routeName: Settings.buildRoute,
    SharingBrowser.routeName: SharingBrowser.buildRoute,
    PlacesBrowser.routeName: PlacesBrowser.buildRoute,
    ArchiveBrowser.routeName: ArchiveBrowser.buildRoute,
    TrustedCertManager.routeName: TrustedCertManager.buildRoute,
    MapBrowser.routeName: MapBrowser.buildRoute,
    ConvertSettings.routeName: ConvertSettings.buildRoute,
  };

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    _log.info("[_onGenerateRoute] Route: ${settings.name}");
    Route<dynamic>? route;
    route ??= _handleBasicRoute(settings);
    route ??= _handleConnectRoute(settings);
    route ??= _handleHomeRoute(settings);
    route ??= _handleRootPickerRoute(settings);
    route ??= _handleAlbumDirPickerRoute(settings);
    route ??= _handleAlbumImporterRoute(settings);
    route ??= _handleTrashbinBrowserRoute(settings);
    route ??= _handleTrashbinViewerRoute(settings);
    route ??= _handleSlideshowViewerRoute(settings);
    route ??= _handleSharedFileViewerRoute(settings);
    route ??= _handleAlbumShareOutlierBrowserRoute(settings);
    route ??= _handleShareFolderPickerRoute(settings);
    route ??= _handleEnhancedPhotoBrowserRoute(settings);
    route ??= _handleLocalFileViewerRoute(settings);
    route ??= _handleImageEditorRoute(settings);
    route ??= _handleChangelogRoute(settings);
    route ??= _handleResultViewerRoute(settings);
    route ??= _handleImageEnhancerRoute(settings);
    route ??= _handleCollectionBrowserRoute(settings);
    route ??= _handleAccountSettingsRoute(settings);
    route ??= _handlePlacePickerRoute(settings);
    route ??= _handleTimelineViewerRoute(settings);
    route ??= _handleCollectionViewerRoute(settings);
    route ??= _handleUploadFolderPickerRoute(settings);
    return route;
  }

  Route<dynamic>? _handleBasicRoute(RouteSettings settings) {
    for (final e in _getRouter().entries) {
      if (e.key == settings.name) {
        return e.value(settings);
      }
    }
    return null;
  }

  Route<dynamic>? _handleConnectRoute(RouteSettings settings) {
    try {
      if (settings.name == Connect.routeName && settings.arguments != null) {
        final args = settings.arguments as ConnectArguments;
        return Connect.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handleConnectRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleHomeRoute(RouteSettings settings) {
    try {
      if (settings.name == Home.routeName && settings.arguments != null) {
        final args = settings.arguments as HomeArguments;
        // move this elsewhere later
        context.read<AccountController>().setCurrentAccount(args.account);
        return Home.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handleHomeRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleRootPickerRoute(RouteSettings settings) {
    try {
      if (settings.name == RootPicker.routeName && settings.arguments != null) {
        final args = settings.arguments as RootPickerArguments;
        return RootPicker.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handleRootPickerRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleAlbumDirPickerRoute(RouteSettings settings) {
    try {
      if (settings.name == AlbumDirPicker.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as AlbumDirPickerArguments;
        return AlbumDirPicker.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleAlbumDirPickerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleAlbumImporterRoute(RouteSettings settings) {
    try {
      if (settings.name == AlbumImporter.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as AlbumImporterArguments;
        return AlbumImporter.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handleAlbumImporterRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleTrashbinBrowserRoute(RouteSettings settings) {
    try {
      if (settings.name == TrashbinBrowser.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as TrashbinBrowserArguments;
        return TrashbinBrowser.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleTrashbinBrowserRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleTrashbinViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == TrashbinViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as TrashbinViewerArguments;
        return TrashbinViewer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleTrashbinViewerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleSlideshowViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == SlideshowViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as SlideshowViewerArguments;
        return SlideshowViewer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleSlideshowViewerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleSharedFileViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == SharedFileViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as SharedFileViewerArguments;
        return SharedFileViewer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleSharedFileViewerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleAlbumShareOutlierBrowserRoute(RouteSettings settings) {
    try {
      if (settings.name == AlbumShareOutlierBrowser.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as AlbumShareOutlierBrowserArguments;
        return AlbumShareOutlierBrowser.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleAlbumShareOutlierBrowserRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleShareFolderPickerRoute(RouteSettings settings) {
    try {
      if (settings.name == ShareFolderPicker.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as ShareFolderPickerArguments;
        return ShareFolderPicker.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleShareFolderPickerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleEnhancedPhotoBrowserRoute(RouteSettings settings) {
    try {
      if (settings.name == EnhancedPhotoBrowser.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as EnhancedPhotoBrowserArguments;
        return EnhancedPhotoBrowser.buildRoute(args, settings);
      } else if (settings.name?.startsWith(
            "${EnhancedPhotoBrowser.routeName}?",
          ) ==
          true) {
        final queries = Uri.parse(settings.name!).queryParameters;
        final args = EnhancedPhotoBrowserArguments(queries["filename"]);
        return EnhancedPhotoBrowser.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleEnhancedPhotoBrowserRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleLocalFileViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == LocalFileViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as LocalFileViewerArguments;
        return LocalFileViewer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleLocalFileViewerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleImageEditorRoute(RouteSettings settings) {
    try {
      if (settings.name == ImageEditor.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as ImageEditorArguments;
        return ImageEditor.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handleImageEditorRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleChangelogRoute(RouteSettings settings) {
    try {
      if (settings.name == Changelog.routeName) {
        if (settings.arguments != null) {
          final args = settings.arguments as ChangelogArguments;
          return Changelog.buildRoute(args, settings);
        } else {
          return MaterialPageRoute(builder: (_) => const Changelog());
        }
      }
    } catch (e) {
      _log.severe("[_handleChangelogRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleResultViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == ResultViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as ResultViewerArguments;
        return ResultViewer.buildRoute(args, settings);
      } else if (settings.name?.startsWith("${ResultViewer.routeName}?") ==
          true) {
        final queries = Uri.parse(settings.name!).queryParameters;
        final args = ResultViewerArguments(queries["url"]!);
        return ResultViewer.buildRoute(args, settings);
      }
    } catch (e, stackTrace) {
      _log.severe(
        "[_handleResultViewerRoute] Failed while handling route",
        e,
        stackTrace,
      );
    }
    return null;
  }

  Route<dynamic>? _handleImageEnhancerRoute(RouteSettings settings) {
    try {
      if (settings.name == ImageEnhancer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as ImageEnhancerArguments;
        return ImageEnhancer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handleImageEnhancerRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleCollectionBrowserRoute(RouteSettings settings) {
    try {
      if (settings.name == CollectionBrowser.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as CollectionBrowserArguments;
        return CollectionBrowser.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleCollectionBrowserRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleAccountSettingsRoute(RouteSettings settings) {
    try {
      if (settings.name == AccountSettings.routeName) {
        final args = settings.arguments as AccountSettingsArguments?;
        return AccountSettings.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleAccountSettingsRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handlePlacePickerRoute(RouteSettings settings) {
    try {
      if (settings.name == PlacePicker.routeName) {
        final args = settings.arguments as PlacePickerArguments?;
        return PlacePicker.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe("[_handlePlacePickerRoute] Failed while handling route", e);
    }
    return null;
  }

  Route<dynamic>? _handleTimelineViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == TimelineViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as TimelineViewerArguments;
        return TimelineViewer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleTimelineViewerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleCollectionViewerRoute(RouteSettings settings) {
    try {
      if (settings.name == CollectionViewer.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as CollectionViewerArguments;
        return CollectionViewer.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleCollectionViewerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  Route<dynamic>? _handleUploadFolderPickerRoute(RouteSettings settings) {
    try {
      if (settings.name == UploadFolderPicker.routeName &&
          settings.arguments != null) {
        final args = settings.arguments as UploadFolderPickerArguments;
        return UploadFolderPicker.buildRoute(args, settings);
      }
    } catch (e) {
      _log.severe(
        "[_handleUploadFolderPickerRoute] Failed while handling route",
        e,
      );
    }
    return null;
  }

  late final _bloc = context.read<_Bloc>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
}

class _ThemedMyApp extends StatelessWidget {
  const _ThemedMyApp({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // set status bar and navigation bar color
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: theme.colorScheme.secondaryContainer,
        systemNavigationBarIconBrightness: theme.brightness.invert(),
      ),
      child: _AppLockMyApp(child: child),
    );
  }

  final Widget child;
}

class _MyScrollBehavior extends MaterialScrollBehavior {
  const _MyScrollBehavior();

  @override
  get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.mouse,
  };
}
