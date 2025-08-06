import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'sharee.g.dart';

enum ShareeType {
  user,
  group,
  remote,
  remoteGroup,
  email,
  circle,
  room,
  deck,
  lookup,
}

@ToString(ignoreNull: true)
class Sharee with EquatableMixin {
  Sharee({
    required this.type,
    required this.label,
    required this.shareType,
    required this.shareWith,
    this.shareWithDisplayNameUnique,
  });

  @override
  String toString() => _$toString();

  @override
  get props => [type, label, shareType, shareWith, shareWithDisplayNameUnique];

  final ShareeType type;
  final String label;
  final int shareType;
  final CiString shareWith;
  final String? shareWithDisplayNameUnique;
}

class ShareeRepo {
  ShareeRepo(this.dataSrc);

  /// See [ShareeDataSource.list]
  Future<List<Sharee>> list(Account account) => dataSrc.list(account);

  final ShareeDataSource dataSrc;
}

abstract class ShareeDataSource {
  /// List all sharees of this account
  Future<List<Sharee>> list(Account account);
}
