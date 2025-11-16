import 'package:flutter/widgets.dart';
import 'package:nc_photos/widget/my_app/my_app.dart';

mixin PageVisibilityMixin<T extends StatefulWidget> on State<T>, RouteAware {
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  dispose() {
    MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  didPush() {
    _isVisible = true;
  }

  @override
  didPushNext() {
    _isVisible = false;
  }

  @override
  didPop() {
    _isVisible = false;
  }

  @override
  didPopNext() {
    _isVisible = true;
  }

  bool isPageVisible() => _isVisible;

  var _isVisible = true;
}
