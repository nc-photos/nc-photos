part of '../my_app.dart';

class _AppLockMyApp extends StatefulWidget {
  const _AppLockMyApp({required this.child});

  @override
  State<StatefulWidget> createState() => _AppLockMyAppState();

  final Widget child;
}

@npLog
class _AppLockMyAppState extends State<_AppLockMyApp> {
  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onHide: () {
        SessionStorage().lastSuspendTime = clock.now();
      },
      onShow: () async {
        if (context.read<SecurePrefController>().protectedPageAuthTypeValue ==
            null) {
          return;
        }
        final now = clock.now();
        final diff = now.difference(SessionStorage().lastSuspendTime);
        _log.info("Suspended for: $diff");
        if (diff >= const Duration(seconds: 30) && !_shouldLock) {
          _log.info("Suspended for too long, auth required");
          setState(() {
            _shouldLock = true;
          });
          late final OverlayEntry authOverlay;
          authOverlay = OverlayEntry(
            builder:
                (_) => _AppLockOverlay(
                  onAuthSuccess: () {
                    authOverlay.remove();
                    if (mounted) {
                      setState(() {
                        _shouldLock = false;
                      });
                    }
                  },
                ),
          );
          _key.currentState?.insert(authOverlay);
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      key: _key,
      initialEntries: [
        OverlayEntry(maintainState: true, builder: (_) => widget.child),
      ],
    );
  }

  late final AppLifecycleListener _lifecycleListener;
  final _key = GlobalKey<OverlayState>();
  var _shouldLock = false;
}

class _AppLockOverlay extends StatelessWidget {
  const _AppLockOverlay({required this.onAuthSuccess});

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope.none(
      child: Navigator(
        onGenerateRoute:
            (_) => MaterialPageRoute(
              builder:
                  (context) =>
                      _AppLockOverlayPage(onAuthSuccess: onAuthSuccess),
            ),
      ),
    );
  }

  final VoidCallback onAuthSuccess;
}

class _AppLockOverlayPage extends StatefulWidget {
  const _AppLockOverlayPage({required this.onAuthSuccess});

  @override
  State<StatefulWidget> createState() => _AppLockOverlayPageState();

  final VoidCallback onAuthSuccess;
}

@npLog
class _AppLockOverlayPageState extends State<_AppLockOverlayPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _auth();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: Colors.black,
        child: const Align(
          alignment: Alignment(0, .75),
          child: Icon(Icons.lock_outlined, size: 64),
        ),
      ),
    );
  }

  Future<void> _auth() async {
    if (mounted && await Navigator.of(context).authProtectedPage()) {
      widget.onAuthSuccess();
    } else {
      _log.warning("[_auth] Auth failed");
      await Future.delayed(const Duration(seconds: 2));
      unawaited(_auth());
    }
  }
}
