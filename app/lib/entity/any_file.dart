/// Any files including local and remote files
abstract interface class AnyFile {
  String get afId;
  String get afName;
  String? get afMime;
  DateTime get afDateTime;
}
