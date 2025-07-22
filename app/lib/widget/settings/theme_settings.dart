import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'theme/bloc.dart';
part 'theme/state_event.dart';
part 'theme_settings.g.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _Bloc(
        prefController: context.read(),
      ),
      child: const _WrappedThemeSettings(),
    );
  }
}

class _WrappedThemeSettings extends StatefulWidget {
  const _WrappedThemeSettings();

  @override
  State<StatefulWidget> createState() => _WrappedThemeSettingsState();
}

@npLog
class _WrappedThemeSettingsState extends State<_WrappedThemeSettings>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          _BlocListener(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null && isPageVisible()) {
                SnackBarManager().showSnackBarForException(state.error!.error);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(L10n.global().settingsThemeTitle),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const _SeedColorOption(),
                  if (getRawPlatform() == NpPlatform.android &&
                      AndroidInfo().sdkInt >= AndroidVersion.Q)
                    _BlocSelector<bool>(
                      selector: (state) => state.isFollowSystemTheme,
                      builder: (_, isFollowSystemTheme) {
                        return SwitchListTile(
                          title: Text(
                              L10n.global().settingsFollowSystemThemeTitle),
                          value: isFollowSystemTheme,
                          onChanged: (value) {
                            _bloc.add(_SetFollowSystemTheme(value));
                          },
                        );
                      },
                    ),
                  _BlocSelector<bool>(
                    selector: (state) => state.isUseBlackInDarkTheme,
                    builder: (context, isUseBlackInDarkTheme) {
                      return SwitchListTile(
                        title: Text(
                            L10n.global().settingsUseBlackInDarkThemeTitle),
                        subtitle: Text(isUseBlackInDarkTheme
                            ? L10n.global()
                                .settingsUseBlackInDarkThemeTrueDescription
                            : L10n.global()
                                .settingsUseBlackInDarkThemeFalseDescription),
                        value: isUseBlackInDarkTheme,
                        onChanged: (value) {
                          _bloc.add(_SetUseBlackInDarkTheme(
                              value, Theme.of(context)));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final _bloc = context.read<_Bloc>();
}

class _SeedColorOption extends StatelessWidget {
  const _SeedColorOption();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.seedColor != current.seedColor ||
          previous.secondarySeedColor != current.secondarySeedColor,
      builder: (context, state) {
        return ListTile(
          title: Text(L10n.global().settingsSeedColorTitle),
          subtitle: Text(
              state.seedColor == null || SessionStorage().isSupportDynamicColor
                  ? L10n.global().settingsSeedColorSystemColorDescription
                  : L10n.global().settingsSeedColorDescription),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.seedColor != null)
                Icon(
                  Icons.circle,
                  size: 32,
                  color: Color(state.seedColor!),
                ),
              if (state.secondarySeedColor != null)
                Icon(
                  Icons.circle,
                  size: 32,
                  color: Color(state.secondarySeedColor!),
                ),
            ],
          ),
          onTap: () => _onSeedColorPressed(context),
        );
      },
    );
  }

  Future<void> _onSeedColorPressed(BuildContext context) async {
    final parentContext = context;
    await showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: parentContext.read<_Bloc>(),
        child: const _SeedColorPicker(),
      ),
    );
  }
}

class _SeedColorPicker extends StatefulWidget {
  const _SeedColorPicker();

  @override
  State<StatefulWidget> createState() => _SeedColorPickerState();
}

class _SeedColorPickerState extends State<_SeedColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: AlertDialog(
        title: Text(L10n.global().settingsSeedColorTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(L10n.global().settingsThemePrimaryColor),
              leading: const SizedBox(width: 48),
              trailing: _BlocSelector<int?>(
                selector: (state) => state.seedColor,
                builder: (context, seedColor) => _SeedColorPickerItem(
                  seedColor: seedColor?.run(Color.new),
                  onSelected: () => _onPrimaryTap(this.context),
                ),
              ),
              contentPadding: EdgeInsets.zero,
              onTap: () => _onPrimaryTap(context),
            ),
            ListTile(
              title: Text(L10n.global().settingsThemeSecondaryColor),
              leading: _BlocSelector<bool>(
                selector: (state) => state.secondarySeedColor != null,
                builder: (context, isSecondaryEnabled) => Checkbox(
                  value: isSecondaryEnabled,
                  onChanged: (value) {
                    if (value == true) {
                      _onSecondaryTap(this.context);
                    } else {
                      context.addEvent(_SetThemeColor(
                          context.state.seedColor?.let(Color.new), null));
                    }
                  },
                ),
              ),
              trailing: _BlocSelector<int?>(
                selector: (state) => state.secondarySeedColor,
                builder: (context, secondarySeedColor) => _SeedColorPickerItem(
                  seedColor: secondarySeedColor?.run(Color.new),
                  onSelected: () => _onSecondaryTap(this.context),
                ),
              ),
              contentPadding: EdgeInsets.zero,
              onTap: () => _onSecondaryTap(context),
            ),
            const Divider(thickness: 1),
            Text(
              L10n.global().settingsThemePresets,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              children: const [
                _PresetItem(primary: Color(0xFFF44336)),
                _PresetItem(primary: Color(0xFF9C27B0)),
                _PresetItem(primary: Color(0xFF2196F3)),
                _PresetItem(primary: Color(0xFF4CAF50)),
                _PresetItem(primary: Color(0xFFFFC107)),
                _PresetItem(
                  emoji: "\u{1f349}",
                  primary: Color(0xFF009736),
                  secondary: Color(0xFFEE2A35),
                ),
                _PresetItem(
                  emoji: "\u{1f33d}",
                  primary: Color(0xFFFFC107),
                  secondary: Color(0xFF4CAF50),
                ),
                _PresetItem(
                  emoji: "\u{1f38f}",
                  primary: Color(0xFF2196F3),
                  secondary: Color(0xFFF44336),
                ),
              ]
                  .map((e) => _PresetItemView(
                        item: e,
                        onSelected: () => _onPresetSelected(
                          context,
                          primary: e.primary,
                          secondary: e.secondary,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: SessionStorage().isSupportDynamicColor
            ? [
                TextButton(
                  onPressed: () => _onSystemColorSelected(context),
                  child: Text(L10n.global()
                      .settingsSeedColorPickerSystemColorButtonLabel),
                ),
              ]
            : null,
      ),
    );
  }

  Future<void> _onPrimaryTap(BuildContext context) async {
    setState(() {
      _isVisible = false;
    });
    try {
      final color = await showDialog<Color>(
        context: context,
        builder: (_) => _SeedColorCustomPicker(
          initialColor:
              context.bloc.prefController.seedColorValue ?? defaultSeedColor,
        ),
        barrierColor: Colors.transparent,
      );
      if (color == null) {
        return;
      }
      context.addEvent(_SetThemeColor(
          color, context.state.secondarySeedColor?.let(Color.new)));
    } finally {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  Future<void> _onSecondaryTap(BuildContext context) async {
    setState(() {
      _isVisible = false;
    });
    try {
      final color = await showDialog<Color>(
        context: context,
        builder: (_) => _SeedColorCustomPicker(
          initialColor: context.bloc.prefController.secondarySeedColorValue ??
              defaultSeedColor,
        ),
        barrierColor: Colors.transparent,
      );
      if (color == null) {
        return;
      }
      // enabling secondary automatically enable primary color
      context.addEvent(_SetThemeColor(
          context.state.seedColor?.let(Color.new) ?? defaultSeedColor, color));
    } finally {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  Future<void> _onPresetSelected(
    BuildContext context, {
    required Color? primary,
    Color? secondary,
  }) async {
    context.addEvent(_SetThemeColor(primary, secondary));
    Navigator.of(context).pop();
  }

  Future<void> _onSystemColorSelected(BuildContext context) async {
    context.addEvent(const _SetThemeColor(null, null));
    Navigator.of(context).pop();
  }

  var _isVisible = true;
}

class _SeedColorCustomPicker extends StatefulWidget {
  const _SeedColorCustomPicker({
    required this.initialColor,
  });

  @override
  State<StatefulWidget> createState() => _SeedColorCustomPickerState();

  final Color initialColor;
}

class _SeedColorCustomPickerState extends State<_SeedColorCustomPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().settingsSeedColorPickerTitle),
      content: SingleChildScrollView(
        child: _HueRingPicker(
          pickerColor: _customColor,
          onColorChanged: (value) {
            setState(() {
              _customColor = value;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_customColor);
          },
          child: Text(L10n.global().applyButtonLabel),
        ),
      ],
    );
  }

  late var _customColor = widget.initialColor;
}

class _SeedColorPickerItem extends StatelessWidget {
  const _SeedColorPickerItem({
    required this.seedColor,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final content = SizedBox.square(
      dimension: _size,
      child: Center(
        child: seedColor != null
            ? Icon(
                Icons.circle,
                size: _size * .9,
                color: seedColor,
              )
            : const Icon(Icons.edit_outlined),
      ),
    );
    if (onSelected != null) {
      return InkWell(
        customBorder: const CircleBorder(),
        onTap: onSelected,
        child: content,
      );
    } else {
      return content;
    }
  }

  final Color? seedColor;
  final VoidCallback? onSelected;

  static const _size = 48.0;
}

class _PresetItemView extends StatelessWidget {
  const _PresetItemView({
    required this.item,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final content = SizedBox.square(
      dimension: _size,
      child: Center(
        child: item.emoji != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.circle,
                    size: _size * .9,
                    color: Colors.white,
                  ),
                  Text(
                    item.emoji!,
                    style: const TextStyle(fontSize: _size * .35),
                  ),
                ],
              )
            : Icon(
                Icons.circle,
                size: _size * .9,
                color: item.primary,
              ),
      ),
    );
    if (onSelected != null) {
      return InkWell(
        customBorder: const CircleBorder(),
        onTap: onSelected,
        child: content,
      );
    } else {
      return content;
    }
  }

  final _PresetItem item;
  final VoidCallback? onSelected;

  static const _size = 72.0;
}

class _PresetItem {
  const _PresetItem({
    this.emoji,
    required this.primary,
    this.secondary,
  });

  final String? emoji;
  final Color primary;
  final Color? secondary;
}

/// Based on the original HueRingPicker
class _HueRingPicker extends StatefulWidget {
  const _HueRingPicker({
    required this.pickerColor,
    required this.onColorChanged,
    // ignore: unused_element_parameter
    this.colorPickerHeight = 250.0,
    // ignore: unused_element_parameter
    this.hueRingStrokeWidth = 20.0,
    // ignore: unused_element_parameter
    this.displayThumbColor = true,
    // ignore: unused_element_parameter
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final double colorPickerHeight;
  final double hueRingStrokeWidth;
  final bool displayThumbColor;
  final BorderRadius pickerAreaBorderRadius;

  @override
  _HueRingPickerState createState() => _HueRingPickerState();
}

class _HueRingPickerState extends State<_HueRingPicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
    super.initState();
  }

  @override
  void didUpdateWidget(_HueRingPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
  }

  void onColorChanging(HSVColor color) {
    setState(() => currentHsvColor = color.withSaturation(1).withValue(1));
    widget.onColorChanged(currentHsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: widget.pickerAreaBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                ColorIndicator(
                  currentHsvColor,
                  width: 128,
                  height: 128,
                ),
                SizedBox(
                  width: widget.colorPickerHeight,
                  height: widget.colorPickerHeight,
                  child: ColorPickerHueRing(
                    currentHsvColor,
                    onColorChanging,
                    displayThumbColor: widget.displayThumbColor,
                    strokeWidth: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
