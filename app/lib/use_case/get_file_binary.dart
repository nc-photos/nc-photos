import 'dart:typed_data';

import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';

class GetFileBinary {
  GetFileBinary(this.fileRepo);

  /// Get the binary content of a file
  Future<Uint8List> call(Account account, FileDescriptor file) =>
      fileRepo.getBinary(account, file);

  final FileRepo fileRepo;
}
