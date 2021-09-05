import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nc_photos/pref.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildThemeData(context),
      child: child,
    );
  }

  static ThemeData buildThemeData(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.light
        ? _buildLightThemeData(context, theme)
        : _buildDarkThemeData(context, theme);
  }

  static AppBarTheme getContextualAppBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.light) {
      return theme.appBarTheme.copyWith(
        brightness: Brightness.dark,
        color: Colors.grey[800],
        actionsIconTheme: theme.primaryIconTheme
            .copyWith(color: Colors.white.withOpacity(.87)),
        iconTheme: theme.primaryIconTheme
            .copyWith(color: Colors.white.withOpacity(.87)),
        textTheme: theme.primaryTextTheme
            .apply(bodyColor: Colors.white.withOpacity(.87)),
      );
    } else {
      return theme.appBarTheme.copyWith(
        brightness: Brightness.dark,
        color: Colors.grey[200],
        actionsIconTheme:
            theme.primaryIconTheme.copyWith(color: Colors.black87),
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.black87),
        textTheme: theme.primaryTextTheme.apply(bodyColor: Colors.black87),
      );
    }
  }

  static Color getSelectionOverlayColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primarySwatchLight[100]!.withOpacity(0.7)
        : primarySwatchDark[700]!.withOpacity(0.7);
  }

  static Color getSelectionCheckColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey[800]!
        : Colors.grey[350]!;
  }

  static Color getOverscrollIndicatorColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey[800]!
        : Colors.grey[200]!;
  }

  static Color getRootPickerContentBoxColor(BuildContext context) {
    return Colors.blue[200]!;
  }

  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black87
        : Colors.white.withOpacity(.87);
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black.withOpacity(.6)
        : Colors.white60;
  }

  static Color getAppBarDarkModeSwitchColor(BuildContext context) {
    return Colors.black87;
  }

  static Color getAppBarDarkModeSwitchTrackColor(BuildContext context) {
    return Colors.white.withOpacity(.5);
  }

  static Color getListItemBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black26
        : Colors.white12;
  }

  static ThemeData _buildLightThemeData(BuildContext context, ThemeData theme) {
    final appBarTheme = theme.appBarTheme.copyWith(
      brightness: Brightness.dark,
      color: theme.scaffoldBackgroundColor,
      actionsIconTheme: theme.primaryIconTheme.copyWith(color: Colors.black87),
      iconTheme: theme.primaryIconTheme.copyWith(color: Colors.black87),
      textTheme: theme.primaryTextTheme.apply(bodyColor: Colors.black87),
    );
    return theme.copyWith(appBarTheme: appBarTheme);
  }

  static ThemeData _buildDarkThemeData(BuildContext context, ThemeData theme) {
    final Color background;
    final Color popup;
    if (Pref.inst().isUseBlackInDarkThemeOr(false)) {
      background = Colors.black;
      popup = Colors.grey[900]!;
    } else {
      // in the material spec, black is suggested to be 0x121212, but the one
      // used in flutter by default is 0x303030, why?
      background = Colors.grey[850]!;
      popup = Colors.grey[800]!;
    }

    final appBarTheme = theme.appBarTheme.copyWith(
      brightness: Brightness.dark,
      color: background,
      actionsIconTheme:
          theme.primaryIconTheme.copyWith(color: Colors.white.withOpacity(.87)),
      iconTheme:
          theme.primaryIconTheme.copyWith(color: Colors.white.withOpacity(.87)),
      textTheme: theme.primaryTextTheme
          .apply(bodyColor: Colors.white.withOpacity(.87)),
    );
    final bottomNavigationBarTheme = theme.bottomNavigationBarTheme.copyWith(
      backgroundColor: background,
    );
    final popupMenuTheme = theme.popupMenuTheme.copyWith(
      color: popup,
    );
    return theme.copyWith(
      scaffoldBackgroundColor: background,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      popupMenuTheme: popupMenuTheme,
      dialogBackgroundColor: popup,
    );
  }

  static const primarySwatchLight = Colors.blue;
  static const primarySwatchDark = Colors.cyan;

  static const widthLimitedContentMaxWidth = 550.0;

  /// Make a TextButton look like a default FlatButton. See
  /// https://flutter.dev/go/material-button-migration-guide
  static final flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  final Widget child;
}