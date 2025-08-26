part of '../trusted_cert_manager.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.trustedCertController, required this.prefController})
    : super(_State.init()) {
    on<_Load>(_onLoad);
    on<_RemoveCert>(_onRemoveCert);
    on<_TrustCert>(_onTrustCert);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onLoad(_Load ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        trustedCertController.stream.map(
          (certs) => certs.sorted((a, b) {
            final temp = a.host.compareTo(b.host);
            if (temp == 0) {
              return a.sha1.compareTo(b.sha1);
            } else {
              return temp;
            }
          }),
        ),
        onData: (data) => state.copyWith(isCertsReady: true, certs: data),
      ),
      forEach(
        emit,
        trustedCertController.errorStream.skip(1),
        onData: (error) {
          _log.severe(
            "[_onLoad] Uncaught exception",
            error?.error,
            error?.stackTrace,
          );
          return state.copyWith(error: error);
        },
      ),
    ]);
  }

  void _onRemoveCert(_RemoveCert ev, Emitter<_State> emit) {
    _log.info(ev);
    trustedCertController.remove(ev.item);
  }

  void _onTrustCert(_TrustCert ev, Emitter<_State> emit) {
    _log.info(ev);
    trustedCertController.whitelistLastBadCert();
  }

  final TrustedCertController trustedCertController;
  final PrefController prefController;
}
