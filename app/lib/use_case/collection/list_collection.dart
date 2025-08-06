import 'dart:async';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/builder.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/use_case/album/list_album2.dart';
import 'package:nc_photos/use_case/nc_album/list_nc_album.dart';

class ListCollection {
  ListCollection(this._c, {required this.serverController})
    : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.albumRepo2) &&
      DiContainer.has(c, DiType.ncAlbumRepo);

  Stream<List<Collection>> call(Account account) {
    final controller = StreamController<List<Collection>>();
    var albums = <Album>[];
    var isAlbumDone = false;
    var ncAlbums = <NcAlbum>[];
    var isNcAlbumDone = false;

    void notify() {
      controller.add([
        ...albums.map((a) => CollectionBuilder.byAlbum(account, a)),
        ...ncAlbums.map((a) => CollectionBuilder.byNcAlbum(account, a)),
      ]);
    }

    void onDone() {
      if (isAlbumDone && isNcAlbumDone) {
        controller.close();
      }
    }

    ListAlbum2(_c)(account).listen(
      (event) {
        albums = event;
        notify();
      },
      onDone: () {
        isAlbumDone = true;
        onDone();
      },
      onError: (e, stackTrace) {
        controller.addError(e, stackTrace);
        isAlbumDone = true;
        onDone();
      },
    );
    if (!serverController.isSupported(ServerFeature.ncAlbum)) {
      isNcAlbumDone = true;
    } else {
      ListNcAlbum(_c)(account).listen(
        (event) {
          ncAlbums = event;
          notify();
        },
        onDone: () {
          isNcAlbumDone = true;
          onDone();
        },
        onError: (e, stackTrace) {
          controller.addError(e, stackTrace);
          isNcAlbumDone = true;
          onDone();
        },
      );
    }
    return controller.stream;
  }

  final DiContainer _c;
  final ServerController serverController;
}
