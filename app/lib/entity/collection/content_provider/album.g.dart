// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $CollectionAlbumProviderCopyWithWorker {
  CollectionAlbumProvider call({Account? account, Album? album});
}

class _$CollectionAlbumProviderCopyWithWorkerImpl
    implements $CollectionAlbumProviderCopyWithWorker {
  _$CollectionAlbumProviderCopyWithWorkerImpl(this.that);

  @override
  CollectionAlbumProvider call({dynamic account, dynamic album}) {
    return CollectionAlbumProvider(
      account: account as Account? ?? that.account,
      album: album as Album? ?? that.album,
    );
  }

  final CollectionAlbumProvider that;
}

extension $CollectionAlbumProviderCopyWith on CollectionAlbumProvider {
  $CollectionAlbumProviderCopyWithWorker get copyWith => _$copyWith;
  $CollectionAlbumProviderCopyWithWorker get _$copyWith =>
      _$CollectionAlbumProviderCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$CollectionAlbumProviderToString on CollectionAlbumProvider {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "CollectionAlbumProvider {account: $account, album: $album}";
  }
}
