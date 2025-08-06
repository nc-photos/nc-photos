import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:np_log/np_log.dart';
import 'package:np_math/np_math.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'slideshow_dialog.g.dart';

@toString
class SlideshowConfig {
  const SlideshowConfig({
    required this.duration,
    required this.isShuffle,
    required this.isRepeat,
    required this.isReverse,
  });

  @override
  String toString() => _$toString();

  /// Time where each item is shown
  final Duration duration;

  /// Whether to shuffle the items
  final bool isShuffle;

  /// Whether to repeat the slideshow after finishing
  final bool isRepeat;

  /// Whether to show the items in reverse order
  final bool isReverse;
}

class SlideshowDialog extends StatefulWidget {
  const SlideshowDialog({
    super.key,
    required this.duration,
    required this.isShuffle,
    required this.isRepeat,
    required this.isReverse,
  });

  @override
  createState() => _SlideshowDialogState();

  final Duration duration;
  final bool isShuffle;
  final bool isRepeat;
  final bool isReverse;
}

@npLog
class _SlideshowDialogState extends State<SlideshowDialog> {
  @override
  initState() {
    super.initState();
    _durationSecond = widget.duration.inSeconds % 60;
    _durationMinute = widget.duration.inMinutes;
  }

  @override
  build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().slideshowSetupDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L10n.global().slideshowSetupDialogDurationTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: L10n.global().timeMinuteInputHint,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_durationSecond == 0 && int.tryParse(value!) == 0) {
                        return L10n.global().dateTimeInputInvalid;
                      }
                      if (int.tryParse(value!)?.inRange(0, 59) == true) {
                        return null;
                      }
                      return L10n.global().dateTimeInputInvalid;
                    },
                    onSaved: (value) {
                      _formValue.minute = int.parse(value!);
                    },
                    onChanged: (value) {
                      try {
                        _durationMinute = int.parse(value);
                      } catch (_) {}
                    },
                    initialValue: widget.duration.inMinutes.toString().padLeft(
                      2,
                      "0",
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(":"),
                const SizedBox(width: 4),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: L10n.global().timeSecondInputHint,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_durationMinute == 0 && int.tryParse(value!) == 0) {
                        return L10n.global().dateTimeInputInvalid;
                      }
                      if (int.tryParse(value!)?.inRange(0, 59) == true) {
                        return null;
                      }
                      return L10n.global().dateTimeInputInvalid;
                    },
                    onSaved: (value) {
                      _formValue.second = int.parse(value!);
                    },
                    onChanged: (value) {
                      try {
                        _durationSecond = int.parse(value);
                      } catch (_) {}
                    },
                    initialValue: (widget.duration.inSeconds % 60)
                        .toString()
                        .padLeft(2, "0"),
                  ),
                ),
              ],
            ),
            SwitchFormField(
              title: Text(L10n.global().slideshowSetupDialogShuffleTitle),
              onSaved: (value) {
                _formValue.isShuffle = value!;
              },
              initialValue: widget.isShuffle,
            ),
            SwitchFormField(
              title: Text(L10n.global().slideshowSetupDialogRepeatTitle),
              onSaved: (value) {
                _formValue.isRepeat = value!;
              },
              initialValue: widget.isRepeat,
            ),
            SwitchFormField(
              title: Text(L10n.global().slideshowSetupDialogReverseTitle),
              onSaved: (value) {
                _formValue.isReverse = value!;
              },
              initialValue: widget.isReverse,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _onOkPressed(context),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  void _onOkPressed(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState!.save();
      if (_formValue.minute == 0 && _formValue.second == 0) {
        // invalid
        SnackBarManager().showSnackBar(
          SnackBar(
            content: Text(L10n.global().dateTimeInputInvalid),
            duration: k.snackBarDurationNormal,
          ),
        );
        return;
      }

      final product = SlideshowConfig(
        duration: Duration(
          minutes: _formValue.minute,
          seconds: _formValue.second,
        ),
        isShuffle: _formValue.isShuffle,
        isRepeat: _formValue.isRepeat,
        isReverse: _formValue.isReverse,
      );
      _log.info("[_onOkPressed] Config: $product");
      Navigator.of(context).pop(product);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _formValue = _FormValue();

  late int _durationSecond;
  late int _durationMinute;
}

class _FormValue {
  late int minute;
  late int second;
  late bool isShuffle;
  late bool isRepeat;
  late bool isReverse;
}
