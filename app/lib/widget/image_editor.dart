import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/handler/permission_handler.dart';
import 'package:nc_photos/widget/image_editor/color_toolbar.dart';
import 'package:nc_photos/widget/image_editor/crop_controller.dart';
import 'package:nc_photos/widget/image_editor/transform_toolbar.dart';
import 'package:nc_photos/widget/image_editor_persist_option_dialog.dart';
import 'package:np_platform_image_processor/np_platform_image_processor.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';
import 'package:np_ui/np_ui.dart';

class ImageEditorArguments {
  const ImageEditorArguments(this.account, this.file);

  final Account account;
  final FileDescriptor file;
}

class ImageEditor extends StatefulWidget {
  static const routeName = "/image-editor";

  static Route buildRoute(ImageEditorArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => ImageEditor.fromArgs(args),
        settings: settings,
      );

  const ImageEditor({super.key, required this.account, required this.file});

  ImageEditor.fromArgs(ImageEditorArguments args, {Key? key})
    : this(key: key, account: args.account, file: args.file);

  @override
  createState() => _ImageEditorState();

  final Account account;
  final FileDescriptor file;
}

class _ImageEditorState extends State<ImageEditor> {
  @override
  initState() {
    super.initState();
    _initImage();
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
  build(BuildContext context) => Theme(
    data: buildDarkTheme(context),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(body: Builder(builder: _buildContent)),
    ),
  );

  Future<void> _initImage() async {
    final fileInfo = await getFileFromCache(
      CachedNetworkImageType.largeImage,
      getViewerUrlForImageFile(widget.account, widget.file),
      widget.file.fdMime,
    );
    // no need to set shouldfixOrientation because the previews are always in
    // the correct orientation
    _src = await ImageLoader.loadUri(
      "file://${fileInfo!.file.path}",
      _previewWidth,
      _previewHeight,
      ImageLoaderResizeMethod.fit,
      isAllowSwapSide: true,
    );
    if (mounted) {
      setState(() {
        _isDoneInit = true;
      });
    }
  }

  Widget _buildContent(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackButton(context);
        }
      },
      child: ColoredBox(
        color: Colors.black,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child:
                  _isDoneInit
                      ? _isCropMode
                          ? CropController(
                            // crop always work on the src, otherwise we'll be
                            // cropping repeatedly
                            image: _src,
                            initialState: _cropFilter,
                            onCropChanged: (cropFilter) {
                              _cropFilter = cropFilter;
                              _applyFilters();
                            },
                          )
                          : Image(
                            image: (_dst ?? _src).run(
                              (obj) =>
                                  PixelImage(obj.pixel, obj.width, obj.height),
                            ),
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                          )
                      : Container(),
            ),
            if (_activeTool == _ToolType.color)
              ColorToolbar(
                initialState: _colorFilters,
                onActiveFiltersChanged: (colorFilters) {
                  _colorFilters = colorFilters.toList();
                  _applyFilters();
                },
              )
            else if (_activeTool == _ToolType.transform)
              TransformToolbar(
                initialState: _transformFilters,
                onActiveFiltersChanged: (transformFilters) {
                  _transformFilters = transformFilters.toList();
                  _applyFilters();
                },
                isCropModeChanged: (value) {
                  setState(() {
                    _isCropMode = value;
                  });
                },
                onCropToolDeactivated: () {
                  _cropFilter = null;
                  _applyFilters();
                },
              ),
            const SizedBox(height: 4),
            _buildToolBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: BackButton(onPressed: () => _onBackButton(context)),
    title: Text(L10n.global().imageEditTitle),
    actions: [
      if (_isModified)
        IconButton(
          icon: const Icon(Icons.save_outlined),
          tooltip: L10n.global().saveTooltip,
          onPressed: () => _onSavePressed(context),
        ),
      IconButton(
        icon: const Icon(Icons.help_outline),
        tooltip: L10n.global().helpTooltip,
        onPressed: () {
          launch(help_util.editPhotosUrl);
        },
      ),
    ],
  );

  Widget _buildToolBar(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _ToolButton(
              icon: Icons.palette_outlined,
              label: L10n.global().imageEditToolbarColorLabel,
              isSelected: _activeTool == _ToolType.color,
              onPressed: () {
                setState(() {
                  _setActiveTool(_ToolType.color);
                });
              },
            ),
            _ToolButton(
              icon: Icons.transform_outlined,
              label: L10n.global().imageEditToolbarTransformLabel,
              isSelected: _activeTool == _ToolType.transform,
              onPressed: () {
                setState(() {
                  _setActiveTool(_ToolType.transform);
                });
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _onBackButton(BuildContext context) async {
    if (!_isModified) {
      Navigator.of(context).pop();
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(L10n.global().imageEditDiscardDialogTitle),
            content: Text(L10n.global().imageEditDiscardDialogContent),
            actions: [
              TextButton(
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
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
  }

  Future<void> _onSavePressed(BuildContext context) async {
    final c = KiwiContainer().resolve<DiContainer>();
    await ImageProcessor.filter(
      "${widget.account.url}/${widget.file.fdPath}",
      widget.file.filename,
      4096,
      3072,
      _buildFilterList(),
      headers: {
        "Authorization": AuthUtil.fromAccount(widget.account).toHeaderValue(),
      },
      isSaveToServer: c.pref.isSaveEditResultToServerOr(),
    );
    Navigator.of(context).pop();
  }

  Future<void> _showSaveEditResultDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const ImageEditorPersistOptionDialog(isFromEditor: true),
    );
  }

  void _setActiveTool(_ToolType tool) {
    _activeTool = tool;
    _isCropMode = false;
  }

  List<ImageFilter> _buildFilterList() {
    return [
      if (_cropFilter != null) _cropFilter!.toImageFilter()!,
      ..._transformFilters.map((f) => f.toImageFilter()).nonNulls,
      ..._colorFilters.map((f) => f.toImageFilter()),
    ];
  }

  Future<void> _applyFilters() async {
    final result = await ImageProcessor.filterPreview(_src, _buildFilterList());
    setState(() {
      _dst = result;
    });
  }

  bool get _isModified =>
      _cropFilter != null ||
      _transformFilters.isNotEmpty ||
      _colorFilters.isNotEmpty;

  bool _isDoneInit = false;
  late final Rgba8Image _src;
  Rgba8Image? _dst;
  var _activeTool = _ToolType.color;
  var _isCropMode = false;

  var _colorFilters = <ColorArguments>[];
  var _transformFilters = <TransformArguments>[];
  TransformArguments? _cropFilter;
}

enum _ToolType { color, transform }

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                // borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : M3.of(context).filterChip.disabled.labelText,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
}

const _previewWidth = 640;
const _previewHeight = 480;
