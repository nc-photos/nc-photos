import 'dart:async';
import 'dart:io' as io;
import 'dart:isolate';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as imagelib;
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/exception_util.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/use_case/put_file_binary.dart';
import 'package:nc_photos/widget/app_bar_circular_progress_indicator.dart';
import 'package:nc_photos/widget/handler/permission_handler.dart';
import 'package:nc_photos/widget/image_editor/color_toolbar.dart';
import 'package:nc_photos/widget/image_editor/crop_controller.dart';
import 'package:nc_photos/widget/image_editor/effect_toolbar/effect_toolbar.dart';
import 'package:nc_photos/widget/image_editor/pixel_toolbar_util.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar.dart';
import 'package:nc_photos/widget/image_editor_persist_option_dialog.dart';
import 'package:nc_photos/widget/local_result_viewer/local_result_viewer.dart';
import 'package:np_common/exception.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/unique.dart';
import 'package:np_exiv2/np_exiv2.dart' as exiv2;
import 'package:np_ffi_image_editor/np_ffi_image_editor.dart' as image_editor;
import 'package:np_platform_local_media/np_platform_local_media.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:np_ui/np_ui.dart';
import 'package:path/path.dart' as pathlib;
import 'package:path_provider/path_provider.dart';
import 'package:to_string/to_string.dart';
import 'package:uuid/uuid.dart';

part 'app_bar.dart';
part 'bloc.dart';
part 'face_selector.dart';
part 'image_editor.g.dart';
part 'save_dialog.dart';
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
            fileRepo: KiwiContainer().resolve<DiContainer>().fileRepo,
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
              selector: (state) => state.savedFile,
              listener: (context, savedFile) {
                if (savedFile != null) {
                  Navigator.of(context).pushReplacementNamed(
                    LocalResultViewer.routeName,
                    arguments: LocalResultViewerArguments(savedFile),
                  );
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.hasSelectedFaceReset,
              listener: (context, hasSelectedFaceReset) {
                if (hasSelectedFaceReset?.value == true) {
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(
                        L10n.global().imageEditResetSelectedFaceMessage,
                      ),
                      duration: k.snackBarDurationNormal,
                    ),
                  );
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.shouldNotifySelectFace,
              listener: (context, shouldNotifySelectFace) {
                if (shouldNotifySelectFace) {
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(L10n.global().imageEditFaceNotSelected),
                      duration: k.snackBarDurationNormal,
                    ),
                  );
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
            _BlocListenerT(
              selector: (state) => state.initError,
              listener: (context, initError) {
                if (initError != null) {
                  final (text, action) = exceptionToSnackBarData(
                    initError.error,
                  );
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(
                        "${L10n.global().imageEditOpenErrorMessage} ($text)",
                      ),
                      action: action,
                      duration: k.snackBarDurationNormal,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.saveError,
              listener: (context, saveError) {
                if (saveError != null) {
                  final (text, action) = exceptionToSnackBarData(
                    saveError.error,
                  );
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(
                        "${L10n.global().imageEditSaveErrorMessage} ($text)",
                      ),
                      action: action,
                      duration: k.snackBarDurationNormal,
                    ),
                  );
                }
              },
            ),
          ],
          child: _BlocBuilder(
            buildWhen:
                (previous, current) =>
                    previous.isModified != current.isModified ||
                    previous.saveState != current.saveState,
            builder:
                (context, state) => PopScope(
                  canPop: !state.isModified && state.saveState == null,
                  onPopInvokedWithResult: (didPop, result) {
                    if (!didPop && state.saveState == null) {
                      context.addEvent(const _RequestQuit());
                    }
                  },
                  child: Scaffold(
                    body: Stack(
                      children: [
                        const _Body(),
                        _BlocSelector(
                          selector: (state) => state.saveState,
                          builder:
                              (context, saveState) =>
                                  saveState != null
                                      ? const _SaveDialog()
                                      : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
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
    return ColoredBox(
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
                      previous.isCropMode != current.isCropMode ||
                      previous.isFaceSelectionMode !=
                          current.isFaceSelectionMode,
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
                } else if (state.isFaceSelectionMode) {
                  return const _FaceSelector();
                } else {
                  return Image(
                    image: (state.dst ?? state.src!).let(
                      (obj) => PixelImage(obj.pixel, obj.width, obj.height),
                    ),
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          _BlocSelector(
            selector: (state) => state.activeTool,
            builder:
                (context, activeTool) => switch (activeTool) {
                  _ToolType.color => ColorToolbar(
                    initialState: context.state.pixelFilters,
                    onActiveFiltersChanged: (pixelFilters) {
                      context.addEvent(_SetPixelFilters(pixelFilters.toList()));
                    },
                  ),
                  _ToolType.effect => EffectToolbar(
                    initialFilters: context.state.pixelFilters,
                    onActiveFiltersChanged: (pixelFilters) {
                      context.addEvent(_SetPixelFilters(pixelFilters.toList()));
                    },
                    isFaceSelectionModeChanged: (value) {
                      context.addEvent(_SetFaceSelectionMode(value));
                    },
                    onFaceFilterValueChanged: () {
                      context.addEvent(const _FaceFilterValueChanged());
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
          const SizedBox(height: 8),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
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
