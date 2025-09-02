import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'convert_settings.g.dart';

class ConvertSettings extends StatelessWidget {
  static const routeName = "/convert-settings";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) => const ConvertSettings(),
    settings: settings,
  );

  const ConvertSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _Bloc(prefController: context.read()),
      child: const _WrappedConvertSettings(),
    );
  }
}

class _WrappedConvertSettings extends StatelessWidget {
  const _WrappedConvertSettings();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.addEvent(const _Save());
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(L10n.global().uploadBatchConvertSettings)),
        body: Form(
          key: context.bloc.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ItemContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10n.global().uploadBatchConvertSettingsFormat,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      _BlocSelector(
                        selector: (state) => state.format,
                        builder:
                            (context, format) =>
                                DropdownButtonFormField<ConvertFormat>(
                                  items:
                                      ConvertFormat.values
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e.toDisplayString()),
                                            ),
                                          )
                                          .toList(),
                                  value: format,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    context.addEvent(_SetFormat(value!));
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _ItemContainer(
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            L10n.global().uploadBatchConvertSettingsQuality,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          _BlocSelector(
                            selector: (state) => state.quality,
                            builder:
                                (context, quality) => Text(
                                  quality.toString(),
                                  style: Theme.of(context).textStyleColored(
                                    (textTheme) => textTheme.bodyMedium,
                                    (colorScheme) => colorScheme.onSurfaceLow,
                                  ),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _BlocSelector(
                          selector: (state) => state.quality,
                          builder:
                              (context, quality) => Slider(
                                min: 0,
                                max: 100,
                                divisions: 100,
                                value: quality.toDouble(),
                                padding: const EdgeInsets.all(8),
                                onChanged: (value) {
                                  context.addEvent(_SetQuality(value.toInt()));
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _ItemContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BlocSelector(
                        selector: (state) => state.downsizeMp,
                        builder:
                            (context, downsizeMp) => CheckboxListTile(
                              title: Text(
                                L10n.global()
                                    .uploadBatchConvertSettingsDownscaling,
                              ),
                              subtitle: downsizeMp?.let(
                                (e) => Text(
                                  L10n.global().megapixelCount(
                                    e.toStringAsFixed(1),
                                  ),
                                  style: Theme.of(context).textStyleColored(
                                    (textTheme) => textTheme.bodyMedium,
                                    (colorScheme) => colorScheme.onSurfaceLow,
                                  ),
                                ),
                              ),
                              value: downsizeMp != null,
                              contentPadding: const EdgeInsets.all(0),
                              onChanged: (value) {
                                context.addEvent(
                                  _SetDownsizeMp(value! ? 16 : null),
                                );
                              },
                            ),
                      ),
                      _BlocSelector(
                        selector: (state) => state.downsizeMp,
                        builder:
                            (context, downsizeMp) =>
                                downsizeMp == null
                                    ? const SizedBox.shrink()
                                    : Slider(
                                      min: 0.1,
                                      max: 50,
                                      value: downsizeMp,
                                      padding: const EdgeInsets.all(8),
                                      onChanged: (value) {
                                        context.addEvent(_SetDownsizeMp(value));
                                      },
                                    ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemContainer extends StatelessWidget {
  const _ItemContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: child,
    );
  }

  final Widget child;
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
