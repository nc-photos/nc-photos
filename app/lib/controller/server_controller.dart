import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/entity/server_status.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'server_controller.g.dart';

enum ServerFeature { ncAlbum, ncMetadata }

@npLog
class ServerController {
  ServerController({
    required this.account,
    required this.accountPrefController,
  });

  void dispose() {
    _statusStreamContorller.close();
  }

  ValueStream<ServerStatus> get status {
    if (!_statusStreamContorller.hasValue) {
      unawaited(_load());
    }
    return _statusStreamContorller.stream;
  }

  Future<void> _load() => _getStatus();

  Future<void> _getStatus() async {
    try {
      final response = await ApiUtil.fromAccount(account).status().get();
      if (!response.isGood) {
        _log.severe("[_getStatus] Failed requesting server: $response");
        _loadStatus();
        return;
      }
      final apiStatus = await api.StatusParser().parse(response.body);
      final status = ApiStatusConverter.fromApi(apiStatus);
      _log.info("[_getStatus] Server status: $status");
      _statusStreamContorller.add(status);
      _saveStatus(status);
    } catch (e, stackTrace) {
      _log.severe("[_getStatus] Failed while get", e, stackTrace);
      _loadStatus();
      return;
    }
  }

  void _loadStatus() {
    final cache = accountPrefController.serverStatusValue;
    if (cache != null) {
      _statusStreamContorller.add(cache);
    }
  }

  void _saveStatus(ServerStatus status) {
    final cache = accountPrefController.serverStatusValue;
    if (cache != status) {
      accountPrefController.setServerStatus(status);
    }
  }

  final Account account;
  final AccountPrefController accountPrefController;

  final _statusStreamContorller = BehaviorSubject<ServerStatus>();
}

extension ServerControllerExtension on ServerController {
  bool isSupported(ServerFeature feature) {
    final status = _statusStreamContorller.valueOrNull;
    switch (feature) {
      case ServerFeature.ncAlbum:
        return status == null || status.majorVersion >= 25;
      case ServerFeature.ncMetadata:
        return status != null && status.majorVersion >= 28;
    }
  }
}
