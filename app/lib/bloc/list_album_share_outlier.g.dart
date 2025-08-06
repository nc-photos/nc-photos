// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_album_share_outlier.dart';

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$ListAlbumShareOutlierBlocNpLog on ListAlbumShareOutlierBloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "bloc.list_album_share_outlier.ListAlbumShareOutlierBloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$ListAlbumShareOutlierItemToString on ListAlbumShareOutlierItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ListAlbumShareOutlierItem {file: ${file.fdPath}, shareItems: ${shareItems.toReadableString()}}";
  }
}

extension _$ListAlbumShareOutlierExtraShareItemToString
    on ListAlbumShareOutlierExtraShareItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ListAlbumShareOutlierExtraShareItem {share: $share}";
  }
}

extension _$ListAlbumShareOutlierMissingShareItemToString
    on ListAlbumShareOutlierMissingShareItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ListAlbumShareOutlierMissingShareItem {shareWith: $shareWith, shareWithDisplayName: $shareWithDisplayName}";
  }
}

extension _$ListAlbumShareOutlierBlocQueryToString
    on ListAlbumShareOutlierBlocQuery {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ListAlbumShareOutlierBlocQuery {account: $account, album: $album}";
  }
}

extension _$ListAlbumShareOutlierBlocStateToString
    on ListAlbumShareOutlierBlocState {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "${objectRuntimeType(this, "ListAlbumShareOutlierBlocState")} {account: $account, items: ${items.toReadableString()}}";
  }
}

extension _$ListAlbumShareOutlierBlocFailureToString
    on ListAlbumShareOutlierBlocFailure {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ListAlbumShareOutlierBlocFailure {account: $account, items: ${items.toReadableString()}, exception: $exception}";
  }
}
