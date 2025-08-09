import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nc_photos/snack_bar_manager.dart';

void main() {
  group("SnackBarManager", () {
    group("showSnackBar", () {
      testWidgets("canBeReplaced = true", (tester) async {
        final manager = SnackBarManager.scoped();
        await tester.pumpWidget(_TestWidget(manager));
        manager.showSnackBar(
          const SnackBar(
            content: Text("test1"),
            duration: Duration(seconds: 10),
          ),
          canBeReplaced: true,
        );
        await tester.pumpAndSettle();
        expect(find.text("test1"), findsOneWidget);

        manager.showSnackBar(
          const SnackBar(
            content: Text("test2"),
            duration: Duration(seconds: 1),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text("test1"), findsNothing);
        expect(find.text("test2"), findsOneWidget);
      });
    });
  });
}

class _TestWidget extends StatefulWidget {
  const _TestWidget(this.manager);

  @override
  createState() => _TestWidgetState();

  final SnackBarManager manager;
}

class _TestWidgetState extends State<_TestWidget> implements SnackBarHandler {
  @override
  initState() {
    super.initState();
    widget.manager.registerHandler(this);
  }

  @override
  build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(body: Container()),
    );
  }

  @override
  dispose() {
    super.dispose();
    widget.manager.unregisterHandler(this);
  }

  @override
  showSnackBar(SnackBar snackBar) =>
      _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}
