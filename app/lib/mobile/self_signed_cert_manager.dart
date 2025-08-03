import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/mobile/android/self_signed_cert.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'self_signed_cert_manager.g.dart';

@npLog
class SelfSignedCertManager {
  factory SelfSignedCertManager() => _inst;

  SelfSignedCertManager._();

  Future<void> init() async {
    HttpOverrides.global = _CustomHttpOverrides();
    final infos = await _readAllCerts();
    _whitelist = infos;
  }

  /// Verify [cert] and return if it's registered in the whitelist for [host]
  bool verify(X509Certificate cert, String host, int port) {
    final fingerprint = _sha1BytesToString(cert.sha1);
    return _whitelist.any((info) =>
        fingerprint == info.sha1 &&
        host.toLowerCase() == info.host.toLowerCase());
  }

  bool get hasBadCert => _latestBadCert != null;

  String getLastBadCertHost() => _latestBadCert!.host;

  String getLastBadCertFingerprint() =>
      _sha1BytesToString(_latestBadCert!.cert.sha1);

  /// Whitelist the last bad cert
  Future<CertInfo> whitelistLastBadCert() async {
    final info = await _writeCert(_latestBadCert!.host, _latestBadCert!.cert);
    _whitelist.add(info);
    unawaited(SelfSignedCert.reload());
    return info;
  }

  /// Clear all whitelisted certs and they will no longer be allowed afterwards
  Future<void> clearWhitelist() async {
    final certDir = await _openCertsDir();
    await certDir.delete(recursive: true);
    _whitelist.clear();
    return SelfSignedCert.reload();
  }

  Future<bool> removeFromWhitelist(CertInfo cert) async {
    final certDir = await _openCertsDir();
    final certFiles = (await certDir.list().toList()).whereType<File>();
    for (final f in certFiles) {
      if (!f.path.endsWith(".json")) {
        continue;
      }
      try {
        final info = CertInfo.fromJson(jsonDecode(await f.readAsString()));
        if (info == cert) {
          final pemF = File(f.path.slice(0, -5));
          await Future.wait([f.delete(), pemF.delete()]);
          _log.info(
              "[removeFromWhitelist] File removed: ${f.path}, ${pemF.path}");
          unawaited(SelfSignedCert.reload());
          _whitelist.remove(cert);
          return true;
        }
      } catch (e, stacktrace) {
        _log.severe(
            "[removeFromWhitelist] Failed to read certificate file: ${path_lib.basename(f.path)}",
            e,
            stacktrace);
      }
    }
    return false;
  }

  List<CertInfo> get whitelist => _whitelist.toList();

  /// Read and return all persisted certificate infos
  Future<List<CertInfo>> _readAllCerts() async {
    final products = <CertInfo>[];
    final certDir = await _openCertsDir();
    final certFiles = (await certDir.list().toList()).whereType<File>();
    for (final f in certFiles) {
      if (!f.path.endsWith(".json")) {
        continue;
      }
      try {
        final info = CertInfo.fromJson(jsonDecode(await f.readAsString()));
        _log.info(
            "[_readAllCerts] Found certificate info: ${path_lib.basename(f.path)} for host: ${info.host}");
        products.add(info);
      } catch (e, stacktrace) {
        _log.severe(
            "[_readAllCerts] Failed to read certificate file: ${path_lib.basename(f.path)}",
            e,
            stacktrace);
      }
    }
    return products;
  }

  /// Persist a new cert and return the info object
  Future<CertInfo> _writeCert(String host, X509Certificate cert) async {
    final certDir = await _openCertsDir();
    while (true) {
      final fileName = const Uuid().v4();
      final certF = File("${certDir.path}/$fileName");
      if (await certF.exists()) {
        continue;
      }
      await certF.writeAsString(cert.pem, flush: true);

      final siteF = File("${certDir.path}/$fileName.json");
      final certInfo = CertInfo.fromX509Certificate(host, cert);
      await siteF.writeAsString(jsonEncode(certInfo.toJson()), flush: true);
      _log.info(
          "[_writeCert] Persisted cert at '${certF.path}' for host '${_latestBadCert?.host}'");
      return certInfo;
    }
  }

  Future<Directory> _openCertsDir() async {
    final privateDir = await getApplicationSupportDirectory();
    final certDir = Directory("${privateDir.path}/certs");
    if (!await certDir.exists()) {
      return certDir.create();
    } else {
      return certDir;
    }
  }

  _BadCertInfo? _latestBadCert;
  var _whitelist = <CertInfo>[];

  static final _inst = SelfSignedCertManager._();
}

// Modifications to this class must also reflect on Android side
final class CertInfo with EquatableMixin {
  const CertInfo({
    required this.host,
    required this.sha1,
    required this.subject,
    required this.issuer,
    required this.startValidity,
    required this.endValidity,
  });

  factory CertInfo.fromX509Certificate(String host, X509Certificate cert) {
    return CertInfo(
      host: host,
      sha1: _sha1BytesToString(cert.sha1),
      subject: cert.subject,
      issuer: cert.issuer,
      startValidity: cert.startValidity,
      endValidity: cert.endValidity,
    );
  }

  JsonObj toJson() {
    return {
      "host": host,
      "sha1": sha1,
      "subject": subject,
      "issuer": issuer,
      "startValidity": startValidity.toUtc().toIso8601String(),
      "endValidity": endValidity.toUtc().toIso8601String(),
    };
  }

  factory CertInfo.fromJson(JsonObj json) {
    return CertInfo(
      host: json["host"],
      sha1: json["sha1"],
      subject: json["subject"],
      issuer: json["issuer"],
      startValidity: DateTime.parse(json["startValidity"]),
      endValidity: DateTime.parse(json["endValidity"]),
    );
  }

  @override
  List<Object?> get props => [
        host,
        sha1,
        subject,
        issuer,
        startValidity,
        endValidity,
      ];

  final String host;
  final String sha1;
  final String subject;
  final String issuer;
  final DateTime startValidity;
  final DateTime endValidity;
}

class _BadCertInfo {
  _BadCertInfo(this.cert, this.host, this.port);

  final X509Certificate cert;
  final String host;
  final int port;
}

@npLog
class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) {
        try {
          if (SelfSignedCertManager().verify(cert, host, port)) {
            // _log.warning(
            //     "[badCertificateCallback] Allowing whitelisted self-signed cert");
            return true;
          }
        } catch (e, stacktrace) {
          _log.shout("[badCertificateCallback] Failed while verifying cert", e,
              stacktrace);
        }
        SelfSignedCertManager()._latestBadCert = _BadCertInfo(cert, host, port);
        return false;
      };
  }
}

String _sha1BytesToString(Uint8List bytes) =>
    bytes.map((e) => e.toRadixString(16).padLeft(2, "0")).join();
