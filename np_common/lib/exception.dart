/// Platform permission is not granted by user
class PermissionException implements Exception {
  const PermissionException([this.message]);

  @override
  String toString() {
    if (message == null) {
      return "PermissionException";
    } else {
      return "PermissionException: $message";
    }
  }

  final dynamic message;
}

class FileNotFoundException implements Exception {
  const FileNotFoundException([this.message]);

  @override
  String toString() {
    if (message == null) {
      return "FileNotFoundException";
    } else {
      return "FileNotFoundException: $message";
    }
  }

  final dynamic message;
}
