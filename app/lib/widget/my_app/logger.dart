part of '../my_app.dart';

@npLog
class _NavigatorLogger extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      _log.fine(
        'Push: ${previousRoute?.settings.name} -> ${route.settings.name}',
      );
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute?.settings.name != null) {
      _log.fine(
        'Replace: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
      );
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      _log.fine(
        'Pop: ${route.settings.name} -> ${previousRoute?.settings.name}',
      );
    }
  }
}
