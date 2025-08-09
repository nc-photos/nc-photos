import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:to_string/to_string.dart';

part 'tagged_file.g.dart';

@toString
class TaggedFile with EquatableMixin {
  const TaggedFile({required this.fileId});

  @override
  String toString() => _$toString();

  @override
  get props => [fileId];

  final int fileId;
}

class TaggedFileRepo {
  const TaggedFileRepo(this.dataSrc);

  /// See [TaggedFileDataSource.list]
  Future<List<TaggedFile>> list(Account account, File dir, List<Tag> tags) =>
      dataSrc.list(account, dir, tags);

  final TaggedFileDataSource dataSrc;
}

abstract class TaggedFileDataSource {
  /// List all files under [dir] that is associated with [tags]
  Future<List<TaggedFile>> list(Account account, File dir, List<Tag> tags);
}
