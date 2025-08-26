import 'dart:async';

import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/rx_extension.dart';
import 'package:np_collection/np_collection.dart';
import 'package:rxdart/rxdart.dart';

class TrustedCertControllerRemoveError extends Error {
  TrustedCertControllerRemoveError();
}

class TrustedCertController {
  TrustedCertController({required this.manager}) {
    _streamController.add(manager.whitelist);
  }

  ValueStream<List<CertInfo>> get stream => _streamController.stream;
  ValueStream<ExceptionEvent?> get errorStream => _errorStreamController.stream;

  Future<void> whitelistLastBadCert() async {
    final cert = await manager.whitelistLastBadCert();
    _streamController.addWithValue((value) => value.added(cert));
  }

  Future<void> remove(CertInfo cert) async {
    final result = await manager.removeFromWhitelist(cert);
    if (result) {
      _streamController.addWithValue((value) => value.removed(cert));
    } else {
      _errorStreamController.add(
        ExceptionEvent(TrustedCertControllerRemoveError()),
      );
    }
  }

  final SelfSignedCertManager manager;

  final _streamController = BehaviorSubject<List<CertInfo>>();
  final _errorStreamController = BehaviorSubject<ExceptionEvent?>.seeded(null);
}
