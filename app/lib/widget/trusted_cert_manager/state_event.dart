part of 'trusted_cert_manager.dart';

@genCopyWith
@toString
class _State {
  const _State({required this.isCertsReady, required this.certs, this.error});

  factory _State.init() => const _State(isCertsReady: false, certs: []);

  @override
  String toString() => _$toString();

  final bool isCertsReady;
  final List<CertInfo> certs;

  final ExceptionEvent? error;
}

abstract interface class _Event {}

@toString
class _Load implements _Event {
  const _Load();

  @override
  String toString() => _$toString();
}

@toString
class _RemoveCert implements _Event {
  const _RemoveCert(this.item);

  @override
  String toString() => _$toString();

  final CertInfo item;
}

@toString
class _TrustCert implements _Event {
  const _TrustCert();

  @override
  String toString() => _$toString();
}
