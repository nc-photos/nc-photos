import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';
import 'package:time_machine2/time_machine2.dart';
import 'package:to_string/to_string.dart';

part 'photo_date_time_edit_dialog.g.dart';

class PhotoDateTimeEditDialog extends StatelessWidget {
  const PhotoDateTimeEditDialog({super.key, required this.initialDateTime});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _Bloc(initialDateTime: initialDateTime),
      child: _WrappedPhotoDateTimeEditDialog(),
    );
  }

  final ZonedDateTime initialDateTime;
}

class _WrappedPhotoDateTimeEditDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().updateDateTimeDialogTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L10n.global().dateSubtitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          _BlocSelector(
            selector: (state) => state.dateTime,
            builder: (context, dateTime) {
              final displayDt = DateTime(
                dateTime.year,
                dateTime.monthOfYear,
                dateTime.dayOfMonth,
                dateTime.hourOfDay,
                dateTime.minuteOfHour,
              );
              return GestureDetector(
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    initialDate: displayDt,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (result != null) {
                    context.addEvent(_SetDate(result.toDate()));
                  }
                },
                child: _TextInputBox(
                  text: Text(DateFormat.yMMMd().format(displayDt)),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            L10n.global().timeSubtitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          _BlocSelector(
            selector: (state) => state.dateTime,
            builder: (context, dateTime) {
              final displayDt = DateTime(
                dateTime.year,
                dateTime.monthOfYear,
                dateTime.dayOfMonth,
                dateTime.hourOfDay,
                dateTime.minuteOfHour,
              );
              return GestureDetector(
                onTap: () async {
                  final result = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(displayDt),
                  );
                  if (result != null) {
                    context.addEvent(_SetTime(result));
                  }
                },
                child: _TextInputBox(
                  text: Text(DateFormat.jm().format(displayDt)),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            L10n.global().timeZoneOffsetSubtitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const _TimeZoneInput(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(context.state.dateTime);
          },
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),
        ),
      ],
    );
  }
}

class _TextInputBox extends StatelessWidget {
  const _TextInputBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
        ),
      ),
      child: text,
    );
  }

  final Widget text;
}

class _TimeZoneInput extends StatelessWidget {
  const _TimeZoneInput();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.dateTime.offset,
      builder: (context, offset) {
        final isNegative = offset.inSeconds < 0;
        final (hour, min) = offset.inSeconds.abs().let((s) {
          return (s ~/ 3600, (s % 3600) ~/ 60);
        });
        return Row(
          children: [
            const Text("UTC"),
            const SizedBox(width: 4),
            DropdownButton(
              value: isNegative,
              items: const [
                DropdownMenuItem(value: false, child: Text("+")),
                DropdownMenuItem(value: true, child: Text("-")),
              ],
              onChanged: (v) {
                context.addEvent(
                  _SetTimeZoneOffset(isNegative: v!, hour: hour, min: min),
                );
              },
            ),
            const SizedBox(width: 8),
            DropdownButton(
              value: hour,
              items: List.generate(
                15,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(i.toString().padLeft(2, "0")),
                ),
              ),
              onChanged: (v) {
                context.addEvent(
                  _SetTimeZoneOffset(
                    isNegative: isNegative,
                    hour: v!,
                    min: min,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text(":"),
            const SizedBox(width: 8),
            DropdownButton(
              value: min,
              items: [
                for (final m in [0, 15, 30, 45])
                  DropdownMenuItem(
                    value: m,
                    child: Text(m.toString().padLeft(2, "0")),
                  ),
              ],
              onChanged: (v) {
                context.addEvent(
                  _SetTimeZoneOffset(
                    isNegative: isNegative,
                    hour: hour,
                    min: v!,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

@genCopyWith
@toString
class _State {
  const _State({required this.dateTime});

  factory _State.init({required ZonedDateTime dateTime}) =>
      _State(dateTime: dateTime);

  @override
  String toString() => _$toString();

  final ZonedDateTime dateTime;
}

sealed class _Event {}

@toString
class _SetDate implements _Event {
  const _SetDate(this.value);

  @override
  String toString() => _$toString();

  final Date value;
}

@toString
class _SetTime implements _Event {
  const _SetTime(this.value);

  @override
  String toString() => _$toString();

  final TimeOfDay value;
}

@toString
class _SetTimeZoneOffset implements _Event {
  const _SetTimeZoneOffset({
    required this.isNegative,
    required this.hour,
    required this.min,
  });

  @override
  String toString() => _$toString();

  final bool isNegative;
  final int hour;
  final int min;
}

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required ZonedDateTime initialDateTime})
    : super(_State.init(dateTime: initialDateTime)) {
    on<_SetDate>(_onSetDate);
    on<_SetTime>(_onSetTime);
    on<_SetTimeZoneOffset>(_onSetTimeZoneOffset);
  }

  @override
  String get tag => _log.fullName;

  void _onSetDate(_SetDate ev, _Emitter emit) {
    _log.info(ev);
    final newLocalDt = state.dateTime.localDateTime.adjustDate(
      (d) => LocalDate(ev.value.year, ev.value.month, ev.value.day),
    );
    emit(
      state.copyWith(
        dateTime: ZonedDateTime.atLeniently(newLocalDt, state.dateTime.zone),
      ),
    );
  }

  void _onSetTime(_SetTime ev, _Emitter emit) {
    _log.info(ev);
    final newLocalDt = state.dateTime.localDateTime.adjustTime(
      (d) => LocalTime(ev.value.hour, ev.value.minute, 0),
    );
    emit(
      state.copyWith(
        dateTime: ZonedDateTime.atLeniently(newLocalDt, state.dateTime.zone),
      ),
    );
  }

  void _onSetTimeZoneOffset(_SetTimeZoneOffset ev, _Emitter emit) {
    _log.info(ev);
    final sign = ev.isNegative ? -1 : 1;
    final newOffset = Offset(sign * (ev.hour * 3600 + ev.min * 60));
    final newZone = DateTimeZone.forOffset(newOffset);
    emit(
      state.copyWith(
        dateTime: ZonedDateTime.atLeniently(
          state.dateTime.localDateTime,
          newZone,
        ),
      ),
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
