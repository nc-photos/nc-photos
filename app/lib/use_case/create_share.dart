import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';

class CreateUserShare {
  const CreateUserShare(this.shareRepo);

  Future<Share> call(Account account, FileDescriptor file, String shareWith) =>
      shareRepo.create(account, file, shareWith);

  final ShareRepo shareRepo;
}

class CreateLinkShare {
  const CreateLinkShare(this.shareRepo);

  Future<Share> call(
    Account account,
    String relativePath, {
    String? password,
  }) => shareRepo.createLink(account, relativePath, password: password);

  Future<Share> fromFile(
    Account account,
    FileDescriptor file, {
    String? password,
  }) => shareRepo.createLink(account, file.strippedPath, password: password);

  final ShareRepo shareRepo;
}
