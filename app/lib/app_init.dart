import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/data_source.dart';
import 'package:nc_photos/entity/album/data_source2.dart';
import 'package:nc_photos/entity/album/repo2.dart';
import 'package:nc_photos/entity/face_recognition_person/data_source.dart';
import 'package:nc_photos/entity/face_recognition_person/repo.dart';
import 'package:nc_photos/entity/favorite.dart';
import 'package:nc_photos/entity/favorite/data_source.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/data_source.dart';
import 'package:nc_photos/entity/file/data_source2.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/image_location/data_source.dart';
import 'package:nc_photos/entity/image_location/repo.dart';
import 'package:nc_photos/entity/local_file/data_source.dart';
import 'package:nc_photos/entity/local_file/repo.dart';
import 'package:nc_photos/entity/nc_album/data_source.dart';
import 'package:nc_photos/entity/nc_album/repo.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/pref/provider/secure_storage.dart';
import 'package:nc_photos/entity/pref/provider/shared_preferences.dart';
import 'package:nc_photos/entity/pref_util.dart' as pref_util;
import 'package:nc_photos/entity/recognize_face/data_source.dart';
import 'package:nc_photos/entity/recognize_face/repo.dart';
import 'package:nc_photos/entity/search.dart';
import 'package:nc_photos/entity/search/data_source.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/share/data_source.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/entity/sharee/data_source.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/tag/data_source.dart';
import 'package:nc_photos/entity/tagged_file.dart';
import 'package:nc_photos/entity/tagged_file/data_source.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/touch_manager.dart';
import 'package:np_db/np_db.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_http/np_http.dart';
import 'package:np_log/np_log.dart' as np_log;
import 'package:np_platform_util/np_platform_util.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum InitIsolateType {
  main,

  /// Isolates with Flutter engine, e.g., those spawned by flutter_isolate or
  /// flutter_background_service
  flutterIsolate,
}

Future<void> init(InitIsolateType isolateType) async {
  if (_hasInitedInThisIsolate) {
    _log.warning("[init] Already initialized in this isolate");
    return;
  }

  initLog();
  await _initDeviceInfo();
  _initKiwi();
  await _initPref();
  await _initAccountPrefs();
  _initEquatable();
  if (features.isSupportSelfSignedCert) {
    await _initSelfSignedCertManager();
  }
  await initHttp(
    appVersion: k.versionStr,
    isNewHttpEngine: Pref().isNewHttpEngine() ?? false,
  );
  await _initDiContainer(isolateType);
  _initVisibilityDetector();
  initGpsMap();
  // init session storage
  SessionStorage();
  if (isolateType == InitIsolateType.main &&
      getRawPlatform() == NpPlatform.android) {
    unawaited(_initRefreshRate());
  }

  await _initAds();

  _hasInitedInThisIsolate = true;
}

void initLog() {
  if (_hasInitedInThisIsolate) {
    return;
  }

  np_log.initLog(
    isDebugMode: np_log.isDevMode,
    print: (log) => debugPrint(log, wrapWidth: 1024),
  );
}

Future<void> _initPref() async {
  final provider = PrefSharedPreferencesProvider();
  await provider.init();
  final pref = Pref.scoped(provider);
  Pref.setGlobalInstance(pref);

  if (Pref().getLastVersion() == null) {
    if (Pref().getSetupProgress() == null) {
      // new install
      await Pref().setLastVersion(k.version);
    } else {
      // v6 is the last version without saving the version number in pref
      await Pref().setLastVersion(6);
    }
  }
}

Future<void> _initAccountPrefs() async {
  for (final a in Pref().getAccounts3Or([])) {
    try {
      AccountPref.setGlobalInstance(a, await pref_util.loadAccountPref(a));
    } catch (e, stackTrace) {
      _log.shout(
        "[_initAccountPrefs] Failed reading pref for account: $a",
        e,
        stackTrace,
      );
    }
  }
}

Future<void> _initDeviceInfo() async {
  if (getRawPlatform() == NpPlatform.android) {
    await AndroidInfo.init();
  }
}

void _initKiwi() {
  final kiwi = KiwiContainer();
  kiwi.registerInstance<EventBus>(EventBus());
}

void _initEquatable() {
  EquatableConfig.stringify = false;
}

Future<void> _initSelfSignedCertManager() async {
  try {
    return SelfSignedCertManager().init();
  } catch (e, stackTrace) {
    _log.shout(
      "[_initSelfSignedCertManager] Failed to load self signed certs",
      e,
      stackTrace,
    );
  }
}

Future<void> _initDiContainer(InitIsolateType isolateType) async {
  final c = DiContainer.late();
  c.pref = Pref();
  c.securePref = await _createSecurePref();
  c.npDb = await _createDb(isolateType);

  c.albumRepo = AlbumRepo(AlbumCachedDataSource(c));
  c.albumRepoRemote = AlbumRepo(AlbumRemoteDataSource());
  c.albumRepoLocal = AlbumRepo(AlbumSqliteDbDataSource(c));
  c.albumRepo2 = CachedAlbumRepo2(
    const AlbumRemoteDataSource2(),
    AlbumSqliteDbDataSource2(c.npDb),
  );
  c.albumRepo2Remote = const BasicAlbumRepo2(AlbumRemoteDataSource2());
  c.albumRepo2Local = BasicAlbumRepo2(AlbumSqliteDbDataSource2(c.npDb));
  c.fileRepo = FileRepo(FileCachedDataSource(c));
  c.fileRepoRemote = const FileRepo(FileWebdavDataSource());
  c.fileRepoLocal = FileRepo(FileSqliteDbDataSource(c));
  c.fileRepo2 = CachedFileRepo(
    const FileRemoteDataSource(),
    FileNpDbDataSource(c.npDb),
  );
  c.fileRepo2Remote = const BasicFileRepo(FileRemoteDataSource());
  c.fileRepo2Local = BasicFileRepo(FileNpDbDataSource(c.npDb));
  c.shareRepo = ShareRepo(ShareRemoteDataSource());
  c.shareeRepo = ShareeRepo(ShareeRemoteDataSource());
  c.favoriteRepo = const FavoriteRepo(FavoriteRemoteDataSource());
  c.tagRepo = const TagRepo(TagRemoteDataSource());
  c.tagRepoRemote = const TagRepo(TagRemoteDataSource());
  c.tagRepoLocal = TagRepo(TagSqliteDbDataSource(c.npDb));
  c.taggedFileRepo = const TaggedFileRepo(TaggedFileRemoteDataSource());
  c.searchRepo = SearchRepo(SearchSqliteDbDataSource(c));
  c.ncAlbumRepo = CachedNcAlbumRepo(
    const NcAlbumRemoteDataSource(),
    NcAlbumSqliteDbDataSource(c.npDb),
  );
  c.ncAlbumRepoRemote = const BasicNcAlbumRepo(NcAlbumRemoteDataSource());
  c.ncAlbumRepoLocal = BasicNcAlbumRepo(NcAlbumSqliteDbDataSource(c.npDb));
  c.faceRecognitionPersonRepo = const BasicFaceRecognitionPersonRepo(
    FaceRecognitionPersonRemoteDataSource(),
  );
  c.faceRecognitionPersonRepoRemote = const BasicFaceRecognitionPersonRepo(
    FaceRecognitionPersonRemoteDataSource(),
  );
  c.faceRecognitionPersonRepoLocal = BasicFaceRecognitionPersonRepo(
    FaceRecognitionPersonSqliteDbDataSource(c.npDb),
  );
  c.recognizeFaceRepo = const BasicRecognizeFaceRepo(
    RecognizeFaceRemoteDataSource(),
  );
  c.recognizeFaceRepoRemote = const BasicRecognizeFaceRepo(
    RecognizeFaceRemoteDataSource(),
  );
  c.recognizeFaceRepoLocal = BasicRecognizeFaceRepo(
    RecognizeFaceSqliteDbDataSource(c.npDb),
  );
  c.imageLocationRepo = BasicImageLocationRepo(
    ImageLocationNpDbDataSource(c.npDb),
  );

  c.touchManager = TouchManager(c);

  if (getRawPlatform() == NpPlatform.android) {
    // local file currently only supported on Android
    c.localFileRepo = const LocalFileRepo(LocalFileMediaStoreDataSource());
  }

  KiwiContainer().registerInstance<DiContainer>(c);
}

void _initVisibilityDetector() {
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
}

Future<void> _initRefreshRate() async {
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e, stackTrace) {
    _log.severe(
      "[_initRefreshRate] Failed while setHighRefreshRate",
      e,
      stackTrace,
    );
  }
}

Future<NpDb> _createDb(InitIsolateType isolateType) async {
  final npDb = NpDb();
  final androidSdk =
      getRawPlatform() == NpPlatform.android ? AndroidInfo().sdkInt : null;
  if (isolateType == InitIsolateType.main) {
    await npDb.initMainIsolate(androidSdk: androidSdk);
  } else {
    await npDb.initBackgroundIsolate(androidSdk: androidSdk);
  }
  return npDb;
}

Future<Pref> _createSecurePref() async {
  final provider = PrefSecureStorageProvider();
  await provider.init();
  return Pref.scoped(provider);
}

Future<InitializationStatus> _initAds() {
  return MobileAds.instance.initialize();
}

final _log = Logger("app_init");
var _hasInitedInThisIsolate = false;
