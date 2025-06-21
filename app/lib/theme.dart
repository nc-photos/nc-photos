import 'dart:ui';

import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/theme/dimension.dart';
import 'package:np_ui/np_ui.dart';

const defaultSeedColor = Color(0xFF2196F3);

extension ThemeExtension on ThemeData {
  double get widthLimitedContentMaxWidth => 550.0;

  Color get listPlaceholderBackgroundColor =>
      colorScheme.primaryContainer.withOpacity(.6);

  Color get listPlaceholderForegroundColor =>
      colorScheme.onPrimaryContainer.withOpacity(.7);

  Color get homeNavigationBarBackgroundColor =>
      elevate(colorScheme.surface, 2).withOpacity(.55);

  Color get onDarkSurface {
    return brightness == Brightness.light
        ? colorScheme.onInverseSurface
        : colorScheme.onSurface;
  }

  ImageFilter get appBarBlurFilter => ImageFilter.blur(
        sigmaX: 12,
        sigmaY: 12,
        tileMode: TileMode.mirror,
      );

  Color get nextcloudBlue => const Color(0xFF0082C9);

  LinearGradient get photoGridShimmerGradient {
    final Color color;
    if (brightness == Brightness.light) {
      color = Colors.white.withOpacity(.85);
    } else {
      color = Colors.white.withOpacity(.25);
    }
    return LinearGradient(
      colors: [
        listPlaceholderBackgroundColor.withOpacity(0),
        color,
        listPlaceholderBackgroundColor.withOpacity(0),
      ],
      stops: const [0.1, 0.3, 0.4],
      begin: const Alignment(-1.0, -0.3),
      end: const Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    );
  }
}

class DarkModeSwitchTheme extends StatelessWidget {
  const DarkModeSwitchTheme({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.all(theme.colorScheme.surface),
          thumbColor: WidgetStateProperty.all(Colors.black87),
        ),
        colorScheme: theme.colorScheme.copyWith(
          outline: Colors.transparent,
        ),
      ),
      child: child,
    );
  }

  final Widget child;
}

ThemeData buildTheme(BuildContext context, Brightness brightness) {
  return (brightness == Brightness.light)
      ? buildLightTheme(context)
      : buildDarkTheme(context);
}

ThemeData buildLightTheme(BuildContext context, [ColorScheme? dynamicScheme]) {
  final colorScheme = _getColorScheme(
    context,
    dynamicScheme ?? SessionStorage().lightDynamicColorScheme,
    Brightness.light,
  );
  return _applyColorScheme(colorScheme);
}

ThemeData buildDarkTheme(BuildContext context, [ColorScheme? dynamicScheme]) {
  final colorScheme = _getColorScheme(
    context,
    dynamicScheme ?? SessionStorage().darkDynamicColorScheme,
    Brightness.dark,
  );
  if (context.read<PrefController>().isUseBlackInDarkTheme.value) {
    return _applyColorScheme(colorScheme.copyWith(
      background: Colors.black,
      surface: Colors.grey[900],
    ));
  } else {
    return _applyColorScheme(colorScheme);
  }
}

ColorScheme _getColorScheme(
    BuildContext context, ColorScheme? dynamicScheme, Brightness brightness) {
  var primary = context.read<PrefController>().seedColorValue;
  Color? secondary;
  if (primary == null) {
    if (dynamicScheme != null) {
      return dynamicScheme;
    } else {
      primary = defaultSeedColor;
    }
  } else {
    secondary = context.read<PrefController>().secondarySeedColorValue;
  }
  return SeedColorScheme.fromSeeds(
    brightness: brightness,
    tones: FlexTones.oneHue(brightness),
    primaryKey: primary,
    secondaryKey: secondary,
  );
}

ThemeData _applyColorScheme(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.background,
      foregroundColor: colorScheme.onSurface,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
    ),
    iconTheme: IconThemeData(
      color: colorScheme.onSurfaceVariant,
    ),
    // remove after dialog supports m3
    dialogBackgroundColor:
        Color.lerp(colorScheme.surface, colorScheme.surfaceTint, 0.11),
    popupMenuTheme: PopupMenuThemeData(
      // remove after menu supports m3
      color: Color.lerp(colorScheme.surface, colorScheme.surfaceTint, 0.08),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      // default for Material 3
      height: 80,
    ),
    // remove after checkbox supports m3
    // see: https://m3.material.io/components/checkbox/specs
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        } else {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondary;
          } else {
            return Colors.transparent;
          }
        }
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
    ),
    // remove after checkbox supports m3
    // see: https://m3.material.io/components/switch/specs
    // the color here is slightly modified to work better with the M2 switch
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSurface.withOpacity(.12);
          } else {
            return colorScheme.surfaceVariant.withOpacity(.12);
          }
        } else {
          if (states.contains(WidgetState.selected)) {
            // return colorScheme.primary;
            return colorScheme.secondary;
          } else {
            return colorScheme.surfaceVariant;
          }
        }
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          if (states.contains(WidgetState.selected)) {
            // return colorScheme.surface;
            return colorScheme.onSurface.withOpacity(.38);
          } else {
            return colorScheme.onSurface.withOpacity(.38);
          }
        } else {
          if (states.contains(WidgetState.selected)) {
            // return colorScheme.onPrimary;
            return colorScheme.onSecondary;
          } else {
            return colorScheme.outline;
          }
        }
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.inversePrimary,
      behavior: SnackBarBehavior.floating,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.secondary,
      inactiveTrackColor: colorScheme.secondaryContainer,
      thumbColor: colorScheme.secondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(colorScheme.secondaryContainer),
        foregroundColor: WidgetStateProperty.all(colorScheme.secondary),
        overlayColor:
            WidgetStateProperty.all(colorScheme.secondary.withOpacity(.1)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(colorScheme.secondary),
        overlayColor:
            WidgetStateProperty.all(colorScheme.secondary.withOpacity(.1)),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.secondary,
      selectionHandleColor: colorScheme.secondary,
      selectionColor: colorScheme.secondary.withOpacity(.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: colorScheme.secondary, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: Color.lerp(
          colorScheme.secondaryContainer, colorScheme.surfaceTint, .14),
      iconTheme: IconThemeData(
        color: colorScheme.secondary,
      ),
    ),
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: colorScheme.secondary),
    extensions: [
      M3(
        checkbox: M3Checkbox(
          disabled: M3CheckboxDisabled(
            container: colorScheme.onSurface.withOpacity(.38),
          ),
        ),
        filterChip: M3FilterChip(
          disabled: M3FilterChipDisabled(
            containerSelected: colorScheme.onSurface.withOpacity(.12),
            labelText: colorScheme.onSurface.withOpacity(.38),
          ),
        ),
        listTile: M3ListTile(
          enabled: M3ListTileEnabled(
            headline: colorScheme.onSurface,
            supportingText: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      const AppDimension(
        homeBottomAppBarHeight: 68,
        timelineDateItemHeight: 32,
      ),
    ],
  );
}

extension BrightnessExtension on Brightness {
  Brightness invert() {
    switch (this) {
      case Brightness.dark:
        return Brightness.light;
      case Brightness.light:
        return Brightness.dark;
    }
  }
}
