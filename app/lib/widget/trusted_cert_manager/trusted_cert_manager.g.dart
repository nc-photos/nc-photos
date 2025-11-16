// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_cert_manager.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? isCertsReady,
    List<CertInfo>? certs,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic isCertsReady,
    dynamic certs,
    dynamic error = copyWithNull,
  }) {
    return _State(
      isCertsReady: isCertsReady as bool? ?? that.isCertsReady,
      certs: certs as List<CertInfo>? ?? that.certs,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_WrappedTrustedCertManagerStateNpLog
    on _WrappedTrustedCertManagerState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.trusted_cert_manager.trusted_cert_manager._WrappedTrustedCertManagerState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.trusted_cert_manager.trusted_cert_manager._Bloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {isCertsReady: $isCertsReady, certs: [length: ${certs.length}], error: $error}";
  }
}

extension _$_LoadToString on _Load {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Load {}";
  }
}

extension _$_RemoveCertToString on _RemoveCert {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RemoveCert {item: $item}";
  }
}

extension _$_TrustCertToString on _TrustCert {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TrustCert {}";
  }
}
