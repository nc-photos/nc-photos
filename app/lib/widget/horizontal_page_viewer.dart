import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/widget/page_changed_listener.dart';
import 'package:np_platform_util/np_platform_util.dart';

class HorizontalPageViewer extends StatefulWidget {
  HorizontalPageViewer({
    super.key,
    this.pageCount,
    required this.pageBuilder,
    this.initialPage = 0,
    HorizontalPageViewerController? controller,
    this.viewportFraction = 1,
    this.canSwitchPage = true,
    this.onPageChanged,
  }) : controller = controller ?? HorizontalPageViewerController();

  @override
  createState() => _HorizontalPageViewerState();

  final int initialPage;
  final int? pageCount;
  final Widget Function(BuildContext context, int index) pageBuilder;
  final HorizontalPageViewerController controller;
  final double viewportFraction;
  final bool canSwitchPage;
  final void Function(int from, int to)? onPageChanged;
}

class _HorizontalPageViewerState extends State<HorizontalPageViewer> {
  @override
  initState() {
    super.initState();
    _pageFocus.requestFocus();

    widget.controller._pageController = PageController(
      initialPage: widget.initialPage,
      viewportFraction: widget.viewportFraction,
      keepPage: false,
    );
    if (widget.onPageChanged != null) {
      widget.controller._pageController.addListener(
        PageChangedListener(
          widget.controller._pageController,
          onPageChanged: widget.onPageChanged,
        ).call,
      );
    }
  }

  @override
  build(BuildContext context) {
    if (!_hasInit) {
      _updateNavigationState(widget.initialPage);
      _hasInit = true;
    }
    return getRawPlatform() == NpPlatform.web
        ? _buildWebContent(context)
        : _buildContent(context);
  }

  @override
  dispose() {
    widget.controller._pageController.dispose();
    super.dispose();
  }

  Widget _buildWebContent(BuildContext context) {
    assert(getRawPlatform() == NpPlatform.web);
    // support switching pages with keyboard on web
    return KeyboardListener(
      onKeyEvent: (ev) {
        if (!widget.canSwitchPage) {
          return;
        }
        if (ev is KeyUpEvent) {
          if (ev.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _switchToLeft();
          } else if (ev.logicalKey == LogicalKeyboardKey.arrowRight) {
            _switchToRight();
          }
        }
      },
      focusNode: _pageFocus,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: widget.controller._pageController,
          itemCount: widget.pageCount,
          itemBuilder: widget.pageBuilder,
          physics:
              getRawPlatform() != NpPlatform.web && widget.canSwitchPage
                  ? null
                  : const NeverScrollableScrollPhysics(),
        ),
        if (getRawPlatform() == NpPlatform.web)
          ..._buildNavigationButtons(context),
      ],
    );
  }

  List<Widget> _buildNavigationButtons(BuildContext context) {
    return [
      if (_canSwitchRight)
        Align(
          key: const ValueKey(0),
          alignment: Alignment.centerRight,
          child: Material(
            type: MaterialType.transparency,
            child: Visibility(
              visible: widget.canSwitchPage,
              child: AnimatedOpacity(
                opacity: _isShowRight ? 1.0 : 0.0,
                duration: k.animationDurationShort,
                child: MouseRegion(
                  onEnter: (details) {
                    setState(() {
                      _isShowRight = true;
                    });
                  },
                  onExit: (details) {
                    setState(() {
                      _isShowRight = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 36,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                      ),
                      onPressed: _switchToRight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      if (_canSwitchLeft)
        Align(
          key: const ValueKey(1),
          alignment: Alignment.centerLeft,
          child: Material(
            type: MaterialType.transparency,
            child: Visibility(
              visible: widget.canSwitchPage,
              child: AnimatedOpacity(
                opacity: _isShowLeft ? 1.0 : 0.0,
                duration: k.animationDurationShort,
                child: MouseRegion(
                  onEnter: (details) {
                    setState(() {
                      _isShowLeft = true;
                    });
                  },
                  onExit: (details) {
                    setState(() {
                      _isShowLeft = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 36,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                      onPressed: _switchToLeft,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ];
  }

  /// Switch to the previous image in the stream
  void _switchToPrev() {
    widget.controller._pageController
        .previousPage(
          duration: k.animationDurationNormal,
          curve: Curves.easeInOut,
        )
        .whenComplete(
          () => _updateNavigationState(
            widget.controller._pageController.page!.round(),
          ),
        );
  }

  /// Switch to the next image in the stream
  void _switchToNext() {
    widget.controller._pageController
        .nextPage(duration: k.animationDurationNormal, curve: Curves.easeInOut)
        .whenComplete(
          () => _updateNavigationState(
            widget.controller._pageController.page!.round(),
          ),
        );
  }

  /// Switch to the image on the "left", what that means depend on the current
  /// text direction
  void _switchToLeft() {
    if (Directionality.of(context) == TextDirection.ltr) {
      _switchToPrev();
    } else {
      _switchToNext();
    }
  }

  /// Switch to the image on the "right", what that means depend on the current
  /// text direction
  void _switchToRight() {
    if (Directionality.of(context) == TextDirection.ltr) {
      _switchToNext();
    } else {
      _switchToPrev();
    }
  }

  /// Update the navigation state for [page]
  void _updateNavigationState(int page) {
    // currently useless to run on non-web platform
    if (getRawPlatform() != NpPlatform.web) {
      return;
    }
    final hasNext = widget.pageCount == null || page < widget.pageCount! - 1;
    final hasPrev = page > 0;
    final hasLeft =
        Directionality.of(context) == TextDirection.ltr ? hasPrev : hasNext;
    if (_canSwitchLeft != hasLeft) {
      setState(() {
        _canSwitchLeft = hasLeft;
        if (!_canSwitchLeft) {
          _isShowLeft = false;
        }
      });
    }
    final hasRight =
        Directionality.of(context) == TextDirection.ltr ? hasNext : hasPrev;
    if (_canSwitchRight != hasRight) {
      setState(() {
        _canSwitchRight = hasRight;
        if (!_canSwitchRight) {
          _isShowRight = false;
        }
      });
    }
  }

  var _hasInit = false;

  var _canSwitchRight = true;
  var _canSwitchLeft = true;
  var _isShowRight = false;
  var _isShowLeft = false;

  /// used to gain focus on web for keyboard support
  final _pageFocus = FocusNode();
}

class HorizontalPageViewerController {
  Future<void> previousPage({
    required Duration duration,
    required Curve curve,
  }) => _pageController.previousPage(duration: duration, curve: curve);

  Future<void> nextPage({required Duration duration, required Curve curve}) =>
      _pageController.nextPage(duration: duration, curve: curve);

  void animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) => _pageController.animateToPage(page, duration: duration, curve: curve);

  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  int get currentPage =>
      _pageController.hasClients
          ? _pageController.page!.round()
          : _pageController.initialPage;

  late PageController _pageController;
}
