import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/handler/permission_handler.dart';
import 'package:nc_photos/widget/image_editor/color_toolbar.dart';
import 'package:nc_photos/widget/image_editor/crop_controller.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar.dart';
import 'package:nc_photos/widget/image_editor_persist_option_dialog.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/unique.dart';
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;
import 'package:np_platform_image_processor/np_platform_image_processor.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'app_bar.dart';
part 'bloc.dart';
part 'image_editor.g.dart';
part 'state_event.dart';
part 'tool_bar.dart';

class ImageEditorArguments {
  const ImageEditorArguments(this.file);

  final AnyFile file;
}

class ImageEditor extends StatelessWidget {
  static const routeName = "/image-editor";

  static Route buildRoute(ImageEditorArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => ImageEditor.fromArgs(args),
        settings: settings,
      );

  const ImageEditor({super.key, required this.file});

  ImageEditor.fromArgs(ImageEditorArguments args, {Key? key})
    : this(key: key, file: args.file);

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (context) => _IeBloc(
            account: accountController.account,
            prefController: context.read(),
            file: file,
          ),
      child: const _WrappedImageEditor(),
    );
  }

  final AnyFile file;
}

class _WrappedImageEditor extends StatefulWidget {
  const _WrappedImageEditor();

  @override
  State<StatefulWidget> createState() => _WrappedImageEditorState();
}

class _WrappedImageEditorState extends State<_WrappedImageEditor> {
  @override
  void initState() {
    super.initState();
    _ensurePermission().then((value) {
      if (value && mounted) {
        final c = KiwiContainer().resolve<DiContainer>();
        if (!c.pref.hasShownSaveEditResultDialogOr()) {
          _showSaveEditResultDialog(context);
        }
      }
    });
  }

  Future<bool> _ensurePermission() async {
    if (!await const PermissionHandler().ensureStorageWritePermission()) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MultiBlocListener(
          listeners: [
            _BlocListenerT(
              selector: (state) => state.quitRequest,
              listener: (context, quitRequest) async {
                final result = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(L10n.global().imageEditDiscardDialogTitle),
                        content: Text(
                          L10n.global().imageEditDiscardDialogContent,
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              MaterialLocalizations.of(
                                context,
                              ).cancelButtonLabel,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text(L10n.global().discardButtonLabel),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                );
                if (result == true) {
                  Navigator.of(context).pop();
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.isSaved,
              listener: (context, isSaved) {
                if (isSaved) {
                  Navigator.of(context).pop();
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.error,
              listener: (context, error) {
                if (error != null) {
                  SnackBarManager().showSnackBarForException(error.error);
                }
              },
            ),
          ],
          child: const Scaffold(body: _Body()),
        ),
      ),
    );
  }

  Future<void> _showSaveEditResultDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const ImageEditorPersistOptionDialog(isFromEditor: true),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.isModified,
      builder:
          (context, isModified) => PopScope(
            canPop: !isModified,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                context.addEvent(const _RequestQuit());
              }
            },
            child: ColoredBox(
              color: Colors.black,
              child: Column(
                children: [
                  const _AppBar(),
                  Expanded(
                    child: _BlocBuilder(
                      buildWhen:
                          (previous, current) =>
                              previous.src != current.src ||
                              previous.dst != current.dst ||
                              previous.isCropMode != current.isCropMode,
                      builder: (context, state) {
                        if (state.src == null) {
                          return const SizedBox.shrink();
                        } else if (state.isCropMode) {
                          return CropController(
                            // crop always work on the src, otherwise we'll be
                            // cropping repeatedly
                            image: state.src!,
                            initialState: context.state.cropFilter,
                            onCropChanged: (cropFilter) {
                              context.addEvent(_SetCropFilter(cropFilter));
                            },
                          );
                        } else {
                          return Image(
                            image: (state.dst ?? state.src!).let(
                              (obj) =>
                                  PixelImage(obj.pixel, obj.width, obj.height),
                            ),
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                          );
                        }
                      },
                    ),
                  ),
                  _BlocSelector(
                    selector: (state) => state.activeTool,
                    builder:
                        (context, activeTool) => switch (activeTool) {
                          _ToolType.color => ColorToolbar(
                            initialState: context.state.colorFilters,
                            onActiveFiltersChanged: (colorFilters) {
                              context.addEvent(
                                _SetColorFilters(colorFilters.toList()),
                              );
                            },
                          ),
                          _ToolType.transform => TransformToolbar(
                            initialState: context.state.transformFilters,
                            onActiveFiltersChanged: (transformFilters) {
                              context.addEvent(
                                _SetTransformFilters(transformFilters.toList()),
                              );
                            },
                            isCropModeChanged: (value) {
                              context.addEvent(_SetCropMode(value));
                            },
                            onCropToolDeactivated: () {
                              context.addEvent(const _SetCropFilter(null));
                            },
                          ),
                        },
                  ),
                  const SizedBox(height: 4),
                  const _ToolBar(),
                ],
              ),
            ),
          ),
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_IeBloc, _State>;
// typedef _BlocListener = BlocListener<_IeBloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_IeBloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_IeBloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _IeBloc get bloc => read();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
