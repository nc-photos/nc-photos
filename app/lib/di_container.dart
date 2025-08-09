import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/repo2.dart';
import 'package:nc_photos/entity/face_recognition_person/repo.dart';
import 'package:nc_photos/entity/favorite.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/image_location/repo.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/entity/nc_album/repo.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/recognize_face/repo.dart';
import 'package:nc_photos/entity/search.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/tagged_file.dart';
import 'package:nc_photos/touch_manager.dart';
import 'package:np_common/or_null.dart';
import 'package:np_db/np_db.dart';

enum DiType {
  albumRepo,
  albumRepoRemote,
  albumRepoLocal,
  albumRepo2,
  albumRepo2Remote,
  albumRepo2Local,
  fileRepo,
  fileRepoRemote,
  fileRepoLocal,
  fileRepo2,
  fileRepo2Remote,
  fileRepo2Local,
  shareRepo,
  shareeRepo,
  favoriteRepo,
  tagRepo,
  tagRepoRemote,
  tagRepoLocal,
  taggedFileRepo,
  localFileRepo,
  searchRepo,
  ncAlbumRepo,
  ncAlbumRepoRemote,
  ncAlbumRepoLocal,
  faceRecognitionPersonRepo,
  faceRecognitionPersonRepoRemote,
  faceRecognitionPersonRepoLocal,
  recognizeFaceRepo,
  recognizeFaceRepoRemote,
  recognizeFaceRepoLocal,
  imageLocationRepo,
  pref,
  touchManager,
  npDb,
  securePref,
}

class DiContainer {
  DiContainer({
    AlbumRepo? albumRepo,
    AlbumRepo? albumRepoRemote,
    AlbumRepo? albumRepoLocal,
    AlbumRepo2? albumRepo2,
    AlbumRepo2? albumRepo2Remote,
    AlbumRepo2? albumRepo2Local,
    FileRepo? fileRepo,
    FileRepo? fileRepoRemote,
    FileRepo? fileRepoLocal,
    FileRepo2? fileRepo2,
    FileRepo2? fileRepo2Remote,
    FileRepo2? fileRepo2Local,
    ShareRepo? shareRepo,
    ShareeRepo? shareeRepo,
    FavoriteRepo? favoriteRepo,
    TagRepo? tagRepo,
    TagRepo? tagRepoRemote,
    TagRepo? tagRepoLocal,
    TaggedFileRepo? taggedFileRepo,
    LocalFileRepo? localFileRepo,
    SearchRepo? searchRepo,
    NcAlbumRepo? ncAlbumRepo,
    NcAlbumRepo? ncAlbumRepoRemote,
    NcAlbumRepo? ncAlbumRepoLocal,
    FaceRecognitionPersonRepo? faceRecognitionPersonRepo,
    FaceRecognitionPersonRepo? faceRecognitionPersonRepoRemote,
    FaceRecognitionPersonRepo? faceRecognitionPersonRepoLocal,
    RecognizeFaceRepo? recognizeFaceRepo,
    RecognizeFaceRepo? recognizeFaceRepoRemote,
    RecognizeFaceRepo? recognizeFaceRepoLocal,
    ImageLocationRepo? imageLocationRepo,
    Pref? pref,
    TouchManager? touchManager,
    NpDb? npDb,
    Pref? securePref,
  }) : _albumRepo = albumRepo,
       _albumRepoRemote = albumRepoRemote,
       _albumRepoLocal = albumRepoLocal,
       _albumRepo2 = albumRepo2,
       _albumRepo2Remote = albumRepo2Remote,
       _albumRepo2Local = albumRepo2Local,
       _fileRepo = fileRepo,
       _fileRepoRemote = fileRepoRemote,
       _fileRepoLocal = fileRepoLocal,
       _fileRepo2 = fileRepo2,
       _fileRepo2Remote = fileRepo2Remote,
       _fileRepo2Local = fileRepo2Local,
       _shareRepo = shareRepo,
       _shareeRepo = shareeRepo,
       _favoriteRepo = favoriteRepo,
       _tagRepo = tagRepo,
       _tagRepoRemote = tagRepoRemote,
       _tagRepoLocal = tagRepoLocal,
       _taggedFileRepo = taggedFileRepo,
       _localFileRepo = localFileRepo,
       _searchRepo = searchRepo,
       _ncAlbumRepo = ncAlbumRepo,
       _ncAlbumRepoRemote = ncAlbumRepoRemote,
       _ncAlbumRepoLocal = ncAlbumRepoLocal,
       _faceRecognitionPersonRepo = faceRecognitionPersonRepo,
       _faceRecognitionPersonRepoRemote = faceRecognitionPersonRepoRemote,
       _faceRecognitionPersonRepoLocal = faceRecognitionPersonRepoLocal,
       _recognizeFaceRepo = recognizeFaceRepo,
       _recognizeFaceRepoRemote = recognizeFaceRepoRemote,
       _recognizeFaceRepoLocal = recognizeFaceRepoLocal,
       _imageLocationRepo = imageLocationRepo,
       _pref = pref,
       _touchManager = touchManager,
       _npDb = npDb,
       _securePref = securePref;

  DiContainer.late();

  static bool has(DiContainer contianer, DiType type) {
    switch (type) {
      case DiType.albumRepo:
        return contianer._albumRepo != null;
      case DiType.albumRepoRemote:
        return contianer._albumRepoRemote != null;
      case DiType.albumRepoLocal:
        return contianer._albumRepoLocal != null;
      case DiType.albumRepo2:
        return contianer._albumRepo2 != null;
      case DiType.albumRepo2Remote:
        return contianer._albumRepo2Remote != null;
      case DiType.albumRepo2Local:
        return contianer._albumRepo2Local != null;
      case DiType.fileRepo:
        return contianer._fileRepo != null;
      case DiType.fileRepoRemote:
        return contianer._fileRepoRemote != null;
      case DiType.fileRepoLocal:
        return contianer._fileRepoLocal != null;
      case DiType.fileRepo2:
        return contianer._fileRepo2 != null;
      case DiType.fileRepo2Remote:
        return contianer._fileRepo2Remote != null;
      case DiType.fileRepo2Local:
        return contianer._fileRepo2Local != null;
      case DiType.shareRepo:
        return contianer._shareRepo != null;
      case DiType.shareeRepo:
        return contianer._shareeRepo != null;
      case DiType.favoriteRepo:
        return contianer._favoriteRepo != null;
      case DiType.tagRepo:
        return contianer._tagRepo != null;
      case DiType.tagRepoRemote:
        return contianer._tagRepoRemote != null;
      case DiType.tagRepoLocal:
        return contianer._tagRepoLocal != null;
      case DiType.taggedFileRepo:
        return contianer._taggedFileRepo != null;
      case DiType.localFileRepo:
        return contianer._localFileRepo != null;
      case DiType.searchRepo:
        return contianer._searchRepo != null;
      case DiType.ncAlbumRepo:
        return contianer._ncAlbumRepo != null;
      case DiType.ncAlbumRepoRemote:
        return contianer._ncAlbumRepoRemote != null;
      case DiType.ncAlbumRepoLocal:
        return contianer._ncAlbumRepoLocal != null;
      case DiType.faceRecognitionPersonRepo:
        return contianer._faceRecognitionPersonRepo != null;
      case DiType.faceRecognitionPersonRepoRemote:
        return contianer._faceRecognitionPersonRepoRemote != null;
      case DiType.faceRecognitionPersonRepoLocal:
        return contianer._faceRecognitionPersonRepoLocal != null;
      case DiType.recognizeFaceRepo:
        return contianer._recognizeFaceRepo != null;
      case DiType.recognizeFaceRepoRemote:
        return contianer._recognizeFaceRepoRemote != null;
      case DiType.recognizeFaceRepoLocal:
        return contianer._recognizeFaceRepoLocal != null;
      case DiType.imageLocationRepo:
        return contianer._imageLocationRepo != null;
      case DiType.pref:
        return contianer._pref != null;
      case DiType.touchManager:
        return contianer._touchManager != null;
      case DiType.npDb:
        return contianer._npDb != null;
      case DiType.securePref:
        return contianer._securePref != null;
    }
  }

  DiContainer copyWith({
    OrNull<AlbumRepo>? albumRepo,
    OrNull<AlbumRepo2>? albumRepo2,
    OrNull<FileRepo>? fileRepo,
    OrNull<FileRepo2>? fileRepo2,
    OrNull<ShareRepo>? shareRepo,
    OrNull<ShareeRepo>? shareeRepo,
    OrNull<FavoriteRepo>? favoriteRepo,
    OrNull<TagRepo>? tagRepo,
    OrNull<TaggedFileRepo>? taggedFileRepo,
    OrNull<LocalFileRepo>? localFileRepo,
    OrNull<SearchRepo>? searchRepo,
    OrNull<NcAlbumRepo>? ncAlbumRepo,
    OrNull<FaceRecognitionPersonRepo>? faceRecognitionPersonRepo,
    OrNull<RecognizeFaceRepo>? recognizeFaceRepo,
    OrNull<ImageLocationRepo>? imageLocationRepo,
    OrNull<Pref>? pref,
    OrNull<TouchManager>? touchManager,
    OrNull<NpDb>? npDb,
    OrNull<Pref>? securePref,
  }) {
    return DiContainer(
      albumRepo: albumRepo == null ? _albumRepo : albumRepo.obj,
      albumRepo2: albumRepo2 == null ? _albumRepo2 : albumRepo2.obj,
      fileRepo: fileRepo == null ? _fileRepo : fileRepo.obj,
      fileRepo2: fileRepo2 == null ? _fileRepo2 : fileRepo2.obj,
      shareRepo: shareRepo == null ? _shareRepo : shareRepo.obj,
      shareeRepo: shareeRepo == null ? _shareeRepo : shareeRepo.obj,
      favoriteRepo: favoriteRepo == null ? _favoriteRepo : favoriteRepo.obj,
      tagRepo: tagRepo == null ? _tagRepo : tagRepo.obj,
      taggedFileRepo:
          taggedFileRepo == null ? _taggedFileRepo : taggedFileRepo.obj,
      localFileRepo: localFileRepo == null ? _localFileRepo : localFileRepo.obj,
      searchRepo: searchRepo == null ? _searchRepo : searchRepo.obj,
      ncAlbumRepo: ncAlbumRepo == null ? _ncAlbumRepo : ncAlbumRepo.obj,
      faceRecognitionPersonRepo:
          faceRecognitionPersonRepo == null
              ? _faceRecognitionPersonRepo
              : faceRecognitionPersonRepo.obj,
      recognizeFaceRepo:
          recognizeFaceRepo == null
              ? _recognizeFaceRepo
              : recognizeFaceRepo.obj,
      imageLocationRepo:
          imageLocationRepo == null
              ? _imageLocationRepo
              : imageLocationRepo.obj,
      pref: pref == null ? _pref : pref.obj,
      touchManager: touchManager == null ? _touchManager : touchManager.obj,
      npDb: npDb == null ? _npDb : npDb.obj,
      securePref: securePref == null ? _securePref : securePref.obj,
    );
  }

  AlbumRepo get albumRepo => _albumRepo!;
  AlbumRepo get albumRepoRemote => _albumRepoRemote!;
  AlbumRepo get albumRepoLocal => _albumRepoLocal!;
  AlbumRepo2 get albumRepo2 => _albumRepo2!;
  AlbumRepo2 get albumRepo2Remote => _albumRepo2Remote!;
  AlbumRepo2 get albumRepo2Local => _albumRepo2Local!;
  FileRepo get fileRepo => _fileRepo!;
  FileRepo get fileRepoRemote => _fileRepoRemote!;
  FileRepo get fileRepoLocal => _fileRepoLocal!;
  FileRepo2 get fileRepo2 => _fileRepo2!;
  FileRepo2 get fileRepo2Remote => _fileRepo2Remote!;
  FileRepo2 get fileRepo2Local => _fileRepo2Local!;
  ShareRepo get shareRepo => _shareRepo!;
  ShareeRepo get shareeRepo => _shareeRepo!;
  FavoriteRepo get favoriteRepo => _favoriteRepo!;
  TagRepo get tagRepo => _tagRepo!;
  TagRepo get tagRepoRemote => _tagRepoRemote!;
  TagRepo get tagRepoLocal => _tagRepoLocal!;
  TaggedFileRepo get taggedFileRepo => _taggedFileRepo!;
  LocalFileRepo get localFileRepo => _localFileRepo!;
  SearchRepo get searchRepo => _searchRepo!;
  NcAlbumRepo get ncAlbumRepo => _ncAlbumRepo!;
  NcAlbumRepo get ncAlbumRepoRemote => _ncAlbumRepoRemote!;
  NcAlbumRepo get ncAlbumRepoLocal => _ncAlbumRepoLocal!;
  FaceRecognitionPersonRepo get faceRecognitionPersonRepo =>
      _faceRecognitionPersonRepo!;
  FaceRecognitionPersonRepo get faceRecognitionPersonRepoRemote =>
      _faceRecognitionPersonRepoRemote!;
  FaceRecognitionPersonRepo get faceRecognitionPersonRepoLocal =>
      _faceRecognitionPersonRepoLocal!;
  RecognizeFaceRepo get recognizeFaceRepo => _recognizeFaceRepo!;
  RecognizeFaceRepo get recognizeFaceRepoRemote => _recognizeFaceRepoRemote!;
  RecognizeFaceRepo get recognizeFaceRepoLocal => _recognizeFaceRepoLocal!;
  ImageLocationRepo get imageLocationRepo => _imageLocationRepo!;

  Pref get pref => _pref!;
  TouchManager get touchManager => _touchManager!;
  NpDb get npDb => _npDb!;
  Pref get securePref => _securePref!;

  set albumRepo(AlbumRepo v) {
    assert(_albumRepo == null);
    _albumRepo = v;
  }

  set albumRepoRemote(AlbumRepo v) {
    assert(_albumRepoRemote == null);
    _albumRepoRemote = v;
  }

  set albumRepoLocal(AlbumRepo v) {
    assert(_albumRepoLocal == null);
    _albumRepoLocal = v;
  }

  set albumRepo2(AlbumRepo2 v) {
    assert(_albumRepo2 == null);
    _albumRepo2 = v;
  }

  set albumRepo2Remote(AlbumRepo2 v) {
    assert(_albumRepo2Remote == null);
    _albumRepo2Remote = v;
  }

  set albumRepo2Local(AlbumRepo2 v) {
    assert(_albumRepo2Local == null);
    _albumRepo2Local = v;
  }

  set fileRepo(FileRepo v) {
    assert(_fileRepo == null);
    _fileRepo = v;
  }

  set fileRepoRemote(FileRepo v) {
    assert(_fileRepoRemote == null);
    _fileRepoRemote = v;
  }

  set fileRepoLocal(FileRepo v) {
    assert(_fileRepoLocal == null);
    _fileRepoLocal = v;
  }

  set fileRepo2(FileRepo2 v) {
    assert(_fileRepo2 == null);
    _fileRepo2 = v;
  }

  set fileRepo2Remote(FileRepo2 v) {
    assert(_fileRepo2Remote == null);
    _fileRepo2Remote = v;
  }

  set fileRepo2Local(FileRepo2 v) {
    assert(_fileRepo2Local == null);
    _fileRepo2Local = v;
  }

  set shareRepo(ShareRepo v) {
    assert(_shareRepo == null);
    _shareRepo = v;
  }

  set shareeRepo(ShareeRepo v) {
    assert(_shareeRepo == null);
    _shareeRepo = v;
  }

  set favoriteRepo(FavoriteRepo v) {
    assert(_favoriteRepo == null);
    _favoriteRepo = v;
  }

  set tagRepo(TagRepo v) {
    assert(_tagRepo == null);
    _tagRepo = v;
  }

  set tagRepoRemote(TagRepo v) {
    assert(_tagRepoRemote == null);
    _tagRepoRemote = v;
  }

  set tagRepoLocal(TagRepo v) {
    assert(_tagRepoLocal == null);
    _tagRepoLocal = v;
  }

  set taggedFileRepo(TaggedFileRepo v) {
    assert(_taggedFileRepo == null);
    _taggedFileRepo = v;
  }

  set localFileRepo(LocalFileRepo v) {
    assert(_localFileRepo == null);
    _localFileRepo = v;
  }

  set searchRepo(SearchRepo v) {
    assert(_searchRepo == null);
    _searchRepo = v;
  }

  set ncAlbumRepo(NcAlbumRepo v) {
    assert(_ncAlbumRepo == null);
    _ncAlbumRepo = v;
  }

  set ncAlbumRepoRemote(NcAlbumRepo v) {
    assert(_ncAlbumRepoRemote == null);
    _ncAlbumRepoRemote = v;
  }

  set ncAlbumRepoLocal(NcAlbumRepo v) {
    assert(_ncAlbumRepoLocal == null);
    _ncAlbumRepoLocal = v;
  }

  set faceRecognitionPersonRepo(FaceRecognitionPersonRepo v) {
    assert(_faceRecognitionPersonRepo == null);
    _faceRecognitionPersonRepo = v;
  }

  set faceRecognitionPersonRepoRemote(FaceRecognitionPersonRepo v) {
    assert(_faceRecognitionPersonRepoRemote == null);
    _faceRecognitionPersonRepoRemote = v;
  }

  set faceRecognitionPersonRepoLocal(FaceRecognitionPersonRepo v) {
    assert(_faceRecognitionPersonRepoLocal == null);
    _faceRecognitionPersonRepoLocal = v;
  }

  set recognizeFaceRepo(RecognizeFaceRepo v) {
    assert(_recognizeFaceRepo == null);
    _recognizeFaceRepo = v;
  }

  set recognizeFaceRepoRemote(RecognizeFaceRepo v) {
    assert(_recognizeFaceRepoRemote == null);
    _recognizeFaceRepoRemote = v;
  }

  set recognizeFaceRepoLocal(RecognizeFaceRepo v) {
    assert(_recognizeFaceRepoLocal == null);
    _recognizeFaceRepoLocal = v;
  }

  set imageLocationRepo(ImageLocationRepo v) {
    assert(_imageLocationRepo == null);
    _imageLocationRepo = v;
  }

  set pref(Pref v) {
    assert(_pref == null);
    _pref = v;
  }

  set touchManager(TouchManager v) {
    assert(_touchManager == null);
    _touchManager = v;
  }

  set npDb(NpDb v) {
    assert(_npDb == null);
    _npDb = v;
  }

  set securePref(Pref v) {
    assert(_securePref == null);
    _securePref = v;
  }

  AlbumRepo? _albumRepo;
  AlbumRepo? _albumRepoRemote;
  // Explicitly request a AlbumRepo backed by local source
  AlbumRepo? _albumRepoLocal;
  AlbumRepo2? _albumRepo2;
  AlbumRepo2? _albumRepo2Remote;
  AlbumRepo2? _albumRepo2Local;
  FileRepo? _fileRepo;
  // Explicitly request a FileRepo backed by remote source
  FileRepo? _fileRepoRemote;
  // Explicitly request a FileRepo backed by local source
  FileRepo? _fileRepoLocal;
  FileRepo2? _fileRepo2;
  FileRepo2? _fileRepo2Remote;
  FileRepo2? _fileRepo2Local;
  ShareRepo? _shareRepo;
  ShareeRepo? _shareeRepo;
  FavoriteRepo? _favoriteRepo;
  TagRepo? _tagRepo;
  TagRepo? _tagRepoRemote;
  TagRepo? _tagRepoLocal;
  TaggedFileRepo? _taggedFileRepo;
  LocalFileRepo? _localFileRepo;
  SearchRepo? _searchRepo;
  NcAlbumRepo? _ncAlbumRepo;
  NcAlbumRepo? _ncAlbumRepoRemote;
  NcAlbumRepo? _ncAlbumRepoLocal;
  FaceRecognitionPersonRepo? _faceRecognitionPersonRepo;
  FaceRecognitionPersonRepo? _faceRecognitionPersonRepoRemote;
  FaceRecognitionPersonRepo? _faceRecognitionPersonRepoLocal;
  RecognizeFaceRepo? _recognizeFaceRepo;
  RecognizeFaceRepo? _recognizeFaceRepoRemote;
  RecognizeFaceRepo? _recognizeFaceRepoLocal;
  ImageLocationRepo? _imageLocationRepo;

  Pref? _pref;
  TouchManager? _touchManager;
  NpDb? _npDb;
  Pref? _securePref;
}

extension DiContainerExtension on DiContainer {
  /// Uses remote repo if available
  ///
  /// Notice that not all repo support this
  DiContainer withRemoteRepo() => copyWith(
    albumRepo: OrNull(_albumRepoRemote),
    albumRepo2: OrNull(_albumRepo2Remote),
    fileRepo: OrNull(_fileRepoRemote),
    tagRepo: OrNull(_tagRepoRemote),
    ncAlbumRepo: OrNull(_ncAlbumRepoRemote),
    faceRecognitionPersonRepo: OrNull(_faceRecognitionPersonRepoRemote),
    recognizeFaceRepo: OrNull(_recognizeFaceRepoRemote),
  );

  /// Uses local repo if available
  ///
  /// Notice that not all repo support this
  DiContainer withLocalRepo() => copyWith(
    albumRepo: OrNull(_albumRepoLocal),
    albumRepo2: OrNull(_albumRepo2Local),
    fileRepo: OrNull(_fileRepoLocal),
    tagRepo: OrNull(_tagRepoLocal),
    ncAlbumRepo: OrNull(_ncAlbumRepoLocal),
    faceRecognitionPersonRepo: OrNull(_faceRecognitionPersonRepoLocal),
    recognizeFaceRepo: OrNull(_recognizeFaceRepoLocal),
  );

  DiContainer withLocalAlbumRepo() =>
      copyWith(albumRepo: OrNull(albumRepoLocal));
  DiContainer withRemoteFileRepo() =>
      copyWith(fileRepo: OrNull(fileRepoRemote));
  DiContainer withLocalFileRepo() => copyWith(fileRepo: OrNull(fileRepoLocal));
  DiContainer withRemoteTagRepo() => copyWith(tagRepo: OrNull(tagRepoRemote));
  DiContainer withLocalTagRepo() => copyWith(tagRepo: OrNull(tagRepoLocal));
}
