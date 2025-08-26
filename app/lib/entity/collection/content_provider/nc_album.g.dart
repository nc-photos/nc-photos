// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nc_album.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $CollectionNcAlbumProviderCopyWithWorker {
  CollectionNcAlbumProvider call({Account? account, NcAlbum? album});
}

class _$CollectionNcAlbumProviderCopyWithWorkerImpl
    implements $CollectionNcAlbumProviderCopyWithWorker {
  _$CollectionNcAlbumProviderCopyWithWorkerImpl(this.that);

  @override
  CollectionNcAlbumProvider call({dynamic account, dynamic album}) {
    return CollectionNcAlbumProvider(
      account: account as Account? ?? that.account,
      album: album as NcAlbum? ?? that.album,
    );
  }

  final CollectionNcAlbumProvider that;
}

extension $CollectionNcAlbumProviderCopyWith on CollectionNcAlbumProvider {
  $CollectionNcAlbumProviderCopyWithWorker get copyWith => _$copyWith;
  $CollectionNcAlbumProviderCopyWithWorker get _$copyWith =>
      _$CollectionNcAlbumProviderCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$CollectionNcAlbumProviderToString on CollectionNcAlbumProvider {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "CollectionNcAlbumProvider {account: $account, album: $album}";
  }
}
