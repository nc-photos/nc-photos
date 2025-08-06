import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:to_string/to_string.dart';

part 'favorite.g.dart';

@toString
class Favorite with EquatableMixin {
  const Favorite({required this.fileId});

  @override
  String toString() => _$toString();

  Favorite copyWith({int? fileId}) => Favorite(fileId: fileId ?? this.fileId);

  @override
  get props => [fileId];

  final int fileId;
}

class FavoriteRepo {
  const FavoriteRepo(this.dataSrc);

  /// See [FavoriteDataSource.list]
  Future<List<Favorite>> list(Account account, File dir) =>
      dataSrc.list(account, dir);

  final FavoriteDataSource dataSrc;
}

abstract class FavoriteDataSource {
  /// List all favorites for a user under [dir]
  Future<List<Favorite>> list(Account account, File dir);
}
