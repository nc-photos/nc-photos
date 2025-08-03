import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/server_status.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'account_pref_controller.g.dart';
part 'account_pref_controller/util.dart';

@npLog
@npSubjectAccessor
class AccountPrefController {
  AccountPrefController({
    required this.account,
  }) : _accountPref = AccountPref.of(account);

  void dispose() {
    _shareFolderController.close();
    _accountLabelController.close();
    _personProviderController.close();
    _isEnableMemoryAlbumController.close();
  }

  Future<void> setShareFolder(String value) => _set<String>(
        controller: _shareFolderController,
        setter: (pref, value) => pref.setShareFolder(value),
        value: value,
      );

  Future<void> setAccountLabel(String? value) => _set<String?>(
        controller: _accountLabelController,
        setter: (pref, value) => pref.setAccountLabel(value),
        value: value,
      );

  Future<void> setPersonProvider(PersonProvider value) => _set<PersonProvider>(
        controller: _personProviderController,
        setter: (pref, value) => pref.setPersonProvider(value.index),
        value: value,
      );

  Future<void> setEnableMemoryAlbum(bool value) => _set<bool>(
        controller: _isEnableMemoryAlbumController,
        setter: (pref, value) => pref.setEnableMemoryAlbum(value),
        value: value,
      );

  Future<void> setNewSharedAlbum(bool value) => _set<bool>(
        controller: _hasNewSharedAlbumController,
        setter: (pref, value) => pref.setNewSharedAlbum(value),
        value: value,
      );

  Future<void> setServerStatus(ServerStatus value) => _set(
        controller: _serverStatusController,
        setter: (pref, value) =>
            pref.setServerStatus(jsonEncode(value!.toJson())),
        value: value,
      );

  Future<void> _set<T>({
    required BehaviorSubject<T> controller,
    required Future<bool> Function(AccountPref pref, T value) setter,
    required T value,
  }) async {
    final backup = controller.value;
    controller.add(value);
    try {
      if (!await setter(_accountPref, value)) {
        throw StateError("Unknown error");
      }
    } catch (e, stackTrace) {
      _log.severe("[_set] Failed setting preference", e, stackTrace);
      controller
        ..addError(e, stackTrace)
        ..add(backup);
    }
  }

  final Account account;

  final AccountPref _accountPref;
  @npSubjectAccessor
  late final _shareFolderController =
      BehaviorSubject.seeded(_accountPref.getShareFolderOr(""));
  @npSubjectAccessor
  late final _accountLabelController =
      BehaviorSubject.seeded(_accountPref.getAccountLabel());
  @npSubjectAccessor
  late final _personProviderController = BehaviorSubject.seeded(
      PersonProvider.fromValue(_accountPref.getPersonProviderOr()));
  @npSubjectAccessor
  late final _isEnableMemoryAlbumController =
      BehaviorSubject.seeded(_accountPref.isEnableMemoryAlbumOr(true));
  @npSubjectAccessor
  late final _hasNewSharedAlbumController =
      BehaviorSubject.seeded(_accountPref.hasNewSharedAlbum() ?? false);
  @npSubjectAccessor
  late final _serverStatusController = BehaviorSubject.seeded(_accountPref
      .getServerStatus()
      ?.let((e) => ServerStatus.fromJson(jsonDecode(e))));
}
