import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ValueStreamBuilder<T> extends StreamBuilder<T> {
  ValueStreamBuilder({
    super.key,
    ValueStream<T>? stream,
    required super.builder,
  }) : super(stream: stream, initialData: stream?.value);
}

class ValueStreamBuilderEx<T> extends StreamBuilder<T> {
  ValueStreamBuilderEx({
    super.key,
    ValueStream<T>? stream,
    required StreamWidgetBuilder<T> builder,
  }) : super(
         stream: stream,
         initialData: stream?.value,
         builder:
             builder.snapshotBuilder ??
             (context, snapshot) {
               return builder.valueBuilder!(context, snapshot.requireData);
             },
       );
}

class StreamWidgetBuilder<T> {
  const StreamWidgetBuilder._({this.snapshotBuilder, this.valueBuilder});

  const StreamWidgetBuilder.snapshot(AsyncWidgetBuilder<T> builder)
    : this._(snapshotBuilder: builder);
  const StreamWidgetBuilder.value(
    Widget Function(BuildContext context, T value) builder,
  ) : this._(valueBuilder: builder);

  final AsyncWidgetBuilder<T>? snapshotBuilder;
  final Widget Function(BuildContext context, T value)? valueBuilder;
}
