// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_pref_controller.dart';

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$AccountPrefControllerNpLog on AccountPrefController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "controller.account_pref_controller.AccountPrefController",
  );
}

// **************************************************************************
// NpSubjectAccessorGenerator
// **************************************************************************

extension $AccountPrefControllerNpSubjectAccessor on AccountPrefController {
  // _shareFolderController
  ValueStream<String> get shareFolder => _shareFolderController.stream;
  Stream<String> get shareFolderNew => shareFolder.skip(1);
  Stream<String> get shareFolderChange => shareFolder.distinct().skip(1);
  String get shareFolderValue => _shareFolderController.value;
  // _accountLabelController
  ValueStream<String?> get accountLabel => _accountLabelController.stream;
  Stream<String?> get accountLabelNew => accountLabel.skip(1);
  Stream<String?> get accountLabelChange => accountLabel.distinct().skip(1);
  String? get accountLabelValue => _accountLabelController.value;
  // _personProviderController
  ValueStream<PersonProvider> get personProvider =>
      _personProviderController.stream;
  Stream<PersonProvider> get personProviderNew => personProvider.skip(1);
  Stream<PersonProvider> get personProviderChange =>
      personProvider.distinct().skip(1);
  PersonProvider get personProviderValue => _personProviderController.value;
  // _isEnableMemoryAlbumController
  ValueStream<bool> get isEnableMemoryAlbum =>
      _isEnableMemoryAlbumController.stream;
  Stream<bool> get isEnableMemoryAlbumNew => isEnableMemoryAlbum.skip(1);
  Stream<bool> get isEnableMemoryAlbumChange =>
      isEnableMemoryAlbum.distinct().skip(1);
  bool get isEnableMemoryAlbumValue => _isEnableMemoryAlbumController.value;
  // _hasNewSharedAlbumController
  ValueStream<bool> get hasNewSharedAlbum =>
      _hasNewSharedAlbumController.stream;
  Stream<bool> get hasNewSharedAlbumNew => hasNewSharedAlbum.skip(1);
  Stream<bool> get hasNewSharedAlbumChange =>
      hasNewSharedAlbum.distinct().skip(1);
  bool get hasNewSharedAlbumValue => _hasNewSharedAlbumController.value;
  // _serverStatusController
  ValueStream<ServerStatus?> get serverStatus => _serverStatusController.stream;
  Stream<ServerStatus?> get serverStatusNew => serverStatus.skip(1);
  Stream<ServerStatus?> get serverStatusChange =>
      serverStatus.distinct().skip(1);
  ServerStatus? get serverStatusValue => _serverStatusController.value;
}
