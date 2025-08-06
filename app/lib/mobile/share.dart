import 'package:nc_photos/mobile/android/share.dart';
import 'package:nc_photos/platform/share.dart' as itf;

class AndroidFileShareFile {
  const AndroidFileShareFile(this.fileUri, this.mimeType);

  final String fileUri;
  final String? mimeType;
}

class AndroidFileShare implements itf.FileShare {
  const AndroidFileShare(this.files);

  @override
  Future<void> share() {
    final uris = files.map((e) => e.fileUri).toList();
    final mimes = files.map((e) => e.mimeType).toList();
    return Share.shareItems(uris, mimes);
  }

  Future<void> setAs() {
    assert(files.length == 1);
    return Share.shareAsAttachData(files.first.fileUri, files.first.mimeType);
  }

  final List<AndroidFileShareFile> files;
}

class AndroidTextShare extends itf.TextShare {
  AndroidTextShare(this.text, {this.mimeType = "text/plain"});

  @override
  share() {
    return Share.shareText(text, mimeType);
  }

  final String text;
  final String? mimeType;
}
